
Describe "Get-ProcessRules" {
    BeforeAll{
        . "$(Split-Path $PSScriptRoot)\src\**\CpuCores.ps1"
        . "$(Split-Path $PSScriptRoot)\src\**\CpuPriorities.ps1"
        . "$(Split-Path $PSScriptRoot)\src\**\Get-ProcessRules.ps1"
        "[
            {
              `"Selector`": `"(.*)`",
              `"affinity`": [ 1,2 ],
              `"priority`": `"Normal`"
            }
        ]" | Set-Content $PSScriptRoot\rule.json
    }
    AfterAll {
        Remove-Item $PSScriptRoot\rule.json -Force -ErrorAction SilentlyContinue
    }
    Context "functionality" {
        
        It "should_return_values" {
            $rules  = Get-ProcessRules -Path $PSScriptRoot
            @($rules).Count | Should BeExactly 1
        }
    }
    Context "validations" {
        "[
            {
              `"Selector`": `"(.*)`",
              `"affinity`": [ 0 ],
              `"priority`": `"Normal`"
            }
        ]" | Set-Content $PSScriptRoot\rule.json

        It "should_throw_exception_if_model_not_valid" {
            Get-ProcessRules -Path $PSScriptRoot
            $Error.Count | Should BeGreaterThan  0
        }
    }
}