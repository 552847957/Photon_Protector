VERSION 5.00
Begin VB.Form frmWatch 
   Caption         =   "����-ʵʱ���"
   ClientHeight    =   1920
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4350
   Icon            =   "frmMain.frx":0000
   ScaleHeight     =   1920
   ScaleWidth      =   4350
   StartUpPosition =   2  '��Ļ����
   Begin VB.CommandButton Command2 
      Caption         =   "�ر�"
      Height          =   375
      Left            =   1920
      TabIndex        =   3
      Top             =   1440
      Width           =   975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "����"
      Height          =   375
      Left            =   3120
      TabIndex        =   1
      Top             =   1440
      Width           =   975
   End
   Begin VB.Frame Frame1 
      Caption         =   "״̬"
      Height          =   975
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   3855
      Begin VB.Label Label1 
         Caption         =   "�����......"
         Height          =   255
         Left            =   360
         TabIndex        =   2
         Top             =   360
         Width           =   3255
      End
   End
End
Attribute VB_Name = "frmWatch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public Working As Boolean
'����Microsoft WMI Scripting V1.2 Library
Private objSWbemServices As SWbemServices
Private WithEvents CreateProcessEvent As SWbemSink
Attribute CreateProcessEvent.VB_VarHelpID = -1
Private WithEvents DeleteProcessEvent As SWbemSink
Attribute DeleteProcessEvent.VB_VarHelpID = -1
Private WithEvents ModificationProcessEvent As SWbemSink
Attribute ModificationProcessEvent.VB_VarHelpID = -1
Private Declare Function OpenProcess Lib "kernel32.dll " (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
'�򿪽���API
Private Declare Function EnumProcessModules Lib "psapi.dll " (ByVal hProcess As Long, ByRef lphModule As Long, ByVal cb As Long, ByRef cbNeeded As Long) As Long
'����ģ��API
Private Declare Function GetModuleFileNameExA Lib "psapi.dll " (ByVal hProcess As Long, ByVal hModule As Long, ByVal ModuleName As String, ByVal nSize As Long) As Long
'��ý���EXEִ���ļ�ģ��API
Private Declare Function CloseHandle Lib "kernel32.dll " (ByVal hObject As Long) As Long
'�رվ��API
Private Const SYNCHRONIZE = &H100000
Private Const STANDARD_RIGHTS_REQUIRED = &HF0000
Private Const PROCESS_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED Or SYNCHRONIZE Or &HFFF)
Private Declare Function NtSuspendProcess Lib "ntdll.dll" (ByVal hProc As Long) As Long
Private Declare Function NtResumeProcess Lib "ntdll.dll" (ByVal hProc As Long) As Long
Private Declare Function TerminateProcess Lib "kernel32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long
Private hProcess As Long

Function GetProcessPathByProcessID(PID As Long) As String
        On Error GoTo Z
        Dim cbNeeded     As Long
        Dim szBuf(1 To 250)         As Long
        Dim ret     As Long
        Dim szPathName     As String
        Dim nSize     As Long
        Dim hProcess     As Long
        hProcess = OpenProcess(&H400 Or &H10, 0, PID)
        If hProcess <> 0 Then
                ret = EnumProcessModules(hProcess, szBuf(1), 250, cbNeeded)
                If ret <> 0 Then
                        szPathName = Space(260)
                        nSize = 500
                        ret = GetModuleFileNameExA(hProcess, szBuf(1), szPathName, nSize)
                        GetProcessPathByProcessID = Left(szPathName, ret)
                End If
        End If
        ret = CloseHandle(hProcess)
        If GetProcessPathByProcessID = " " Then
              GetProcessPathByProcessID = "SYSTEM "
        End If
        Exit Function
Z:
End Function


Private Sub Command1_Click()
Me.Hide
End Sub

Private Sub Command2_Click()
If Working = True Then
  CreateProcessEvent.Cancel
  DeleteProcessEvent.Cancel
  Label1.Caption = "�Ѿ�ֹͣ����......"
  'addinfo "ʵʱ��ر��رգ�......"
  Command2.Caption = "����"
  Working = False
Else
  StartMonitorCreateProcessEvent
  StartMonitorDeleteProcessEvent
  Label1.Caption = "�������У�ʵʱ���ϵͳ���н��̵Ĵ���......"
  'addinfo "ʵʱ��ؿ���......"
  Command2.Caption = "�ر�"
  Working = True
End If
End Sub

Private Sub Command3_Click()

End Sub

'���ֲ�������
'StartMonitorCreateProcessEvent
'StartMonitorDeleteProcessEvent
'StartMonitorModificationProcessEvent
'CreateProcessEvent.Cancel
'DeleteProcessEvent.Cancel
'ModificationProcessEvent.Cancel


Private Sub Form_Load()
StartMonitorCreateProcessEvent
StartMonitorDeleteProcessEvent

