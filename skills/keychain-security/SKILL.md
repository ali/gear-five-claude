---
name: keychain-security
description: "Secure credential handling using macOS Keychain. Use when working with API keys, passwords, tokens, or any sensitive data. Triggers: 'API key', 'credentials', 'secret', 'password', 'token', 'authenticate'."
---

# Keychain Security

Secure credential handling. NEVER expose secrets.

## Golden Rules

1. **NEVER log secrets** - Not even partially, not even "exists" checks
2. **NEVER CLI arguments** - Visible in `ps`, shell history
3. **NEVER hardcode** - Not in code, not in prompts
4. **NEVER echo/print** - Even for debugging

## Reading from Keychain

**Check existence (safe):**
```bash
security find-generic-password -s "service" -a "account" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Credential exists"
else
  echo "Credential not found"
fi
```

**Use in code (safe):**
```typescript
// Read at call time, use directly, never store in loggable variable
const result = Bun.spawnSync({
  cmd: ["security", "find-generic-password", "-s", "service", "-a", "account", "-w"],
  stderr: "pipe",
});
// Use result.stdout directly in API call
```

**UNSAFE - Never do this:**
```bash
# BAD: Prints the secret!
security find-generic-password -s "service" -a "account" -w

# BAD: Stores in variable that might get logged
TOKEN=$(security find-generic-password ...)
echo "Token: $TOKEN"

# BAD: Visible in process list
curl -H "Authorization: Bearer $TOKEN" ...
```

## Storing Credentials

```bash
# Store a credential
security add-generic-password \
  -s "my-service" \
  -a "my-account" \
  -w "the-secret-value" \
  -U  # Update if exists
```

## Environment Variables

For non-Keychain secrets (less secure, but sometimes necessary):

```bash
# In ~/.zshrc or ~/.bashrc (not in code!)
export MY_API_KEY="..."

# In code, read at runtime
const key = process.env.MY_API_KEY;
// Use directly, don't log
```

## Common Services

| Service | Keychain service name |
|---------|----------------------|
| GitHub | `github.com` or `gh:github.com` |
| OpenAI | `openai-api-key` |
| Anthropic | `anthropic-api-key` |

## When User Asks to Store a Secret

1. Ask them to provide via Keychain command (you don't see it)
2. Or ask them to set env var (you don't see the value)
3. NEVER ask them to type the secret in chat

```
I need an API key for [service]. Please store it securely:

Option 1 (recommended):
security add-generic-password -s "[service]" -a "[account]" -w

Option 2:
Add to your shell config: export [VAR_NAME]="your-key"

Then let me know when it's stored.
```
