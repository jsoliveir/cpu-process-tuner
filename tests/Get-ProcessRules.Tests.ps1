
Describe "Get-ProcessRules" {
    BeforeAll{
        . $PSScriptRoot\..\.src\**\CpuCores.ps1
        . $PSScriptRoot\..\.src\**\CpuPriorities.ps1
        . $PSScriptRoot\..\.src\**\Get-ProcessRules.ps1
        "[
            {
              `"Selector`": `"(.*)`",
              `"CpuAffinity`": [ 1,2 ],
              `"CpuPriority`": `"Normal`"
            }
        ]" | Set-Content $PSScriptRoot\rule.json
    }
    AfterAll {
        Remove-Item $PSScriptRoot\rule.json -Force
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
              `"CpuAffinity`": [ 0 ],
              `"CpuPriority`": `"Normal`"
            }
        ]" | Set-Content $PSScriptRoot\rule.json

        It "should_throw_exception_if_model_not_valid" {
            Get-ProcessRules -Path $PSScriptRoot
            $Error.Count | Should BeGreaterThan  0
        }
    }
}