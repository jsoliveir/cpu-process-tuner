
Function Get-ProcessRules{
    param([Parameter(Mandatory=$false)] $Config = (Get-ProcessConfigFile))
    
    $RulesYml = (Get-Content $Config -ErrorAction SilentlyContinue | ConvertFrom-Yaml).rules

    if( ! $RulesYml ){
        Write-Warning "No Rules found!"
        return
    }


    $Rules = @()

    foreach($r in $RulesYml){
        $Rules += [PSCustomObject] [Ordered]@{
            selector = $r.selector
            priority = [CpuPriority]$r.priority
            affinity = [CpuAffinity]$r.affinity
        }
    }
    return $Rules
}