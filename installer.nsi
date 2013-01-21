!define ProgramName "Meld"
!define MeldVersion "1.6.1"
!define ProgramVersion "${MeldVersion}.1"
!define Publisher "Keegan Witt"
!define ExePath "$INSTDIR\meld\meld.exe"
!define UninstallerPath "$INSTDIR\uninstall.exe"
!define IconPath "$INSTDIR\meld\meld.ico"
!define Filename "meld-${ProgramVersion}.exe"
!define WebsiteUrl "https://code.google.com/p/meld-installer/"

!include "FileFunc.nsh"

Name "${ProgramName}"
OutFile "${Filename}"
Icon "meld\meld.ico"
RequestExecutionLevel admin

VIProductVersion "${ProgramVersion}"
VIAddVersionKey "ProductName" "${ProgramName}"
VIAddVersionKey "FileVersion" "${ProgramVersion}"
VIAddVersionKey "ProductVersion" "${MeldVersion}"
VIAddVersionKey "CompanyName" "${Publisher}"
VIAddVersionKey "LegalCopyright" "Copyright (C) Keegan Witt"
VIAddVersionKey "OriginalFilename" "${Filename}"
VIAddVersionKey "FileDescription" "Meld ${MeldVersion} Installer"

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
    WriteRegStr "HKLM" "Software\${ProgramName}" "Executable" "${ExePath}"
    WriteUninstaller "${UninstallerPath}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayName" "${ProgramName}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayIcon" "${IconPath}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayVersion" "${ProgramVersion}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "Publisher" "${Publisher}"
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
    WriteRegDWORD "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "EstimatedSize" "$0"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "UninstallString" "${UninstallerPath}"
    WriteRegDWORD "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "NoModify" "1"
    WriteRegDWORD "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "NoRepair" "1"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "InstallLocation" "$INSTDIR\"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "URLInfoAbout" "${WebsiteUrl}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "HelpLink" "${WebsiteUrl}"
    WriteRegStr "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "URLUpdateInfo" "${WebsiteUrl}"
SectionEnd
Section "Start Menu Shortcut"
    SectionIn 1
    SetShellVarContext all
    SetOutPath "$INSTDIR\meld"
    CreateDirectory "$SMPROGRAMS\${ProgramName}"
    CreateShortCut "$SMPROGRAMS\${ProgramName}\${ProgramName}.lnk" "${ExePath}" "" "${IconPath}"
    CreateShortCut "$SMPROGRAMS\${ProgramName}\Uninstall ${ProgramName}.lnk" "${UninstallerPath}" "" "${IconPath}"
SectionEnd
Section "Desktop Shortcut"
    SectionIn 2
    SetShellVarContext all
    SetOutPath "$INSTDIR\meld"
    CreateShortCut "$DESKTOP\${ProgramName}.lnk" "${ExePath}" "" "${IconPath}"
SectionEnd

UninstPage components
UninstPage uninstConfirm
UninstPage instfiles

Section "un.Program and Shortcuts (Required)"
    SectionIn RO
    SetShellVarContext all
    RMDir /r "$INSTDIR\meld"
    RMDir /r "$INSTDIR\python"
    Delete "${UninstallerPath}"
    RMDir "$INSTDIR"
    RMDir /r "$SMPROGRAMS\${ProgramName}"
    Delete "$DESKTOP\${ProgramName}.lnk"
    DeleteRegKey "HKLM" "Software\${ProgramName}"
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
        ExecWait '$R0 _?=$INSTDIR'
        Delete "${UninstallerPath}"
        RMDir "$INSTDIR"
    done:
FunctionEnd
