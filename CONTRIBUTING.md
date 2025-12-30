# Contributing to PSScriptModule.Template

Thank you for your interest in contributing to PSScriptModule.Template! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and collaborative environment for everyone.

## How to Contribute

### Reporting Issues

Before creating an issue, please check if a similar issue already exists. When reporting issues:

- Use a clear and descriptive title
- Provide a detailed description of the issue
- Include steps to reproduce the problem
- Specify your PowerShell version and operating system
- Include relevant error messages or logs

### Suggesting Enhancements

We welcome suggestions for enhancements! Please:

- Use a clear and descriptive title
- Provide a detailed description of the proposed feature
- Explain why this enhancement would be useful
- Include examples of how the feature would work

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Follow the project structure**:
   - Place public functions in `src/Public/`
   - Place private functions in `src/Private/`
   - Add corresponding Pester tests with `.Tests.ps1` suffix
   - Update documentation in `docs/help/` if needed

3. **Write quality code**:
   - Follow PowerShell best practices
   - Use approved verbs for function names (Get, Set, New, etc.)
   - Include proper comment-based help for all public functions
   - Ensure your code passes PSScriptAnalyzer checks

4. **Test your changes**:
   ```powershell
   # Run all tests
   Invoke-Build Test
   
   # Run PSScriptAnalyzer
   Invoke-Build Invoke-PSScriptAnalyzer
   
   # Run Pester tests
   Invoke-Build Invoke-UnitTests
   ```

5. **Document your changes**:
   - Update the README.md if needed
    - Generate or update function help sections

6. **Commit your changes**:
   - Use clear and meaningful commit messages
   - Follow semantic versioning keywords in commit messages:
     - `+semver: breaking` or `+semver: major` for breaking changes
     - `+semver: feature` or `+semver: minor` for new features
     - `+semver: fix` or `+semver: patch` for bug fixes
     - `+semver: none` or `+semver: skip` to skip version bump

7. **Submit a pull request**:
   - Provide a clear description of the changes
   - Reference any related issues
   - Ensure all CI checks pass

## Development Setup

### Prerequisites

- PowerShell 7.0 or higher (PowerShell 5.1 minimum)
- Git
- Required modules (installed via PSDepend):
  - InvokeBuild
  - ModuleBuilder
  - Pester
  - PSScriptAnalyzer
  - PlatyPS

### Setting Up Your Development Environment

1. Clone your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/PSScriptModule.Template.git
   cd PSScriptModule.Template
   ```

2. Install dependencies:
   ```powershell
   # Install PSDepend if not already installed
   Install-Module -Name PSDepend -Scope CurrentUser
   
   # Install project dependencies
   Invoke-PSDepend -Path ./requirements.psd1 -Install -Import -Force
   ```

3. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Building the Project

Use Invoke-Build for all build tasks:

```powershell
# Full build (clean + build)
Invoke-Build

# Run tests only
Invoke-Build Test

# Create a release build
Invoke-Build -ReleaseType Release

# Clean build artifacts
Invoke-Build Clean
```

## Testing Guidelines

### Writing Tests

- Create a `.Tests.ps1` file for each function
- Use descriptive test names that explain what is being tested
- Follow the Arrange-Act-Assert pattern
- Test both success and failure scenarios
- Mock external dependencies

Example test structure:
```powershell
Describe 'Get-MyFunction' {
    Context 'When valid input is provided' {
        It 'Should return expected output' {
            # Arrange
            $input = 'test'
            
            # Act
            $result = Get-MyFunction -Input $input
            
            # Assert
            $result | Should -Be 'expected'
        }
    }
}
```

### Running Tests

```powershell
# Run all tests
Invoke-Build Test

# Run specific test file
Invoke-Pester -Path ./src/Public/Get-PSScriptModuleInfo.Tests.ps1
```

## Code Style Guidelines

- Use 4 spaces for indentation (no tabs)
- Use PascalCase for function names
- Use camelCase for parameter names
- Place opening braces on the same line
- Use explicit parameter names in function calls
- Avoid aliases in production code
- Include comment-based help for all public functions

## Documentation

- All public functions must have comment-based help
- Use PlatyPS to generate markdown documentation
- Update the README.md for significant changes
- Include examples in your documentation

## Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

Version numbers are automatically managed by GitVersion based on commit messages.

## Release Process

Releases are automated through the CI/CD pipeline:

1. Merge pull request to `main` branch
2. CI/CD pipeline automatically:
   - Calculates version number using GitVersion
   - Runs all tests and checks
   - Builds the module
   - Creates a GitHub release
   - Publishes to PowerShell Gallery (if configured)

## Getting Help

If you need help:

- Check existing issues and discussions
- Review the documentation in the `docs/` folder
- Open an issue with your question

## License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

## Recognition

Contributors will be recognized in the project's release notes and documentation.

Thank you for contributing to PSScriptModule.Template!
