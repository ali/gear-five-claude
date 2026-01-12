# Settings Audit Checklist

## JSON Validity
- [ ] settings.json parses without errors
- [ ] No trailing commas
- [ ] No duplicate keys
- [ ] Proper escaping in strings

## Permissions

### Structure Check
- [ ] `permissions.allow` is an array
- [ ] `permissions.deny` is an array
- [ ] No conflicts between allow and deny

### Best Practices
- [ ] Specific patterns over broad (`Bash(git:*)` > `Bash(*)`)
- [ ] Sensitive paths in deny list
- [ ] No `Read(**/.env)` in allow list
- [ ] Credentials/secrets patterns denied

### Common Patterns
```json
{
  "allow": [
    "Bash(git:*)",
    "Bash(npm:*)",
    "Read(~/Developer/**)"
  ],
  "deny": [
    "Read(**/.env)",
    "Read(**/*credentials*)",
    "Read(**/*.key)"
  ]
}
```

## Hooks

### Existence Check
- [ ] All referenced scripts exist
- [ ] Scripts are executable (`chmod +x`)
- [ ] No syntax errors in shell scripts

### Hook Events
- [ ] SessionStart - runs on session begin
- [ ] PreToolUse - runs before each tool
- [ ] PostToolUse - runs after each tool
- [ ] PreCompact - runs before context compaction
- [ ] SessionEnd - runs on session end

### Hook Script Best Practices
- [ ] Exit 0 on success
- [ ] Meaningful stderr on failure
- [ ] Timeout is reasonable (default: 10000ms)

## Sandbox

### Configuration
- [ ] `sandbox.enabled` is set appropriately
- [ ] `excludedCommands` includes network tools
- [ ] Filesystem permissions are scoped

### Common Exclusions
```json
{
  "excludedCommands": [
    "curl", "wget", "git",
    "npm", "yarn", "pnpm", "bun",
    "docker", "docker-compose"
  ]
}
```

## Model Settings
- [ ] `model` is valid (sonnet, opus, haiku)
- [ ] `alwaysThinkingEnabled` matches preference

## Plugins
- [ ] All `enabledPlugins` entries exist
- [ ] No deprecated plugins referenced

## Environment Variables
- [ ] `env` section has required paths
- [ ] PATH includes tool directories
- [ ] No secrets in env (use Keychain instead)
