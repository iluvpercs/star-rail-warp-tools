# Contributing

Thanks for helping improve Star Rail Warp Tools. This project is intentionally small and dependency-free; please keep changes focused.

## Ground rules

- Do not commit Warp History URLs, auth keys, raw logcat output, or device identifiers.
- Do not add telemetry or third-party network calls without an explicit discussion first.
- Do not make the script download or install ADB automatically; users install Platform-Tools themselves.
- Preserve the existing behaviour: the script must continue to work from `irm ... | iex` and from a downloaded file.
- There is currently no `LICENSE` file. Do not assume a license when contributing.

## Development setup

- Windows with Windows PowerShell 5.1 or PowerShell 7+
- Optional: `adb.exe` on `PATH` for manual device testing
- Optional for static analysis:

```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser -Force
```

## Before opening a pull request

Run the same checks used by CI:

```powershell
# 1. PowerShell parser validation
$files = Get-ChildItem -Recurse -Filter '*.ps1' -File
foreach ($file in $files) {
    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile(
        $file.FullName, [ref]$tokens, [ref]$errors
    )
    if ($errors.Count -gt 0) { throw "Parse errors in $($file.Name)" }
}

# 2. Static analysis
Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./.psscriptanalyzer.psd1
```

Error-severity findings must be resolved. Warning-severity findings are reviewed in pull requests.

## Pull request expectations

- Describe what changed and why.
- Include the exact commands you ran to validate the change.
- Do not attach screenshots containing tokens or URLs.
- Update `CHANGELOG.md` under **Unreleased** when behaviour or documentation changes.

## Reporting issues

Use the issue templates. For bug reports, include the PowerShell version, `adb version`, your Windows version, and the script output with any URLs or tokens removed. Never paste raw logcat output into a public issue.
