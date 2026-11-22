## Summary

<!-- Describe what changed and why. -->

## Validation

<!-- List the exact commands you ran and their results. Remove URLs and tokens from any output. -->

- [ ] PowerShell parser validation passed
- [ ] `Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./.psscriptanalyzer.psd1` has no error-severity findings

## Checklist

- [ ] No Warp History URLs, auth keys, or raw logcat output are included
- [ ] No telemetry or unnecessary network requests were added
- [ ] `irm ... | iex` usage still works
- [ ] `CHANGELOG.md` updated under **Unreleased** if behaviour or documentation changed
- [ ] Documentation updated if user-facing behaviour changed

## Related issues

<!-- Link issues with "Closes #..." if applicable. -->
