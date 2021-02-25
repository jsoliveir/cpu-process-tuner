
Function Get-ProcessRules{
    param([Parameter(Mandatory=$false)] $Config = (Get-ProcessConfigFile))
    
    $RulesYml = (Get-Content $Config -ErrorAction SilentlyContinue | ConvertFrom-Yaml).rules

    if( ! $RulesYml ){
        Write-Warning "No Rules found!"
        Write-Host -ForegroundColor DarkGray "Run [New-ProcessRule] to create the fist rule"
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