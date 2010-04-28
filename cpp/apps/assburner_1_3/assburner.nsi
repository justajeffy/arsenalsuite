; DESCRIPTION: Assburner installer script
; (C) Blur Studio 2005

!define MUI_PRODUCT "Assburner"
!define MUI_VERSION "v1.3.X"

!define QTDIR "C:\Qt\4.1.0\"


Name "${MUI_PRODUCT} ${MUI_VERSION} ${PLATFORM}"

#!include "MUI.nsh"

; Name of resulting executable installer
OutFile "ab_install_${PLATFORM}.exe"
InstallDir "C:\blur\assburner\"

Page directory
Page instfiles

#SilentInstall silent

Section "install"
    Processes::KillProcess "abpsmon.exe"
	Processes::KillProcess "assburner.exe"
	StrCmp $R0 "0" skipsleep
	Sleep 3000
	skipsleep:
    Delete $INSTDIR\*.dll
    SetOutPath $INSTDIR
	File assburner.exe
	File psmon\abpsmon.exe
	File assburner.ini
	File runScriptJob.ms
    File ..\..\lib\stone\stone.dll
    File ..\..\lib\stonegui\stonegui.dll
    File ..\..\lib\classes\classes.dll
	CreateShortCut "$DESKTOP\Assburner.lnk" "$INSTDIR\assburner.exe" ""
	CreateShortCut "$QUICKLAUNCH\Assburner.lnk" "$INSTDIR\assburner.exe" ""
    SetOutPath $INSTDIR\plugins
    File /r "plugins\*.*"
	; delete old assburner3 dir!!!
	RMDir /r "c:\max5\assburner3"
	; Delete everything from spool directory, then re-create it
	RMDir /r "$INSTDIR\spool"
	CreateDirectory "$INSTDIR\spool"
	; Disable windows error reporting for assburner
	DeleteRegKey HKLM "SOFTWARE\Microsoft\PCHealth\ErrorReporting\ExclusionList\assburner.exe"
	WriteRegDWORD HKLM "SOFTWARE\Microsoft\PCHealth\ErrorReporting\ExclusionList" "assburner.exe" 1
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT} (remove only)"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
	;Delete Files and directory
	RMDir /r "$INSTDIR\*.*"
	RMDir "$INSTDIR"
	
	Delete "$DESKTOP\Assburner.lnk"
	Delete "$QUICKLAUNCH\Assburner.lnk"
	
	;Delete Uninstaller And Unistall Registry Entries
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"  
SectionEnd

Section
	SetOutPath $INSTDIR
	ExecShell "" "$INSTDIR\assburner.exe"	
SectionEnd
