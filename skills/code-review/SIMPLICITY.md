# YAGNI & Simplicity Checklist

## Premature Abstraction

### One-Use Helpers
```javascript
// BAD: Helper used once
function formatUserName(user) {
  return `${user.first} ${user.last}`;
}
display(formatUserName(user));

// GOOD: Inline it
display(`${user.first} ${user.last}`);
```

### Over-Generalization
```javascript
// BAD: Generic for one use case
class DataProcessor<T, R> {
  constructor(private transformer: (t: T) => R) {}
  process(data: T[]): R[] { return data.map(this.transformer); }
}
new DataProcessor(x => x * 2).process(numbers);

// GOOD: Just do it
numbers.map(x => x * 2);
```

### Interface for Single Implementation
```typescript
// BAD
interface IUserService { getUser(id: string): User; }
class UserService implements IUserService { ... }

// GOOD: Skip interface until you need it
class UserService { getUser(id: string): User { ... } }
```

## Dead Code

### Unused Exports
```javascript
// Check: Is this imported anywhere?
export function unusedHelper() { ... }
```

### Commented Code
```javascript
// BAD: Delete it, git remembers
// function oldImplementation() { ... }
```

### Unreachable Branches
```javascript
// BAD: This never executes
if (process.env.NODE_ENV === 'test' && process.env.NODE_ENV === 'prod') {
  // ...
}
```

## Over-Configuration

### Feature Flags for Non-Features
```javascript
// BAD: Flag that's always true
if (config.ENABLE_USERS) { ... }

// GOOD: Just include the code
```

### Unused Options
```javascript
// BAD: Options never varied
function process(data, { format = 'json', validate = true } = {}) {
  // format is always 'json', validate is always true
}

// GOOD: Remove unused options
function process(data) {
  // hardcode the only values used
}
```

## Unnecessary Indirection

### Pass-Through Functions
```javascript
// BAD
function getUser(id) {
  return userService.getUser(id);
}

// GOOD: Call userService.getUser directly
```

### Delegation Chains
```javascript
// BAD: A calls B calls C calls D
// GOOD: A calls D directly (if possible)
```

### Event Systems for Direct Calls
```javascript
// BAD: Event for single listener
eventBus.emit('userCreated', user);
eventBus.on('userCreated', sendWelcomeEmail);

// GOOD: Just call the function
sendWelcomeEmail(user);
```

## The Three Rule

> "Three similar lines > one clever abstraction"

```javascript
// ACCEPTABLE: Repetition is fine
validateName(form.firstName);
validateName(form.lastName);
validateName(form.middleName);

// DON'T: Create abstraction for 3 uses
```

Wait for 4+ occurrences before abstracting.
