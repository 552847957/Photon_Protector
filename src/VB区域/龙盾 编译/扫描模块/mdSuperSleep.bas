Attribute VB_Name = "mdSuperSleep"
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Public selectover As Boolean
Public Function SuperSleep(DealyTime As Single) '�˴�ԭΪlong���޸�Ϊsingle����ʱ1ms :SK<2<8h
Dim TimerCount As Single
    TimerCount = Timer + DealyTime '����X�� ZJ9x6|q
    While TimerCount - Timer > 0
        DoEvents
        Sleep 1
    Wend
    Text1 = "SuperSleep " & DealyTime
End Function


