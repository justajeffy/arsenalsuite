

; DESCRIPTION: Resin installer script
; (C) Blur Studio 2005

!define MUI_PRODUCT "PyExcelerator"
!define MUI_VERSION "0.6.3a"

!define QTDIR "c:\qt\4.1.0\"

!define PYTHON_DIR "C:\Python24\"

Name "${MUI_PRODUCT} ${MUI_VERSION}"

!include "MUI.nsh"

; Name of resulting executable installer
OutFile "pyexcelerator_install_${MUI_VERSION}.exe"
InstallDir "${PYTHON_DIR}\Lib\site-packages\pyExcelerator"

!define MUI_FINISHPAGE
!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!define MUI_HEADERBITMAP "resin.bmp"

!define MUI_FINISHPAGE_TITLE "PyExcelerator Installation Complete"
!define MUI_FINISHPAGE_TEXT "\n\r\nClick Finish now to close the installation program."

!insertmacro MUI_PAGE_INSTFILES ; File installation page
;SilentInstall silent

Section "install"
	SetOutPath $INSTDIR
	File /r "pyExcelerator\*.*"
;	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT} (remove only)"
;	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
	;Delete Files and directory
	RMDir /r "$INSTDIR\*.*"
	RMDir "$INSTDIR"

	;Delete Uninstaller And Unistall Registry Entries
;	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
;	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"  
SectionEnd

