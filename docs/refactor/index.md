# Moonforge Refactoring Guide

## Introduction

This refactoring guide provides a comprehensive, step-by-step plan to improve the Moonforge Flutter application's code quality, structure, and maintainability **without changing
any user-facing behavior or public APIs**. The goal is to make the codebase cleaner, more consistent, easier to test, and simpler to maintain and extend.

### Why This Refactor?

While Moonforge already has a solid foundation with feature-first architecture and good separation of concerns, any growing codebase benefits from periodic refactoring to:

- **Reduce code duplication**: Extract common patterns into reusable components
- **Improve consistency**: Standardize patterns across features
- **Enhance testability**: Make the code easier to unit test and mock
- **Increase maintainability**: Clarify structure and reduce complexity
- **Better readability**: Clean naming, documentation, and organization

### Hard Constraints

✅ **No functional changes**: The app must behave exactly the same from the user's perspective  
✅ **No API changes**: Any public interfaces that other parts of the app depend on must maintain the same API surface  
✅ **Incremental safety**: The app must build and run successfully after each step

## Refactoring Themes

This guide systematically addresses the following areas:

### 1. Architecture & Layering

- Strengthen feature boundaries and reduce cross-feature dependencies
- Clarify the separation between presentation, domain, and data concerns
- Reduce "god classes" and overly large widgets

### 2. State Management Cleanup

- Normalize Provider patterns across features
- Standardize async state handling (loading, error, success)
- Improve error handling consistency

### 3. UI/Widget Structure & Duplication Removal

- Extract common UI patterns into reusable widgets
- Consolidate repeated layouts and styling
- Break down large widget trees into smaller, focused components

### 4. Data & Service Layer Cleanup

- Standardize repository patterns
- Consolidate service layer patterns
- Improve dependency injection consistency

### 5. Testing & Tooling Improvements

- Add missing unit tests for business logic
- Introduce widget tests for complex screens
- Strengthen linting rules

### 6. Naming, Style & Documentation Consistency

- Enforce consistent naming conventions
- Remove outdated comments
- Add documentation for complex logic
- Standardize file organization

## Table of Contents

The refactoring is divided into 10 focused steps, ordered from low-risk to high-impact changes:

| Step             | Title                                    | Priority | Effort | Description                                                                                |
|------------------|------------------------------------------|----------|--------|--------------------------------------------------------------------------------------------|
| [1](step-1.md)   | Code Formatting and Linting Cleanup      | High     | S      | Standardize code style with dart format and fix lint issues                                |
| [2](step-2.md)   | File and Folder Organization Consistency | High     | M      | Ensure consistent feature structure and naming conventions; consolidate creation utilities | ✅ |
| [3](step-3.md)   | Extract Common Widget Patterns           | High     | M      | Create reusable widgets for repeated UI patterns                                           | ✅ |
| [4](step-4.md)   | Consolidate Theme and Style Utilities    | Medium   | M      | Centralize colors, text styles, and spacing constants                                      |
| [5](step-5.md)   | Standardize Async State Management       | High     | L      | Normalize loading/error/success patterns across features                                   |
| [6](step-6.md)   | Repository Pattern Consistency           | Medium   | M      | Standardize data access patterns and error handling                                        |
| [7](step-7.md)   | Service Layer Consolidation              | Medium   | M      | Reduce service duplication and clarify responsibilities                                    |
| [8](step-8.md)   | Widget Tree Simplification               | Medium   | L      | Break down large widgets into smaller, testable components                                 |
| [9](step-9.md)   | Testing Infrastructure Enhancement       | Medium   | L      | Add unit tests for business logic and widget tests for complex UI                          |
| [10](step-10.md) | Documentation and Code Comments          | Low      | M      | Update documentation and add useful code comments                                          |

## General Guidelines

### Working Through Steps

1. **One step at a time**: Complete each step fully before moving to the next
2. **One step per PR/branch**: Each step should be its own pull request for easier review
3. **Follow the order**: Steps are designed to build on each other
4. **Keep changes small**: If a step feels too large, break it into sub-steps

### Safety First

After completing each step:

1. **Run static analysis**: `flutter analyze` should pass with no new warnings
2. **Format code**: Ensure `dart format .` shows no changes
3. **Run all tests**: `flutter test` should pass completely
4. **Manual testing**: Exercise affected features manually
5. **Review changes**: Use `git diff` to verify changes match the step's intent

### Git Workflow

For each step:

```bash
# do not create a new branch from main

# Make changes following the step guide
# ... edit files ...

# Verify changes
flutter analyze
dart format .
flutter test

# Commit with clear message
git add .
git commit -m "refactor: <step description>"
```

### Verification Checklist

Before marking any step as complete:

- [ ] Code builds without errors (`flutter build` for your target platform)
- [ ] All existing tests pass (`flutter test`)
- [ ] Static analysis is clean (`flutter analyze`)
- [ ] Code is properly formatted (`dart format .`)
- [ ] Manual testing confirms no behavior changes
- [ ] PR is reviewed and approved
- [ ] No breaking changes to public APIs

### Rolling Back

If you discover issues after completing a step:

1. **Identify the problem**: What behavior changed unexpectedly?
2. **Check git history**: `git log` and `git diff` to review changes
3. **Fix forward**: Prefer fixing the issue rather than reverting
4. **Revert if necessary**: `git revert <commit>` to undo changes safely
5. **Learn**: Document what went wrong to avoid similar issues

## Estimated Timeline

- **Total effort**: ~20-30 person-days for all 10 steps
- **Recommended pace**: 1-2 steps per week
- **Expected duration**: 6-10 weeks for complete refactor

Individual step estimates:

- **S (Small)**: 1-2 days
- **M (Medium)**: 3-5 days
- **L (Large)**: 6-10 days

## Success Criteria

At the end of this refactoring effort, the codebase should exhibit:

1. ✅ **Consistency**: Similar problems solved the same way across features
2. ✅ **Reduced duplication**: Common patterns extracted and reused
3. ✅ **Improved testability**: Higher test coverage with clearer test boundaries
4. ✅ **Better maintainability**: Easier to understand, modify, and extend
5. ✅ **Clean codebase**: No technical debt from the refactoring process itself
6. ✅ **Zero behavior changes**: All features work exactly as before

## Getting Help

If you encounter issues or have questions:

1. **Review the step guide carefully**: Most common pitfalls are documented
2. **Check existing documentation**: `docs/architecture/` has useful context
3. **Ask the team**: Discuss approach before making large changes
4. **Start small**: If unsure, refactor one file first as a proof of concept

## Next Steps

Ready to begin? Start with [Step 1: Code Formatting and Linting Cleanup](step-1.md).
