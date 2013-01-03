# Author: Keegan Witt
# Note: This script requires Meld (http://meldmerge.org/) and Portable Python (http://portablepython.com/) in addition to NSIS to work.

!define ProgramName "Meld"
!define MeldVersion "1.6.1"
!define MeldDir "meld-${MeldVersion}"
!define PythonVersion "2.7.3.1"
!define PythonDir "python-portable-${PythonVersion}"
!define UninstallerExe "uninstall.exe"

Name "${ProgramName}"
OutFile "meld-${MeldVersion}.exe"
Icon "${MeldDir}\meld.ico"
RequestExecutionLevel admin

Page license
Page components
Page directory
Page instfiles

LicenseText "Licenses"
LicenseData "LICENSES.rtf"

DirText "Choose a directory to install Meld to."
InstallDir "$PROGRAMFILES\${ProgramName}"

Section "Program Files (Required)"
    SectionIn RO
    SetOutPath "$INSTDIR"
    File /r "${MeldDir}"
    File /r "${PythonDir}"
    WriteUninstaller "$INSTDIR\${UninstallerExe}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayName" "${ProgramName}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "UninstallString" "$\"$INSTDIR\${UninstallerExe}$\""
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayIcon" "$INSTDIR\${MeldDir}\meld.ico"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayVersion" "${MeldVersion}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "Publisher" "Keegan Witt"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "EstimatedSize" "255000"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "UninstallString" ""
SectionEnd
Section "Start Menu Shortcut"
    SectionIn 1
    SetShellVarContext all
    CreateDirectory "$SMPROGRAMS\${ProgramName}"
    CreateShortCut "$SMPROGRAMS\${ProgramName}\${ProgramName}.lnk" "$INSTDIR\${MeldDir}\meld.vbs" "" "$INSTDIR\${MeldDir}\meld.ico"
    CreateShortCut "$SMPROGRAMS\${ProgramName}\Uninstall ${ProgramName}.lnk" "$INSTDIR\${UninstallerExe}" "" "$INSTDIR\${MeldDir}\meld.ico"
SectionEnd
Section "Desktop Shortcut"
    SectionIn 2
    SetShellVarContext all
    CreateShortCut "$DESKTOP\${ProgramName}.lnk" "$INSTDIR\${MeldDir}\meld.vbs" "" "$INSTDIR\${MeldDir}\meld.ico"
SectionEnd

UninstPage uninstConfirm
UninstPage instfiles

Section "Uninstall"
    RMDir /r "$INSTDIR\${MeldDir}"
    RMDir /r "$INSTDIR\${PythonDir}"
    Delete "$INSTDIR\${UninstallerExe}"
    RMDir "$INSTDIR"
    RMDir /r "$SMPROGRAMS\${ProgramName}"
    Delete "$DESKTOP\${ProgramName}.lnk" 
    DeleteRegKey "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}"
SectionEnd

Function .onInit
    ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "UninstallString"
    StrCmp $R0 "" done
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "${ProgramName} is already installed. $\n$\nClick `OK` to remove the previous version or `Cancel` to cancel this upgrade." IDOK uninstall
    Abort
    uninstall:
        ClearErrors
        Exec $INSTDIR\uninstall.exe
    done:
FunctionEnd
