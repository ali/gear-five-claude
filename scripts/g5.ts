#!/usr/bin/env bun
/**
 * Gear Five installer + wizard (Bun).
 *
 * User-scoped only: edits ~/.claude/settings.json
 *
 * Usage:
 *   bun ./scripts/g5.ts wizard
 *   bun ./scripts/g5.ts install --workspace ~/src/claude-workspace
 *   bun ./scripts/g5.ts doctor
 *   bun ./scripts/g5.ts print-config
 */

import { mkdir, readdir, readFile, stat, writeFile, chmod, copyFile } from "node:fs/promises";
import * as path from "node:path";
import * as os from "node:os";
import readline from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";

type Profile = "balanced" | "strict";

type SettingsJson = {
  permissions?: {
    allow?: string[];
    deny?: string[];
  };
  env?: Record<string, string>;
  hooks?: Record<
    string,
    Array<{
      matcher: string;
      hooks: Array<{ type: "command"; command: string; timeout?: number }>;
    }>
  >;
  statusLine?: { type: "command"; command: string };
};

type InstallConfig = {
  workspace: string;
  vault: string;
  profile: Profile;
  enableStatusLine: boolean;
  claudeDir: string;
  templatesRoot: string;
  dryRun: boolean;
  yes: boolean;
};

function printUsage(exitCode = 0) {
  output.write(
    [
      "",
      "Gear Five (Bun) installer",
      "",
      "Commands:",
      "  wizard        Interactive Q&A, then installs",
      "  install       Install without prompts (use flags)",
      "  doctor        Validate install (no changes)",
      "  print-config  Print the settings.json patch we would apply",
      "",
      "Flags:",
      "  --workspace <path>      Workspace directory (default: ~/src/claude-workspace)",
      "  --vault <path>          Vault directory (default: <workspace>/vault)",
      "  --profile <balanced|strict> (default: balanced)",
      "  --no-statusline         Disable Gear Five status line",
      "  --claude-dir <path>     Claude user dir (default: ~/.claude) (useful for testing)",
      "  --templates-root <path> Template root containing hooks/, skills/, vault-template/, scripts/ (default: repo root)",
      "  --dry-run               Print actions without writing",
      "  --yes                   Do not prompt for confirmation (install only)",
      "",
    ].join("\n"),
  );
  process.exit(exitCode);
}

function expandHome(p: string): string {
  if (p === "~") return os.homedir();
  if (p.startsWith("~/")) return path.join(os.homedir(), p.slice(2));
  return p;
}

function uniqueAppend(arr: string[], items: string[]): string[] {
  const seen = new Set(arr);
  for (const item of items) {
    if (!seen.has(item)) {
      arr.push(item);
      seen.add(item);
    }
  }
  return arr;
}

async function pathExists(p: string): Promise<boolean> {
  try {
    await stat(p);
    return true;
  } catch {
    return false;
  }
}

function normalizeAbs(p: string): string {
  return path.resolve(expandHome(p));
}

function repoRootFromHere(): string {
  // scripts/g5.ts -> repoRoot/scripts
  return path.resolve(import.meta.dir, "..");
}

