
Function Set-ProcessRules{
    param([Parameter(Mandatory = $true, ValueFromPipeline = $true)] $rules)

    PROCESS{
        $processes =  Get-Process
        foreach($r in $rules){
            $process =  ($processes | Where-Object Path -match $r.Selector);
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
        @{n="Process"; e={$_.Name}}, `
        @{n="Affinity"; e={[cores][int]$_.ProcessorAffinity}}, `
        @{n="Priority"; e={$_.PriorityClass}}
    }
}