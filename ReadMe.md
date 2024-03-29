[![Publish](https://github.com/jsoliveir/ProcessTunerCLI/actions/workflows/publish.yml/badge.svg)](https://github.com/jsoliveir/ProcessTunerCLI/actions/workflows/tests.yml)
# What the Process Tuner is
> Powershell 5.0+ | Powershell Core 7.0+

ProcessTuner is a tool that manages CPU affinities and priorites for processes running in a given operating system. 

It basically stands for:

1. Limiting CPU cores for running processes

2. Managing CPU priorities for process that you use often

3. Improving the operating system responsiveness


## A problem scenario ...

1. Given you're working with a computer machine...

2. The machine is running applications and services backed by processes ...

3. You figure out that a specifc process, for some reason, is consumming 100% of your total CPU power ...

4. You concluded that it is "burning" the machine resources and is the operating system is completly hanged.

## What would you do?

1. The first approach would be to find and kill the process but, sometimes that cannot be done.

2. If the process is an Antivirus, an application running in a server you might need it running and in this case, would be really good if we could control CPU resources (priorities) for that given process. 

ProcessTuner allows to set CPU affinities/priorities for processes running the the operating system. 
That means that you can isolate processes in specific CPU cores, making them slower, but letting the operating system responsive enough to work on more important tasks.

For the problematic scenario above, you could use this tool to create a `Rule` for that  given process. 

You would set the CPU affinity to [CPU1] and priority to [Idle].
That means that 100% of CPU power for that process will be only a small portion of your total CPU capacity.

The process will become slower but the other applications including the operating system will recover the responsiveness. :) 

# How to use it

## Install

```powershell
Install-Module ProcessTuner
```

## Import

```powershell
Import-Module ProcessTuner -Force
```

## List

```powershell
Get-Module ProcessTuner
```

## Update

the cleanest way

```powershell
Uninstall-Module ProcessTuner -AllVersions
Remove-Module ProcessTuner
Install-Module ProcessTuner
Import-Module ProcessTuner
```

or 

```powershell
Update-Module ProcessTuner -Force
Import-Module ProcessTuner
```

## Create rules
```powershell
New-ProcessRule `
  -Selector /system32 `
  -Priority High

New-ProcessRule `
   -Affinity CPU0,CPU1,CPU2 `
   -Priority BelowNormal `
   -Selector notepad  

New-ProcessRule `
   -Affinity CPU5,CPU6,CPU7 `
   -Priority AboveNormal `
   -Selector chrome  
```

## Remove rules
```powershell
Remove-ProcessRule `
   -Selector /system32

Remove-ProcessRule `
   -Priority High

Remove-ProcessRule `
   -Selector /system32 `
   -Affinity CPU0,CPU2  
```

## Manage Rules thru the config file

```powershell
Start-Process $(Get-ProcessConfigFile)
```

or 

```powershell
code $(Get-ProcessConfigFile)
```

Config file structure

```yaml
rules:
- selector: chrome    # process or path (regex)
  priority: 2         # priority value 
  affinity: 3         # affinity mask
  
- selector: notepad
  priority: 2
  affinity: 255
```

CPU priority values:

https://github.com/jsoliveir/process-cpu-tuner/blob/master/src/Enum/CpuPriority.ps1

CPU affinity mask values:

https://github.com/jsoliveir/process-cpu-tuner/blob/master/src/Enum/CpuAffinity.ps1

CPU affinity mask calculator:

https://bitsum.com/tools/cpu-affinity-calculator/

## Check existing rules

```powershell
Get-ProcessRules
```

    selector priority         affinity
    -------- --------         --------
    chrome   RealTime CPU0, CPU1, CPU2
    code         High              All
    .*         Normal              All

## Apply the rules once (testing)

```powershell
Get-ProcessRules | Set-ProcessRules
```

## Start auto management (attached)
```powershell
Start-ProcessTuner 
```

## Start auto management (background / dettached)

```powershell
Start-ProcessTuner -Background
```

## Extra args

```powershell
Start-ProcessTuner `
    -RulesPath rules/example.yml `
    -Interval 10 `
    -Background
```



## Check the logs (background)

```powershell
Get-Job ProcessTuner | Receive-Job -Keep
```

## Attach to the job (realtime)
```powershell
Get-Job ProcessTuner | Receive-Job -Wait
```

# 

![](img/print.png "ProcessTuner CLI")

# 

## Hide/Minimize current the console window

```powershell
Set-WindowStyle -Style MINIMIZE
```

```powershell
Set-WindowStyle -Style MAXIMIZE
```

```powershell
Set-WindowStyle -Style SHOWDEFAULT
```



Allowed Window Styles:

    'FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 
    'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 
    'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL'



# Configurations 

By default ProcessTuner looks for a file named by `rules.yml` in the current working directory.

If any configuration file could not be found ProcessTuner will look for it in the parent directories.

If the configuration is still not found the one existing in the $HOME will be used.

To see what file is being using run the following command:

## Get the current config file path

```powershell
 Get-ProcessConfigFile
 ```


