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

$dockerArgs = @("build")
If ($Path -eq ".") { $dockerArgs += "--no-cache" }
$Tags | ForEach-Object { $dockerArgs += @("--tag", "${DockerRepository}:${_}") }
$BuildArgs | ForEach-Object { $dockerArgs += @("--build-arg", $_) }
$dockerArgs += $Path

Write-Verbose "docker $($dockerArgs -join ' ')"
# AppVeyor apprently hates Start-Process (or doesn't stream stdout while in process)
& docker $dockerArgs
If ($LASTEXITCODE -ne 0) {
  Write-Error "Build failed."
}

Write-Host "Build complete."