function gearFiveSettingsPatch(cfg: InstallConfig): SettingsJson {
  const dispatcher = path.join(cfg.claudeDir, "scripts", "hooks-dispatch.sh");
  const statusLineScript = path.join(cfg.claudeDir, "statusline.sh");

  const env: Record<string, string> = {
    GEARFIVE_WORKSPACE: cfg.workspace,
    GEARFIVE_VAULT: cfg.vault,
  };

  // Compatibility: if user doesn’t already use CLAUDE_VAULT, set it.
  // (We won’t clobber it during merge.)
  env.CLAUDE_VAULT = cfg.vault;

  const hooks: SettingsJson["hooks"] = {
    SessionStart: [
      {
        matcher: "*",
        hooks: [{ type: "command", command: `${dispatcher} SessionStart`, timeout: 10000 }],
      },
    ],
    PreCompact: [
      {
        matcher: "*",
        hooks: [{ type: "command", command: `${dispatcher} PreCompact`, timeout: 10000 }],
      },
    ],
    SessionEnd: [
      {
        matcher: "*",
        hooks: [{ type: "command", command: `${dispatcher} SessionEnd`, timeout: 10000 }],
      },
    ],
  };

  const denyBalanced = [
    // common secret locations (examples in Claude Code docs)
    "Read(./.env)",
    "Read(./.env.*)",
    "Read(./secrets/**)",
    "Read(./**/*.pem)",
    "Read(./**/*.key)",
  ];

  const denyStrict = [
    ...denyBalanced,
    // reduce accidental exfil or uncontrolled side effects
    "Bash(curl:*)",
  ];

  const allowBalanced = [
    // keep small; everything else remains ask-by-default
    "Bash(ls:*)",
    "Bash(pwd)",
    "Bash(whoami)",
    "Bash(git status)",
    "Bash(git diff:*)",
    "Bash(git log:*)",
  ];

  const allowStrict = [
    "Bash(ls:*)",
    "Bash(pwd)",
    "Bash(whoami)",
    "Bash(git status)",
  ];

  const permissions: NonNullable<SettingsJson["permissions"]> = {
    allow: cfg.profile === "strict" ? allowStrict : allowBalanced,
    deny: cfg.profile === "strict" ? denyStrict : denyBalanced,
  };

  const patch: SettingsJson = { env, hooks, permissions };
  if (cfg.enableStatusLine) {
    patch.statusLine = { type: "command", command: statusLineScript };
  }
  return patch;
}

function mergeSettings(existing: SettingsJson, patch: SettingsJson): SettingsJson {
  const next: SettingsJson = structuredClone(existing ?? {});

  // env: Gear Five owns GEARFIVE_* keys; CLAUDE_VAULT is only set if missing.
  next.env ??= {};
  for (const [k, v] of Object.entries(patch.env ?? {})) {
    if (k === "CLAUDE_VAULT") {
      if (next.env[k] == null || next.env[k] === "") next.env[k] = v;
      continue;
    }
    if (k.startsWith("GEARFIVE_")) next.env[k] = v;
  }

  // permissions: additive merge (never delete user entries)
  next.permissions ??= {};
  next.permissions.allow = uniqueAppend(next.permissions.allow ?? [], patch.permissions?.allow ?? []);
  next.permissions.deny = uniqueAppend(next.permissions.deny ?? [], patch.permissions?.deny ?? []);

  // hooks: ensure our dispatcher hooks exist; preserve anything else user has.
  next.hooks ??= {};
  for (const [eventName, arr] of Object.entries(patch.hooks ?? {})) {
    const existingArr = next.hooks[eventName] ?? [];
    // If an identical command exists, do nothing; otherwise append our entry.
    const desired = arr[0];
    const desiredCommand = desired?.hooks?.[0]?.command;
    const already = existingArr.some((entry) =>
      entry?.hooks?.some((h) => h.type === "command" && h.command === desiredCommand),
    );
    next.hooks[eventName] = already ? existingArr : [...existingArr, ...arr];
  }

  // statusLine: Gear Five can own it by default (non-destructive would be "only set if missing"),
  // but user asked for it, so we set it (they can disable via --no-statusline).
  if (patch.statusLine) next.statusLine = patch.statusLine;

  return next;
}

async function readSettingsJson(settingsPath: string): Promise<SettingsJson> {
  if (!(await pathExists(settingsPath))) return {};
  const raw = await readFile(settingsPath, "utf8");
  try {
    return JSON.parse(raw) as SettingsJson;
  } catch (e) {
    throw new Error(`Failed to parse ${settingsPath} as JSON. Please fix it first.\n${String(e)}`);
  }
}

