# escape=`
ARG BaseImage=microsoft/aspnet

FROM ${BaseImage}
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

COPY ./temp /temp
RUN Write-Host "Moving temp to" $env:TEMP ; Move-Item \temp\* -Destination $env:TEMP

RUN Install-PackageProvider -Name 'NuGet' -Force

ARG ModuleName=Unattended.SIF
ARG ModuleVersion=0.1
ARG PSRepositoryName
ARG PSRepositoryLocation

RUN Register-PSRepository $env:PSRepositoryName -SourceLocation $env:PSRepositoryLocation -InstallationPolicy Trusted ; `
    Install-Module $env:ModuleName -Repository $env:PSRepositoryName -RequiredVersion $env:ModuleVersion -SkipPublisherCheck -Force

RUN Install-IIS -Verbose ; Install-SQLDeveloper -Verbose

ENTRYPOINT ["powershell"]