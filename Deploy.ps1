[CmdletBinding()]
Param(
  [Parameter(Position = 0)]
  [ValidateNotNullOrEmpty()]
  [string]$DockerRepository = "usif-docker"
  ,
  [Parameter(Position = 1)]
  [AllowEmptyCollection()]
  [string[]]$Tags = @("latest")
)
$ErrorActionPreference = "Stop"

$Tags | ForEach-Object {
  & docker push "${DockerRepository}:${_}"
  If ($LASTEXITCODE -ne 0) {
    Write-Error "Error publishing ${DockerRepository}:${_}"
  }
}

Write-Host "Deploy complete."