async function writeSettingsJson(settingsPath: string, settings: SettingsJson, dryRun: boolean) {
  const content = JSON.stringify(settings, null, 2) + "\n";
  if (dryRun) {
    output.write(`\n[dry-run] Would write ${settingsPath}:\n${content}\n`);
    return;
  }
  // Safety: back up existing settings.json before overwriting.
  if (await pathExists(settingsPath)) {
    const d = new Date();
    const stamp =
      String(d.getFullYear()) +
      String(d.getMonth() + 1).padStart(2, "0") +
      String(d.getDate()).padStart(2, "0") +
      "-" +
      String(d.getHours()).padStart(2, "0") +
      String(d.getMinutes()).padStart(2, "0") +
      String(d.getSeconds()).padStart(2, "0");
    const backupPath = `${settingsPath}.bak-${stamp}`;
    await copyFile(settingsPath, backupPath);
  }
  await mkdir(path.dirname(settingsPath), { recursive: true });
  await writeFile(settingsPath, content, "utf8");
}

async function copyDirContents(srcDir: string, dstDir: string, dryRun: boolean) {
  await mkdir(dstDir, { recursive: true });
  const entries = await readdir(srcDir, { withFileTypes: true });
  for (const entry of entries) {
    const src = path.join(srcDir, entry.name);
    const dst = path.join(dstDir, entry.name);
    if (entry.isDirectory()) {
      await copyDirContents(src, dst, dryRun);
    } else if (entry.isFile()) {
      if (dryRun) {
        output.write(`[dry-run] copy ${src} -> ${dst}\n`);
      } else {
        await mkdir(path.dirname(dst), { recursive: true });
        await copyFile(src, dst);
      }
    }
  }
}

async function ensureExecutableSh(dir: string, dryRun: boolean) {
  if (!(await pathExists(dir))) return;
  const entries = await readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      await ensureExecutableSh(p, dryRun);
      continue;
    }
    if (entry.isFile() && p.endsWith(".sh")) {
      if (dryRun) {
        output.write(`[dry-run] chmod +x ${p}\n`);
      } else {
        await chmod(p, 0o755);
      }
    }
  }
}

async function install(cfg: InstallConfig) {
  const repoRoot = cfg.templatesRoot;
  const settingsPath = path.join(cfg.claudeDir, "settings.json");

  // 1) Copy hooks, skills, scripts
  await copyDirContents(path.join(repoRoot, "hooks"), path.join(cfg.claudeDir, "hooks"), cfg.dryRun);
  await copyDirContents(path.join(repoRoot, "skills"), path.join(cfg.claudeDir, "skills"), cfg.dryRun);
  await mkdir(path.join(cfg.claudeDir, "scripts"), { recursive: true });
  {
    const src = path.join(repoRoot, "scripts", "hooks-dispatch.sh");
    const dst = path.join(cfg.claudeDir, "scripts", "hooks-dispatch.sh");
    if (cfg.dryRun) output.write(`[dry-run] copy ${src} -> ${dst}\n`);
    else await copyFile(src, dst);
  }
  {
    const src = path.join(repoRoot, "scripts", "statusline.sh");
    const dst = path.join(cfg.claudeDir, "statusline.sh");
    if (cfg.dryRun) output.write(`[dry-run] copy ${src} -> ${dst}\n`);
    else await copyFile(src, dst);
  }

  // 2) Make scripts executable
  await ensureExecutableSh(path.join(cfg.claudeDir, "hooks"), cfg.dryRun);
  if (cfg.dryRun) output.write(`[dry-run] chmod +x ${path.join(cfg.claudeDir, "scripts", "hooks-dispatch.sh")}\n`);
  else await chmod(path.join(cfg.claudeDir, "scripts", "hooks-dispatch.sh"), 0o755);
  if (cfg.dryRun) output.write(`[dry-run] chmod +x ${path.join(cfg.claudeDir, "statusline.sh")}\n`);
  else await chmod(path.join(cfg.claudeDir, "statusline.sh"), 0o755);

  // 3) Initialize vault (copy template, but never overwrite user edits)
  await mkdir(cfg.vault, { recursive: true });
  const vaultTemplateDir = path.join(repoRoot, "vault-template");
  if (await pathExists(vaultTemplateDir)) {
    // only copy missing files
    const entries = await readdir(vaultTemplateDir, { withFileTypes: true });
    for (const entry of entries) {
      const src = path.join(vaultTemplateDir, entry.name);
      const dst = path.join(cfg.vault, entry.name);
      if (await pathExists(dst)) continue;
      if (entry.isDirectory()) {
        await copyDirContents(src, dst, cfg.dryRun);
      } else if (entry.isFile()) {
        if (cfg.dryRun) output.write(`[dry-run] copy ${src} -> ${dst}\n`);
        else await copyFile(src, dst);
      }
    }
  }

  // 4) Merge ~/.claude/settings.json
  const existing = await readSettingsJson(settingsPath);
  const patch = gearFiveSettingsPatch(cfg);
  const merged = mergeSettings(existing, patch);
  await writeSettingsJson(settingsPath, merged, cfg.dryRun);

  // 5) Optionally print a minimal verification command the user can run
  output.write(
    [
      "",
      "Gear Five installed.",
      `- Workspace: ${cfg.workspace}`,
      `- Vault: ${cfg.vault}`,
      `- Claude settings: ${settingsPath}`,
      "",
      "Next:",
      "- Restart Claude Code (or start a new session) to pick up settings/hooks.",
      "- Run: bun ./scripts/g5.ts doctor",
      "",
    ].join("\n"),
  );
}

