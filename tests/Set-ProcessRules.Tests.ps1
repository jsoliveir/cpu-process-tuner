
Describe "Set-ProcessRules" {
    BeforeEach{
        . "$(Split-Path $PSScriptRoot)\src\**\CpuCore.ps1"
        . "$(Split-Path $PSScriptRoot)\src\**\CpuPriority.ps1"
        . "$(Split-Path $PSScriptRoot)\src\**\Set-ProcessRules.ps1"
        Function Get-ProcessRules{
            return @([PSCustomObject]@{
                selector = "cmd"
                priority = [CpuPriority]::Idle
                affinity = [CpuAffinity]::Core1
            })
        }
        
      $global:process = Start-Process (Get-ProcessRules).selector -PassThru
    }

    AfterEach{
        $global:process | Stop-Process -Force
    }
    
    Context "functionality" {
        It "should_affect_given_process" {
            Get-ProcessRules | Set-ProcessRules -Verbose -ProcessId  $global:process.Id
            $global:process.PriorityClass | Should -Be "Idle"
            $global:process.ProcessorAffinity | Should -Be $([int][CpuAffinity]::Core1)
        }
    }

    Context "functionality" {
        It "should_affect_processes" {
            Get-ProcessRules | Set-ProcessRules -Verbose
            $global:process.PriorityClass | Should -Be "Idle"
            $global:process.ProcessorAffinity | Should -Be $([int][CpuAffinity]::Core1)
        }
    }
   
}