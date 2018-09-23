[CmdletBinding()]
Param(
  [Parameter(Position = 0)]
  [ValidateNotNullOrEmpty()]
  [string]$DockerRepository = "local/usif-docker"
  ,
  [Parameter(Position = 1)]
  [AllowEmptyCollection()]
  [string[]]$Tags = @("latest")
  ,
  [Parameter(Position = 2)]
  [AllowEmptyCollection()]
  [string[]]$BuildArgs = @()
)
$ErrorActionPreference = "Stop"

$dockerArgs = @("build")
$Tags | ForEach-Object { $dockerArgs += @("--tag", "${DockerRepository}:${_}") }
$BuildArgs | ForEach-Object { $dockerArgs += $("--build-arg", $_) }
$dockerArgs += "."

Write-Verbose "docker $($dockerArgs -join ' ')"
$build = Start-Process docker -ArgumentList $dockerArgs -NoNewWindow -Wait -PassThru
If ($build.ExitCode -ne 0) {
  Write-Error "Build failed."
}

Write-Host "Build complete."