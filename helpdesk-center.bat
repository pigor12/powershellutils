@ECHO OFF
CHCP 65001 > NUL
CLS
TITLE ServiceDesk - FIEMG
SETLOCAL EnableDelayedExpansion
ECHO.
ECHO ----------------------------------------------------
ECHO ==+++=::::::==::++::::::-+-:::-++=:::-+++-:::::=++==
ECHO ==+++:  ----+  .+:  ----=+  . .+=    -+:  :==.  ++==
ECHO ==+++  .---+=  -+   ::::+- .- .+ .:  +:  =+----=++==
ECHO ++++-  ----+.  +-  -====+. --   .+  -+   ++-:  -++++
ECHO ++++  .++++=  :+.  ....==  +=  .+=  ++-   ::.  +++++
ECHO ==++==++++++==++=======++=+++==+++=++++++====+++++==
ECHO.
ECHO  Federação das Indústrias do Estado de Minas Gerais
ECHO.
ECHO.
ECHO Autor: Pedro Igor Martins dos Reis
:MENU
    ECHO.
    ECHO [0] SAIR
    ECHO [1] Preparação de computadores
    ECHO [2] Instalação avulsa
    ECHO [3] Rotinas
    ECHO.
    SET /P "ESCOLHA=Digite a opção que deseja e pressione ENTER: "
    IF "%ESCOLHA%" == "0" GOTO :FIM
    IF "%ESCOLHA%" == "1" GOTO :PREP
    IF "%ESCOLHA%" == "2" GOTO :INST_MENU
    IF "%ESCOLHA%" == "3" GOTO :ROT_MENU
:PREP
    POWERSHELL -Command  "Write-Host -fore Yellow 'Verifique se o diretório C:\TMP está disponível e com todos os arquivos necessários.'"
    IF NOT EXIST "C$\TMP" (
        POWERSHELL -Command  "Write-Host -fore Red 'Pasta TMP indisponível, retornado ao menu principal.'"
    ) ELSE (
        REM TO DO
    )
    GOTO :MENU
:DOWNLOAD
    SET "URL=%~1"
    SET "DESTINATION=%~2"
    SET "P_NAME=%~3"
    BITSADMIN /TRANSFER "%P_NAME%" /DOWNLOAD /PRIORITY NORMAL "%URL%" "%DESTINATION%"
    IF %ERRORLEVEL% NEQ 0 (
        POWERSHELL -Command  "Write-Host -fore Red 'Falha ao baixar o arquivo. Verifique sua conexão com a internet e tente novamente.'"
        EXIT /B 1
    ) ELSE (
        POWERSHELL -Command  "Write-Host -fore Green 'Download concluída.'"
        EXIT /B 0
    )
:PWS_DOWNLOAD
    SET "URL=%~1"
    SET "DESTINATION=%~2"
    SET "P_NAME=%~3"
    ECHO %URL%
    PAUSE
    POWERSHELL -Command "Start-BitsTransfer -DisplayName %P_NAME% -Source "%URL%" -Destination '%DESTINATION%'"
    IF %ERRORLEVEL% NEQ 0 (
        POWERSHELL -Command  "Write-Host -fore Red 'Falha ao baixar o arquivo. Verifique sua conexão com a internet e tente novamente.'"
        EXIT /B 1
    ) ELSE (
        POWERSHELL -Command  "Write-Host -fore Green 'Download concluída.'"
        EXIT /B 0
    )
    EXIT /B 0
:INSTALL
    SET "INSTALLER=%~1"
    SET "FLAGS=%~2"
    START /WAIT "" "%INSTALLER%" "%FLAGS%"
    IF %ERRORLEVEL% NEQ 0 (
        POWERSHELL -Command  "Write-Host -fore Red 'Falha ao instalar o programa. Verifique se o arquivo do instalador está correto.'"
        EXIT /B 1
    ) ELSE (
        POWERSHELL -Command  "Write-Host -fore Green 'Instalação concluída.'"
        EXIT /B 0
    )
