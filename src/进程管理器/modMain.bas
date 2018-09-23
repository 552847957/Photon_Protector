Attribute VB_Name = "modMain"
'������չAPI
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hWnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
'��Ҫ������������
Public Declare Function SetWindowPos& Lib "user32" (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long)
'����
Public Declare Function ShellAbout Lib "shell32.dll" Alias "ShellAboutA" (ByVal hWnd As Long, ByVal szApp As String, ByVal szOtherStuff As String, ByVal hIcon As Long) As Long
'��ʽ���ֽڴ�С
Public Declare Function StrFormatByteSize Lib "shlwapi" Alias "StrFormatByteSizeA" (ByVal dw As Long, ByVal pszBuf As String, ByRef cchBuf As Long) As String

'��ó�������Ŀ¼
Public Function GetApp() As String
    If Right$(App.Path, 1) = "\" Then
        GetApp = App.Path
    Else
        GetApp = App.Path & "\"
    End If
End Function

Public Sub SetTop(Frm As Form, IfTop As Boolean)
    If IfTop = True Then
        Rtn = SetWindowPos(Frm.hWnd, -1, 0, 0, 0, 0, 3)
    Else
        Rtn = SetWindowPos(Frm.hWnd, -2, 0, 0, 0, 0, 3)
    End If
End Sub

Public Function GetAppF(Str As String)
    If Str = "" Then Exit Function
    For I = Len(Str) To 1 Step -1
        If Mid$(Str, I, 1) = "\" Then
            GetAppF = Left$(Str, I - 1)
            Exit For
        End If
    Next
End Function

Public Function FormatLng(ByVal lng As Long) As String
    Dim Buffer As String
    Buffer = Space$(100)
    FormatLng = CheckStr(StrFormatByteSize(lng, Buffer, Len(Buffer)))
End Function

'ȥ���ַ����Ľ�����
Public Function CheckStr(Str As String) As String
    If Right$(Str, 1) = Chr(0) Then
        CheckStr = Left$(Str, Len(Str) - 1)
    Else
        CheckStr = Str
    End If
End Function
