# escape=`
ARG BaseImage=microsoft/aspnet

FROM ${BaseImage}
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Install-PackageProvider -Name 'NuGet' -Force

ARG ModuleName=Unattended.SIF
ARG ModuleVersion=0.1
ARG PSRepositoryName
ARG PSRepositoryLocation

RUN Register-PSRepository $env:PSRepositoryName -SourceLocation $env:PSRepositoryLocation -InstallationPolicy Trusted ; `
    Install-Module $env:ModuleName -Repository $env:PSRepositoryName -RequiredVersion $env:ModuleVersion -SkipPublisherCheck -Force ; `
    Invoke-SystemCheck | ConvertTo-Json | Out-Host

RUN Install-IIS

ENTRYPOINT ["powershell"]