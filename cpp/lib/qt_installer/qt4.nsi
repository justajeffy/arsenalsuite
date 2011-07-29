

; DESCRIPTION: AssFreezer installer script
; (C) Blur Studio 2005

!define MUI_VERSION "4.5.0-1"
!define MUI_PRODUCT "Blur Qt ${MUI_VERSION} DLLs"

!if ${PLATFORM} == "win32-msvc2005_64"
	InstallDir "C:\windows\system32\blur64\"
	!define QTDIR "C:\Qt\4.5.0_64"
!else
	InstallDir "C:\blur\common\"
	!define QTDIR "C:\Qt\4.5.0"
!endif

Name "${MUI_PRODUCT} ${MUI_VERSION} ${PLATFORM}"

!include "addtopath.nsh"
!include "MUI.nsh"
!include "x64.nsh"

; Name of resulting executable installer
OutFile "qt_install_${MUI_VERSION}_${PLATFORM}.exe"


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
!define MUI_FINISHPAGE_TITLE "${MUI_PRODUCT} Installation Complete"
!define MUI_FINISHPAGE_TEXT "\n\r\nClick Finish now to close the installation program."

#SilentInstall silent



!insertmacro MUI_PAGE_INSTFILES ; File installation page

Section "install"
!if ${PLATFORM} == "win32-msvc2005_64"
   ${DisableX64FSRedirection}
!else
!endif
	SetOutPath $INSTDIR

	File "${QTDIR}\bin\QtGui4.dll"
	File "${QTDIR}\bin\QtOpenGL4.dll"
	File "${QTDIR}\bin\QtNetwork4.dll"
	File "${QTDIR}\bin\QtSql4.dll"
	File "${QTDIR}\bin\QtCore4.dll"
	File "${QTDIR}\bin\QtXml4.dll"
	File "${QTDIR}\bin\QtHelp4.dll"
	File "${QTDIR}\bin\QtScript4.dll"
	File "${QTDIR}\bin\QtSvg4.dll"
	File "${QTDIR}\bin\QtWebKit4.dll"
	File "${QTDIR}\bin\QtXmlPatterns4.dll"
	File "${QTDIR}\bin\QtClucene4.dll"
	File "${QTDIR}\bin\QtAssistantClient4.dll"
	File "${QTDIR}\bin\QtDesigner4.dll"
	File "${QTDIR}\bin\QtDesignerComponents4.dll"
	File "${QTDIR}\bin\QtTest4.dll"
	File ..\..\..\binaries\libpq.dll

!if ${PLATFORM} != "win32-msvc2005_64"
	File ..\..\..\binaries\mingwm10.dll
	File ..\..\..\binaries\jpeg62.dll
	File ..\..\..\binaries\zlib1.dll
;	File ..\..\..\binaries\krb5_32.dll
	File ..\..\..\binaries\Half.dll
	File ..\..\..\binaries\IlmThread.dll
	File ..\..\..\binaries\Iex.dll
	File ..\..\..\binaries\IlmImf.dll
	File ..\..\..\binaries\Imath.dll
;	File ..\..\..\binaries\comerr32.dll
;	File ..\..\..\binaries\libtiff3.dll
	File ..\..\..\binaries\libimage.dll
	File ..\..\..\binaries\libpng13.dll
;	File ..\..\..\binaries\libiconv-2.dll
;	File ..\..\..\binaries\libintl-2.dll
!endif

	RMDir /r $INSTDIR\sqldrivers
	SetOutPath $INSTDIR\sqldrivers
	File "${QTDIR}\plugins\sqldrivers\qsqlpsql4.dll"
	SetOutPath $INSTDIR\imageformats
	Delete $INSTDIR\imageformats\qjpeg1.dll
	Delete $INSTDIR\imageformats\tif.dll
	File "${QTDIR}\plugins\imageformats\qjpeg4.dll"
	File "${QTDIR}\plugins\imageformats\qgif4.dll"
	File "${QTDIR}\plugins\imageformats\qico4.dll"
	File "${QTDIR}\plugins\imageformats\qmng4.dll"
	File "${QTDIR}\plugins\imageformats\qsvg4.dll"
	File "${QTDIR}\plugins\imageformats\qtiff4.dll"
!if ${PLATFORM} != "win32-msvc2005_64"
	File ..\qimageio\exr\exr.dll
!endif
	File ..\qimageio\tga\tga.dll
	File ..\qimageio\sgi\sgi.dll
	File ..\qimageio\rla\rla.dll

	Push $INSTDIR
	Call AddToPath
	ReadEnvStr $R0 "PATH"
	StrCpy $R0 "$R0;$INSTDIR}"
	System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("PATH", R0).r0'
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT} (remove only)"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

Section "Uninstall"

	;Delete Files and directory
	Delete $INSTDIR\QtGui4.dll
	Delete $INSTDIR\QtNetwork4.dll
	Delete $INSTDIR\QtSql4.dll
	Delete $INSTDIR\QtCore4.dll
	Delete $INSTDIR\QtXml4.dll
	Delete $INSTDIR\QtOpenGL4.dll
	Delete $INSTDIR\mingwm10.dll
	Delete $INSTDIR\libpq.dll
	Delete $INSTDIR\mingwm10.dll
	Delete $INSTDIR\zlib1.dll
	Delete $INSTDIR\jpeg62.dll
	Delete $INSTDIR\libimage.dll
	Delete $INSTDIR\libpng13.dll
	Delete $INSTDIR\libtiff3.dll
	Delete $INSTDIR\uninstall.exe
	RMDir /r $INSTDIR\sqldrivers
	RMDir /r $INSTDIR\imageformats

;Delete Uninstaller And Unistall Registry Entries
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"  

SectionEnd

