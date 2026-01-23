# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| < latest| :x:                |

## Reporting a Vulnerability

We take the security of PSScriptModule seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### Please Do Not

- **Do not** open a public GitHub issue for security vulnerabilities
- **Do not** disclose the vulnerability publicly until it has been addressed

### Please Do

1. **Report via GitHub Security Advisories**:
    - Navigate to the repository's "Security" tab
    - Click "Advisories" and then "New draft security advisory"
    - Provide detailed information about the vulnerability

1. **Include in Your Report**:
    - Description of the vulnerability
    - Steps to reproduce the issue
    - Potential impact
    - Suggested fix (if available)
    - Your contact information

## Security Best Practices

When using this PowerShell module template:

### Code Security

- **Never commit credentials**: Use `SecureString` or credential management systems
- **Validate all inputs**: Use parameter validation attributes
- **Sanitize user input**: Prevent injection attacks
- **Use approved verbs**: Follow PowerShell naming conventions
- **Handle errors properly**: Don't expose sensitive information in error messages

### Development Security

- **Run PSScriptAnalyzer**: All code must pass static analysis
- **Run InjectionHunter tests**: Check for injection vulnerabilities
- **Review dependencies**: Regularly update modules in `requirements.psd1`

### Deployment Security

- **Sign your scripts**: Use code signing certificates for production
- **Verify execution policy**: Use appropriate PowerShell execution policies
- **Limit permissions**: Follow principle of least privilege
- **Audit module usage**: Enable PowerShell logging in production environments

## Known Security Considerations

### PowerShell Execution

This module requires PowerShell script execution. Ensure:

- Execution policy is set appropriately for your environment
- Scripts are obtained from trusted sources
- Code signing is enforced in production environments

### External Dependencies

This project uses external PowerShell modules:

- **InvokeBuild**: Build orchestration
- **Pester**: Testing framework
- **PSScriptAnalyzer**: Static code analysis
- **platyPS**: Documentation generation

Review the security advisories for these dependencies regularly.

## Security Testing

### Automated Tests

Every PR runs:

1. **PSScriptAnalyzer**: Static code analysis for common issues
1. **InjectionHunter**: Detection of potential injection vulnerabilities
1. **Pester Tests**: Functional testing including security scenarios
1. **Dependency Checks**: Ensure dependencies are up-to-date

## Security Update Process

When a security vulnerability is confirmed:

1. **Assessment**: Evaluate severity and impact
1. **Fix Development**: Create patch in private branch
1. **Testing**: Thoroughly test the security fix
1. **Release**:
    - Use `+semver: patch` for minor security fixes
    - Use `+semver: major` for breaking security changes
1. **Disclosure**: Publish security advisory after fix is released
1. **Notification**: Notify users of the security update

## Additional Resources

- [PowerShell Security Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/learn/security/powershell-security-best-practices)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/Rules/README.md)
- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)

## Contact

For security-related questions that are not vulnerabilities, please open a regular GitHub issue or discussion.

---

**Thank you for helping keep PSScriptModule and its users safe!**
