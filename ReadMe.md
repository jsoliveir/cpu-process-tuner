
# How to use it

Import the existing module

``` powershell
    Import-Module ./ProcessTuner.ps1 -Force
```

Set the rules defined in Rules/ directory

``` powershell
    Get-ProcessRules | Set-ProcessRules
```