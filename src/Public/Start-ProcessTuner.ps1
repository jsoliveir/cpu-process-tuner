
Function Start-ProcessTuner{
    param (
        [Parameter(Mandatory=$false)] $Interval         = 10,
        [Parameter(Mandatory=$false)] $JobName          = "ProcessTuner",
        [Parameter(Mandatory=$false)] [Switch] $Watch
    )

    Stop-ProcessTuner

    Start-Job -Name $JobName {
        param($Interval, $Watch)

        if(Get-Module ProcessTuner){
            Import-Module ProcessTuner -Force -Verbose:$false
        } else {
            Install-Module ProcessTuner -Force
            Import-Module ProcessTuner -Force -Verbose:$false
        }
        
        while ($true) {
            if($Watch){ Clear-Host }
            Get-ProcessRules | Set-ProcessRules
            Start-Sleep -Seconds $Interval
        }

    } -ArgumentList $Interval, $Watch

    if($Watch){
        Get-Job $JobName | Receive-Job -Wait
    }
}
