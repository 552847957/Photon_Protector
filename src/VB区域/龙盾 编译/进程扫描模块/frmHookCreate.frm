VERSION 5.00
Begin VB.Form frmHookCreate 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   2880
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2175
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2880
   ScaleWidth      =   2175
   StartUpPosition =   3  '����ȱʡ
   Begin VB.CommandButton Command5 
      Caption         =   "����"
      Height          =   375
      Left            =   240
      TabIndex        =   5
      Top             =   2400
      Width           =   1695
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Stop"
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   840
      Width           =   1695
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   600
      Top             =   1920
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Timer"
      Height          =   375
      Left            =   240
      TabIndex        =   3
      Top             =   1560
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   270
      Left            =   240
      TabIndex        =   2
      Text            =   "HookNtCreateProcessEx"
      Top             =   120
      Width           =   1695
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Unload"
      Height          =   375
      Left            =   240
      TabIndex        =   1
      Top             =   1200
      Width           =   1695
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Start"
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   480
      Width           =   1695
   End
End
Attribute VB_Name = "frmHookCreate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Load_Drv As New cls_Driver

Private Declare Sub RtlMoveMemory Lib "kernel32.dll" (ByVal Dst As Long, ByVal Src As Long, ByVal uLen As Long)
Private Declare Sub GetMem4 Lib "msvbvm60.dll" (ByVal Address As Long, ByVal Dst As Long)

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal length As Long)
Private Declare Function ZwOpenProcess _
               Lib "ntdll.dll" (ByRef ProcessHandle As Long, _
                                ByVal AccessMask As Long, _
                                ByRef ObjectAttributes As OBJECT_ATTRIBUTES, _
                                ByRef ClientId As CLIENT_ID) As Long


Const FILE_DEVICE_ROOTKIT As Long = &H2A7B
Const METHOD_BUFFERED     As Long = 0
Const METHOD_IN_DIRECT    As Long = 1
Const METHOD_OUT_DIRECT   As Long = 2
Const METHOD_NEITHER      As Long = 3
Const FILE_ANY_ACCESS     As Long = 0
Const FILE_READ_ACCESS    As Long = &H1     '// file & pipe
Const FILE_WRITE_ACCESS   As Long = &H2     '// file & pipe
Const FILE_READ_DATA      As Long = &H1
Const FILE_WRITE_DATA     As Long = &H2

Const TA_ALLOWCREATE      As Long = &H1
Const TA_UNALLOWCREATE    As Long = &H2
Const TA_LOOPING          As Long = &H1
Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long '�򿪽���
Private Declare Function EnumProcessModules Lib "psapi.dll " (ByVal hProcess As Long, lphModule As Long, ByVal cb As Long, cbNeeded As Long) As Long 'ö�ٽ���ģ��
Private Declare Function GetModuleFileNameExA Lib "psapi.dll " (ByVal hProcess As Long, ByVal hModule As Long, ByVal lpFileName As String, ByVal nSize As Long) As Long '��ȡģ���ļ���
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long '�رվ��

