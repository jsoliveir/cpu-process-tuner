
Function Start-ProcessTuner{
    param ([Parameter(Mandatory=$false)] $Interval = 30)

    Start-Job -Name "ProcessTuner" {
        Import-Module -Force ProcessTunerCLI 
        Stop-ProcessTuner
        while ($true) {
            Get-ProcessRules | Set-ProcessRules
            Start-Sleep -Seconds $Interval
        }
    } -ArgumentList $Interval
}