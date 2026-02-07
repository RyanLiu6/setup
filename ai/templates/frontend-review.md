---
description: Copy and customize for frontend code reviews
---

# Frontend Review Prompt Template

Generic template for comprehensive frontend code reviews. Copy and customize for your project.

---

## Full Review Prompt

```
You are an expert Staff Engineer with deep experience in frontend architecture, React patterns, and modern web development.

**Project Context:**
[1-2 sentences: What does this application do? Who uses it?]

**Tech Stack:**
- Framework: [e.g., React 18, Next.js 14, Vue 3, Svelte]
- Language: [e.g., TypeScript 5.x, JavaScript ES2022]
- State Management: [e.g., Zustand, Redux Toolkit, Jotai, React Query, Context]
- Styling: [e.g., Tailwind CSS, CSS Modules, styled-components, Emotion]
- Build Tool: [e.g., Vite, Webpack, Turbopack]
- Testing: [e.g., Vitest, Jest, React Testing Library, Playwright]

**Codebase to Review:**
@[path/to/frontend]

**Design System/Components (if available):**
@[path/to/components]

**Project Phase:**
[PoC / MVP / Production / Scaling]

**In Scope:**
- [Component or feature 1]
- [Component or feature 2]
- [Key constraint or requirement]

**Not in Scope:**
- [Future feature not yet implemented]
- [Known tech debt being tracked separately]
- [Generated code or third-party libraries]

---

**Review Focus:**

1. **Component Architecture** - Composition, prop drilling, state colocation, separation of concerns
2. **Performance** - Unnecessary re-renders, missing memoization, bundle size, lazy loading
3. **Accessibility** - ARIA labels, keyboard navigation, focus management, semantic HTML
4. **State Management** - Data flow, sync vs server state, cache invalidation, race conditions
5. **Code Quality** - Types, hooks patterns, error boundaries, modern React idioms, tests

---

**Output:**
- Be harsh - do not hold back
- Prioritize: Critical 🔴 / High 🟠 / Medium 🟡 / Low 🟢
- Include fix examples where helpful
- Note what's done well
- Write to `~/dev/docs/[project]/frontend-review.md`

After review, I'll ask you to implement critical and high priority fixes.
```

---

## Focused Variants

### Performance Only
```
You are a frontend performance engineer. Target: [X users / Y Lighthouse score].
Review @[path] for: unnecessary re-renders, missing React.memo/useMemo/useCallback, large bundles, unoptimized images, layout shifts, blocking scripts, missing code splitting.
Provide recommendations with expected impact.
```

### Accessibility Only
```
You are an accessibility specialist. Target: WCAG 2.1 AA compliance.
Review @[path] for: missing ARIA attributes, keyboard traps, focus management issues, color contrast, missing alt text, semantic HTML violations, screen reader compatibility.
Document with severity and fix examples.
```

### Component Architecture Only
```
You are a React architect. Future features: [list them].
Review @[path] for: prop drilling, missing composition patterns, state colocation issues, component coupling, missing abstractions, inconsistent patterns.
Focus on structural issues that will cause pain at scale.
```

### State Management Only
```
You are a state management specialist.
Review @[path] for: server vs client state mixing, missing optimistic updates, stale data issues, race conditions, cache invalidation problems, unnecessary global state.
Provide recommendations for cleaner data flow.
```

---

## Common React Anti-patterns to Flag

- Components with 10+ props (composition needed)
- useEffect with complex dependency arrays
- State that could be derived
- Prop drilling more than 2 levels
- Missing error boundaries
- Inline function definitions in JSX causing re-renders
- Missing keys or using index as key on dynamic lists
- Direct DOM manipulation instead of refs
- Business logic in components instead of hooks/utils
- Fetching data in components instead of dedicated hooks

---

## Tips

- Attach Figma links or design specs for UI review context
- State constraints: "no breaking changes", "minimal deps", "must support SSR"
- Mention browser support requirements
- Set depth: "quick scan" vs "line-by-line"
- Include performance budgets if applicable
