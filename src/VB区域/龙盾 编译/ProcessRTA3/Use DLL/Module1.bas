Attribute VB_Name = "Module1"
Public Declare Function SetWindowLong Lib "User32.dll" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
'Download by http://www.codefans.net
Public Declare Function CallWindowProc Lib "User32.dll" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Sub RtlZeroMemory Lib "ntdll.dll" (dest As Any, ByVal numBytes As Long)
Public Declare Function MessageBox Lib "user32" Alias "MessageBoxA" (ByVal hwnd As Long, ByVal lpText As String, ByVal lpCaption As String, ByVal wType As Long) As Long



Public Const GWL_WNDPROC = -4
Public oldWNDPROC, newWNDPROC As Long
Public ExeFiles As String
Public CommandLines As String

Function WndProc(ByVal hwnd As Long, ByVal msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

        Dim tmp As Long

        If msg = &H400 Then

                tmp = pShareMem + 12
                
                wcscpy ByVal StrPtr(ExeFiles), ByVal tmp
                RtlZeroMemory ByVal tmp, 1000
                tmp = pShareMem + 12 + 1000
                
                wcscpy ByVal StrPtr(CommandLines), ByVal tmp
                RtlZeroMemory ByVal tmp, 1000
                
                tmp = InStr(1, ExeFiles, Chr(0))

                If tmp > 1 Then
                        ExeFiles = Left$(ExeFiles, tmp - 1)
                
                End If

                tmp = InStr(1, CommandLines, Chr(0))

                If tmp > 1 Then
                        CommandLines = Left$(CommandLines, tmp - 1)
                
                End If


                If Len(ExeFiles) = 0 Then
                        'tmp = MessageBox(Form1.hwnd, "���� " & CommandLines & "��ͼ����,�Ƿ�����?", "��ʾ", vbYesNo + 32)
                        tmp = CheckProcess(CommandLines, "")

                        If tmp = vbYes Then
                                WndProc = 1
                        Else
                                WndProc = 0
                        End If

                Else
                        'tmp = MessageBox(Form1.hwnd, "���� " & ExeFiles & " ��ͼִ�� " & Chr(13) & "������:" & CommandLines & Chr(13) & "�Ƿ�����?", "��ʾ", vbYesNo + 32)
                        tmp = CheckProcess(CommandLines, ExeFiles)
                        If tmp = True Then
                                WndProc = 1
                        Else
                                WndProc = 0
                        End If
                
                End If
                CommandLines = Space$(1000)
                ExeFiles = Space$(1000)
        Else
       
                WndProc = CallWindowProc(oldWNDPROC, hwnd, msg, wParam, lParam)
    
        End If

End Function

Public Function CheckProcess(ByVal CmdLine As String, ByVal ProcessPath As String) As Boolean
If ProcessPath = "" Then
CheckProcess = True
Exit Function
End If
On Error GoTo ERR:
Dim YesNo As Boolean
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
MyForm.Text1.Text = "�˽������ڴ����У�" & ProcessPath & vbCrLf & "�����У�" & CmdLine
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