Label1.Caption = "�������У�ʵʱ���ϵͳ���н��̵Ĵ���......"
Working = True
'StartMonitorModificationProcessEvent
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
If UnloadMode <> 1 Then
Cancel = True
Me.Hide
End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
CreateProcessEvent.Cancel
DeleteProcessEvent.Cancel

Working = False
'ModificationProcessEvent.Cancel
End Sub

'���̴����¼�
Private Sub CreateProcessEvent_OnObjectReady(ByVal objWbemObject As WbemScripting.ISWbemObject, ByVal objWbemAsyncContext As WbemScripting.ISWbemNamedValueSet)
On Error Resume Next
         Dim Result As String
         Dim DesString As String
Dim ProcessName As String, ProcessID As Long, ProcessPath As String, CommandLine As String, CreationDate As String
ProcessName = objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("Name").Value
ProcessID = objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("ProcessId").Value
'Debug.Print objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("CommandLine").Value
'Debug.Print objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("CreationDate").Value
'Debug.Print objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("ExecutablePath").Value
'Debug.Print objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("Handle").Value
'Debug.Print objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("CreationDate").Value
'Debug.Print objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("ProcessId").Value
ProcessPath = objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("ExecutablePath").Value
CommandLine = objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("CommandLine").Value
If ProcessPath = "" Then Exit Sub
'addinfo "ʵʱ����������������" & ProcessName
''addinfo "����ID��" & ProcessId
''addinfo "�����У�" & CommandLine
''addinfo "����·����" & ProcessPath
'SendText "process|" & ProcessName & "|" & ProcessPath, "process"
  Dim MyFSO As New FileSystemObject
 '  MsgBox ProcessPath & vbCrLf & ProcessName & vbCrLf & "�Ѿ����ƶ��豸" & Split(ProcessPath, ":\")(0) & ":\" & "����"
   If IsNumeric(ProcessID) Then
      hProcess = OpenProcess(PROCESS_ALL_ACCESS, False, CLng(ProcessID))
      If hProcess <> 0 Then
         NtSuspendProcess hProcess '����
         'Result = ProcessScan(ProcessPath)
         DesString = DesString & "������:" & ProcessName & "|" & "����ID:" & ProcessID & "|" & "������:" & CommandLine & "|" & "����·��:" & ProcessPath
         If CheckProcess(ProcessID, ProcessPath) = True Then
           NtResumeProcess hProcess '����
         Else
           TerminateProcess hProcess, 0 '��ֹ
         End If
      End If
   End If

End Sub
Private Function CheckProcess(ByVal ProcessID As String, ByVal ProcessPath As String) As Boolean
If ProcessID = "0" Then
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
MyForm.Text1.Text = "���̣�" & ProcessPath & vbCrLf & "����ID��" & ProcessID & vbCrLf & "���ڴ���"
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
'�����˳��¼�
Private Sub DeleteProcessEvent_OnObjectReady(ByVal objWbemObject As WbemScripting.ISWbemObject, ByVal objWbemAsyncContext As WbemScripting.ISWbemNamedValueSet)
On Error Resume Next
Dim ProcessName As String, ProcessID As Long, ProcessPath As String, CommandLine As String, CreationDate As String
ProcessName = objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("Name").Value
ProcessID = objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("ProcessId").Value
ProcessPath = objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("ExecutablePath").Value
If ProcessPath = "" Then Exit Sub
'addinfo "ʵʱ�����������˳���" & ProcessName
End Sub

'�������Ա���¼�
Private Sub ModificationProcessEvent_OnObjectReady(ByVal objWbemObject As WbemScripting.ISWbemObject, ByVal objWbemAsyncContext As WbemScripting.ISWbemNamedValueSet)
'addinfo "���Ը��ģ�" & objWbemObject.Properties_.item("TargetInstance").Value.Properties_.item("Name").Value
End Sub

  
Private Sub StartMonitorCreateProcessEvent()
Set CreateProcessEvent = New SWbemSink
Set objSWbemServices = GetObject("winmgmts:\\.\root\cimv2")
objSWbemServices.ExecNotificationQueryAsync CreateProcessEvent, "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Process'"
End Sub

Private Sub StartMonitorDeleteProcessEvent()
Set DeleteProcessEvent = New SWbemSink
Set objSWbemServices = GetObject("winmgmts:\\.\root\cimv2")
objSWbemServices.ExecNotificationQueryAsync DeleteProcessEvent, "SELECT * FROM __InstanceDeletionEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Process'"
End Sub

Private Sub StartMonitorModificationProcessEvent()
Set ModificationProcessEvent = New SWbemSink
Set objSWbemServices = GetObject("winmgmts:\\.\root\cimv2")
objSWbemServices.ExecNotificationQueryAsync ModificationProcessEvent, "SELECT * FROM __InstanceModificationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Process'"
End Sub

