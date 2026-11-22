@{
    # Write-Host is intentional: this script is an interactive CLI utility.
    ExcludeRules = @(
        'PSAvoidUsingWriteHost',
        'PSUseShouldProcessForStateChangingFunctions'
    )

    Rules = @{}
}
