# PyQt4 NSIS installer script.
#
# Copyright (c) 2006
# 	Riverbank Computing Limited <info@riverbankcomputing.co.uk>
# 
# This file is part of PyQt.
# 
# This copy of PyQt is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2, or (at your option) any later
# version.
# 
# PyQt is supplied in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
# 
# You should have received a copy of the GNU General Public License along with
# PyQt; see the file LICENSE.  If not, write to the Free Software Foundation,
# Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

# Defines expected from the cmd line /DDEFINE=VALUE
# PYTHON_PATH
# PYTHON_VERSION
# PLATFORM

!if ${PLATFORM} == "win32-msvc2005_64"
	!define _64_BIT
!endif
!if ${PLATFORM} == "win32-msvc2008_64"
	!define _64_BIT
!endif

# These will change with different releases.
!define PYQT_VERSION        "4.7.0"
!define PYQT_LICENSE        "GPL"
!define PYQT_LICENSE_LC     "gpl"
!define PYQT_QT_VERS        "4.6.1"

# These are all derived from the above.
!define PYQT_NAME           "PyQt4 ${PYQT_LICENSE} v${PYQT_VERSION} ${PLATFORM}"
!define PYQT_INSTALLDIR     "${PYTHON_PATH}\"
!define PYQT_PYTHON_HKLM    "Software\Python\PythonCore\${PYTHON_VERSION}\InstallPath"
!define PYQT_QT_HKLM        "Software\Trolltech\Versions\${PYQT_QT_VERS}"


# Tweak some of the standard pages.
!define MUI_WELCOMEPAGE_TEXT \
"This wizard will guide you through the installation of ${PYQT_NAME}.\r\n\
\r\n\
This copy of PyQt has been built with the ${PLATFORM} compiler against \
Python v${PYTHON_VERSION}.x and Qt v${PYQT_QT_VERS}.\r\n\
\r\n\
Any code you write must be released under a license that is compatible with \
the GPL.\r\n\
\r\n\
Click Next to continue."

!define MUI_FINISHPAGE_LINK "Get the latest news of PyQt here"
!define MUI_FINISHPAGE_LINK_LOCATION "http://www.riverbankcomputing.co.uk"


# Include the tools we use.
!include MUI.nsh
!include LogicLib.nsh
!include "x64.nsh"


# Define the product name and installer executable.
Name "PyQt4"
Caption "${PYQT_NAME} Setup"
OutFile "PyQt4_${PYQT_LICENSE_LC}_${PYQT_VERSION}-Py${PYTHON_VERSION}-${PLATFORM}.exe"


# Set the install directory, from the registry if possible.
InstallDir "${PYQT_INSTALLDIR}"

# The different installation types.  "Full" is everything.  "Minimal" is the
# runtime environment.
InstType "Full"
InstType "Minimal"


# Maximum compression.
SetCompressor /SOLID lzma


# We want the user to confirm they want to cancel.
!define MUI_ABORTWARNING


Function .onInit

#    ${If} $0 == ""
#        MessageBox MB_YESNO|MB_ICONQUESTION \
#"This copy of PyQt has been built against Python v${PYTHON_VERSION}.x which \
#doesn't seem to be installed.$\r$\n\
#$\r$\n\
#Do you with to continue with the installation?" IDYES GotPython
#            Abort
GotPython:
    #${Endif}

!ifdef _64_BIT
	SetRegView 64
!endif

    # Check the right version of Qt has been installed.  Note we can't check if
    # the right compiler was used.  This key seems to be present in the
    # commercial version and missing in the GPL version.
    ReadRegStr $0 HKLM "${PYQT_QT_HKLM}" "InstallDir"

    ${If} $0 != ""
               StrCpy $0 $INSTDIR
    ${Endif}

#    ${If} $0 != ""
#        MessageBox MB_YESNO|MB_ICONQUESTION \
#"This copy of PyQt has been built with the ${PLATFORM} compiler against \
#Qt v${PYQT_QT_VERS} which doesn't seem to be installed.$\r$\n\
#$\r$\n\
#Do you with to continue with the installation?" IDYES GotQt
#            Abort
GotQt:
#    ${Endif}
FunctionEnd


# Define the different pages.
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
  
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

  
# Other settings.
!insertmacro MUI_LANGUAGE "English"


# Installer sections.

Section "Extension modules" SecModules
    SectionIn 1 2 RO

!ifdef _64_BIT
    ${DisableX64FSRedirection}
