Attribute VB_Name = "mdMsg"
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
Const WM_MYMESSAGE = &H400 + 100
Const WM_USER = &H400
Public c As Long
Public KillShit As Boolean
Public Declare Function CheckFileDigitalSignature_Ansi Lib "DSDigitalSignature.dll" (ByVal CheckFileDigitalSignature_Ansi As String) As Long


Public Function Wndproc(ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
On Error GoTo Err:
Dim RecStr As String
Dim Mode
Dim DesStr
Dim DesString
Dim cds As COPYDATASTRUCT
    If Msg = WM_MYMESSAGE Then
     'MsgBox "��ʼ����"
    RecStr = Form_Map.ReadMem
    
      'MsgBox RecStr
      '�������
      
      DesString = Split(RecStr, "|")(0)
      DesStr = Split(RecStr, "|")(1)
      Mode = Split(RecStr, "|")(2)
      '�з�
      Dim WtStr
     ' MsgBox DesString
     '  MsgBox DesStr
      '  MsgBox Mode
     ' '\Registry\Machine\System\CurrentControlSet\Services\SuperKillFile|services.exe|DRV
      Select Case Mode
        Case "PRO" '����
       ' MsgBox "����"
       KillShit = False
        WriteProLog "==============================="
         WriteProLog "ʱ�䣺" & Now
         WriteProLog DesStr & "���ڴ������̣�" & DesString
         If CheckProcess(DesStr, DesString) = True Then '����
         WtStr = "Allow"
         Else
         WtStr = "Disallow"
         If KillShit = True Then 'Ҫɾ��
           Dim NewKill As New Killer
           NewKill.KillName = DesString
           Load NewKill
         End If
         End If
          Call WriteString("RTA", "Message", WtStr, _
          App.Path & "\Chat.ini")
        'д����Ϣ
        Case "DRV"
        WriteDrvLog "==============================="
        'MsgBox "����"
         WriteDrvLog "ʱ�䣺" & Now
         WriteDrvLog "������" & DesString
         If CheckDriver(DesStr, DesString) = True Then '����
         WtStr = "Allow"
         Else
         WtStr = "Disallow"
         End If
         
      End Select
    Form_Map.WriteMem (WtStr)
    End If
Err:
    Wndproc = CallWindowProc(c, hwnd, Msg, wParam, lParam)
End Function




Public Function CheckProcess(ByVal FromProcessPath As String, ByVal ProcessPath As String) As Boolean
On Error GoTo Err:

Dim YesNo As Boolean

Dim ID As String, Result As String
Result = ReadString("Rules", """" & ProcessPath & """", App.Path & "\Rules.ini")
If Result = "" Then 'û�м�¼��������һ��Ĭ�ϵļ�¼
  WriteString "Rules", """" & ProcessPath & """", "2", App.Path & "\Rules.ini"
End If
'���¶�ȡ
Result = ReadString("Rules", """" & ProcessPath & """", App.Path & "\Rules.ini")
 If Result = "1" Then '���εĶ���
 WriteProLog "��������ε�Ŀ�꣬�Զ�����"
 CheckProcess = True
 Exit Function
 ElseIf Result = "0" Then '�����εĶ���
 WriteProLog "����������ε�Ŀ�꣬�Զ�����"
 CheckProcess = False
 Exit Function
 End If
 '����ǩ����֤
 'MsgBox "��֤" & ProcessPath
 If CheckFileDigitalSignature_Ansi(ProcessPath) = "1" Then '�Ѿ�������ǩ��
  WriteProLog "�����ӵ������ǩ�����Զ�����"
  CheckProcess = True
  Exit Function
  Else
  WriteProLog "������ǩ��"
  End If
 'Ĭ��2
  '���в���ɨ��
 Dim ScanResult

 ScanResult = ProcessScan(ProcessPath)
If ScanResult <> "SAFE" And ScanResult <> "Error" Then

  
   Dim VirusForm As New frmVirusTip
    VirusForm.PicIcon = GetIconFromFile(ProcessPath, 0, True)
    VirusForm.Tip.Caption = "���ֲ����������У��ѱ����������������أ������޷�������"
    VirusForm.TextRes.Text = ProcessPath & vbCrLf & _
    "��������" & Split(ScanResult, "|")(0) & vbCrLf & _
    "����������" & Split(ScanResult, "|")(1)
    VirusForm.Show vbModal
     WriteProLog "������" & ProcessPath
     WriteProLog "����������" & ScanResult
     WriteProLog "�ѽ�������"
     CheckProcess = False
     Exit Function
Else
Dim MyForm As New frmTip
MyForm.PicIcon = GetIconFromFile(ProcessPath, 0, True)
MyForm.Text1.Text = "���̣�" & FromProcessPath & vbCrLf & "���ڴ������̣�" & ProcessPath
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
   WriteProLog "������û�ѡ����ӵ������б�"
   ElseIf MyForm.ChooseNum = 4 Then
   MyForm2.Text1 = "�ļ���" & ProcessPath & vbCrLf & "�Ѿ���ӵ����ܵĺ������б���ֹ���У���ֹ����"
   WriteString "Rules", """" & ProcessPath & """", "0", App.Path & "\Rules.ini"
   WriteProLog "������û�ѡ����ӵ��������б�"
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
WriteProLog "����������"
CheckProcess = True
ElseIf MyForm.ChooseNum = 2 Then
WriteProLog "����ֹ����"
CheckProcess = False
ElseIf MyForm.ChooseNum = 3 Then
WriteProLog "����������"
CheckProcess = True
ElseIf MyForm.ChooseNum = 4 Then
WriteProLog "����ֹ����"
CheckProcess = False
End If
Exit Function
End If
Err:
WriteProLog "ִ�г���"
CheckProcess = True
End Function


Public Function CheckDriver(ByVal FromProcessPath As String, ByVal ProcessPath As String) As Boolean
'��ProcessPath���DrivePath
On Error GoTo Err:

Dim YesNo As Boolean

Dim ID As String, Result As String
Result = ReadString("DriverRules", """" & ProcessPath & """", App.Path & "\Rules.ini")
If Result = "" Then 'û�м�¼��������һ��Ĭ�ϵļ�¼
  WriteString "DriverRules", """" & ProcessPath & """", "2", App.Path & "\Rules.ini"
End If
'���¶�ȡ
Result = ReadString("DriverRules", """" & ProcessPath & """", App.Path & "\Rules.ini")
 If Result = "1" Then '���εĶ���
 WriteDrvLog "��������ε��������Զ����С�"
 CheckDriver = True
 Exit Function
 ElseIf Result = "0" Then '�����εĶ���
 WriteDrvLog "������������е��������Զ���ֹ��"
 CheckDriver = False
 Exit Function
 End If
 '����ǩ����֤
  If CheckFileDigitalSignature_Ansi(FromProcessPath) = "1" Then '�Ѿ�������ǩ��
  WriteProLog "�����ӵ������ǩ�����Զ�����"
  CheckDriver = True
  Exit Function
  End If
 'Ĭ��2
Dim MyForm As New frmTip
'MyForm.PicIcon = GetIconFromFile(ProcessPath, 0, True)
MyForm.Text1.Text = "���̣�" & FromProcessPath & vbCrLf & "���ڼ���������" & ProcessPath
MyForm.Label3.Caption = "������������"
MyForm.Tip = "�����г��������ƹ���ȫ����ļ�⣬���������ƹ���ϵͳ���Ȩ�ޣ�Ring0���������δ֪������ؽ��кܴ���գ������������޷����ص������Ĳ�����"
If LCase(FromProcessPath) = "services.exe" Then '�����ϵͳ����
MyForm.Option1.Value = True
Else
MyForm.Option2.Value = True
End If
MyForm.Option2.Caption = "��ֹ�˲���"
Kip:
MyForm.Command1.Caption = "��"
MyForm.Show vbModal

'���ѡ���Ժ�Ҳ��ô����
If MyForm.ChooseNum <> 1 And MyForm.ChooseNum <> 2 Then
Dim MyForm2 As New frmTip
MyForm2.PicIcon = GetIconFromFile(ProcessPath, 0, True)
   If MyForm.ChooseNum = 3 Then
   WriteString "DriverRules", """" & ProcessPath & """", "1", App.Path & "\Rules.ini"
   MyForm2.Text1 = "������" & ProcessPath & vbCrLf & "�Ѿ���ӵ����ܵ������б������أ���ɨ�衣"
   WriteDrvLog "������û�ѡ����ӵ������б�"
   ElseIf MyForm.ChooseNum = 4 Then
   MyForm2.Text1 = "������" & ProcessPath & vbCrLf & "�Ѿ���ӵ����ܵĺ������б���ֹ���У���ֹ����"
   WriteString "DriverRules", """" & ProcessPath & """", "0", App.Path & "\Rules.ini"
 WriteDrvLog "������û�ѡ����ӵ�������"
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
WriteDrvLog "���������"
CheckDriver = True
ElseIf MyForm.ChooseNum = 2 Then
WriteDrvLog "�����ز���"
CheckDriver = False
ElseIf MyForm.ChooseNum = 3 Then
WriteDrvLog "���������"
CheckDriver = True
ElseIf MyForm.ChooseNum = 4 Then
WriteDrvLog "�����ز���"
CheckDriver = False
End If
Exit Function
Err:
CheckDriver = True
End Function


Public Function WriteProLog(ByVal Text As String)
Open App.Path & "\ProLog.dat" For Binary As #1
    Put #1, LOF(1) + 1, Text & vbCrLf
Close #1
End Function

Public Function WriteDrvLog(ByVal Text As String)
Open App.Path & "\DrvLog.dat" For Binary As #1
    Put #1, LOF(1) + 1, Text & vbCrLf
Close #1
End Function

