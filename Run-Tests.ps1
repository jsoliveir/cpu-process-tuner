Install-Module Pester -Force -SkipPublisherCheck
Install-Module powershell-yaml -Force -SkipPublisherChe
Import-Module Pester -MinimumVersion 5.0.4 -Force
$ErrorActionPreference = "Stop"
Invoke-Pester