# Security Review Checklist

## Injection Vulnerabilities

### SQL Injection
```javascript
// BAD: String interpolation
db.query(`SELECT * FROM users WHERE id = ${userId}`);

// GOOD: Parameterized query
db.query('SELECT * FROM users WHERE id = ?', [userId]);
```

### Command Injection
```javascript
// BAD: Shell interpolation in commands
// GOOD: Use execFile with array arguments, no shell
```

### XSS Prevention
- Use textContent for plain text content
- Sanitize HTML with DOMPurify before insertion
- Escape user input in templates

## Authentication

### Password Handling
- [ ] Passwords hashed with bcrypt/argon2
- [ ] No plaintext passwords in logs
- [ ] Secure password reset flow

### Session Management
- [ ] Sessions invalidated on logout
- [ ] Session tokens are random and long
- [ ] HttpOnly and Secure flags on cookies

### Token Handling
- [ ] JWTs have expiration
- [ ] Refresh token rotation
- [ ] Tokens stored securely

## Authorization

### Access Control
- [ ] Every endpoint checks permissions
- [ ] No IDOR vulnerabilities
- [ ] Admin functions properly gated

### Data Exposure
- [ ] API responses don't leak extra fields
- [ ] Error messages don't reveal internals
- [ ] Debug info disabled in production

## Cryptography

### Key Management
- [ ] Keys not hardcoded
- [ ] Keys rotated periodically
- [ ] Proper key derivation (PBKDF2, scrypt)

### Algorithms
- [ ] No MD5/SHA1 for security
- [ ] AES-256-GCM for encryption
- [ ] RSA-2048 or better for asymmetric

## API Security

### Rate Limiting
- [ ] Rate limits on auth endpoints
- [ ] Rate limits on expensive operations
- [ ] Proper 429 responses

### Input Validation
- [ ] All inputs validated
- [ ] File upload restrictions
- [ ] Size limits on requests

## Secrets

### Storage
- [ ] No secrets in code
- [ ] No secrets in git history
- [ ] Environment variables or secret manager

### Transmission
- [ ] HTTPS everywhere
- [ ] No secrets in URLs
- [ ] No secrets in logs
