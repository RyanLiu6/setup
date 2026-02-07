---
name: create-pr
description: Create pull requests with concise descriptions
---

# Create Pull Request

Create a pull request with a concise, well-formatted description.

## Workflow

1. **Verify branch**: Ensure you're NOT on main/master branch
2. **Review changes**: Check git status and recent commits
3. **Check with user**: Confirm before pushing (per user's git workflow rules)
4. **Push to origin**: Push to `origin` from the current branch (if needed)
5. **Create PR**: Use `gh pr create` with concise description
6. **Format description**: Small bullet points, derived from conversation and commits

## PR Description Format

Keep it **very concise**. Use this structure:

```
### Why are you making these changes?

<1-3 sentences explaining the motivation/problem being solved>

### How was this tested?

<Brief description of testing approach>
```

### Good examples

```
### Why are you making these changes?

Fix deduplication bug in welcome message that caused duplicate entries when users rejoined.

### How was this tested?

Manual testing with multiple rejoin scenarios. Added unit test for dedup logic.
```

```
### Why are you making these changes?

Add cache timestamp on initial install to prevent stale cache issues reported in #123.

### How was this tested?

Verified cache invalidation works correctly after fresh install and upgrade paths.
```

### Bad examples (too verbose)

```
### Why are you making these changes?

This PR implements a comprehensive solution to fix the deduplication
logic in the welcome message handler by refactoring the underlying
data structure and adding a new sorting algorithm that improves
performance by 50% while also addressing technical debt...
```

## Instructions

1. Check current branch: `git branch --show-current`
   - If on main/master, stop and ask user to create a feature branch

2. Review changes:
   - Run `git status` to see what's committed
   - Run `git log main..HEAD --oneline` (or `master..HEAD`) to see commits
   - Review recent conversation for context

3. Check remote status:
   - Run `git status` to see if branch is already tracking remote
   - If already pushed and up-to-date, skip push step

4. **ASK USER**: "Ready to push and create PR? Here's what will be pushed: [list commits]"
   - Wait for user confirmation
   - This respects the user's git workflow rules

5. Push changes (if user confirmed and needed):
   ```bash
   git push -u origin <current-branch>
   ```

6. Create PR with concise description:
   ```bash
   gh pr create --title "Brief title" --body "$(cat <<'EOF'
   ### Why are you making these changes?

   Brief explanation of what this change does and why.

   ### How was this tested?

   Description of testing approach.
   EOF
   )"
   ```

7. Open the PR using `open`.

## Key principles

- **Be concise**: Each bullet should be one line
- **Focus on what**: Describe the change, not implementation details
- **Derive from context**: Use commit messages and conversation
- **No fluff**: Avoid phrases like "This PR implements" or "In this change"
- **Action-oriented**: Start bullets with verbs (Add, Fix, Update, Remove)

## Notes

- If `gh pr create` fails because PR already exists, use `gh pr view --web` to open it
- Always respect user's git workflow rules (check before push, use feature branches)
- If branch is already pushed and up-to-date, can skip directly to PR creation