:MSI_INSTALL
    SET "INSTALLER=%~1"
    START /WAIT MSIEXEC /I "%INSTALLER%" /PASSIVE /NORESTART
    IF %ERRORLEVEL% NEQ 0 (
        POWERSHELL -Command  "Write-Host -fore Red 'Falha ao instalar o programa. Verifique se o arquivo do instalador está correto.'"
        EXIT /B 1
    ) ELSE (
        POWERSHELL -Command  "Write-Host -fore Green 'Instalação concluída.'"
        EXIT /B 0
    )
:CRIAR_PASTA
    ECHO.
    IF NOT EXIST "C:\TMP" (
        MKDIR "C:\TMP"
        SET "LOCAL=C:\TMP"
        POWERSHELL -Command "Write-Host -fore Green 'Pasta TMP criada no disco local.'"
        EXIT /B 0
    ) ELSE (
        SET "LOCAL=C:\TMP"
        POWERSHELL -Command "Write-Host -fore Yellow 'Pasta TMP já criada no disco local.'"
        EXIT /B 0
    )
:CREDENCIAIS
    SET /P "USERNAME=Digite seu nome de usuário: "
    SET /P "PASSWORD=Digite sua senha (aparecerá no console): "
    EXIT /B 0
:INST_MENU
    CLS
    ECHO.
    POWERSHELL -Command "Write-Host -fore Cyan 'É necessário conexão com a internet para o download dos pacotes.'"
    ECHO.
    ECHO [0]  SAIR
    ECHO [1]  7-zip
    ECHO [2]  PDFSam
    ECHO [3]  Adobe Reader
    ECHO [4]  Google Chrome
    ECHO [5]  Mozilla Firefox
    ECHO [6]  Microsoft Teams
    ECHO [7]  Citrix Workspace
    ECHO [8]  Kaspersky Endpoint
    ECHO [9]  Microsoft Office
    ECHO [10] PROTHEUS
    ECHO [11] Drivers Certisign
    ECHO [12] Microsoft PowerBI
    ECHO [13] VPN FortiClient
    ECHO.
    SET /P "I=Digite a opção que deseja e pressione ENTER: "
    IF "%I%" == "0"  GOTO :MENU
    IF "%I%" == "1"  GOTO :INST_7ZIP
    IF "%I%" == "2"  GOTO :INST_PDFSAM
    IF "%I%" == "3"  GOTO :INST_ACROBAT
    IF "%I%" == "4"  GOTO :INST_CHROME
    IF "%I%" == "5"  GOTO :INST_FIREFOX
    IF "%I%" == "6"  GOTO :INST_TEAMS
    IF "%I%" == "7"  GOTO :INST_CITRIX
    IF "%I%" == "8"  GOTO :INST_KASPERSKY
    IF "%I%" == "9"  GOTO :OFFICE_MENU
    IF "%I%" == "10" GOTO :INST_PROTHEUS
    IF "%I%" == "11" GOTO :INST_CERTISIGN
    IF "%I%" == "12" GOTO :INST_BI
:INST_7ZIP
    CALL :CRIAR_PASTA
    ECHO.
    POWERSHELL -Command "Write-Host -fore Cyan 'Baixando e instalando o 7-Zip...'"
    IF NOT EXIST "%LOCAL%\7zip.exe" (
        CALL :DOWNLOAD "https://www.7-zip.org/a/7z2301-x64.exe" "%LOCAL%\7zip.exe" "7-Zip"
    )
    CALL :INSTALL "%LOCAL%\7zip.exe" "/S"
    GOTO :INST_MENU
:INST_PDFSAM
    CALL :CRIAR_PASTA
    POWERSHELL -Command "Write-Host -fore Cyan 'Baixando e instalando o PDFSam Basic...'"
    IF NOT EXIST "%LOCAL%\PDFSam.msi" (
        CALL :DOWNLOAD "https://github.com/torakiki/pdfsam/releases/download/v5.1.2/pdfsam-5.1.2.msi" "%LOCAL%\PDFSam.msi" "PDFSam Basic"
    )
    CALL :MSI_INSTALL "%LOCAL%\PDFSam.msi"
    ECHO.
    GOTO :INST_MENU
