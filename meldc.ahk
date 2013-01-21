SetWorkingDir, %A_ScriptDir%

params := ""
Loop, %0%
{
    param = %A_Index%
    params .= " "
    params .= %param%
}

Run, ..\python\App\python.exe bin\meld %params%
