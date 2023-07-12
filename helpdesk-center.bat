@ECHO OFF
CHCP 65001 > NUL
CLS
TITLE ServiceDesk - FIEMG
ECHO.
ECHO    ░▒█▀▀▀░▀█▀░▒█▀▀▀░▒█▀▄▀█░▒█▀▀█
ECHO    ░▒█▀▀░░▒█░░▒█▀▀▀░▒█▒█▒█░▒█░▄▄
ECHO    ░▒█░░░░▄█▄░▒█▄▄▄░▒█░░▒█░▒█▄▄▀
ECHO.
ECHO.
ECHO 1 ─ Preparação de computadores
ECHO 2 ─ Instalação avulsa
ECHO 3 ─ Rotinas
ECHO 4 ─ Sair do programa
ECHO.
CHOICE /C 1234 /M "Escolha uma das opções acima:"
GOTO :CASE-%ERRORLEVEL%
:CASE-1
    ECHO Os arquivos deverão estar na mesma pasta deste script com o nome TMP.
    PAUSE
    START /WAIT TMP\7zip.exe /S
    START /WAIT TMP\PDFSam.msi /QUIET /NORESTART
    START /WAIT TMP\Acrobat.exe /sAll
    START /WAIT TMP\Chrome.msi /PASSIVE
    START /WAIT TMP\Teams.exe -s
    START /WAIT TMP\CitrixWorkspaceApp.exe /silent
    START /WAIT TMP\installer.exe /s
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
    ECHO 8 - Microsoft Office
    ECHO.
    SET /P "N=Escolha uma das opções acima:"
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
        GOTO :CASE-4
    :OPCAO-1
        IF NOT EXIST "%LOCAL%\PDFSam.msi" (
            CURL -o %LOCAL%\PDFSam.msi -L "https://github.com/torakiki/pdfsam/releases/download/v5.1.2/pdfsam-5.1.2.msi"
        )
        START /WAIT %LOCAL%\PDFSam.msi /QUIET /NORESTART
        GOTO :CASE-4
    :OPCAO-2
        IF NOT EXIST "%LOCAL%\Acrobat.exe" (
            CURL -o %LOCAL%\Acrobat.exe "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2300320215/AcroRdrDCx642300320215_MUI.exe"
        )
        START /WAIT %LOCAL%\Acrobat.exe /sAll
        GOTO :CASE-4
    :OPCAO-3
        IF NOT EXIST "%LOCAL%\Chrome.msi" (
            CURL -o %LOCAL%\Chrome.msi "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
        )
        START /WAIT %LOCAL%\Chrome.msi /PASSIVE
        GOTO :CASE-4
    :OPCAO-5
        IF NOT EXIST "%LOCAL%\Teams.exe" (
            CURL -o %LOCAL%\Teams.exe "https://statics.teams.cdn.office.net/production-windows-x64/1.6.00.6754/Teams_windows_x64.exe"
        )
        START /WAIT %LOCAL%\Teams.exe -s
        GOTO :CASE-4
    :OPCAO-6
        IF NOT EXIST "%LOCAL%\CitrixWorkspaceApp.exe" (
            CURL -o %LOCAL%\CitrixWorkspaceApp.exe "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/Receiver/Win/CitrixWorkspaceApp23.5.1.83.exe"
        )
        START /WAIT %LOCAL%\CitrixWorkspaceApp.exe /silent
        GOTO :CASE-4
    :OPCAO-7
        IF NOT EXIST "%LOCAL%\installer.exe" (
            SET /P "USERNAME=Digite seu nome de usuário:"
            SET /P "PASSWORD=Digite sua senha (aparecerá no console):"
            POWERSHELL -Command "NET USE J: '\\ATALEIA\Instalacao-Hdesk' /USER:FIEMG\%USERNAME% %PASSWORD%"
            POWERSHELL -Command "Copy-Item -Path 'J:\SEDE\Windows 10 e 11\installer.exe' -Destination '%LOCAL%\installer.exe'"
            POWERSHELL -Command "NET USE J: /DELETE"
        )
        START /WAIT %LOCAL%\installer.exe /s
        GOTO :CASE-4
    :OPCAO-8
        ECHO.
        ECHO Versões disponíveis
        ECHO 0 - 2010
        ECHO 1 - 2013
        ECHO 2 - 2016
        ECHO 3 - 2019
        ECHO 4 - 2021
        SET /P "N=Escolha a versão do Office:"
        :OFFICEV-PRIM
        GOTO :OFFICEV-%N% 2 > NUL || (
            ECHO Opção inválida.
        )
        :OFFICEV-0
            SET /P "USERNAME=Digite seu nome de usuário:"
            SET /P "PASSWORD=Digite sua senha (aparecerá no console):"
            NET USE K: "\\TARUMIRIM\SOFTWARE$\10-PROGRAMAS\Microsoft Office" /USER:FIEMG\%USERNAME% %PASSWORD%
            "K:\Microsoft Office 2010\setup.exe"
            NET USE K: /DELETE
            GOTO :CASE-4
        :OFFICEV-1
            SET /P "USERNAME=Digite seu nome de usuário:"
            SET /P "PASSWORD=Digite sua senha (aparecerá no console):"
            NET USE K: "\\TARUMIRIM\SOFTWARE$\10-PROGRAMAS\Microsoft Office" /USER:FIEMG\%USERNAME% %PASSWORD%
            "K:\Microsoft Office 2013\setup.exe"
            NET USE K: /DELETE
            GOTO :CASE-4
        :OFFICEV-2
            SET /P "USERNAME=Digite seu nome de usuário:"
            SET /P "PASSWORD=Digite sua senha (aparecerá no console):"
            NET USE K: "\\TARUMIRIM\SOFTWARE$\10-PROGRAMAS\Microsoft Office" /USER:FIEMG\%USERNAME% %PASSWORD%
            "K:\Microsoft Office 2016\setup.exe"
            NET USE K: /DELETE
            GOTO :CASE-4
        :OFFICEV-3
            SET /P "USERNAME=Digite seu nome de usuário:"
            SET /P "PASSWORD=Digite sua senha (aparecerá no console):"
            SET /P "ENT=Digite a entidade:"
            NET USE K: "\\TARUMIRIM\SOFTWARE$\10-PROGRAMAS\Microsoft Office" /USER:FIEMG\%USERNAME% %PASSWORD%
            "K:\Microsoft Office  2019 Pro Plus\setup.exe /configure K:\Microsoft Office 2019 Pro Plus\config-%ENT%.xml"
            NET USE K: /DELETE
            GOTO :CASE-4
        :OFFICEV-4
            SET /P "USERNAME=Digite seu nome de usuário:"
            SET /P "PASSWORD=Digite sua senha (aparecerá no console):"
            SET /P "ENT=Digite a entidade:"
            NET USE K: "\\TARUMIRIM\SOFTWARE$\10-PROGRAMAS\Microsoft Office" /USER:FIEMG\%USERNAME% %PASSWORD%
            "K:\Microsoft Office 2021 Pro Plus\setup.exe /configure K:\Microsoft Office 2021 Pro Plus\config-office2021-%ENT%.xml"
            NET USE K: /DELETE
            GOTO :CASE-4
