
Describe "Get-ProcessRules" {
    BeforeAll{
        . "$(Split-Path $PSScriptRoot)\src\**\CpuCore.ps1"
        . "$(Split-Path $PSScriptRoot)\src\**\CpuPriority.ps1"
        . "$(Split-Path $PSScriptRoot)\src\**\Get-ProcessRules.ps1"
        "rules:
            - selector: (.*)
              affinity: [ 0, 1 ]
              priority: Normal
            - selector: /system32
              affinity: [ 2,3,4 ]
              priority: Normal
        " | Set-Content $PSScriptRoot\rule.yml
    }
    AfterAll {
        Remove-Item $PSScriptRoot\rule.yml -Force -ErrorAction SilentlyContinue
    }
    Context "functionality" {
        
        It "should_return_values" {
            $rules  = Get-ProcessRules -Path $PSScriptRoot
            @($rules).Count | Should -BeExactly 2
        }
    }
    Context "validations" {
        "rules:
            - selector: (.*)
              affinity: [ 0, 1 ]
              priority: xxxx" | Set-Content $PSScriptRoot\rule.yml

        It "should_throw_exception_if_model_not_valid" {
            Get-ProcessRules -Path $PSScriptRoot
            $Error.Count | Should -BeGreaterThan  0
        }
    }
}