:INST_ACROBAT
    CALL :CRIAR_PASTA
    POWERSHELL -Command "Write-Host -fore Cyan 'Baixando e instalando o Adobe Acrobat...'"
    IF NOT EXIST "%LOCAL%\Acrobat.exe" (
        CALL :DOWNLOAD "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2300320215/AcroRdrDCx642300320215_MUI.exe" "%LOCAL%\Acrobat.exe" "Acrobat Reader"
    )
    CALL :INSTALL "%LOCAL%\Acrobat.exe" "/sAll"
    ECHO.
    GOTO :INST_MENU
:INST_CHROME
    CALL :CRIAR_PASTA
    POWERSHELL -Command "Write-Host -fore Cyan 'Baixando e instalando o Google Chrome...'"
    IF NOT EXIST "%LOCAL%\Chrome.msi" (
        CALL :DOWNLOAD "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" "%LOCAL%\Chrome.msi" "Google Chrome"
    )
    CALL :MSI_INSTALL "%LOCAL%\Chrome.msi"
    ECHO.
    GOTO :INST_MENU
:INST_FIREFOX
    CALL :CRIAR_PASTA
    POWERSHELL -Command "Write-Host -fore Cyan 'Baixando e instalando o Mozilla Firefox...'"
    IF NOT EXIST "%LOCAL%\Firefox.msi" (
        CALL :DOWNLOAD "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=pt-BR" "%LOCAL%\Firefox.msi" "Mozilla Firefox"
    )
    CALL :MSI_INSTALL "%LOCAL%\Firefox.msi"
    ECHO.
    GOTO :INST_MENU
:INST_TEAMS
    CALL :CRIAR_PASTA
    POWERSHELL -Command "Write-Host -fore Cyan 'Baixando e instalando o Microsoft Teams...'"
    IF NOT EXIST "%LOCAL%\Teams.exe" (
        CALL :DOWNLOAD "https://statics.teams.cdn.office.net/production-windows-x64/1.6.00.6754/Teams_windows_x64.exe" "%LOCAL%\Teams.exe" "Microsoft Teams"
    )
    CALL :INSTALL "%LOCAL%\Teams.exe" "-s"
    ECHO.
    GOTO :INST_MENU
:INST_CITRIX
    CALL :CRIAR_PASTA
    POWERSHELL -Command "Write-Host -fore Cyan 'Baixando e instalando o Citrix Workspace...'"
    IF NOT EXIST "%LOCAL%\CitrixWorkspaceApp.exe" (
        CALL :DOWNLOAD "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/Receiver/Win/CitrixWorkspaceApp23.5.1.83.exe" "%LOCAL%\CitrixWorkspaceApp.exe" "Citrix Workspace"
    )
    CALL :INSTALL "%LOCAL%\CitrixWorkspaceApp.exe" "/silent"
    ECHO.
    GOTO :INST_MENU
:INST_KASPERSKY
    CALL :CRIAR_PASTA
    IF NOT EXIST "%LOCAL%\installer.exe" (
        SET /P "USERNAME=Digite seu nome de usuário:"
        SET /P "PASSWORD=Digite sua senha (aparecerá no console):"
        POWERSHELL -Command "NET USE J: '\\ATALEIA\Instalacao-Hdesk' /USER:FIEMG\%USERNAME% %PASSWORD%"
        POWERSHELL -Command "Copy-Item -Path 'J:\SEDE\Windows 10 e 11\installer.exe' -Destination '%LOCAL%\installer.exe'"
        POWERSHELL -Command "NET USE J: /DELETE"
    )
    START /WAIT %LOCAL%\installer.exe /s
    GOTO :INST_MENU
:OFFICE_MENU
    ECHO [0] SAIR
    ECHO [1] 2010
    ECHO [2] 2013
    ECHO [3] 2016
    ECHO [4] 2019
    ECHO [5] 2021
    ECHO.
    SET /P "OFV=Digite a opção que deseja e pressione ENTER: "
    IF "%OFV%" == "0"  GOTO :INST_MENU
    IF "%OFV%" == "1"  GOTO :OFV_2010
    IF "%OFV%" == "2"  GOTO :OFV_2013
    IF "%OFV%" == "3"  GOTO :OFV_2016
    IF "%OFV%" == "4"  GOTO :OFV_2019
    IF "%OFV%" == "5"  GOTO :OFV_2021
