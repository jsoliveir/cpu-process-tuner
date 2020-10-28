
Function Get-ProcessRules{
    param([Parameter(Mandatory=$false)] $Path 
        = $(Get-Variable RulesPath).Value)
    $rules =  (
        Get-ChildItem `
            -Recurse $Path `
            -Filter *.json
    ) | Get-Content | ConvertFrom-Json

    foreach($r in $rules){
        $affinity = ($r.CpuAffinity | Select-Object @{
            n="affinity"
            e={[cores][int]$_}
        }).affinity
       
       #validate affinities
       [int][cores]$affinity | Out-Null

       $r.CpuAffinity = $affinity
       $r.CpuPriority = [priority]$r.CpuPriority
    }
    
    return $rules | Sort-Object { $_.Selector.Length } 
}