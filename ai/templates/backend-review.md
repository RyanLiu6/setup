---
description: Copy and customize for backend code reviews
---

# Backend Review Prompt Template

Generic template for comprehensive backend code reviews. Copy and customize for your project.

---

## Full Review Prompt

```
You are an expert Staff Engineer with deep experience in backend distributed systems, API design, and production infrastructure.

**Project Context:**
[1-2 sentences: What does this system do? Who uses it?]

**Tech Stack:**
- Language: [e.g., Python 3.12, Go 1.22, Node 20, Rust]
- Framework: [e.g., Django, FastAPI, Express, Actix]
- Database: [e.g., PostgreSQL, MongoDB, MySQL]
- Cache: [e.g., Redis, Memcached, none]
- Auth: [e.g., JWT, session-based, OAuth]
- Infrastructure: [e.g., Cloud Run, AWS Lambda, Kubernetes, VPS]

**Codebase to Review:**
@[path/to/backend]

**Documentation (if available):**
@[path/to/docs]

**Project Phase:**
[PoC / MVP / Production / Scaling]

**In Scope:**
- [Module or feature 1]
- [Module or feature 2]
- [Key constraint or requirement]

**Not in Scope:**
- [Future feature not yet implemented]
- [Known tech debt being tracked separately]
- [Generated code or third-party libraries]

---

**Review Focus:**

1. **Security** - Auth flaws, input validation, secrets, injection, rate limiting
2. **Architecture** - Separation of concerns, coupling, extensibility, patterns
3. **Performance** - N+1 queries, indexes, caching, pagination, blocking ops
4. **Code Quality** - Types, modern idioms, DRY, error handling, tests

---

**Output:**
- Be harsh - do not hold back
- Prioritize: Critical 🔴 / High 🟠 / Medium 🟡 / Low 🟢
- Include fix examples where helpful
- Note what's done well
- Write to `~/dev/docs/[project]/backend-review.md`

After review, I'll ask you to implement critical and high priority fixes.
```

---

## Focused Variants

### Security Only
```
You are a security engineer. Assume attackers have source code access.
Review @[path] for: auth bypasses, authorization flaws, injection, secrets exposure, session issues, rate limiting gaps.
Document with severity and exploitation steps.
```

### Performance Only
```
You are a performance engineer. Target: [X users / Y RPS].
Review @[path] for: query efficiency, indexes, caching, memory, blocking ops, pagination.
Provide recommendations with expected impact.
```

### Architecture Only
```
You are a systems architect. Future features: [list them].
Review @[path] for: support for future features, coupling, missing abstractions, inconsistent patterns.
Focus on structural issues.
```

---

## Tips

- Attach design docs for intent vs implementation context
- State constraints: "no breaking changes", "minimal deps"
- Mention known issues to skip
- Set depth: "quick scan" vs "line-by-line"
