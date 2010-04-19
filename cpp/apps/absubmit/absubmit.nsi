
; DESCRIPTION: Assburner Submit installer script
; (C) Blur Studio 2005

!include absubmit-svnrev.nsi
!define MUI_PRODUCT "Assburner Submit Silent Installer"
!define MUI_VERSION "v1.3.0"

Name "${MUI_PRODUCT} ${MUI_VERSION} ${PLATFORM}"

#!include "MUI.nsh"

; Name of resulting executable installer
OutFile "absubmit_install_${MUI_SVNREV}_${PLATFORM}.exe"
InstallDir "C:\\blur\\absubmit\\"

#!define MUI_FINISHPAGE
#!define MUI_FINISHPAGE_NOREBOOTSUPPORT
#!define MUI_HEADERBITMAP "assburner.bmp"

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
#!define MUI_FINISHPAGE_TITLE "Assburner Installation Complete"
#!define MUI_FINISHPAGE_TEXT "\n\r\nClick Finish now to close the installation program."
#SilentInstall silent
#!insertmacro MUI_PAGE_INSTFILES ; File installation page

Section "install"
	RMDir /r "$INSTDIR\*.*"
	RMDir "$INSTDIR"
    SetOutPath $INSTDIR
	File absubmit.exe
	File absubmit.ini
	File absubmit_version.txt
	File ..\..\lib\stone\stone.dll
	File ..\..\lib\classes\classes.dll
	File ..\..\lib\absubmit\absubmit.dll
	File c:\mingw\bin\exchndl.dll
	File /r fusionsubmit
	File /r fusionvideomakersubmit
	File /r cinema4d
	File /r realflow
	SetOutPath "C:\\blur\\"
	File ..\..\..\binaries\zip.exe
	IfFileExists "C:\\Maxon\\Cinema 4D R10\\plugins\\*.*" Cinema4DExists PastCinema4D
	Cinema4DExists:
		SetOutPath "C:\\Maxon\\Cinema 4D R10\\plugins\\"
		File cinema4d\blur_render_submit.cof
	PastCinema4D:
	IfFileExists "C:\\fusion\\Fusion_5.2\\Scripts\\Comp\\*.*" Fusion52Exists PastFusion52Exists
	Fusion52Exists:
		SetOutPath "C:\\fusion\\Fusion_5.2\\Scripts\\Comp\\Blur_Tools\\"
		File "..\..\..\fusion\Submit Render.eyeonscript"
	PastFusion52Exists:
	IfFileExists "C:\\fusion\\Fusion_5.3\\Scripts\\Comp\\*.*" Fusion53Exists PastFusion53Exists
	Fusion53Exists:
		SetOutPath "C:\\fusion\\Fusion_5.3\\Scripts\\Comp\\Blur_Tools\\"
		File "..\..\..\fusion\Submit Render.eyeonscript"
	PastFusion53Exists:
	IfFileExists "C:\\fusion\\Fusion_5.3_x64\\Scripts\\Comp\\*.*" Fusion53x64Exists PastFusion53x64Exists
	Fusion53x64Exists:
		SetOutPath "C:\\fusion\\Fusion_5.3_x64\\Scripts\\Comp\\Blur_Tools\\"
		File "..\..\..\fusion\Submit Render.eyeonscript"
	PastFusion53x64Exists:
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT} (remove only)"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
	;Delete Files and directory
	RMDir /r "$INSTDIR\*.*"
	RMDir "$INSTDIR"

	;Delete Uninstaller And Unistall Registry Entries
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"  
SectionEnd

