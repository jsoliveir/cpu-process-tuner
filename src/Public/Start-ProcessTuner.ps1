
Function Start-ProcessTuner{
    param (
        [Parameter(Mandatory=$false)] $Interval = 10,
        [Parameter(Mandatory=$false)] $JobName = "ProcessTuner",
        [Parameter(Mandatory=$false)] [Switch] $Wait
    )

    Stop-ProcessTuner

    Start-Job -Name $JobName {
        param($Interval)

        Import-Module ProcessTunerCLI

        while ($true) {
            Get-ProcessRules | Set-ProcessRules
            Start-Sleep -Seconds $Interval
        }

    } -ArgumentList $Interval

    if($Wait){
        Get-Job $JobName | Receive-Job -Wait
    }
}