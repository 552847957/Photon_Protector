Attribute VB_Name = "mdSendMessage"
Option Explicit
Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, ByVal lpsz2 As String) As Long
Private Declare Function SetWindowText Lib "user32" Alias "SetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String) As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Dim SendhWnd As Long '�����߾��

Public Function SendText(ByVal Text As String, ByVal ToType As String)
'Ѱ�ҽ�����
If ToType = "process" Then
SendhWnd = FindWindowEx(FindWindow(vbNullString, "DragonShieldProcessRec"), 0&, "ThunderRT6TextBox", "txtReceive1")
ElseIf ToType = "file" Then

End If

If SendhWnd <> 0 Then
    '�ҵ������ߣ�����
    Call SendMessage(SendhWnd, &HC, 0, ByVal Text) '��Text1�����ݴ���ָ�����壬�޸Ĵ������
Else

End If
End Function
