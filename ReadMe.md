[![Tests](https://github.com/jsoliveir/ProcessTunerCLI/actions/workflows/tests.yml/badge.svg)](https://github.com/jsoliveir/ProcessTunerCLI/actions/workflows/tests.yml)
# What is ProcessTunerCLI
ProcessTunerCLI is a tool that manages CPU priorities for processes running in a given operating system. The tool can be useful when there is a need of restricting CPUs (Cores) for processes in order to keep the operating system responsive.

# How to use it

## Import the existing module

```powershell
Install-Module ProcessTunnerCLI 

or

```powershell
Import-Module ./ProcessTunnerCLI.psm1 -Force
```

## Create the Rules file
Create a yaml file with the rules that must be applied [rules/](rules/example.yml)

```powershell
    # the directory will be created 
    New-ProcessRulesFile -Path rules/example.yml
```
Example:
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

## Set the rules (run once)

``` powershell
Get-ProcessRules | Set-ProcessRules
```

## Set the rules (a specific process)

``` powershell
Get-ProcessRules -Path rules/example.yml | Set-ProcessRules -ProcessId 
```

## Start the processes auto management (background job)

(background)
``` powershell
Start-ProcessTuner -RulesPath rules/ -Interval 10
```
(foreground)
``` powershell
Start-ProcessTuner -RulesPath rules/ -Interval 10 -Wait 
```
## Check the logs 

``` powershell
Get-Job ProcessTuner | Receive-Job
```