!endif

    # Make sure this is clean and tidy.
    RMDir /r $PROGRAMFILES\PyQt4
    CreateDirectory $PROGRAMFILES\PyQt4

    SetOverwrite on

    # We have to take the SIP files from where they should have been installed.
    SetOutPath $INSTDIR\Lib\site-packages
    File "${PYQT_INSTALLDIR}Lib\site-packages\sip.pyd"

    SetOutPath $INSTDIR\Lib\site-packages\PyQt4
    File .\LICENSE.GPL2
    File .\LICENSE.GPL3
    File .\GPL_EXCEPTION.TXT
    File .\GPL_EXCEPTION_ADDENDUM.TXT
    File .\OPENSOURCE-NOTICE.TXT
    File .\__init__.py
    File .\Qt\Qt.pyd
    File .\pyqtconfig.py
    File .\QtAssistant\QtAssistant.pyd
    File .\QtCore\QtCore.pyd
    File .\QtGui\QtGui.pyd
    File .\QtNetwork\QtNetwork.pyd
    File .\QtOpenGL\QtOpenGL.pyd
    File .\QtSql\QtSql.pyd
    File .\QtSvg\QtSvg.pyd
    File .\QtXml\QtXml.pyd
    File .\QtWebKit\QtWebKit.pyd
   # File .\QtXmlPatterns\QtXmlPatterns.pyd
    File .\QtDesigner\QtDesigner.pyd
    File .\QtHelp\QtHelp.pyd
    File .\QtScript\QtScript.pyd
    File .\QtScriptTools\QtScriptTools.pyd
    File .\QtTest\QtTest.pyd
    File .\QtMultimedia\QtMultimedia.pyd
    File .\phonon\phonon.pyd
    File ..\pyqtwinmigrate\sipQtWinMigrate\QtWinMigrate.pyd
    File ..\qscintilla\Python\QSci.pyd
SectionEnd

Section "Developer tools" SecTools
    SectionIn 1

    SetOverwrite on

    SetOutPath $INSTDIR
    File .\pylupdate\pylupdate4.exe
    File .\pyrcc\pyrcc4.exe
    File .\pyuic\pyuic4.bat

    SetOutPath $INSTDIR\Lib\site-packages\PyQt4
    File /r .\pyuic\uic
    File /r .\elementtree
SectionEnd

Section "Examples and tutorial" SecExamples
    SectionIn 1

    SetOverwrite on

    SetOutPath $PROGRAMFILES\PyQt4
    File /r .\examples
SectionEnd

Section "Start Menu shortcuts" SecShortcuts
    SectionIn 1

    # Make sure this is clean and tidy.
    RMDir /r "$SMPROGRAMS\${PYQT_NAME}"
    CreateDirectory "$SMPROGRAMS\${PYQT_NAME}"

    IfFileExists "$PROGRAMFILES\PyQt4\examples" 0 +2
        CreateShortCut "$SMPROGRAMS\${PYQT_NAME}\Examples.lnk" "$PROGRAMFILES\PyQt4\examples"

    CreateShortCut "$SMPROGRAMS\${PYQT_NAME}\Uninstall PyQt.lnk" "$PROGRAMFILES\PyQt4\Uninstall.exe"
SectionEnd

Section -post
    # Tell Windows about the package.
    WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PyQt4" "UninstallString" '"$PROGRAMFILES\PyQt4\Uninstall.exe"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PyQt4" "DisplayName" "${PYQT_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PyQt4" "DisplayVersion" "${PYQT_VERSION}"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PyQt4" "NoModify" "1"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PyQt4" "NoRepair" "1"

    # Save the installation directory for the uninstaller.
    WriteRegStr HKLM "Software\PyQt4" "" $INSTDIR

    # Create the uninstaller.
    WriteUninstaller "$PROGRAMFILES\PyQt4\Uninstall.exe"
SectionEnd


# Section description text.
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecModules} \
"The PyQt4 extension modules: sip, QtCore, QtGui, QtAssistant, QtNetwork, \
QtOpenGL, QtSql, QtSvg and QtXml."
!insertmacro MUI_DESCRIPTION_TEXT ${SecTools} \
"The PyQt4 developer tools: pyuic4, pyrcc4 and pylupdate4."
!insertmacro MUI_DESCRIPTION_TEXT ${SecExamples} \
"Ports to Python of the standard Qt v4 examples and tutorial."
!insertmacro MUI_DESCRIPTION_TEXT ${SecShortcuts} \
"This adds shortcuts to your Start Menu."
!insertmacro MUI_FUNCTION_DESCRIPTION_END


Section "Uninstall"
    # Get the install directory.
    ReadRegStr $INSTDIR HKLM "Software\PyQt4" ""

    # The modules section.
    Delete $INSTDIR\Lib\site-packages\sip.pyd
    RMDir /r $INSTDIR\Lib\site-packages\PyQt4

    # The shortcuts section.
    RMDir /r "$SMPROGRAMS\${PYQT_NAME}"

    # The tools section.
    Delete $INSTDIR\pylupdate4.exe
    Delete $INSTDIR\pyrcc4.exe
    Delete $INSTDIR\pyuic4.bat

    # The examples section and the installer itself.
    RMDir /r "$PROGRAMFILES\PyQt4"

    # Clean the registry.
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PyQt4"
    DeleteRegKey HKLM "Software\PyQt4"
SectionEnd
