# Browser Extension Security Analysis

## Manifest Analysis

### Critical Permissions
```json
{
  "permissions": [
    "<all_urls>",           // CRITICAL: Access to all sites
    "webRequest",           // Can intercept all traffic
    "webRequestBlocking",   // Can modify/block requests
    "cookies",              // Access all cookies
    "storage",              // Can store data
    "tabs",                 // See all open tabs
    "history",              // Access browsing history
    "downloads",            // Trigger downloads
    "nativeMessaging"       // Talk to native apps
  ]
}
```

### Permission Risk Levels
| Permission | Risk | Abuse Potential |
|------------|------|-----------------|
| `<all_urls>` | Critical | Full page access |
| `webRequestBlocking` | Critical | MITM attacks |
| `cookies` | High | Session hijacking |
| `history` | High | Profiling |
| `tabs` | Medium | Tab tracking |
| `storage` | Low | Data persistence |

## Content Script Analysis

### Injection Points
```json
{
  "content_scripts": [{
    "matches": ["<all_urls>"],
    "js": ["content.js"],
    "run_at": "document_start",
    "all_frames": true
  }]
}
```

### Code Patterns to Check
- Data exfiltration: Sending page content to external servers
- Keylogging: Listening to keyboard events
- Form hijacking: Intercepting form submissions
- Credential theft: Watching login pages

## Background Script Analysis

### Red Flags
- Dynamic code execution patterns
- Remote code loading
- Obfuscated variable names
- Persistence mechanisms

## Security Checklist

1. **Minimum permissions**: Does it request more than needed?
2. **Update mechanism**: Can it load remote code?
3. **Data handling**: Where does collected data go?
4. **Third-party code**: External scripts included?
5. **Obfuscation**: Is code intentionally hidden?
6. **Network requests**: What endpoints does it contact?
