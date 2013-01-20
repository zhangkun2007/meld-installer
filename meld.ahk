params := ""
Loop, %0%
{
    param = %A_Index%
    params .= " "
    params .= %param%
}

Run, ..\python\App\pythonw.exe bin\meld %params%
