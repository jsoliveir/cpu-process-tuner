[![Tests](https://github.com/jsoliveir/ProcessTunerCLI/actions/workflows/tests.yml/badge.svg)](https://github.com/jsoliveir/ProcessTunerCLI/actions/workflows/tests.yml)
# What is ProcessTunerCLI
ProcessTunerCLI is a tool that manages CPU priorities for processes running in a given operating system. The tool can be useful when there is a need of restricting CPUs (Cores) for processes in order to keep the operating system responsive.

# How to use it

## Install

```powershell
Install-Module ProcessTunnerCLI 
```

## Import

```powershell
Import-Module ./ProcessTunnerCLI.psm1 -Force
```

## Create rules
```powershell
    New-ProcessRule `
      -Selector /system32 `
      -Priority High

    New-ProcessRule `
       -Affinity CPU0,CPU1,CPU2 `
       -Priority BelowNormal `
       -Selector notepad  `
    
    New-ProcessRule `
       -Affinity CPU5,CPU6,CPU7 `
       -Priority AboveNormal 
       -Selector chrome  `
```

## Remove rules
```powerhell
    Remove-ProcessRule `
       -Selector /system32
      
    Remove-ProcessRule `
       -Priority High

    Remove-ProcessRule `
       -Selector /system32  `
       -Affinity CPU0,CPU2  `
```

## Check existing rules
```powerhell
    Get-ProcessRules
```
## Apply the rules 

``` powershell
Get-ProcessRules | Set-ProcessRules
```

## Start auto management (rule new processes)

(background)
``` powershell
Start-ProcessTuner `
    -RulesPath rules/example.yml `
    -Interval 10
```
(foreground)
``` powershell
Start-ProcessTuner `
    -RulesPath rules/example.yml `
    -Interval 10 `
    -Wait 
```
## Check the logs (background)

``` powershell
Get-Job ProcessTuner | Receive-Job -Wait
```


# Configurations 

By default ProcessTuner looks for a file named by `rules.yml` in the current working directory.

If any configuration file could not be found ProcessTuner will look for it in the parent directories.

If the configuration is still not found the one existing in the $HOME will be used.

To see what file is being using run the following command:

```powershell
 Get-ProcessConfigFile
 ```


