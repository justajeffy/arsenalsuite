

; DESCRIPTION: AssFreezer installer script
; (C) Blur Studio 2005

!include assfreezer-svnrev.nsi
!define MUI_PRODUCT "AssFreezer"
!define MUI_VERSION "v1.0.X"

!define QTDIR "C:\Qt\4.1.0\"

Name "${MUI_PRODUCT} ${MUI_VERSION} ${PLATFORM}"

!include "MUI.nsh"

; Name of resulting executable installer
OutFile "af_install_${MUI_SVNREV}_${PLATFORM}.exe"
InstallDir "C:\\blur\\assfreezer\\"

!define MUI_FINISHPAGE
!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!define MUI_HEADERBITMAP "assfreezer.bmp"

; The icon for the installer title bar and .exe file
;!define MUI_ICON "myapp.ico"
; I want to use my product logo in the installer
;!define MUI_HEADERIMAGE
; Here is my product logo
;!define MUI_HEADERIMAGE_BITMAP "myapp.bmp"
; I want the logo to be on the right side of the installer, not the left
;!define MUI_HEADERIMAGE_RIGHT
; I've written a function that I want to be called when the user cancels the installation
;!define MUI_CUSTOMFUNCTION_ABORT myOnAbort
; Override the text on the Finish Page
!define MUI_FINISHPAGE_TITLE "AssFreezer Installation Complete"
!define MUI_FINISHPAGE_TEXT "\n\r\nClick Finish now to close the installation program."

#SilentInstall silent

!insertmacro MUI_PAGE_INSTFILES ; File installation page

Section "install"
	Processes::KillProcess "assfreezer.exe"
	# nuke old assfreezer installs, if any
	RMDir /r "C:\assfreezer\*.*"
	RMDIR /r "C:\assfreezer"
	Delete "$DESKTOP\short*assfreezer*lnk"
	Delete "$QUICKLAUNCH\short*assfreezer*lnk"
	SetOutPath $INSTDIR
	File assfreezer.exe
	File c:\mingw\bin\exchndl.dll
  	CreateShortCut "$DESKTOP\AssFreezer 1.0.lnk" "$INSTDIR\assfreezer.exe" ""
	CreateShortcut "$QUICKLAUNCH\AssFreezer 1.0.lnk" "$INSTDIR\assfreezer.exe" ""
	File assfreezer.ini
	File assfreezer_version.txt
    File ..\..\lib\stone\stone.dll
    File ..\..\lib\stonegui\stonegui.dll
    File ..\..\lib\classes\classes.dll
    File ..\..\lib\assfreezer\assfreezer.dll
	File ..\..\lib\classesui\classesui.dll
	File ..\..\lib\absubmit\absubmit.dll
	SetOutPath $INSTDIR\images
	File "images\*.*"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT} (remove only)"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

Section "Uninstall"

	;Delete Files and directory
	RMDir /r "$INSTDIR\*.*"
	RMDir "$INSTDIR"
	Delete "$DESKTOP\AssFreezer 1.0.lnk"
	Delete "$QUICKLAUNCH\AssFreezer 1.0.lnk"

	;Delete Uninstaller And Unistall Registry Entries
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"  

SectionEnd

