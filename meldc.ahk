#NoTrayIcon

; store parameters in a string
firstParam := true
params := ""
Loop, %0%
{
    param = %A_Index%
    firstChar := SubStr(%param%, 1, 1)
    if (firstParam = false) {
        params .= " "
    }
    if (firstChar != """" && firstChar != "-") {
        params .= """"
    }
    params .= %param%
    if (firstChar != """" && firstChar != "-") {
        params .= """"
    }
    firstParam := false
}

; determine if Python is bundled
IfExist, %A_ScriptDir%\..\python\App\python.exe
    portablePython := true
IfNotExist, %A_ScriptDir%\..\python\App\python.exe
    portablePython := false

; run Meld
if (portablePython = true) {
    RunWait, "%A_ScriptDir%\..\python\App\python.exe" "%A_ScriptDir%\bin\meld" %params%
    ExitApp, %ErrorLevel%
} else {
    EnvGet, pythonHome, PYTHON_HOME
    if (pythonHome <> "") {
        RunWait, "%pythonHome%\python.exe" "%A_ScriptDir%\bin\meld" %params%
        ExitApp, %ErrorLevel%
    } else {
        MsgBox, 0, Meld, Python was not included with install and PYTHON_HOME is not set.  Unable to determine what python to execute.
        ExitApp, 1
    }
}
