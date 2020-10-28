$Public =  @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private =  @( Get-ChildItem -Path $PSScriptRoot\PRivate\*.ps1 -ErrorAction SilentlyContinue )

Write-Host -ForegroundColor cyan "Importing Process Tuner ..."
$Public | Sort-Object -Property Basename | Foreach-Object{
    Write-Host -ForegroundColor Magenta "* $($_.Basename)"
    . $_.FullName
}
$Private | Sort-Object -Property Basename | Foreach-Object{
    . $_.FullName
}

Set-Variable -Name "RulesPath" -Scope Global -Value "$PSScriptRoot\Rules"

Export-ModuleMember -Function $Public.Basename