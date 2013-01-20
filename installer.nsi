!define ProgramName "Meld"
!define ProgramVersion "1.6.1-1"
!define UninstallerExe "uninstall.exe"
!define IconPath "$INSTDIR\meld\meld.ico"

Name "${ProgramName}"
OutFile "meld-${ProgramVersion}.exe"
Icon "meld\meld.ico"
RequestExecutionLevel admin

Page license
Page components
Page directory
Page instfiles

LicenseText "Licenses"
LicenseData "LICENSES.rtf"

DirText "Choose a directory to install Meld to."
InstallDir "$PROGRAMFILES\${ProgramName}"

Section "Program (Required)"
    SectionIn RO
    SetOutPath "$INSTDIR"
    File /r "meld"
    File /r "python"
    WriteUninstaller "$INSTDIR\${UninstallerExe}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayName" "${ProgramName}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayIcon" "${IconPath}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayVersion" "${ProgramVersion}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "Publisher" "Keegan Witt"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "EstimatedSize" "255000"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "UninstallString" "$\"$INSTDIR\${UninstallerExe}$\""
SectionEnd
Section "Start Menu Shortcut"
    SectionIn 1
    SetShellVarContext all
    SetOutPath "$INSTDIR\meld"
    CreateDirectory "$SMPROGRAMS\${ProgramName}"
    CreateShortCut "$SMPROGRAMS\${ProgramName}\${ProgramName}.lnk" "$INSTDIR\meld\meld.exe" "" "${IconPath}"
    CreateShortCut "$SMPROGRAMS\${ProgramName}\Uninstall ${ProgramName}.lnk" "$INSTDIR\${UninstallerExe}" "" "${IconPath}"
SectionEnd
Section "Desktop Shortcut"
    SectionIn 2
    SetShellVarContext all
    SetOutPath "$INSTDIR\meld"
    CreateShortCut "$DESKTOP\${ProgramName}.lnk" "$INSTDIR\meld\meld.exe" "" "${IconPath}"
SectionEnd

UninstPage components
UninstPage uninstConfirm
UninstPage instfiles

Section "un.Program and Shortcuts (Required)"
    SectionIn RO
    SetShellVarContext all
    RMDir /r "$INSTDIR\meld"
    RMDir /r "$INSTDIR\python"
    Delete "$INSTDIR\${UninstallerExe}"
    RMDir "$INSTDIR"
    RMDir /r "$SMPROGRAMS\${ProgramName}"
    Delete "$DESKTOP\${ProgramName}.lnk"
    DeleteRegKey "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}"
SectionEnd

Section "un.User Files (Uncheck if Reinstalling)"
    SectionIn 1
    RMDir /r "$APPDATA\Meld"
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
