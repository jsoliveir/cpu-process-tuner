
Function Set-ProcessRules{
    [CmdletBinding()]
    param([Parameter(Mandatory = $true, ValueFromPipeline = $true)] $rules)

    BEGIN {
        Write-Host "Setting rules ..."
    }

    PROCESS{
        foreach($r in $rules){
            $r | Select-Object *
            $process =  (Get-Process `
            | Where-Object Path  -NotMatch "powershell" `
            | Where-Object Path -match $r.Selector);
            $process | Foreach-Object {
                try{
                    $_.ProcessorAffinity = [int][cores]$r.CpuAffinity
                    $_.PriorityClass = [string]$r.CpuPriority                    
                }catch{
                }
            }
        }     
    }

    END {
        Get-Process | Select-Object `
        @{n="Process"; e={$_.ProcessNAme}}, `
        @{n="Priority"; e={$_.PriorityClass}},  `
        @{n="Affinity"; e={[cores][int]$_.ProcessorAffinity}} `
        | Format-Table
    }
}