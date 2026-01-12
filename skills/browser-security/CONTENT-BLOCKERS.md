# Content Blocker Analysis

## How Content Blockers Work

### Filter Lists
- **EasyList** - General ads
- **EasyPrivacy** - Tracking
- **Fanboy's Annoyance** - Social widgets, cookie notices
- **uBlock Origin lists** - Extended coverage

### Blocking Methods
1. **Network blocking** - Intercept requests before they fire
2. **Cosmetic filtering** - Hide elements via CSS
3. **Scriptlet injection** - Neutralize tracking scripts

## Common Bypass Techniques

### First-Party Proxying
```javascript
// Tracker disguised as first-party
// Instead of: tracker.example.com/pixel.js
// Uses: yoursite.com/proxy/pixel.js
```

### CNAME Cloaking
```
; DNS record
tracking.yoursite.com CNAME real-tracker.com
```
Detection: Check actual CNAME resolution vs declared domain.

### Dynamic Script Loading
```javascript
// Obfuscated loader
const s = document['createElement']('script');
s['src'] = atob('aHR0cHM6Ly90cmFja2VyLmNvbS90Lmpz');
document['body']['appendChild'](s);
```

### WebSocket/WebRTC
```javascript
// Bypass network blocking via WebSocket
const ws = new WebSocket('wss://tracker.example.com/beacon');
ws.send(JSON.stringify(trackingData));
```

### Inline Scripts
```html
<!-- Harder to block without breaking site -->
<script>
  fetch('/api/analytics', { body: JSON.stringify(userData) });
</script>
```

## Testing Methodology

1. **Baseline measurement** - Requests without blocker
2. **Enable blocker** - Measure blocked requests
3. **Check for bypasses**:
   - CNAME resolution
   - First-party endpoints receiving tracking data
   - WebSocket connections
   - Data in first-party cookies

## Research Resources
- [EasyList filter syntax](https://help.eyeo.com/adblockplus/how-to-write-filters)
- [uBlock Origin static filters](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax)
- [Brave AdBlock components](https://github.com/nickolasclarke/nickolasclarke.github.io)
