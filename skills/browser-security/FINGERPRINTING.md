# Browser Fingerprinting Detection

## Fingerprinting Vectors

### Canvas Fingerprinting
```javascript
// Detection pattern
const canvas = document.createElement('canvas');
const ctx = canvas.getContext('2d');
ctx.fillText('fingerprint', 0, 0);
canvas.toDataURL();  // Unique per system
```

### WebGL Fingerprinting
```javascript
const gl = canvas.getContext('webgl');
gl.getParameter(gl.VENDOR);
gl.getParameter(gl.RENDERER);
gl.getExtension('WEBGL_debug_renderer_info');
```

### AudioContext Fingerprinting
```javascript
const ctx = new AudioContext();
const oscillator = ctx.createOscillator();
const analyser = ctx.createAnalyser();
// Process audio → extract unique signature
```

### Font Detection
```javascript
// Measure text width with different fonts
const fonts = ['Arial', 'Helvetica', 'Times', ...];
fonts.forEach(font => {
  span.style.fontFamily = font;
  if (span.offsetWidth !== baseline) {
    detectedFonts.push(font);
  }
});
```

### Navigator Properties
```javascript
navigator.userAgent
navigator.language
navigator.languages
navigator.hardwareConcurrency
navigator.deviceMemory
navigator.platform
screen.width, screen.height
screen.colorDepth
```

## Detection Methodology

### Instrumentation
```javascript
// Intercept fingerprinting APIs
const originalGetContext = HTMLCanvasElement.prototype.getContext;
HTMLCanvasElement.prototype.getContext = function(type) {
  console.log('Canvas context requested:', type);
  return originalGetContext.apply(this, arguments);
};
```

### Behavioral Analysis
- Same script accesses multiple fingerprinting APIs
- Results sent to third-party endpoint
- No visible user benefit from API calls

## Fingerprinting Libraries
Known libraries to detect:
- **FingerprintJS** - `fpjs`, `FingerprintJS`
- **ClientJS** - `clientjs`
- **Evercookie** - Persistence via multiple vectors
- **CrossBrowserFingerprint** - Uses canvas, WebGL

## Mitigation Techniques
- **Randomization**: Add noise to canvas/audio output
- **Normalization**: Return common values for navigator
- **Blocking**: Deny access to fingerprinting APIs
- **Isolation**: Different fingerprint per site (Brave)

## Research Datasets
- [OpenWPM](https://github.com/openwpm/OpenWPM) - Web measurement framework
- [FPDetective](https://www.cs.kuleuven.be/publicaties/rapporten/cw/CW648.abs.html) - Fingerprinting detection
