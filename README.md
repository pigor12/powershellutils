# Utilidades técnicas

## Verificar usuário logado no computador
`Get-WmiObject -ComputerName {$NOMEDAMAQUINA} -Class Win32_ComputerSystem | Select-Object UserName`

## Reiniar serviço do `services.msc`
`If ((Get-Service $MEUSERVICO).Status -ne 'Running') { Start-Service $MEUSERVICO} ELSE { Stop-Service $MEUSERVICO}`

## Instalação de Programas básicos
`
    winget install -e --id 7zip.7zip;
    winget install -e --id Google.Chrome;
    winget install -e --id Citrix.Workspace;
    winget install -e --id Mozilla.Firefox.ESR;
    winget install -e --id Adobe.Acrobat.Reader.64-bit
`

## Testar conexão com outros computadores
`Test-Connection -TargetName $NOMEDAMAQUINA -IPv4`

## Testar conexão com sites (Powershell 6.0  >)
`Test-Connection -TargetName $SITEEXEMPLO -Traceroute`

## CMD
- `DEFRAG /U /V`
- `IPCONFIG`
- `WMIC PRODUCT GET NAME`
- `{EXECUTÁVEL} /?`
- `{EXECUTÁVEL} /Q`
- `{EXECUTÁVEL} /Silent`
- `{OFFICE} /CONFIGURE /{ARQUIVO-DE-CONFIGURACAO.xml}`

## Atalhos preferidos com o *executar* (Win + R)
* `hdwwiz.cpl`
* `appwiz.cpl`
* `mmsys.cpl`
* `sysdm.cpl`
* `services.msc`
* `lusrmgr.msc`
* `control printers`
* `control update`
* `control system`

## Atalhos preferidos - Windows
* Windows + M → Minimizar tudo;
* Windows + I → Configurações do Windows;
* Windows + T → Selecinar área *tray*;
* Windows + X + P → Aplicativos instalados;
* Windows + X + D → Área de trabalho;
* Windows + X + A → Powershell;
* Windows + X + A → Powershell como administrador;
* Windows + {1/2/3/4} → Mudar para o aplicativo de acordo com a posição na barra de tarefas;

## Contribuindo

Contribuições são sempre bem-vindas! Por favor, consulte a página de "Issues" para ver os recursos e correções de bugs que precisam ser implementados.

## Referências

* [Windows keyboards shortcuts](https://support.microsoft.com/en-us/windows/keyboard-shortcuts-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec)

