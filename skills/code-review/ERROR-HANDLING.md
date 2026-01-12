# Error Handling Audit

## Swallowed Errors

### Empty Catch Blocks
```javascript
// BAD: Exception vanishes
try {
  riskyOperation();
} catch (e) {
  // nothing
}

// GOOD: At minimum, log it
try {
  riskyOperation();
} catch (e) {
  console.error('Operation failed:', e);
  throw e; // or handle appropriately
}
```

### Logged But Not Handled
```javascript
// BAD: Caller thinks it succeeded
async function getUser(id) {
  try {
    return await db.query(`SELECT * FROM users WHERE id = ?`, [id]);
  } catch (e) {
    console.log(e);
    return null; // Caller gets null, doesn't know why
  }
}

// GOOD: Let error propagate or handle explicitly
async function getUser(id) {
  try {
    return await db.query(`SELECT * FROM users WHERE id = ?`, [id]);
  } catch (e) {
    throw new UserQueryError(`Failed to fetch user ${id}`, { cause: e });
  }
}
```

## Dangerous Fallbacks

### Failure Looks Like Success
```javascript
// BAD
const data = await fetch(url).catch(() => ({}));
// Caller receives {} and processes "successfully"

// GOOD
const response = await fetch(url);
if (!response.ok) {
  throw new FetchError(`HTTP ${response.status}`);
}
const data = await response.json();
```

### Default Masks Problem
```javascript
// BAD
const config = loadConfig() ?? defaultConfig;
// If loadConfig fails, we silently use default

// GOOD
const config = loadConfig();
if (!config) {
  console.warn('Config load failed, using defaults');
}
const finalConfig = config ?? defaultConfig;
```

## Silent Degradation

### Feature Quietly Disabled
```javascript
// BAD
async function trackEvent(event) {
  if (!analyticsEnabled) return; // Silent no-op
  await analytics.track(event);
}

// GOOD: Make degradation visible
async function trackEvent(event) {
  if (!analyticsEnabled) {
    console.debug('Analytics disabled, skipping:', event.name);
    return;
  }
  await analytics.track(event);
}
```

### Partial Success Hidden
```javascript
// BAD
const results = items.map(process).filter(Boolean);
// If 3 of 10 fail, caller just sees 7 results

// GOOD: Return success/failure explicitly
const results = items.map(item => {
  try {
    return { success: true, value: process(item) };
  } catch (e) {
    return { success: false, error: e, item };
  }
});
const failures = results.filter(r => !r.success);
if (failures.length > 0) {
  console.warn(`${failures.length} items failed to process`);
}
```

## Missing Error Context

### Original Error Lost
```javascript
// BAD
try {
  await saveUser(user);
} catch (e) {
  throw new Error('Failed to save user');
  // Original error is gone!
}

// GOOD: Preserve cause
try {
  await saveUser(user);
} catch (e) {
  throw new Error('Failed to save user', { cause: e });
}
```

### No Actionable Info
```javascript
// BAD
throw new Error('Operation failed');

// GOOD
throw new Error(`Failed to update user ${userId}: ${e.message}`);
```

## Checklist

- [ ] No empty catch blocks
- [ ] Errors either propagate or are explicitly handled
- [ ] Fallbacks are logged/visible
- [ ] Partial failures are surfaced
- [ ] Error messages include context
- [ ] Original errors are preserved (cause chain)
