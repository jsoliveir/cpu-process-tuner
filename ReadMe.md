
# How to use it

Set the CPU affinities that you want in a json file in the [rules/](rules/) directory
>(the file name does not matter, the CLI will join all the files existing in this directory)
``` json
    [
        {
            "Selector": "/process/bin/path",
            "CpuAffinity": [ 0, 1 ],
            "CpuPriority": "Normal"
        }
    ]
```

## Import the existing module

``` powershell
    Import-Module ./Module.psm1 -Force
```

## Set the rules

``` powershell
    Get-ProcessRules | Set-ProcessRules
```