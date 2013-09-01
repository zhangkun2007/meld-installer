#NoTrayIcon

SetWorkingDir, %A_ScriptDir%

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

IfExist, ..\python\App\pythonw.exe
    portablePython := true
IfNotExist, ..\python\App\pythonw.exe
    portablePython := false
if (portablePython = true) {
    RunWait, ..\python\App\pythonw.exe bin\meld %params%
} else {
    EnvGet, pythonHome, PYTHON_HOME
    if (pythonHome <> "") {
        RunWait, %pythonHome%\pythonw.exe bin\meld %params%
    } else {
        MsgBox, 0, Meld, Python was not included with install and PYTHON_HOME is not set.  Unable to determine what pythonw to execute.
        ExitApp, 1
    }
}

ExitApp, %ErrorLevel%