async function doctor(cfg: InstallConfig) {
  const settingsPath = path.join(cfg.claudeDir, "settings.json");
  const settings = await readSettingsJson(settingsPath);

  const requiredFiles = [
    path.join(cfg.claudeDir, "scripts", "hooks-dispatch.sh"),
    path.join(cfg.claudeDir, "hooks", "SessionStart.d", "00-inject-context.sh"),
    path.join(cfg.claudeDir, "hooks", "PreCompact.d", "00-save-state.sh"),
    path.join(cfg.claudeDir, "hooks", "SessionEnd.d", "00-reflect.sh"),
  ];
  const missing: string[] = [];
  for (const f of requiredFiles) {
    if (!(await pathExists(f))) missing.push(f);
  }

  const envOk = settings.env?.GEARFIVE_VAULT && settings.env?.GEARFIVE_WORKSPACE;
  const hooksOk =
    Boolean(settings.hooks?.SessionStart?.length) &&
    Boolean(settings.hooks?.PreCompact?.length) &&
    Boolean(settings.hooks?.SessionEnd?.length);
  const statusOk = cfg.enableStatusLine ? Boolean(settings.statusLine?.command) : true;

  output.write("\nGear Five doctor:\n");
  if (missing.length) {
    output.write("\nMissing files:\n");
    for (const f of missing) output.write(`- ${f}\n`);
  } else {
    output.write("- Files: OK\n");
  }
  output.write(`- Env (GEARFIVE_*): ${envOk ? "OK" : "MISSING"}\n`);
  output.write(`- Hooks configured: ${hooksOk ? "OK" : "MISSING"}\n`);
  output.write(`- Status line: ${statusOk ? "OK" : "MISSING"}\n`);

  if (!envOk || !hooksOk || !statusOk || missing.length) {
    output.write("\nFix: re-run install:\n");
    output.write(`bun ./scripts/g5.ts install --workspace ${cfg.workspace}\n\n`);
    process.exit(1);
  }
}