:CASE-3
    ECHO.
    ECHO 0 ─ Adicionar impressora(s)
    ECHO 1 ─ Adicionar máquina ao domínio
    ECHO 2 ─ Atualização de políticas de grupo
    ECHO 3 - Windows Update
    ECHO 4 - Verificador de Arquivos de Sistema *
    SET /P "N=Escolha uma das opções acima:"
    :ROT-PRIM
        GOTO :ROT-%N% 2 > NUL || (
            ECHO Opção inválida.
        )
        GOTO :CASE-4
    :ROT-0
        SET /P "EDF=Informe o prédio em questão (RBA | AF):"
        SET /P "ANDAR=Informe seu andar:"
        SET "PREFIX_IMPRESSORA=%EDF%-%ANDAR%-"
        SET "SERVER=\\OLIVEIRA"
        POWERSHELL -Command "Get-Printer -Name '%PREFIX_IMPRESSORA%*' | ForEach-Object { Add-Printer -Name $_.Name -ConnectionName '%SERVER%\'+$_.Name }"
        GOTO :CASE-4
    :ROT-1
        SET /P "USER=Digite o nome do seu usuário:"
        SET /P "NOMEDOPC=Digite o nome do computador:"
        POWERSHELL -Command "Add-Computer -ComputerName %NOMEDOPC% -DomainName 'fiemg.com.br' -Credential FIEMG\%USER% -Force"
        GOTO :CASE-4
    :ROT-2
        GPUPDATE /FORCE
        POWERSHELL -Command "Test-ComputerSecureChannel -Verbose"
        GOTO :CASE-4
    :ROT-3
        SETLOCAL
        FOR /F %%I IN ('powershell.exe -ExecutionPolicy Bypass -Command "(Get-WmiObject -Class Win32_OperatingSystem).Version"') do set OS_VERSION=%%I
        IF "%OS_VERSION:~0,3%"=="6.1" (
            START control update
        ) ELSE IF "%OS_VERSION:~0,3%"=="6.2" (
            START control update
        ) ELSE IF "%OS_VERSION:~0,3%"=="10." (
            START ms-settings:windowsupdate
        ) ELSE IF "%OS_VERSION:~0,3%"=="11." (
            START ms-settings:windowsupdate
        )
        ENDLOCAL
        GOTO :CASE-4
    :ROT-4
        POWERSHELL -Command "Write-Host -fore Yellow 'Para executar estes comandos, é necessário que esteja executando como ADMINISTRADOR.'"
        PAUSE
        START /WAIT DISM /Online /Cleanup-image /Restorehealth
        START /WAIT SFC /SCANNOW
        GOTO :CASE-4
:CASE-4
    ECHO.
    IF EXIST "%LOCAL%" (
        RMDIR /S /Q %LOCAL%
        POWERSHELL -Command "Write-Host -fore Yellow 'Limpando resíduos.'"
    )
    ECHO.
    POWERSHELL -Command "Write-Host -fore Cyan 'Programa encerrado, pressione qualquer tecla para sair.'"
PAUSE > NUL