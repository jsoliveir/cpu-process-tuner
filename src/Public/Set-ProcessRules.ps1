
Function Set-ProcessRules{
    [CmdletBinding()]
    param([Parameter(Mandatory = $true, ValueFromPipeline = $true)] $Rule)

    BEGIN{
        Write-Host -ForegroundColor Magenta "Loading rules ..."
        $global:PROCESSES =  (Get-Process | Where-Object Path  -NotMatch "powershell");

        Get-Process powershell | ForEach-Object {
            $_.ProcessorAffinity = 255
            $_.PriorityClass = "High"
        }
        $global:EFFECTIVE_RULES = @()
    }
       
    PROCESS {
        Write-Host -ForegroundColor DarkGray `
            $Rule.Selector.PadRight(22).Substring(0,20) `
            "$($Rule.CpuPriority)".PadRight(6) "->" `
            $Rule.CpuAffinity

        $global:PROCESSES | Where-Object Path -match $Rule.Selector | Foreach-Object {

            $global:EFFECTIVE_RULES = @($global:EFFECTIVE_RULES `
                | Where-Object Name -notlike $_.ProcessName)

            $global:EFFECTIVE_RULES += ([PSCustomObject]@{
                Name       = $_.ProcessName
                Affinity   = $Rule.CpuAffinity
                Priority   = $Rule.CpuPriority
            })
        }
    }
    
    END {
        foreach($r in $global:EFFECTIVE_RULES | Select-Object * -Unique){
            Get-Process | Where-Object Name -like $r.Name | ForEach-Object {
                try{
                    $_.ProcessorAffinity = [int]$r.Affinity
                    $_.PriorityClass = [string]$r.Priority
                    Write-Host -ForegroundColor Green "$($_.ProcessName)".PadRight(20) " OK."
                }catch{
                    Write-Host -ForegroundColor Red  "$($_.ProcessName)".PadRight(20) "FAIL : " $_.Exception.Message
                }
               
            }
        }
        
        Get-Process | Select-Object `
        @{n="Process"; e={$_.ProcessName}}, `
        @{n="Priority"; e={$_.PriorityClass}},  `
        @{n="Affinity"; e={[cores][int]$_.ProcessorAffinity}} `
        | Format-Table
    }
}
