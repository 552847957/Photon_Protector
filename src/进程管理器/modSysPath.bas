Attribute VB_Name = "modSysPath"
Public Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
Public Declare Function GetSystemDirectory Lib "kernel32" Alias "GetSystemDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long

'���ϵͳsystem32Ŀ¼
Public Function GetSysDir() As String
    Dim temp As String * 256
    Dim x As Integer
    x = GetSystemDirectory(temp, Len(temp))
    GetSysDir = Left$(temp, x)
End Function

'���WinĿ¼
Public Function GetWinDir() As String
    Dim temp As String * 256
    Dim x As Integer
    x = GetWindowsDirectory(temp, Len(temp))
    GetWinDir = Left$(temp, x)
End Function

