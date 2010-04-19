

; DESCRIPTION: Classmaker installer script
; (C) Blur Studio 2005

!include classmaker-svnrev.nsi
!define MUI_PRODUCT "Classmaker"
!define MUI_VERSION "v1.0.X"

!define QTDIR "C:\Qt\4.1.0\"

Name "${MUI_PRODUCT} ${MUI_VERSION}"

!include "MUI.nsh"

; Name of resulting executable installer
OutFile "classmaker_install_${MUI_SVNREV}.exe"
InstallDir "C:\\blur\\classmaker\\"

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
!define MUI_FINISHPAGE_TITLE "Classmaker Installation Complete"
!define MUI_FINISHPAGE_TEXT "\n\r\nClick Finish now to close the installation program."

#SilentInstall silent

!insertmacro MUI_PAGE_INSTFILES ; File installation page

Section "install"
	Processes::KillProcess "classmaker.exe"
	Delete "$DESKTOP\short*classmaker*lnk"
	Delete "$QUICKLAUNCH\short*classmaker*lnk"
	SetOutPath $INSTDIR
	File classmaker.exe
	File c:\mingw\bin\exchndl.dll
  	CreateShortCut "$DESKTOP\Classmaker 1.0.lnk" "$INSTDIR\classmaker.exe" ""
	CreateShortcut "$QUICKLAUNCH\Classmaker 1.0.lnk" "$INSTDIR\classmaker.exe" ""
	File classmaker.ini
	File classmaker_version.txt
    File ..\..\lib\stone\stone.dll
    File ..\..\lib\stonegui\stonegui.dll
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
	Delete "$DESKTOP\Classmaker 1.0.lnk"
	Delete "$QUICKLAUNCH\Classmaker 1.0.lnk"

	;Delete Uninstaller And Unistall Registry Entries
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"  

SectionEnd

