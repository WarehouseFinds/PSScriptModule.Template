@{
    # Build dependencies
    InvokeBuild      = @{ target = 'CurrentUser'; version = 'latest' }
    ModuleBuilder    = @{ target = 'CurrentUser'; version = 'latest' }
    Pester           = @{ target = 'CurrentUser'; version = '5.7.1' }
    PSScriptAnalyzer = @{ target = 'CurrentUser'; version = 'latest' }
    InjectionHunter  = @{ target = 'CurrentUser'; version = 'latest' }
    PlatyPS          = @{ target = 'CurrentUser'; version = 'latest' }
}