
Function Start-ProcessTuner{
    param (
        [Parameter(Mandatory=$false)] $Interval         = 10,
        [Parameter(Mandatory=$false)] $JobName          = "ProcessTuner",
        [Parameter(Mandatory=$false)] $Config           = (Get-ProcessConfigFile),
        [Parameter(Mandatory=$false)] [Switch] $Wait
    )

    Stop-ProcessTuner

    Start-Job -Name $JobName {
        param($Interval,$RulesPath)

        Import-Module ProcessTunerCLI

        while ($true) {
            Get-ProcessRules -Path $RulesPath | Set-ProcessRules
            Start-Sleep -Seconds $Interval
        }

    } -ArgumentList $Interval, $RulesPath

    if($Wait){
        Get-Job $JobName | Receive-Job -Wait
    }
}