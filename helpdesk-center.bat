@ECHO OFF
CHCP 65001 > NUL
CLS
TITLE ServiceDesk - FIEMG
ECHO.
ECHO 1 ─ Preparação de computadores
ECHO 2 ─ Instalação avulsa
ECHO 3 ─ Rotinas
ECHO 4 ─ Sair do programa
ECHO.
CHOICE /C 1234 /M "Escolha uma das opções acima:"
GOTO :CASE-%ERRORLEVEL%
:CASE-1
    ECHO 0 ─ Instalação Online
    ECHO 1 ─ Instalação Offline
    GOTO :CASE-4
:CASE-2
    CLS
    ECHO.
    IF NOT EXIST "C:\TMP" (
        MKDIR "C:\TMP"
        SET "LOCAL=C:\TMP"
        POWERSHELL -Command "Write-Host -fore Green 'Pasta TMP criada no disco local.'"
    ) ELSE (
        IF NOT EXIST "C:\INST" (
            MKDIR "C:\INST"
            SET "LOCAL=C:\INST"
            POWERSHELL -Command "Write-Host -fore Green 'Pasta INST criada no disco local.'"
        ) ELSE (
            SET "LOCAL=C:\TMP"
            POWERSHELL -Command "Write-Host -fore Yellow 'Pasta TMP já criada no disco local.'"
        )
    )
    ECHO.
    ECHO 0 ─ 7-zip
    ECHO 1 ─ PDFSam
    ECHO 2 ─ Adobe Reader
    ECHO 3 ─ Google Chrome
    ECHO 4 ─ Mozilla Firefox
    ECHO 5 ─ Microsoft Teams
    ECHO 6 ─ Citrix Workspace
    ECHO 7 ─ Kaspersky Endpoint
    ECHO.
    SET /P N=Escolha uma das opções acima:
    :OPCAO-PRIM
        GOTO :OPCAO-%N% 2 > NUL || (
            ECHO Opção inválida.
        )
        GOTO :CASE-4
    :OPCAO-0
        IF NOT EXIST "%LOCAL%\7zip.exe" (
            CURL -o %LOCAL%\7zip.exe "https://www.7-zip.org/a/7z2301-x64.exe"
        )
        START /WAIT %LOCAL%\7zip.exe /S
        GOTO :CASE-2
    :OPCAO-1
        IF NOT EXIST "%LOCAL%\PDFSam.msi" (
            CURL -L "https://github.com/torakiki/pdfsam/releases/download/v5.1.2/pdfsam-5.1.2.msi" > %LOCAL%\PDFSam.msi
        )
        START /WAIT %LOCAL%\PDFSam.msi /quiet /norestart
    :OPCAO-2
        IF NOT EXIST "%LOCAL%\Acrobat.exe" (
            CURL -o Acrobat.exe "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2300320215/AcroRdrDCx642300320215_MUI.exe"
        )
        START /WAIT %LOCAL%\Acrobat.exe /sAll
    :OPCAO-3
        IF NOT EXIST "%LOCAL%\Chrome.msi" (
            CURL -o chrome.msi "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
        )
        START /WAIT %LOCAL%\Chrome.msi /quiet /norestart
    :OPCAO-5
        IF NOT EXIST "%LOCAL%\Teams.exe" (
            CURL -o Teams.exe "https://statics.teams.cdn.office.net/production-windows-x64/1.6.00.6754/Teams_windows_x64.exe"
        )
        START /WAIT %LOCAL%\Teams.exe /quiet /norestart
    :OPCAO-6
        IF NOT EXIST "%LOCAL%\CitrixWorkspaceApp.exe" (
            CURL -o citrix.exe "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/Receiver/Win/CitrixWorkspaceApp23.5.1.83.exe"
        )
        START /WAIT %LOCAL%\CitrixWorkspaceApp.exe /silent
    :OPCAO-7
        IF NOT EXIST "%LOCAL%\installer.exe" (
            SET /P "USER=Digite o nome do seu usuário: "
            POWERSHELL -Command "Copy-Item \\187.72.116.72\Instalacao-Hdesk\SEDE\Windows 10 e 11\installer.exe -Destination %LOCAL%\ -Credential FIEMG\%USER%"
        )
        START /WAIT %LOCAL%\installer.exe /s
:CASE-3
    ECHO.
    ECHO 0 ─ Adicionar impressora(s).
    ECHO 1 ─ Adicionar máquina ao domínio.
    ECHO 2 ─ Atualização de políticas de grupo.
    ECHO 3 ─ Falha na relação de confiança com o servidor.
    GOTO :CASE-4
:CASE-4
    ECHO.
    IF EXIST "%LOCAL%" (
        RMDIR /S /Q %LOCAL%
        POWERSHELL -Command "Write-Host -fore Yellow 'Limpando resíduos.'"
    )
    ECHO.
    ECHO Programa encerrado, pressione qualquer tecla para sair.
PAUSE > NUL