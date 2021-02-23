[![Tests](https://github.com/jsoliveir/ProcessTunerCLI/actions/workflows/tests.yml/badge.svg)](https://github.com/jsoliveir/ProcessTunerCLI/actions/workflows/tests.yml)
# What is ProcessTunerCLI
ProcessTunerCLI is a tool that manages CPU priorities for processes running in a given operating system. The tool can be useful when there is a need of restricting CPUs (Cores) for processes in order to keep the operating system responsive.

# How to use it

Set the CPU affinities that you want in a json file in the [rules/](rules/) directory
>(the file name does not matter, the CLI will join all the files existing in this directory)
``` yaml
rules:
  - selector: (.*)              # process path matching regex
    affinity: [ 0, 1 ]          # core0 and core1
    priority: "Normal"          # priority Normal

  - selector: /system32
    affinity: [ 2,3,4 ]
    priority: "Normal"

  - selector: isolated_process.exe
    affinity: [ 5 ]
    priority: "High"
```

## Import the existing module

```powershell
Instal-Module ProcessTunnerCLI 
```

or

```powershell
Import-Module ./ProcessTunnerCLI.psm1 -Force
```

## Set the rules (affecting all processes)

``` powershell
Get-ProcessRules | Set-ProcessRules
```

## Set the rules (a specific process)

``` powershell
    Get-ProcessRules | Set-ProcessRules -ProcessId 
```

## Start the processes auto management

``` powershell
    Start-ProcessTuner
```
