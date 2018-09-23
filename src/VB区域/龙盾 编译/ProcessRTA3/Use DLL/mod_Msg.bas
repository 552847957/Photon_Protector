Attribute VB_Name = "mod_Msg"
Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function MessageBoxA Lib "user32" (ByVal hwnd As Long, ByVal lpText As String, ByVal lpCaption As String, ByVal wType As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal length As Long)
Private Type COPYDATASTRUCT
    dwData As Long
    cbData As Long
    lpData As Long
End Type
Public c As Long
Public Function Wndproc(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
On Error GoTo ERR:
Dim s As String
Dim cds As COPYDATASTRUCT
    If Msg = &H4A Then
    CopyMemory cds, ByVal lParam, Len(cds)
    s = Space(cds.cbData)
    CopyMemory ByVal s, ByVal cds.lpData, cds.cbData
    s = StrConv(s, vbFromUnicode)
    s = Left(s, InStr(1, s, Chr(0)) - 1)
        If CheckProcess(wParam, s) = True Then
            Wndproc = 1234
        Else
            Wndproc = 0
        End If
        Exit Function

'    s = "����(Pid:" & wParam & ")Ҫ�����½���: " & s & ",�Ƿ�����?"
'    Debug.Print s
'        If MessageBoxA(0, s, "", 4) = 6 Then
'            Wndproc = 1234
'        Else
'            Wndproc = 0
'        End If
'        Exit Function
    End If
ERR:
    Wndproc = CallWindowProc(c, hwnd, Msg, wParam, lParam)
End Function

Public Function CheckProcess(ByVal FromProcessID As String, ByVal ProcessPath As String) As Boolean
If FromProcessID = "0" Then
Exit Function
End If
On Error GoTo ERR:
Dim FromProcessPath As String
Dim YesNo As Boolean
FromProcessPath = GetProcessPath(FromProcessID)
Dim ID As String, Result As String
Result = ReadString("Rules", """" & ProcessPath & """", App.Path & "\Rules.ini")
If Result = "" Then 'û�м�¼��������һ��Ĭ�ϵļ�¼
  WriteString "Rules", """" & ProcessPath & """", "2", App.Path & "\Rules.ini"
End If
'���¶�ȡ
Result = ReadString("Rules", """" & ProcessPath & """", App.Path & "\Rules.ini")
 If Result = "1" Then '���εĶ���
 CheckProcess = True
 Exit Function
 ElseIf Result = "0" Then '�����εĶ���
 CheckProcess = False
 Exit Function
 End If
 'Ĭ��2
Dim MyForm As New frmTip
MyForm.PicIcon = GetIconFromFile(ProcessPath, 0, True)
MyForm.Text1.Text = "���̣�" & FromProcessPath & vbCrLf & "������ID��" & FromProcessID & vbCrLf & "���ڴ������̣�" & ProcessPath
Dim MyFSO As New FileSystemObject
Dim StrDrv As String
StrDrv = Left(ProcessPath, 3)
If Right(StrDrv, 2) <> ":\" Then '������Ǳ�׼·����
  MyForm.Option2.Value = True
MyForm.Tip = "���ɽ������ڴ����У��벻Ҫ���������������ļ���������Ǵ��ļ��У����Ϊαװ��Ӧ�ó���"
GoTo Kip:
End If
If MyFSO.GetDrive(StrDrv).DriveType <> Fixed Then '����ǲ��Ǳ��س��ֵĶ���
 MyForm.Option2.Value = True
MyForm.Tip = "�Ǳ��ش������������п��ɽ��̣��벻Ҫ���������������ļ���������Ǵ��ļ��У����Ϊαװ��Ӧ�ó���"
Else
 MyForm.Option1.Value = True
MyForm.Tip = "���ش������������н��̣��벻Ҫ���������������ļ��������ڱ��ش����У�������ϵͳ�Զ����еĳ���Ĭ��30����С�"
End If
Kip:
MyForm.Command1.Caption = "��"
MyForm.Show vbModal

'���ѡ���Ժ�Ҳ��ô����
If MyForm.ChooseNum <> 1 And MyForm.ChooseNum <> 2 Then
Dim MyForm2 As New frmTip
MyForm2.PicIcon = GetIconFromFile(ProcessPath, 0, True)
   If MyForm.ChooseNum = 3 Then
   WriteString "Rules", """" & ProcessPath & """", "1", App.Path & "\Rules.ini"
   MyForm2.Text1 = "�ļ���" & ProcessPath & vbCrLf & "�Ѿ���ӵ����ܵ������б������أ���ɨ�衣"
   ElseIf MyForm.ChooseNum = 4 Then
   MyForm2.Text1 = "�ļ���" & ProcessPath & vbCrLf & "�Ѿ���ӵ����ܵĺ������б���ֹ���У���ֹ����"
   WriteString "Rules", """" & ProcessPath & """", "0", App.Path & "\Rules.ini"
   End If
MyForm2.Option1.Visible = False
MyForm2.Option2.Visible = False
MyForm2.Check1.Visible = False
MyForm2.Command2.Caption = "��֪����"
MyForm2.Label2.Visible = False
MyForm2.Label3.Caption = "��ӹ���"
MyForm2.Show
End If

If MyForm.ChooseNum = 1 Then
CheckProcess = True
ElseIf MyForm.ChooseNum = 2 Then
CheckProcess = False
ElseIf MyForm.ChooseNum = 3 Then
CheckProcess = True
ElseIf MyForm.ChooseNum = 4 Then
CheckProcess = False
End If

ERR:
End Function