async function runWizard() {
  const rl = readline.createInterface({ input, output });
  try {
    output.write(
      [
        "",
        "Gear Five Wizard (Bun)",
        "",
        "If you are Claude (the agent) driving this setup:",
        "- Ask the user these questions, then run the install command with the chosen answers.",
        "",
        "Questions to ask:",
        "1) Where should your Gear Five workspace live? (default: ~/src/claude-workspace)",
        "2) Which profile? balanced (recommended) or strict",
        "3) Enable Gear Five status line? (recommended: yes)",
        "",
      ].join("\n"),
    );

    const workspaceIn =
      (await rl.question("Workspace path [~/src/claude-workspace]: ")).trim() || "~/src/claude-workspace";
    const profileIn = ((await rl.question("Profile [balanced]: ")).trim() || "balanced") as Profile;
    const statusIn = (await rl.question("Enable status line? [Y/n]: ")).trim().toLowerCase();

    const workspace = normalizeAbs(workspaceIn);
    const vault = path.join(workspace, "vault");
    const claudeDir = path.join(os.homedir(), ".claude");
    const templatesRoot = repoRootFromHere();
    const enableStatusLine = statusIn === "" || statusIn === "y" || statusIn === "yes";

    output.write("\nSummary:\n");
    output.write(`- workspace: ${workspace}\n`);
    output.write(`- vault:     ${vault}\n`);
    output.write(`- profile:   ${profileIn}\n`);
    output.write(`- statusline:${enableStatusLine ? "yes" : "no"}\n`);
    const confirm = (await rl.question("\nProceed? [Y/n]: ")).trim().toLowerCase();
    if (confirm && confirm !== "y" && confirm !== "yes") {
      output.write("Cancelled.\n");
      process.exit(0);
    }

    await install({
      workspace,
      vault,
      profile: profileIn === "strict" ? "strict" : "balanced",
      enableStatusLine,
      claudeDir,
      templatesRoot,
      dryRun: false,
      yes: true,
    });
  } finally {
    rl.close();
  }
}

function parseArgs(argv: string[]): { cmd: string; cfg: Partial<InstallConfig> } {
  const cmd = argv[2] ?? "";
  const cfg: Partial<InstallConfig> = {};
  for (let i = 3; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--workspace") cfg.workspace = argv[++i];
    else if (a === "--vault") cfg.vault = argv[++i];
    else if (a === "--profile") cfg.profile = argv[++i] as Profile;
    else if (a === "--no-statusline") cfg.enableStatusLine = false;
    else if (a === "--claude-dir") cfg.claudeDir = argv[++i];
    else if (a === "--templates-root") cfg.templatesRoot = argv[++i];
    else if (a === "--dry-run") cfg.dryRun = true;
    else if (a === "--yes") cfg.yes = true;
    else if (a === "-h" || a === "--help") printUsage(0);
    else {
      output.write(`Unknown arg: ${a}\n`);
      printUsage(2);
    }
  }
  return { cmd, cfg };
}

async function main() {
  const { cmd, cfg: partial } = parseArgs(process.argv);
  if (!cmd) printUsage(2);

  const workspace = normalizeAbs(partial.workspace ?? "~/src/claude-workspace");
  const vault = normalizeAbs(partial.vault ?? path.join(workspace, "vault"));
  const profile: Profile = partial.profile === "strict" ? "strict" : "balanced";
  const enableStatusLine = partial.enableStatusLine ?? true;
  const claudeDir = normalizeAbs(partial.claudeDir ?? path.join(os.homedir(), ".claude"));
  const templatesRoot = normalizeAbs(partial.templatesRoot ?? repoRootFromHere());
  const dryRun = partial.dryRun ?? false;
  const yes = partial.yes ?? false;

  const resolved: InstallConfig = { workspace, vault, profile, enableStatusLine, claudeDir, templatesRoot, dryRun, yes };

  if (cmd === "wizard") {
    await runWizard();
    return;
  }

  if (cmd === "print-config") {
    const patch = gearFiveSettingsPatch(resolved);
    output.write(JSON.stringify(patch, null, 2) + "\n");
    return;
  }

  if (cmd === "doctor") {
    await doctor(resolved);
    return;
  }

  if (cmd === "install") {
    if (!yes && !dryRun) {
      output.write(
        [
          "",
          "This will modify user-scoped Claude Code settings:",
          `- ${path.join(claudeDir, "settings.json")}`,
          "",
          "Re-run with --yes to proceed, or add --dry-run to preview.",
          "",
        ].join("\n"),
      );
      process.exit(2);
    }
    await install(resolved);
    return;
  }

  output.write(`Unknown command: ${cmd}\n`);
  printUsage(2);
}

await main();

