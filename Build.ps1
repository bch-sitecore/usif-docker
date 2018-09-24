[CmdletBinding()]
Param(
  [Parameter(Position = 0)]
  [ValidateNotNullOrEmpty()]
  [string]$DockerRepository = "usif-docker"
  ,
  [Parameter(Position = 1)]
  [AllowEmptyCollection()]
  [string[]]$Tags = @("latest")
  ,
  [Parameter(Position = 2)]
  [AllowEmptyCollection()]
  [string[]]$BuildArgs = @()
  ,
  [Parameter()]
  [string]$Path = "."
)
$ErrorActionPreference = "Stop"

$dockerArgs = @("build", "--no-cache")
$Tags | ForEach-Object { $dockerArgs += @("--tag", "${DockerRepository}:${_}") }
$BuildArgs | ForEach-Object { $dockerArgs += @("--build-arg", $_) }
$dockerArgs += $Path

Write-Verbose "docker $($dockerArgs -join ' ')"
$result = Start-Process docker -ArgumentList $dockerArgs -Wait -NoNewWindow -PassThru
If ($result.ExitCode -ne 0) {
  Write-Error "Build failed."
}

Write-Host "Build complete."