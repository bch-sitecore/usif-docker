[CmdletBinding()]
Param()
$ErrorActionPreference = "Stop"

$osVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx
Write-Host "Server version ${osVersion}"

$psVersion = $PSVersionTable.PSVersion
Write-Host "PowerShell version ${psVersion}"

docker version

Write-Host "Install complete."