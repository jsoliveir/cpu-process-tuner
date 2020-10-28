
Function Set-ProcessRules{
    param([Parameter(Mandatory = $true, ValueFromPipeline = $true)] $rules)

    BEGIN {
        Write-Host "Setting rules ..."
    }

    PROCESS{
        foreach($r in $rules){
            $process =  (Get-Process | Where-Object Path -match $r.Selector);
            $process | Foreach-Object {
                try{
                    $_.ProcessorAffinity = [int][cores]$r.CpuAffinity
                    $_.PriorityClass = [string]$r.CpuPriority  
                    Get-Process | Select-Object `
                    @{n="Process"; e={$_.Name}}, `
                    @{n="Priority"; e={$_.PriorityClass}},  `
                    @{n="Affinity"; e={[cores][int]$_.ProcessorAffinity}}
                }catch{
                    Write-Warning $_.Exception.Message
                }
            }
        }     
    }
}