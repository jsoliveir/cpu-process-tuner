
Function Get-ProcessRules{
    param([Parameter(Mandatory=$false)] $Config = (Get-ProcessConfigFile))
    $RulesYml = (Get-Content $Config | ConvertFrom-Yaml).rules

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