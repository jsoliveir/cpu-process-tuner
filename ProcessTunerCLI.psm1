Install-Module powershell-yaml -ErrorAction Continue

$Scripts =  @( Get-ChildItem -Path $PSScriptRoot\src\**\*.ps1 -ErrorAction SilentlyContinue )
$Public =  @( Get-ChildItem -Path $PSScriptRoot\src\Public\*.ps1 -ErrorAction SilentlyContinue )

Write-Host -ForegroundColor cyan "Importing Process Tuner ..."
$Scripts | Sort-Object -Property Basename | Foreach-Object{
    if($_.Directory -match "Public"){
        Write-Host -ForegroundColor Magenta "* $($_.Basename)"
    }
    . $_.FullName
}

Export-ModuleMember -Function $Public.Basename
