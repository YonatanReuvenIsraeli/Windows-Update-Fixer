@echo off
title Windows Update Fixer
setlocal
echo Program Name: Windows Update Fixer
echo Version: 1.1.1
echo License: GNU General Public License v3.0
echo Developer: @YonatanReuvenIsraeli
echo GitHub: https://github.com/YonatanReuvenIsraeli
echo Sponsor: https://github.com/sponsors/YonatanReuvenIsraeli
"%windir%\System32\net.exe" session > nul 2>&1
if not "%errorlevel%"=="0" goto "NotAdministrator"
"%windir%\System32\net.exe" user > nul 2>&1
if not "%errorlevel%"=="0" goto "InWindowsPreinstallationEnvironmentWindowsRecoveryEnvironment"
goto "sc"

:"NotAdministrator"
echo.
echo Please run this batch file as an administrator. Press any key to close this batch file.
pause > nul 2>&1
goto "Close"

:"InWindowsPreinstallationEnvironmentWindowsRecoveryEnvironment"
echo.
echo You are in Windows Preinstallation Environment or Windows Recovery Environment! You must run this batch file in Windows. Press any key to close this batch file.
pause > nul 2>&1
goto "Close"

:"sc"
echo.
set sc=
set /p sc="Reseting the BITS service and the Windows Update service to the default security descriptor will overwrite your existing security ACLs on the BITS and Windows Update service and set them to default. Do you want to do this? (Yes/No) "
if /i "%sc%"=="Yes" goto "Suresc"
if /i "%sc%"=="No" goto "Windows"
echo Invalid syntax!
goto "sc"

:"Suresc"
echo.
set Suresc=
set /p Suresc="Are you sure you want to reset the BITS service and the Windows Update service to the default security descriptor? (Yes/No) "
if /i "%Suresc%"=="Yes" goto "Windows"
if /i "%Suresc%"=="No" goto "sc"
echo Invalid syntax!
goto "Suresc"

:"Windows"
echo.
echo [1] Windows XP or Windows Server 2003.
echo [2] Windows Vista or Windows Server 2008.
echo [3] None of the above.
echo.
set Windows=
set /p Windows="Which of the following Windows versions is this PC? (1-3) "
if /i "%Windows%"=="1" goto "Sure1"
if /i "%Windows%"=="2" goto "Sure2"
if /i "%Windows%"=="3" goto "Sure3"
echo Invalid syntax!
goto "Windows"

:"Sure1"
echo.
set Sure=
set /p Sure="Are you sure this PC is Windows XP or Windows Server 2003? (Yes/No) "
if /i "%Sure%"=="Yes" goto "StopUpdateServices"
if /i "%Sure%"=="No" goto "Windows"
echo Invalid syntax!
goto "Sure1"

:"Sure2"
echo.
set Sure=
set /p Sure="Are you sure this PC is Windows Vista or Windows Server 2008? (Yes/No) "
if /i "%Sure%"=="Yes" goto "StopUpdateServices"
if /i "%Sure%"=="No" goto "Windows"
echo Invalid syntax!
goto "Sure2"

:"Sure3"
echo.
set Sure=
set /p Sure="Are you sure this PC is none of the above? (Yes/No) "
if /i "%Sure%"=="Yes" goto "StopUpdateServices"
if /i "%Sure%"=="No" goto "Windows"
echo Invalid syntax!
goto "Sure3"

:"StopUpdateServices"
echo.
echo Stoping Windows Update services.
"%windir%\System32\net.exe" stop bits /y > nul 2>&1
"%windir%\System32\net.exe" stop wuauserv /y > nul 2>&1
"%windir%\System32\net.exe" stop cryptsvc /y > nul 2>&1
"%windir%\System32\net.exe" stop appidsvc /y > nul 2>&1
echo Windows Update services stoped.
echo.
echo Deleting Windows Update files.
rd "%ALLUSERSPROFILE%\Microsoft\Network\Downloader" /s /q > nul 2>&1
rd "%SystemRoot%\SoftwareDistribution" /s /q > nul 2>&1
rd "%SystemRoot%\System32\catroot2" /s /q > nul 2>&1
echo Windows Update files deleted.
if /i "%sc%"=="Yes" goto "Reset"
if /i "%sc%"=="No" goto "Reregister"

:"Reset"
echo.
echo Reseting the BITS service and the Windows Update service to the default security descriptor.
"%windir%\System32\sc.exe" sdset bits D:(A;CI;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU) > nul 2>&1
if not "%errorlevel%"=="0" goto "Error"
"%windir%\System32\sc.exe" sdset wuauserv D:(A;;CCLCSWRPLORC;;;AU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY) > nul 2>&1
if not "%errorlevel%"=="0" goto "Error"
echo BITS service and the Windows Update service reset to the default security descriptor.
goto "Reregister"

:"Reregister"
echo.
echo Reregistering BITS files and Windows Update files.
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\atl.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\urlmon.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\mshtml.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\shdocvw.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\browseui.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\jscript.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\vbscript.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\scrrun.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\msxml.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\msxml3.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\msxml6.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\actxprxy.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\softpub.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wintrust.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\dssenh.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\rsaenh.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\gpkcsp.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\sccbase.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\slbcsp.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\cryptdlg.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\oleaut32.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\ole32.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\shell32.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\initpki.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wuapi.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wuaueng.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wuaueng1.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wucltui.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wups.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wups2.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wuweb.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\qmgr.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\qmgrprxy.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wucltux.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\muweb.dll" > nul 2>&1
"%windir%\System32\regsvr32.exe" /s "%windir%\System32\wuwebv.dll" > nul 2>&1
echo BITS files and Windows Update files reregistered.
echo.
echo Reseting Winsock catalog.
"%windir%\System32\netsh.exe" winsock reset > nul 2>&1
if not "%errorlevel%"=="0" goto "Error"
echo Restart needed to finish Winsock catalog reset.
if /i "%Windows%"=="1" goto "Proxy"
if /i "%Windows%"=="2" goto "StartUpdateServices"
if /i "%Windows%"=="3" goto "StartUpdateServices"

:"Proxy"
echo.
echo Setting the proxy settings.
"%windir%\System32\proxycfg.exe" -d
if not "%errorlevel%"=="0" goto "Error"
echo Proxy settings set.
goto "StartUpdateServices"

:"StartUpdateServices"
echo.
echo Starting Windows Update services.
"%windir%\System32\net.exe" start bits > nul 2>&1
"%windir%\System32\net.exe" start wuauserv > nul 2>&1
"%windir%\System32\net.exe" start cryptsvc > nul 2>&1
"%windir%\System32\net.exe" start appidsvc > nul 2>&1
echo Windows Update services started.
if /i "%Windows%"=="2" goto "BITS"
goto "Restart"

:"BITS"
echo.
echo Clearing the BITS queue.
"%windir%\System32\bitsadmin.exe" /reset /allusers
echo BITS queue cleared.
goto "Restart"

:"Error"
"%windir%\System32\net.exe" start bits > nul 2>&1
"%windir%\System32\net.exe" start wuauserv > nul 2>&1
"%windir%\System32\net.exe" start cryptsvc > nul 2>&1
"%windir%\System32\net.exe" start appidsvc > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "sc"

:"Restart"
endlocal
echo.
echo Restart needed to finish fixing Windows Update. Press any key to restart this PC.
pause > nul 2>&1
"%windir%\System32\shutdown.exe" /r /t 00
