# escape=`
ARG BaseImage=microsoft/aspnet

FROM ${BaseImage}
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Update NuGet Package Provider
RUN Install-PackageProvider -Name "NuGet" -Force

# Register repository
ARG PSRepositoryName
ARG PSRepositoryLocation
RUN Register-PSRepository $env:PSRepositoryName -SourceLocation $env:PSRepositoryLocation -InstallationPolicy Trusted

# Install USIF
ARG ModuleName=Unattended.SIF
ARG ModuleVersion=0.0.1
RUN Install-Module $env:ModuleName -Repository $env:PSRepositoryName -RequiredVersion $env:ModuleVersion -SkipPublisherCheck -Force

# Run install tasks
RUN Install-IIS ; Install-SQLDeveloper ; Install-JavaSE8

# Remove USIF & repository
RUN Get-InstalledModule $env:ModuleName -AllVersions | Uninstall-Module ; `
    Unregister-PSRepository $env:PSRepositoryName

ENTRYPOINT ["powershell"]