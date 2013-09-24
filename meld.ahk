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

; determine which executable to use (use python.exe when calling from the commandline so the process waits for the exit code, otherwise use pythonw.exe so no command prompt appears)
if (params <> "") {
    pyExe = python.exe
} else {
    pyExe = pythonw.exe
}

; determine if Python is bundled
IfExist, %A_ScriptDir%\..\python\App\%pyExe%
    portablePython := true
IfNotExist, %A_ScriptDir%\..\python\App\%pyExe%
    portablePython := false

; run Meld
if (portablePython = true) {
    RunWait, "%A_ScriptDir%\..\python\App\%pyExe%" "%A_ScriptDir%\bin\meld" %params%
} else {
    EnvGet, pythonHome, PYTHON_HOME
    if (pythonHome <> "") {
        RunWait, "%pythonHome%\%pyExe%" "%A_ScriptDir%\bin\meld" %params%
    } else {
        MsgBox, 0, "Meld", "Python was not included with install and PYTHON_HOME is not set.  Unable to determine what pythonw to execute."
        ExitApp, 1
    }
}
ExitApp, %ErrorLevel%
