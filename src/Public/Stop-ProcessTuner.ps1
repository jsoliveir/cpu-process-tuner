
Function Stop-ProcessTuner{
    Get-Job -Name "ProcessTuner" -ErrorAction SilentlyContinue | Stop-Job
    Get-Job -Name "ProcessTuner" -ErrorAction SilentlyContinue
    Get-Job -Name "ProcessTuner" -ErrorAction SilentlyContinue | Remove-Job 
}