:OF_MOUNT
    NET USE K: "\\TARUMIRIM\SOFTWARE$\10-PROGRAMAS\Microsoft Office" /USER:FIEMG\%USERNAME% %PASSWORD%
    EXIT /B 0
:OF_UMOUNT
    NET USE K: /DELETE
    EXIT /B 0
:OF_ERROR_MESSAGE
    POWERSHELL -Command "Write-Host -fore Red 'Erro, arquivo de instalação (setup.exe) indisponível.'"
:OFV_2010
    CALL :CREDENCIAIS
    CALL :OF_MOUNT
    IF EXIST "K:\Microsoft Office 2010" (
        "K:\Microsoft Office 2010\setup.exe"
        CALL :OF_UMOUNT
    ) ELSE (
        CALL :OF_ERROR_MESSAGE
    )
    GOTO :INST_MENU
:OFV_2013
    CALL :CREDENCIAIS
    CALL :OF_MOUNT
    IF EXIST "K:\Microsoft Office 2013" (
        "K:\Microsoft Office 2013\setup.exe"
        CALL :OF_UMOUNT
    ) ELSE (
        CALL :OF_ERROR_MESSAGE
    )
    GOTO :INST_MENU
:OFV_2016
    CALL :CREDENCIAIS
    CALL :OF_MOUNT
    IF EXIST "K:\Microsoft Office 2016" (
        "K:\Microsoft Office 2016\setup.exe"
        CALL :OF_UMOUNT
    ) ELSE (
        CALL :OF_ERROR_MESSAGE
    )
    GOTO :INST_MENU
:OFV_2019
    CALL :CREDENCIAIS
    SET /P "ENT=Digite a entidade: (fiemg | sesi | senai | iel)"
    IF EXIST "K:\Microsoft Office 2019 Pro Plus\config-%ENT%.xml" (
        "K:\Microsoft Office  2019 Pro Plus\setup.exe /configure K:\Microsoft Office 2019 Pro Plus\config-%ENT%.xml"
        CALL :OF_UMOUNT
    ) ELSE (
        POWERSHELL -Command "Write-Host -fore Red 'Erro, entidade incorreta ou arquivo .xml indisponível.'"
    )
    GOTO :INST_MENU
:OFV_2021
    CALL :CREDENCIAIS
    SET /P "ENT=Digite a entidade: (fiemg | sesi | senai | iel)"
    CALL :OF_MOUNT
    IF EXIST "K:\Microsoft Office 2021 Pro Plus\config-office2021-%ENT%.xml"(
        "K:\Microsoft Office 2021 Pro Plus\setup.exe /configure K:\Microsoft Office 2021 Pro Plus\config-office2021-%ENT%.xml"
        CALL :OF_UMOUNT
    ) ELSE (
        POWERSHELL -Command "Write-Host -fore Red 'Erro, entidade incorreta ou arquivo .xml indisponível.'"
    )
    GOTO :INST_MENU
:INST_PROTHEUS
    IF NOT EXIST "C:\PROTHEUS\" (
        CALL :CREDENCIAIS
        NET USE I: "\\TARUMIRIM\SOFTWARE$\10-PROGRAMAS\UTILIDADES" /USER:FIEMG\%USERNAME% %PASSWORD%
        MKDIR "C:\PROTHEUS"
        XCOPY "I:PROTHEUS\" "C:\PROTHEUS\" /E /H
        NET USE I: /DELETE
    ) ELSE (
        POWERSHELL -Command "Write-Host -fore Red 'Pasta PROTHEUS existente no disco, gentileza verificar.'"
    )
    GOTO :INST_MENU
