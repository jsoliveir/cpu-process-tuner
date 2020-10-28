$Scripts =  @( Get-ChildItem -Path $PSScriptRoot\.src\**\*.ps1 -ErrorAction SilentlyContinue )
$Public =  @( Get-ChildItem -Path $PSScriptRoot\.src\Public\*.ps1 -ErrorAction SilentlyContinue )

Write-Host -ForegroundColor cyan "Importing Process Tuner ..."
$Scripts | Sort-Object -Property Basename | Foreach-Object{
    if($_.Directory -match "Public"){
        Write-Host -ForegroundColor Magenta "* $($_.Basename)"
    }
    . $_.FullName
}

Set-Variable -Name "RulesPath" -Scope Global -Value "$PSScriptRoot\Rules"

Get-Process powershell | ForEach-Object {
    $_.ProcessorAffinity = 255
    $_.PriorityClass = "High"
}

Export-ModuleMember -Function $Public.Basename