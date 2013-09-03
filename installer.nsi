!define ProgramName "Meld"
!define MeldVersion "1.7.5"
!define ProgramVersion "${MeldVersion}.0"
!define Publisher "Keegan Witt"
!define ExePath "$INSTDIR\meld\meld.exe"
!define UninstallerPath "$INSTDIR\uninstall.exe"
!define IconPath "$INSTDIR\meld\meld.ico"
!define Filename "meld-${ProgramVersion}.exe"
!define WebsiteUrl "https://code.google.com/p/meld-installer/"
!define MUI_UNICON "meld\meld.ico"
!define MUI_ICON "meld\meld.ico"
!define MUI_FINISHPAGE_RUN "${ExePath}"

SetCompressor /SOLID bzip2

!include "MUI2.nsh"
!include "FileFunc.nsh"

!insertmacro MUI_PAGE_LICENSE "LICENSES.rtf"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Name "${ProgramName}"
OutFile "${Filename}"
RequestExecutionLevel admin
InstallDir "$PROGRAMFILES\${ProgramName}"

VIProductVersion "${ProgramVersion}"
VIAddVersionKey "ProductName" "${ProgramName}"
VIAddVersionKey "FileVersion" "${ProgramVersion}"
VIAddVersionKey "ProductVersion" "${MeldVersion}"
VIAddVersionKey "CompanyName" "${Publisher}"
VIAddVersionKey "LegalCopyright" "Copyright (C) Keegan Witt"
VIAddVersionKey "OriginalFilename" "${Filename}"
VIAddVersionKey "FileDescription" "Meld ${MeldVersion} Installer"

SectionGroup /e "!Program"
    Section "Meld (Required)"
        SectionIn RO
        SetOutPath "$INSTDIR"
        File /r "meld"
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
    Section "Python (not needed if PYTHON_HOME points to Python 2 with PyGTK)"
        SetOutPath "$INSTDIR"
        File /r "python"
        ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
        IntFmt $0 "0x%08X" $0
        WriteRegDWORD "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "EstimatedSize" "$0"
    SectionEnd
SectionGroupEnd
SectionGroup /e "Shortcuts"
    Section "Start Menu Shortcut"
        SetShellVarContext all
        CreateDirectory "$SMPROGRAMS\${ProgramName}"
        CreateShortCut "$SMPROGRAMS\${ProgramName}\${ProgramName}.lnk" "${ExePath}" "" "${IconPath}"
        CreateShortCut "$SMPROGRAMS\${ProgramName}\Uninstall ${ProgramName}.lnk" "${UninstallerPath}" "" "${IconPath}"
    SectionEnd
    Section "Desktop Shortcut"
        SetShellVarContext all
        CreateShortCut "$DESKTOP\${ProgramName}.lnk" "${ExePath}" "" "${IconPath}"
    SectionEnd
    Section "Send To Menu Shortcut"
        SetShellVarContext all
        CreateShortCut "$SENDTO\${ProgramName}.lnk" "${ExePath}" "" "${IconPath}"
    SectionEnd
    Section /o "Quick Launch Shortcut"
        SetShellVarContext all
        CreateShortCut "$QUICKLAUNCH\${ProgramName}.lnk" "${ExePath}" "" "${IconPath}"
    SectionEnd
SectionGroupEnd

Section "un.Program and Shortcuts (Required)"
    SectionIn RO
    SetShellVarContext all
    RMDir /r "$INSTDIR\meld"
    RMDir /r "$INSTDIR\python"
    Delete "${UninstallerPath}"
    RMDir "$INSTDIR"
    RMDir /r "$SMPROGRAMS\${ProgramName}"
    Delete "$DESKTOP\${ProgramName}.lnk"
    Delete "$SENDTO\${ProgramName}.lnk"
    Delete "$QUICKLAUNCH\${ProgramName}.lnk"
    DeleteRegKey "HKLM" "Software\${ProgramName}"
    DeleteRegKey "HKLM" "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}"
SectionEnd

Section /o "un.User Application Data"
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
