# Contributing

This repository contains a large native codebase and documentation added during the `main` consolidation.

## Branching

Use feature branches for changes:

```text
feature/<short-name>
docs/<short-name>
fix/<short-name>
```

## Documentation changes

When adding documentation:

- reference real files from the repository;
- avoid claiming unverified features;
- keep examples minimal unless the referenced API has been confirmed;
- update `docs/source-map.md` when documenting new source files;
- update `CHANGELOG.md` for repository-level changes.

## Code changes

When changing source code:

- keep changes focused;
- document the build target used for testing;
- mention affected modules;
- include screenshots/logs only when useful;
- avoid unrelated formatting churn in Lazarus project files.

## Pull request checklist

- [ ] The change has a clear purpose.
- [ ] Relevant documentation is updated.
- [ ] `python scripts/validate-repository.py` passes.
- [ ] Build/test notes are included when native code changes.
- [ ] No unverified claims were added to documentation.
