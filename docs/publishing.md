# 📦 Publishing to PowerShell Gallery

## Manual Publishing

```powershell
Invoke-Build -ReleaseType Release -NugetApiKey 'YOUR-API-KEY'
```

## Automated Publishing (CI/CD)

Configure your GitHub repository secrets:

- `NUGETAPIKEY_PSGALLERY` - Your PowerShell Gallery API key

The CI/CD pipeline will automatically publish on release.

### Manual Workflow Dispatch

You can manually trigger builds and releases via GitHub Actions workflow dispatch:

1. **Navigate to Actions** → CI workflow
1. **Click "Run workflow"**
1. **Configure options**:
   - `version-tag`: Specify a version tag to build (e.g., `v0.9.7`) - leave empty to use current commit
   - `publish`: Check to publish the release to PowerShell Gallery

This is useful for:

- Creating releases from specific commits or tags
- Re-publishing existing versions
- Testing release workflows before merging to main
