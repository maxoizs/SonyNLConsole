@echo off

set Product=SonyNLConsole
set bin=%~dp0bin
set BuildLog=%bin%\buildmsi.log
set CDLog=%bin%\buildCD.log
set MsiFileName=%bin%\%Product%.msi
set SourcePath=%~dp0SNLC

echo *** Creating %Product%.msi
del %bin% /f /q

echo *** Create Product Folder  %bin%
md %bin%

if not exist %SourcePath% echo @@@@@@ install is not exists @@@@@@@@@

echo *** Creating %Product% %1 %2 .msi  >%BuildLog%

echo *** collect install ****
:: ignored because it take too much 
::heat.exe dir SNLC -ag -suid -srd -sreg -dr INSTALLDIR -cg SourceComponentGroup -var var.SourcePath -out install.wxs

echo *** Doing Candle msi >>%BuildLog%
candle.exe -out %bin%\ -dProduct=%Product% -dSourcePath=%SourcePath%\ %~dp0%Product%.wxi  %~dp0install.wxs -arch x64 -nologo >>%BuildLog%

echo *** Doing light msi >>%BuildLog%
light.exe -out %MsiFileName%  -ext WixUIExtension %bin%\%Product%.wixobj %bin%\install.wixobj -nologo >>%BuildLog%

%~dp0..\ThirdParty\InstallFramework\current\SetupSDK\Tools\PathVerify\PathVerify.exe %MsiFileName% -output %bin%
