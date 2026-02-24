---
name: 💥 Breaking Change (Major)
about: Submit a breaking change (version bump: MAJOR)
title: '[major] '
labels: 'breaking-change, major'
assignees: ''
---

## ⚠️ Breaking Change

## What's Breaking?
<!-- Describe what existing functionality this changes or removes -->

## Reason for Breaking Change
<!-- Why is this breaking change necessary? -->

## Migration Path
<!-- How can users/developers adapt to this change? -->

**Before:**
```
<!-- Example of old behavior -->
```

**After:**
```
<!-- Example of new behavior -->
```

## Implementation
<!-- How did you implement this change? -->

## Impact Assessment
<!-- What does this affect? -->

- [ ] Changes default behavior
- [ ] Removes features
- [ ] Changes menu structure
- [ ] Requires new macOS version
- [ ] Changes data format
- [ ] Other: ___

## Testing
<!-- How did you test this change? -->

- [ ] Tested new behavior works correctly
- [ ] Verified breaking changes are intentional
- [ ] Built and ran the app locally
- [ ] Tested upgrade path from previous version

## Documentation Updates
<!-- What documentation needs updating? -->

- [ ] Updated README
- [ ] Updated VERSIONING.md
- [ ] Added migration guide
- [ ] Updated inline comments

## Version Bump
**Type:** MAJOR (e.g., 0.9.0 → 1.0.0)

This PR will trigger a major version bump when merged.

⚠️ **Important:** Use `[major]` prefix or `BREAKING CHANGE` in your merge commit to ensure proper version bumping.

## Additional Context
<!-- Any other relevant information -->

## Checklist for Reviewers
- [ ] Breaking changes are justified
- [ ] Migration path is clear
- [ ] Documentation is updated
- [ ] All tests pass
