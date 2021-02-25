Function New-ProcessRule {
    param(
        [Parameter(Mandatory=$false)] [String] $Selector        = ".*",
        [Parameter(Mandatory=$false)] [CpuPriority] $Priority   = [CpuPriority]::Normal,
        [Parameter(Mandatory=$false)] [CpuAffinity] $Affinity   = [CpuAffinity]::All,
        [Parameter(Mandatory=$false)] [String] $Config          = (Get-ProcessConfigFile -Global:$Global),
        [Parameter(Mandatory=$false)] [Switch] $Global      
    )

    if($Config -notlike "*.y*ml" )
        {  $Config = "${Config}.yml" } 

    if(!(Test-Path $Config)) 
        { New-Item -Force $Config | Out-Null}

    $Rules = Get-Content $Config | ConvertFrom-Yaml -ErrorAction Ignore -Ordered
    
    if(!$Rules) { $Rules = @{  } }

    $Rules.rules = @($Rules.rules | Where-Object selector -notlike $Selector )
   
    $Rules.rules += @([PSCustomObject] [Ordered] @{ 
        selector=$Selector
        priority=[int]$Priority
        affinity=[int]$Affinity
    })

    $Rules.rules = $Rules.rules | Sort-Object selector

    $Rules | ConvertTo-Yaml |  Set-Content $Config

    return  @([PSCustomObject] [Ordered] @{ 
        selector=$Selector
        priority=$Priority
        affinity=$Affinity
    })
}
