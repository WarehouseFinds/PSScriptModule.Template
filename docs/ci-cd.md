# 🔄 CI/CD Pipeline

The template includes a comprehensive CI/CD pipeline that runs automatically on pull requests and pushes to main.

## Pipeline Structure

The CI workflow orchestrates multiple jobs in parallel:

1. **Setup** - Caches PowerShell module dependencies for faster builds
1. **Unit Tests** - Runs Pester tests with code coverage reporting
1. **Static Code Analysis** - Validates code with PSScriptAnalyzer rules
1. **Code Injection Analysis** - Scans for injection vulnerabilities with InjectionHunter
1. **Semantic Code Analysis** - Runs CodeQL security analysis
1. **Build** - Compiles module, generates help, creates releases, and publishes to PowerShell Gallery

### Workflow Triggers

- **Pull Request**: Runs all quality gates (tests not run for workflow-only changes)
- **Push to main**: Runs full pipeline and creates prerelease
- **Workflow Dispatch**: Manual trigger with custom version and publish options
- **Schedule**: Weekly CodeQL security scan

## Build Types

The pipeline automatically determines the build type:

| Event | Build Type | Version Format | Published |
| --------- | ---------------- | --------- |
| Pull Request | Debug | `1.2.3-PullRequest1234` | No |
| Push to main | Prerelease | `1.2.3-Prerelease` | Yes |
| Manual (workflow_dispatch) | Release | `1.2.3` | Optional |

## 🔄 Versioning Strategy

This template uses **Semantic Versioning** (SemVer) with automated version management through GitVersion.

### GitVersion Configuration

- **Workflow**: GitHub Flow (main branch + feature branches)
- **Strategy**: Every PR merge to `main` creates a new release
- **Version calculation**: Based on commit history and tags

### Controlling Version Bumps

Include one of these keywords in your commit message:

| Keyword | Version Change | Example |
| --------- | ---------------- | --------- |
| `+semver: breaking` or `+semver: major` | Major (1.0.0 → 2.0.0) | Breaking changes |
| `+semver: feature` or `+semver: minor` | Minor (1.0.0 → 1.1.0) | New features |
| `+semver: fix` or `+semver: patch` | Patch (1.0.0 → 1.0.1) | Bug fixes |
| `+semver: none` or `+semver: skip` | No change | Documentation updates |

### Example Commit Messages

```bash
git commit -m "Add new Get-Something function +semver: minor"
git commit -m "Fix parameter validation bug +semver: patch"
git commit -m "Remove deprecated function +semver: breaking"
git commit -m "Update README +semver: none"
```
