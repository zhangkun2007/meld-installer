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

Run, ..\python\App\pythonw.exe bin\meld %params%
Exit, %ErrorLevel%
