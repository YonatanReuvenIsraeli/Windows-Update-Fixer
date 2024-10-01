@echo off
title Windows Update Fixer
setlocal
echo Program Name: Windows Update Fixer
echo Version: 1.0.10
echo Developer: @YonatanReuvenIsraeli
echo Website: https://www.yonatanreuvenisraeli.dev
echo License: GNU General Public License v3.0
net session > nul 2>&1
if not "%errorlevel%"=="0" goto "NotAdministrator"
net user > nul 2>&1
if not "%errorlevel%"=="0" goto "InWindowsRecoveryEnvironment"
goto "Start"

:"NotAdministrator"
echo.
echo Please run this batch file as an administrator. Press any key to close this batch file.
pause > nul 2>&1
goto "Close"

:"InWindowsRecoveryEnvironment"
echo.
echo Please run this batch file from within Windows. Press any key to close this batch file.
pause > nul 2>&1
goto "Close"

:"Start"
echo.
echo Press any key to fix Windows Update!
pause > nul 2>&1
echo.
echo Stoping Windows Update services.
net stop bits /y > nul 2>&1
net stop wuauserv /y > nul 2>&1
net stop cryptsvc /y > nul 2>&1
net stop appidsvc /y > nul 2>&1
echo Windows Update services stoped.
echo.
echo Deleting Windows Update files.
rd "%ALLUSERSPROFILE%\Microsoft\Network\Downloader" /s /q > nul 2>&1
rd "%SystemRoot%\SoftwareDistribution" /s /q > nul 2>&1
rd "%SystemRoot%\System32\catroot2" /s /q > nul 2>&1
echo Windows Update files deleted.
goto "sc"

:"sc"
echo.
set sc=
set /p sc="Reseting the BITS service and the Windows Update service to the default security descriptor will overwrite your existing security ACLs on the BITS and Windows Update service and set them to default. Do you want to do this? (Yes/No) "
if /i "%sc%"=="Yes" goto "Reset"
if /i "%sc%"=="No" goto "Reregister"
echo Invalid syntax!
goto "sc"

:"Reset"
echo.
echo Reseting the BITS service and the Windows Update service to the default security descriptor.
sc.exe sdset bits D:(A;CI;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU) > nul 2>&1
if not "%errorlevel%"=="0" goto "Error"
sc.exe sdset wuauserv D:(A;;CCLCSWRPLORC;;;AU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY) > nul 2>&1
if not "%errorlevel%"=="0" goto "Error"
echo BITS service and the Windows Update service reset to the default security descriptor.
goto "Reregister"

:"Reregister"
echo.
echo Reregistering BITS files and Windows Update files.
regsvr32 /s "%windir%\system32\atl.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\urlmon.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\mshtml.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\shdocvw.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\browseui.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\jscript.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\vbscript.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\scrrun.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\msxml.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\msxml3.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\msxml6.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\actxprxy.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\softpub.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wintrust.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\dssenh.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\rsaenh.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\gpkcsp.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\sccbase.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\slbcsp.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\cryptdlg.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\oleaut32.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\ole32.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\shell32.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\initpki.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wuapi.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wuaueng.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wuaueng1.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wucltui.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wups.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wups2.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wuweb.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\qmgr.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\qmgrprxy.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wucltux.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\muweb.dll" > nul 2>&1
regsvr32 /s "%windir%\system32\wuwebv.dll" > nul 2>&1
echo BITS files and Windows Update files reregistered.
echo.
echo Reseting Winsock catalog.
netsh winsock reset > nul 2>&1
if not "%errorlevel%"=="0" goto "Error"
echo Restart needed to finish Winsock catalog reset.
goto "Windows"

:"Windows"
echo.
echo [1] Windows XP or Windows Server 2003.
echo [2] Windows Vista or Windows Server 2008.
echo [3] None of the above.
set Windows=
set /p Windows="Which of the following Windows versions is this PC? (1-3) "
if /i "%Windows%"=="1" goto "1"
if /i "%Windows%"=="2" goto "2"
if /i "%Windows%"=="3" goto "2"
echo Invalid syntax!
goto "Windows"

:"1"
echo.
echo Setting the proxy settings.
proxycfg.exe -d
if not "%errorlevel%"=="0" goto "Error"
echo Proxy settings set.
goto "2"

:"2"
echo.
echo Starting Windows Update services.
net start bits > nul 2>&1
net start wuauserv > nul 2>&1
net start cryptsvc > nul 2>&1
net start appidsvc> nul 2>&1
echo Windows Update services started.
if /i "%Windows%"=="2" goto :"BITS"
goto "Restart"

:"BITS"
echo.
echo Clearing the BITS queue.
bitsadmin /reset /allusers
echo BITS queue cleared.
goto "Restart"

:"Error"
net start bits > nul 2>&1
net start wuauserv > nul 2>&1
net start cryptsvc > nul 2>&1
net start appidsvc> nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "Start"

:"Restart"
endlocal
echo.
echo Restart needed. Press any key to restart this PC.
pause > nul 2>&1
shutdown /r /t 00
