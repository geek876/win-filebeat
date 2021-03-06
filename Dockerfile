FROM mcr.microsoft.com/windows/servercore:1809 as core
FROM mcr.microsoft.com/powershell:preview-nanoserver-1809
COPY --from=core /windows/system32/netapi32.dll /windows/system32/netapi32.dll

ARG BEAT_VERSION=7.3.2
ARG ARCH=x86_64

LABEL Description="winlogbeat-${BEAT_VERSION}-${ARCH}" Vendor="Elastic.co" Version="${BEAT_VERSION}" Arch="${ARCH}"

RUN echo "%BEAT_VERSION%"

RUN pwsh.exe -Command \
    $ErrorActionPreference = 'Stop' ; \
    Invoke-WebRequest -Method Get -Uri https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$env:BEAT_VERSION-windows-$env:ARCH.zip -OutFile "C:\Program` Files\filebeat.zip" ; \
    Expand-Archive -Path "C:\Program` Files\filebeat.zip" -DestinationPath 'C:\Program Files' ; \
    Rename-Item "C:\Program` Files\filebeat-$env:BEAT_VERSION-windows-$env:ARCH" "C:\Program` Files\filebeat" ; \
    Remove-Item "C:\Program` Files\filebeat.zip" -Force

COPY ["entrypoint.ps1", "C:/Program Files/filebeat"]

WORKDIR "C:\Program Files\filebeat"

CMD ["pwsh.exe", "entrypoint.ps1"]
