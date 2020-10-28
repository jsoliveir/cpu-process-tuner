
Describe "Get-ProcessRules" {
    BeforeAll{
        . $PSScriptRoot\..\.src\**\CpuCores.ps1
        . $PSScriptRoot\..\.src\**\CpuPriorities.ps1
        . $PSScriptRoot\..\.src\**\Set-ProcessRules.ps1
        Function Get-ProcessRules{
            return @([PSCustomObject]@{
                Selector = "notepad"
                CpuPriority = [priority]::Idle
                CpuAffinity = [cores]::Core1
            })
        }

      $global:process = Start-Process notepad `
        -PassThru -WindowStyle Hidden
    }

    AfterAll{
        $global:process | Stop-Process -Force
    }
    
    Context "functionality" {
        It "should_affect_processes" {
            Get-ProcessRules | Set-ProcessRules
            $global:process.PriorityClass | Should Be "Idle"
            $global:process.ProcessorAffinity | Should Be $([int][cores]::Core1)
        }
    }
   
}