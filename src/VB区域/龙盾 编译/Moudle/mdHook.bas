Attribute VB_Name = "mdHook"
Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function MessageBoxA Lib "user32" (ByVal hwnd As Long, ByVal lpText As String, ByVal lpCaption As String, ByVal wType As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Private Type COPYDATASTRUCT
    dwData As Long
    cbData As Long
    lpData As Long
End Type
Public c As Long
Option Explicit
Private Declare Function OpenProcess Lib "kernel32.dll" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessID As Long) As Long
Private Declare Function GetModuleFileNameExA Lib "psapi.dll" (ByVal hProcess As Long, ByVal hModule As Long, ByVal ModuleName As String, ByVal nSize As Long) As Long
Private Declare Function CloseHandle Lib "kernel32.dll" (ByVal hObject As Long) As Long
Private Declare Function EnumProcessModules Lib "psapi.dll" (ByVal hProcess As Long, ByRef lphModule As Long, ByVal cb As Long, ByRef cbNeeded As Long) As Long

Private Function GetProcessNameByProcessId(ByVal Pid As Long) As String
     Dim szBuf(1 To 250) As Long
     Dim Ret As Long
     Dim szPathName As String
     Dim nSize As Long
     Dim hProcess As Long
     hProcess = OpenProcess(&H400 Or &H10, 0, Pid)
     If hProcess <> 0 Then
        Ret = EnumProcessModules(hProcess, szBuf(1), 250, Pid)
        If Ret <> 0 Then
            szPathName = Space(260)
            nSize = 500
            Ret = GetModuleFileNameExA(hProcess, szBuf(1), szPathName, nSize)
            GetProcessNameByProcessId = szPathName
        End If
     End If
     Ret = CloseHandle(hProcess)
End Function


Public Function Wndproc(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Dim s As String
MsgBox ".."
Dim cds As COPYDATASTRUCT
    If Msg = &H4A Then
    CopyMemory cds, ByVal lParam, Len(cds)
    s = Space(cds.cbData)
    CopyMemory ByVal s, ByVal cds.lpData, cds.cbData
    s = StrConv(s, vbFromUnicode)
    s = Left(s, InStr(1, s, Chr(0)) - 1)
    Dim ProcessPath As String
    ProcessPath = s
    AddInfo ProcessPath
    AddInfo s
Dim MyFSO As New FileSystemObject
Dim Result As String
'If MyFSO.GetDrive(Split(ProcessPath, ":\")(0) & ":\").DriveType = Removable Then
'   MsgBox ProcessPath & vbCrLf & ProcessName & vbCrLf & "�Ѿ����ƶ��豸" & Split(ProcessPath, ":\")(0) & ":\" & "����"
'         Result = ProcessScan(ProcessPath)
'         AddInfo Result
'         If Result <> "SAFE" And Result <> "Error" Then '������Ǹ�����
'            DesString = DesString & "������:" & Split(Result, "|")(0) & "|" & "����:" & Split(Result, "|")(1) & "|"
'         End If
'         If Result = "SAFE" Then
'            DesString = DesString & "���������ȫ" & "|"
'         ElseIf Result = "Error" Then
'            DesString = DesString & "ɨ���ļ�����δ֪" & "|"
'         End If
'
'         DesString = DesString & "�����߽���:" & GetProName(GetProcessNameByProcessId(wParam)) & "|" & "������·��" & GetProcessNameByProcessId(wParam) & "|" & "������:" & GetProName(ProcessPath) & "|" & "����·��:" & ProcessPath
'         If ShowTextTip("��⵽�������ڴ��ƶ��豸����", DesString, ProcessPath) = 1 Then
'           Wndproc = 1234
'         Else
'           Wndproc = 0
'         End If
'      End If
'   End If
'
'
'Else 'û�����ƶ��豸��
'
'         Result = ProcessScan(ProcessPath)
'         AddInfo Result
'         If Result <> "SAFE" And Result <> "Error" Then '������Ǹ�����
'            DesString = DesString & "������:" & Split(Result, "|")(0) & "|" & "����:" & Split(Result, "|")(1) & "|"
'         End If
'         If Result = "SAFE" Then
'            DesString = DesString & "���������ȫ" & "|"
'            GoTo Out:
'         ElseIf Result = "Error" Then
'            DesString = DesString & "ɨ���ļ�����δ֪" & "|"
'            GoTo Out:
'         End If
'
'         DesString = DesString & "�����߽���:" & GetProName(GetProcessNameByProcessId(wParam)) & "|" & "������·��" & GetProcessNameByProcessId(wParam) & "|" & "������:" & GetProName(ProcessPath) & "|" & "����·��:" & ProcessPath
'         If ShowTextTip("��⵽ľ��������ڴ���", DesString, ProcessPath) = 1 Then
'           Wndproc = 1234
'         Else
'           Wndproc = 0
'         End If
'      End If
'   End If
'
'
'End If
        If MessageBoxA(0, s, "", 4) = 6 Then
            Wndproc = 1234
        Else
            Wndproc = 0
        End If
        Exit Function

End If
Wndproc = CallWindowProc(c, hwnd, Msg, wParam, lParam)
End Function

Private Function GetProName(ByVal Path As String) As String
Dim i As Integer
i = InStrRev("c:\windows\text.txt", "\")
GetProName = Right("c:\windows\text.txt", Len(("c:\windows\text.txt") - i))
End Function