:INST_CERTISIGN
    SET /P "CERT=Escolha o tipo de certificado ( 0 - Starsign CUT | 1 - Desktop ID ): "
    IF "%CERT%" == "0" (
        ECHO.
        ECHO Baixando arquivos necessários...
        CALL :CRIAR_PASTA
        PAUSE
        IF NOT EXIST "%LOCAL%\GDSetup.exe" (
            CALL :DOWNLOAD "https://drivers.certisign.com.br/midias/tokens/gdburti/64bits/2k-xp-vi-7/GDsetupStarsignCUTx64.exe" "%LOCAL%\GDSetup.exe" "GDSetup"
        )
        IF NOT EXIST "%LOCAL%\CSP.exe" (
            CALL :DOWNLOAD "https://drivers.certisign.com.br/midias/gerenciadores/safesign/64bits/SafeSignIC30124-x64-win-tu-admin.exe" "%LOCAL%\CSP.exe" "CSP-Safesign"
        )
    )
    IF "%CERT%" == "1" (
        POWERSHELL -Command "Write-Host -fore Yellow 'Atenção! DesktopID funciona apenas com Windows 10 ou posterior.'"
        PAUSE
        CALL :CRIAR_PASTA
        IF NOT EXIST "%LOCAL%\DesktopID.exe" (
            CALL :DOWNLOAD "https://drivers.certisign.com.br/DesktopID/Windows/Setup_desktopID.exe" "%LOCAL%\DesktopID.exe" "DesktopID"
        )
        CALL :INSTALL 
    )
    GOTO :INST_MENU
:INST_BI
    CALL :CRIAR_PASTA
    IF NOT EXIST "%LOCAL%\PowerBI.exe" (
        CALL :DOWNLOAD "https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe" "%LOCAL%\PowerBI.exe" "Microsoft PowerBI"
    )
    CALL :INSTALL "%LOCAL%\PowerBI.exe" "-silent -norestart"
    GOTO :INST_MENU
:ROT_MENU
    CLS
    ECHO.
    ECHO [0]  SAIR
    ECHO [1]  Adicionar impressora(s)
    ECHO [2]  Adicionar máquina ao domínio *
    ECHO [3]  Atualização de políticas de grupo
    ECHO [4]  Windows Update
    ECHO [5]  Verificador de Arquivos de Sistema *
    ECHO [6]  Serial do computador
    ECHO [7]  Listar usuário(s) administrador(es)
    ECHO [8]  LAPS *
    ECHO [9]  Análise técnica
    ECHO [10] Avaliação chamado
    ECHO.
    SET /P "ROT_E=Digite a opção que deseja e pressione ENTER: "
    IF "%ROT_E%" == "0"  GOTO :MENU
    IF "%ROT_E%" == "1"  GOTO :ROT_IMPRESSORA
    IF "%ROT_E%" == "2"  GOTO :ROT_DOMIN
    IF "%ROT_E%" == "3"  GOTO :ROT_GRPPOL
    IF "%ROT_E%" == "4"  GOTO :ROT_WINUPDATE
    IF "%ROT_E%" == "5"  GOTO :ROT_DISM
    IF "%ROT_E%" == "6"  GOTO :ROT_SERIAL
    IF "%ROT_E%" == "7"  GOTO :ROT_ADMINS
    IF "%ROT_E%" == "8"  GOTO :ROT_LAPS
    IF "%ROT_E%" == "9"  GOTO :ROT_TEC
    IF "%ROT_E%" == "10" GOTO :ROT_CHD
:ROT_IMPRESSORA
    SET /P "EDF=Informe o prédio em questão (RBA | AF):"
    SET /P "ANDAR=Informe seu andar:"
    SET "PREFIX_IMPRESSORA=%EDF%-%ANDAR%-"
    SET "SERVER=\\OLIVEIRA"
    POWERSHELL -Command "Get-Printer -Name '%PREFIX_IMPRESSORA%*' | ForEach-Object { Add-Printer -Name $_.Name -ConnectionName '%SERVER%\'+$_.Name }"
    PAUSE
    GOTO :ROT_MENU
:ROT_DOMIN
    POWERSHELL -Command "Write-Host -fore Yellow 'Para poder executar este comando é necessário ter privilégio de administrador.'"
    SET /P "USER=Digite o nome do seu usuário:"
    SET /P "NOMEDOPC=Digite o nome do computador:"
    POWERSHELL -Command "Add-Computer -ComputerName %NOMEDOPC% -DomainName 'fiemg.com.br' -Credential FIEMG\%USER% -Force"
    PAUSE
    GOTO :ROT_MENU
