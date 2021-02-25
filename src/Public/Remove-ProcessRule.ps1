Function Remove-ProcessRule {
    param(
        [Parameter(Mandatory=$false)] [String] $Selector,
        [Parameter(Mandatory=$false)] [CpuPriority] $Priority,
        [Parameter(Mandatory=$false)] [CpuAffinity] $Affinity,
        [Parameter(Mandatory=$false)] [String] $Config = (Get-ProcessConfigFile)
    )

    if(!(Test-Path $Config)) 
        { return }

    $Rules = Get-Content $Config | ConvertFrom-Yaml -ErrorAction Ignore -Ordered
    
    if(!$Rules) { $Rules = @{  } }

    $Rules.rules = @($Rules.rules `
        | Where-Object { !($_.selector) -or $_.selector -notlike $Selector } `
        | Where-Object { !($_.priority) -or $_.priority -ne [int]$Priority } `
        | Where-Object { !($_.affinity) -or $_.affinity -ne [int]$Affinity } `
        | Sort-Object selector)

    $Rules | ConvertTo-Yaml |  Set-Content $Config

}
