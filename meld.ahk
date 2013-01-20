params := ""
Loop, %0%
{
    param = %A_Index%
    params .= " "
    params .= %param%
}

Run, %A_WorkingDir%\..\python\App\pythonw.exe %A_WorkingDir%\bin\meld %params%
