
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
                    $_ | Select-Object `
                        @{n="Process"; e={$_.Name}}, `
                        @{n="Rule"; e={$r.Selector}}, `
                        @{n="Affinity"; e={$_.ProcessorAffinity}}, `
                        @{n="Priority"; e={$_.PriorityClass}}
                }catch{
                    Write-Warning $_.Exception.Message
                }
            }
        }
    }
}