Public Function GetProcPath(pid As Long) As String
'����PID��ȡ����·��
    On Error GoTo over
    Dim tmp As Long, process As Long, Modules(255) As Long, Path As String * 512
    process = OpenProcess(&H400 Or &H10, 0, pid)                                '�򿪽���
    If process = 0 Then GoTo over                                               '�жϽ��̴��Ƿ�ɹ�
    If EnumProcessModules(process, Modules(0), 256, tmp) <> 0 Then GetProcPath = Replace(Left$(Path, GetModuleFileNameExA(process, Modules(0), Path, 256)), "\??\", "") 'ö��ģ��ɹ� 'ȡ��·��'�����ִ�������
over:
    Call CloseHandle(process)                                                   '�رվ��
End Function



Public Sub StartHookFunction()
DoEvents
    If EnablePrivilege(SE_DEBUG) = False Then
       If Not EnablePrivilege1(SE_DEBUG_PRIVILEGE, True) Then
          If MsgBox("�����ʼ��ʧ�ܡ��Ƿ��˳������˳�����������غ����", vbYesNo, "����") = vbYes Then
           Unload frmMain
           Unload Me
          End If
          
       End If
    End If
    '��ʼ������
    With Load_Drv
        .szDrvFilePath = App.Path & "\HookNtCreateProcessEx.sys"
        .szDrvLinkName = "HookNtCreateProcessEx"
        .szDrvSvcName = "HookNtCreateProcessEx"
        .szDrvDisplayName = "HookNtCreateProcessEx"
        .InstDrv
        .StartDrv
        .OpenDrv
        
    End With
    '��������
    Call Load_Drv.IoControl(Load_Drv.CTL_CODE_GEN(&H805), 0, 0, 0, 0)
    frmMain.Status.Caption = "Ring0�������سɹ������������С���"
    Timer1.Enabled = True
    Call ShowTip("����-�߼�ʵʱ����", "�������سɹ���ʵʱ������н��̵Ĵ�������", 4)

End Sub

Public Sub StopHookFunction()
DoEvents
 'ж���������رռ�ʱ��
    With Load_Drv
        .DelDrv
    End With
    Timer1.Enabled = False
    frmMain.Status.Caption = "������ͣ���С���"
    Unload Me
End Sub

Private Sub Command4_Click()

    Call Load_Drv.IoControl(Load_Drv.CTL_CODE_GEN(&H806), 0, 0, 0, 0)
    Timer1.Enabled = False
End Sub

Private Sub Command5_Click()
'MsgBox YesOrNo("I:\WPS.19.996.exe", 1000, "C:\Windows\System32\explorer.exe")
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    With Load_Drv 'ж������
        .DelDrv
    End With
End Sub


Private Sub Timer1_Timer()
On Error Resume Next
    Dim i As Long
    With Load_Drv
    Call .IoControl(.CTL_CODE_GEN(&H801), 0, 0, 0, 0, i)
    
    'MsgBox i
    'Debug.Print i
    If i = TA_LOOPING Then
        
        Dim allow As Long
        Dim ProcessName As String, FProcessPath As String
        Dim ProcessID As Long
        
        ProcessName = String$(260, 0)
        
        Call .IoControl(.CTL_CODE_GEN(&H802), 0, 0, VarPtr(ProcessID), 4)
        Call .IoControl(.CTL_CODE_GEN(&H803), 0, 0, StrPtr(ProcessName), 260)
        
        ProcessName = StrConv(ProcessName, vbUnicode)
        ProcessName = Left(ProcessName, InStr(1, ProcessName, Chr(0)) - 1)
        FProcessPath = GetProcPath(ProcessID)
        Debug.Print ProcessName
        Debug.Print FProcessPath
        Debug.Print ProcessID
         Timer1.Enabled = False
         
        ' If MsgBox("���������Ƿ�����", vbYesNo) = vbYes Then
        If CheckProcess(FProcessPath, ProcessName) = True Then
           allow = TA_ALLOWCREATE
          ' Call ShowTip("����-�߼�ʵʱ����", "���̣�" & ProcessName & vbCrLf & "�ѷ��С���", 4)
         Else
           allow = TA_UNALLOWCREATE
         '  Call ShowTip("����-�߼�ʵʱ����", "���̣�" & ProcessName & vbCrLf & "�����ء���", 4)
         End If

         Call .IoControl(.CTL_CODE_GEN(&H804), VarPtr(allow), 4, 0, 0)
         
         Dim hProcess As Long
         hProcess = OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID)
         NtResumeProcess hProcess '����
         ZwClose hProcess
         
         SuperSleep 1
         
         hProcess = OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID)
         NtResumeProcess hProcess '����
         ZwClose hProcess
         Timer1.Enabled = True
    End If
    End With
    

End Sub
Public Function CheckProcess(ByVal FromProcessPath As String, ByVal ProcessPath As String) As Boolean

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
