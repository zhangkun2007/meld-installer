#NoTrayIcon

; store parameters in a string
params := GetCommandLine()

; determine if Python is bundled
IfExist, %A_ScriptDir%\..\python\App\pythonw.exe
    portablePython := true
IfNotExist, %A_ScriptDir%\..\python\App\pythonw.exe
    portablePython := false

; run Meld
if (portablePython = true) {
    RunWait, "%A_ScriptDir%\..\python\App\pythonw.exe" "%A_ScriptDir%\bin\meld" %params%
    ExitApp, %ErrorLevel%
} else {
    EnvGet, pythonHome, PYTHON_HOME
    EnvGet, meldPython, MELD_PYTHON
    if (meldPython <> "") {
        RunWait, "%meldPython%\pythonw.exe" "%A_ScriptDir%\bin\meld" %params%
        ExitApp, %ErrorLevel%
    } else if (pythonHome <> "") {
        RunWait, "%pythonHome%\pythonw.exe" "%A_ScriptDir%\bin\meld" %params%
        ExitApp, %ErrorLevel%
    } else {
        MsgBox, 0, Meld, Python was not included with install and neither MELD_PYTHON or PYTHON_HOME were set.  Unable to determine what pythonw to execute.
        ExitApp, 1
    }
}


; functionas below are from http://code.google.com/p/woomla/source/browse/trunk/AutoHotKey/CommandLine.ahk and are licensed GPL3

; --------------------------------------------------------------------
; Purpose: Return all of the script's command line
;          arguments in their original form.
; Input:
;   SkipParameters - The number of parameters to remove
;                    from the front of the returned string.
; Output:
;   RETURN - The command line arguments.
; --------------------------------------------------------------------
GetCommandLine( SkipParameters = 0 )
{
    AllCommandLine := SplitCommandString( DllCall( "GetCommandLineA", "Str" ), false, false )

    ; Set the size beforehand to avoid multiple resizings while assembling it.
    VarSetCapacity( CommandLine, StrLen( AllCommandLine ) )

    ; Scripts support command line parameters. The format is:
    ; AutoHotkey.exe [Switches] [Script Filename] [Script Parameters]

    ; And for compiled scripts, the format is:
    ; CompiledScript.exe [Switches] [Script Parameters]

    InSwitches := true
    if ( !A_IsCompiled )
        SkipParameters++
    Loop, Parse, AllCommandLine, `n
    {
        if ( A_Index = 1 )
            continue
        StrippedCommand := StripWhitespace( A_LoopField )
        if ( InSwitches )
        {
            InSwitches := false
            if ( SubStr( StrippedCommand, 1, 1 ) = "/" )
            {
                ; Just basing the switches on the slash is not enough.
                ; The script might have its own slash parameters.
                ; Ensure we only strip known AHK switches.
                if    (  StrippedCommand = "/f"
                    || StrippedCommand = "/r"
                    || StrippedCommand = "/force"
                    || StrippedCommand = "/restart"
                    || StrippedCommand = "/ErrorStdOut" )
                {
                    InSwitches := true
                    continue
                }
            }
        }
        if ( SkipParameters > 0 )
        {
            SkipParameters--
            continue
        }
        CommandLine .= A_LoopField
    }
    CommandLine := StripWhitespace( CommandLine, true, false )
    return CommandLine
}

; --------------------------------------------------------------------
; Purpose: Read a Windows Command Line styled string and
;          break it down into seperate arguments.
;          Each argument will go on a seperate line.
; Input:
;   String - The string to parse.
;   StripQuotes - Remove quotes from the command line.
;   StripWhitespace - Remove the whitespace between the arguments.
;                     If false, whitespace will go at
;                     the start of each line.
; Output:
;   RETURN - The parsed commands.
; --------------------------------------------------------------------
SplitCommandString( String, StripQuotes = true, StripWhitespace = true )
{
    InQuotes := false
    NewLine := true

    ; Set the probable/maximum size beforehand to avoid multiple resizings while assembling it.
    VarSetCapacity( OutString, StrLen( String ) )

    Loop, Parse, String
    {
        if ( !InQuotes )
        {
            if A_LoopField is space
            {
                if ( !NewLine )
                {
                    NewLine := true
                    OutString .= "`n"
                }
                if ( StripWhitespace )
                    continue
            }
        }
        if A_LoopField is not space
            NewLine := false
        if ( A_LoopField = """" )
        {
            InQuotes := !InQuotes
            if ( StripQuotes )
                continue
        }
        OutString .= A_LoopField
    }
    return OutString
}

; --------------------------------------------------------------------
; Purpose: Removes whitespace from the edges of a string.
; Input:
;   String - The string to parse.
;   Front - Remove whitespace from the starting edge.
;   Back - Remove whitespace from the trailing edge.
; Output:
;   RETURN - The stripped string.
; --------------------------------------------------------------------
StripWhitespace( String, Front = true, Back = true )
{
    if String is space ; Those loops can't properly handle an entirely blank string.
        return ""

    if ( Front )
    {
        Loop, % StrLen( String ) ;%
        {
            Character := SubStr( String, A_Index, 1 )
            if Character is not space
            {
                StringTrimLeft, String, String, A_Index - 1
                break
            }
        }
    }
    if ( Back )
    {
        Length := StrLen( String )
        Loop, %Length%
        {
            Character := SubStr( String, Length - ( A_Index - 1 ), 1 )
            if Character is not space
            {
                StringTrimRight, String, String, A_Index - 1
                break
            }
        }
    }
    return String
}
