
Function Start-ProcessTuner{
    param (
        [Parameter(Mandatory=$false)] $Interval         = 10,
        [Parameter(Mandatory=$false)] $JobName          = "ProcessTuner",
        [Parameter(Mandatory=$false)] [Switch] $Backgound
    )
    Write-Host "Starting ..." -ForegroundColor cyan
    
    Stop-ProcessTuner

    Start-Job -Name $JobName {
        param($Interval, $Backgound)

        if(Get-Module ProcessTuner){
            Import-Module ProcessTuner -Force -Verbose:$false
        } else {
            Install-Module ProcessTuner -Force
            Import-Module ProcessTuner -Force -Verbose:$false
        }
        
        while ($true) {
            if(!$Backgound){ Clear-Host }
            Get-ProcessRules | Set-ProcessRules
            Start-Sleep -Seconds $Interval
        }

    } -ArgumentList $Interval, $Backgound | Out-Null

    if(!$Backgound){
        Get-Job $JobName | Receive-Job -Wait
    }else{
        Get-Job $JobName
    }
}
