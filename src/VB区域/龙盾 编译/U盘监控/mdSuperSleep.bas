Attribute VB_Name = "mdSuperSleep"
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Function SuperSleep(DealyTime As Single) '此处原为long，修改为single可延时1ms :SK<2<8h
Dim TimerCount As Single
    TimerCount = Timer + DealyTime '增加X秒 ZJ9x6|q
    While TimerCount - Timer > 0
        DoEvents
        Sleep 1
    Wend
    Text1 = "SuperSleep " & DealyTime
End Function