:ROT_GRPPOL
    GPUPDATE /FORCE
    POWERSHELL -Command "Test-ComputerSecureChannel -Verbose"
    PAUSE
    GOTO :ROT_MENU
:ROT_WINUPDATE
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
    GOTO :ROT_MENU
:ROT_DISM
    POWERSHELL -Command "Write-Host -fore Yellow 'Para executar estes comandos, é necessário que esteja executando como ADMINISTRADOR.'"
    PAUSE
    START /WAIT DISM /Online /Cleanup-image /Restorehealth
    START /WAIT SFC /SCANNOW
    GOTO :ROT_MENU
:ROT_SERIAL
    FOR /f "usebackq skip=1 tokens=2 delims==" %%i IN (`WMIC BIOS GET SERIALNUMBER /VALUE 2^>NUL`) DO SET "SERIAL=%%i"
    ECHO %SERIAL% | CLIP
    POWERSHELL -Command "Write-Host -fore Cyan 'Código Serial copiado para a área de transferência.'"
    PAUSE
    GOTO :ROT_MENU
:ROT_ADMINS
    POWERSHELL -Command "Get-LocalGroupMember -Group "Administradores""
    PAUSE
    GOTO :ROT_MENU
:ROT_LAPS
    POWERSHELL -Command "Write-Host -fore Yellow 'Para poder executar este comando é necessário ter privilégio de administrador.'"
    SET /P "PC=Digite o nome da máquina:"
    SET /P "USER=Digite o nome de seu usuário:"
    POWERSHELL -Command "Get-LapsADPassword -Identity %PC% -AsPlainText -Credential FIEMG\%USER%"
    PAUSE
    GOTO :ROT_MENU
:ROT_TEC
    CLS
    ECHO.
    ECHO.
    ECHO CPU
    POWERSHELL -Command "Get-CimInstance -ClassName Win32_Processor"
    ECHO.
    ECHO RAM
    POWERSHELL -Command "Get-WmiObject -Class "Win32_PhysicalMemoryArray""
    ECHO.
    ECHO Disco(s) disponível(is)
    POWERSHELL -Command "Get-Physicaldisk | Format-Table -Autosize | Select MediaType"
    ECHO.
    PAUSE
    GOTO :ROT_MENU
:ROT_CHD
    SET /P "SOLICITANTE=Nome do(a) solicitante: "
    SET /P "CAUSA=Causa raiz: "
    SET /P "SOLUCAO=Solução aplicada: "
    SET /P "TESTES=Testes realizados: "
    SET /P "TECNICO=Técnico responsável: "
    ECHO.
    ECHO Resolvido.
    ECHO Prezado(a) %SOLICITANTE%, estamos finalizando seu chamado.
    ECHO Causa raiz: %CAUSA%
    ECHO Testes realizados: %TESTES%
    ECHO.
    ECHO Após receber este e-mail, não deixe de avaliar, sua opinião é muito importante para melhoria de nosso atendimento.
    ECHO.
    ECHO Atenciosamente,
    ECHO %TECNICO%.
    ECHO ---------------------------------
    ECHO Técnico de Suporte de Informática
    PAUSE
    GOTO :ROT_MENU
:FIM
    ECHO.
    IF EXIST "%LOCAL%" (
        SET /P "BKP=Deseja manter os arquivos no diretório %LOCAL% (0 - Não | 1 - SIM) ? "
        IF "%BKP%" == "0" (
            RMDIR /S /Q %LOCAL%
            POWERSHELL -Command "Write-Host -fore Yellow 'Limpando resíduos.'"
        ) ELSE (
            POWERSHELL -Command "Write-Host -fore Yellow 'Diretório %LOCAL% inalterado.'"
        )
    )
    ECHO.
    POWERSHELL -Command "Write-Host -fore Cyan 'Programa encerrado, pressione qualquer tecla para sair.'"
PAUSE > NUL
