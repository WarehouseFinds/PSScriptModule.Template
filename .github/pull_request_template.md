# Description

<!-- Provide a brief description of the changes in this PR -->

## Type of Change

<!-- Mark the relevant option with an 'x' -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Performance improvement
- [ ] Test improvement

## Semantic Versioning

<!-- Include the appropriate keyword in your commit message to control versioning -->

- [ ] `+semver: major` - Breaking changes (1.0.0 → 2.0.0)
- [ ] `+semver: minor` - New features (1.0.0 → 1.1.0)
- [ ] `+semver: patch` - Bug fixes (1.0.0 → 1.0.1)
- [ ] `+semver: none` - No version change (documentation, tests)

## Checklist

<!-- Mark completed items with an 'x' -->

### Code Quality

- [ ] Code follows PowerShell best practices and approved verbs
- [ ] All functions include `[CmdletBinding()]` attribute
- [ ] Parameter validation attributes are used appropriately
- [ ] Proper error handling with try/catch blocks is implemented
- [ ] Verbose output is provided for troubleshooting
- [ ] No hard-coded paths, credentials, or sensitive data

### Testing

- [ ] All new functions have corresponding `.Tests.ps1` files
- [ ] Existing tests pass: `Invoke-Build Test`
- [ ] New tests added for new functionality
- [ ] Code coverage is adequate
- [ ] Edge cases are tested (null/empty inputs)

### Code Analysis

- [ ] PSScriptAnalyzer passes: `Invoke-Build Invoke-PSScriptAnalyzer`
- [ ] No new PSScriptAnalyzer warnings introduced
- [ ] Security checks pass (InjectionHunter tests)

### Documentation

- [ ] Comment-based help is complete and accurate
- [ ] Markdown help files updated (if function signatures changed)
- [ ] Examples included in help documentation
- [ ] README.md updated (if applicable)
- [ ] CHANGELOG.md updated (if applicable)

### Module Manifest

- [ ] New public functions added to `FunctionsToExport` in `.psd1`
- [ ] Module manifest version updated (if applicable)

## Related Issues

<!-- Link related issues using #issue_number or 'Fixes #issue_number' for auto-closing -->

Closes #

## Additional Notes

<!-- Add any additional context, screenshots, or information about the PR here -->
