VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BD0C1912-66C3-49CC-8B12-7B347BF6C846}#15.3#0"; "Codejock.SkinFramework.v15.3.1.ocx"
Begin VB.Form frmMain 
   Caption         =   "���̹�����"
   ClientHeight    =   7080
   ClientLeft      =   225
   ClientTop       =   855
   ClientWidth     =   8040
   BeginProperty Font 
      Name            =   "����"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   472
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   536
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  '����ȱʡ
   Begin VB.Timer Timer2 
      Left            =   3960
      Top             =   3000
   End
   Begin VB.Timer Timer1 
      Left            =   3960
      Top             =   2520
   End
   Begin VB.PictureBox PicMain 
      Align           =   3  'Align Left
      BorderStyle     =   0  'None
      Height          =   6810
      Left            =   0
      ScaleHeight     =   454
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   497
      TabIndex        =   1
      Top             =   0
      Width           =   7455
      Begin VB.Frame ����_F 
         Caption         =   " �� �� "
         BeginProperty Font 
            Name            =   "����"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1215
         Left            =   1560
         TabIndex        =   3
         Top             =   1200
         Visible         =   0   'False
         Width           =   5055
         Begin VB.CommandButton Mmqx_C 
            Caption         =   "ȡ ��"
            BeginProperty Font 
               Name            =   "����"
               Size            =   12
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Left            =   3960
            TabIndex        =   6
            Top             =   480
            Width           =   855
         End
         Begin VB.TextBox txtPassword 
            BeginProperty Font 
               Name            =   "����"
               Size            =   12
               Charset         =   134
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   360
            IMEMode         =   3  'DISABLE
            Left            =   240
            PasswordChar    =   "*"
            TabIndex        =   5
            Top             =   480
            Width           =   2445
         End
         Begin VB.CommandButton Mmqr_C 
            Caption         =   "ȷ ��"
            BeginProperty Font 
               Name            =   "����"
               Size            =   12
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Left            =   2880
            TabIndex        =   4
            Top             =   480
            Width           =   855
         End
      End
      Begin MSComctlLib.ListView List1 
         Height          =   4335
         Left            =   0
         TabIndex        =   2
         Top             =   0
         Width           =   4935
         _ExtentX        =   8705
         _ExtentY        =   7646
         View            =   3
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         AllowReorder    =   -1  'True
         FullRowSelect   =   -1  'True
         GridLines       =   -1  'True
         _Version        =   393217
         SmallIcons      =   "IM1"
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         Appearance      =   1
         NumItems        =   0
      End
   End
   Begin MSComctlLib.StatusBar SB1 
      Align           =   2  'Align Bottom
      Height          =   270
      Left            =   0
      TabIndex        =   0
      Top             =   6810
      Width           =   8040
      _ExtentX        =   14182
      _ExtentY        =   476
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   3
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   3969
            MinWidth        =   3969
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   7091
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList IM1 
      Left            =   3480
      Top             =   3480
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      MaskColor       =   12632256
      _Version        =   393216
   End
   Begin XtremeSkinFramework.SkinFramework SkinFramework1 
      Left            =   7680
      Top             =   1680
      _Version        =   983043
      _ExtentX        =   635
      _ExtentY        =   635
      _StockProps     =   0
   End
   Begin VB.Menu mnuFile 
      Caption         =   "ϵͳ(&F)"
      Begin VB.Menu mnuRefurbish 
         Caption         =   "����ˢ��(&R)"
         Shortcut        =   {F5}
      End
      Begin VB.Menu mnuLine1 
         Caption         =   "-"
      End
      Begin VB.Menu �޸�����_M 
         Caption         =   "�޸�����"
      End
      Begin VB.Menu nu6 
         Caption         =   "-"
      End
      Begin VB.Menu ��������_M 
         Caption         =   "��������"
      End
      Begin VB.Menu ȡ����������_M 
         Caption         =   "ȡ����������"
      End
      Begin VB.Menu nu7 
         Caption         =   "-"
      End
      Begin VB.Menu ע��_M 
         Caption         =   "ע��"
      End
      Begin VB.Menu �ػ�_M 
         Caption         =   "�ػ�"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "�˳�(&X)"
      End
   End
   Begin VB.Menu mnuProcess 
      Caption         =   "����(&P)"
      Begin VB.Menu mnuEndPro 
         Caption         =   "��������(&E)"
      End
      Begin VB.Menu mnuDelPro 
         Caption         =   "ɾ�������ļ�(&D)"
      End
      Begin VB.Menu mnuLine2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileProperties 
         Caption         =   "�ļ�����(&R)..."
      End
      Begin VB.Menu mnuFolder 
         Caption         =   "����Ŀ¼(&F)..."
      End
      Begin VB.Menu mnuLine22 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSetProClass 
         Caption         =   "�������ȼ�(&P)"
         Begin VB.Menu mnuSetProClassSub 
            Caption         =   "ʵʱ(&R)"
            Enabled         =   0   'False
            Index           =   0
         End
         Begin VB.Menu mnuSetProClassSub 
            Caption         =   "��(&H)"
            Index           =   1
         End
         Begin VB.Menu mnuSetProClassSub 
            Caption         =   "���ڱ�׼(&A)"
            Index           =   2
         End
         Begin VB.Menu mnuSetProClassSub 
            Caption         =   "��׼(&N)"
            Index           =   3
         End
         Begin VB.Menu mnuSetProClassSub 
            Caption         =   "���ڱ�׼(&B)"
            Index           =   4
         End
         Begin VB.Menu mnuSetProClassSub 
            Caption         =   "��(&L)"
            Index           =   5
         End
      End
   End
   Begin VB.Menu mnuWindow 
      Caption         =   "����(&W)"
      Begin VB.Menu mnuOnTop 
         Caption         =   "��������(&A)"
         Shortcut        =   ^A
      End
      Begin VB.Menu ����_M 
         Caption         =   "����"
      End
   End
   Begin VB.Menu XTSD_S 
      Caption         =   "ϵͳ����(&S)"
      Begin VB.Menu ȫ������_M 
         Caption         =   "ȫ������"
      End
      Begin VB.Menu ȫ������_M 
         Caption         =   "ȫ������"
      End
      Begin VB.Menu nu5 
         Caption         =   "-"
      End
      Begin VB.Menu XTSD_S_SD 
         Caption         =   "�������г���"
         Shortcut        =   {F8}
      End
      Begin VB.Menu XTSD_S_JS 
         Caption         =   "�������г���"
         Shortcut        =   {F9}
      End
      Begin VB.Menu mu1 
         Caption         =   "-"
      End
      Begin VB.Menu �ر�������_M 
         Caption         =   "�ر�������"
      End
      Begin VB.Menu ��������_M 
         Caption         =   "��������"
      End
      Begin VB.Menu nu2 
         Caption         =   "-"
      End
      Begin VB.Menu �رտ�ʼ�˵�_M 
         Caption         =   "�رտ�ʼ�˵�"
      End
      Begin VB.Menu �򿪿�ʼ�˵�_M 
         Caption         =   "�򿪿�ʼ�˵�"
      End
      Begin VB.Menu nu3 
         Caption         =   "-"
      End
      Begin VB.Menu �������������_M 
         Caption         =   "�������������1"
      End
      Begin VB.Menu �������������_M2 
         Caption         =   "�������������2"
      End
      Begin VB.Menu �������������_M3 
         Caption         =   "�������������3"
      End
      Begin VB.Menu ȡ������_M 
         Caption         =   "ȡ������"
      End
      Begin VB.Menu nu4 
         Caption         =   "-"
      End
      Begin VB.Menu ��������ͼ��_M 
         Caption         =   "��������ͼ��"
      End
      Begin VB.Menu ȡ����������ͼ��_M 
         Caption         =   "ȡ����������ͼ��"
      End
      Begin VB.Menu nu11 
         Caption         =   "-"
      End
      Begin VB.Menu �ر�explorer_M 
         Caption         =   "�ر�explorer1"
      End
      Begin VB.Menu �ر�explorer_M2 
         Caption         =   "�ر�explorer2"
      End
      Begin VB.Menu �ָ�explorer_M 
         Caption         =   "�ָ�explorer"
      End
      Begin VB.Menu ��explorer_M 
         Caption         =   "��explorer"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "����(&H)"
      Begin VB.Menu mnuAbout 
         Caption         =   "���ڱ����(&A)"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'����ʹ��FindWindow��ShowWindow������������?�������һ�����ӳ���?���Ƚ���һ�������������ť?�ڴ������������������¶���:
'{����������
Public DrvController As New clsProcess
    Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As Any) As Long
    Private Declare Function ShowWindow Lib "user32" (ByVal hWnd As Long, ByVal nCmdShow As Long) As Long
    Const SW_HIDE = 0
    Const SW_SHOWNORMAL = 1
'����������}
'{���ƿ�ʼ�˵�
  Private Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, ByVal lpsz2 As String) As Long
  'Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
  'Private Declare Function ShowWindow Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
  Private Declare Function IsWindowVisible Lib "user32" (ByVal hWnd As Long) As Long
  Private Const SW_RESTORE = 9
  Private Const SW_SHOW = 5
  Private Const SW_SHOWMAXIMIZED = 3
  'Private Const SW_HIDE = 0
  
  Private hhkLowLevelKybd As Long
''''''  �ƿ�ʼ�˵�״̬
''''''  Dim hwnd     As Long
''''''  Dim ss     As Boolean
''''''  hwnd = FindWindow("Shell_TrayWnd", vbNullString)
''''''  hlong = FindWindowEx(hwnd, 0, "Button", vbNullString)
''''''  ss = IsWindowVisible(hlong)
''''''  If ss = True Then
''''''  MsgBox "visible"
''''''  Else
''''''  MsgBox "hide"
''''''  End If
  
'�����ƿ�ʼ�˵�
'{ �ػ�
Private Const EWX_LogOff As Long = 0
Private Const EWX_SHUTDOWN As Long = 1
Private Const EWX_REBOOT As Long = 2
Private Const EWX_FORCE As Long = 4
Private Const EWX_POWEROFF As Long = 8

'The ExitWindowsEx function either logs off, shuts down, or shuts
'down and restarts the system.
Private Declare Function ExitWindowsEx Lib "user32" (ByVal dwOptions As Long, ByVal dwReserved As Long) As Long

'The GetLastError function returns the calling thread's last-error
'code value. The last-error code is maintained on a per-thread basis.
'Multiple threads do not overwrite each other's last-error code.
Private Declare Function GetLastError Lib "kernel32" () As Long

Private Type LUID
UsedPart As Long
IgnoredForNowHigh32BitPart As Long
End Type

Private Type LUID_AND_ATTRIBUTES
TheLuid As LUID
Attributes As Long
End Type

Private Type TOKEN_PRIVILEGES
PrivilegeCount As Long
TheLuid As LUID
Attributes As Long
End Type

'The GetCurrentProcess function returns a pseudohandle for the
'current process.
Private Declare Function GetCurrentProcess Lib "kernel32" () As Long

'The OpenProcessToken function opens the access token associated with
'a process.
Private Declare Function OpenProcessToken Lib "advapi32" (ByVal ProcessHandle As Long, ByVal DesiredAccess As Long, TokenHandle As Long) As Long

'The LookupPrivilegeValue function retrieves the locally unique
'identifier (LUID) used on a specified system to locally represent
'the specified privilege name.
Private Declare Function LookupPrivilegeValue Lib "advapi32" Alias "LookupPrivilegeValueA" (ByVal lpSystemName As String, ByVal lpName As String, lpLuid As LUID) As Long

'The AdjustTokenPrivileges function enables or disables privileges
'in the specified access token. Enabling or disabling privileges
'in an access token requires TOKEN_ADJUST_PRIVILEGES access.
Private Declare Function AdjustTokenPrivileges Lib "advapi32" (ByVal TokenHandle As Long, ByVal DisableAllPrivileges As Long, NewState As TOKEN_PRIVILEGES, ByVal BufferLength As Long, PreviousState As TOKEN_PRIVILEGES, ReturnLength As Long) As Long

Private Declare Sub SetLastError Lib "kernel32" (ByVal dwErrCode As Long)

Private Const mlngWindows95 = 0
Private Const mlngWindowsNT = 1

Public glngWhichWindows32 As Long

'The GetVersion function returns the operating system in use.
Private Declare Function GetVersion Lib "kernel32" () As Long
'} �ػ�

''''''{�ȼ�
'''''Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
'''''Const WM_SETHOTKEY = &H32
'''''Const HOTKEYF_SHIFT = &H1
'''''Const HOTKEYF_CONTROL = &H2
'''''Const HOTKEYF_ALT = &H4
''''''}�ȼ�

'{���ô������ϽǵĹرհ�ť
  Private Declare Function GetSystemMenu Lib "user32" (ByVal hWnd As Long, ByVal bRevert As Long) As Long
  Private Declare Function RemoveMenu Lib "user32" (ByVal hMenu As Long, ByVal nPosition As Long, ByVal wFlags As Long) As Long
'RemoveMenu GetSystemMenu(Me.hwnd, 0), &HF060, 0

'}���ô������ϽǵĹرհ�ť



'{��VB�����о���ҪʹCtrl-Alt-Delete��Ctrl-Esc ��Ч��

Private Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, ByVal lpvParam As Any, ByVal fuWinIni As Long) As Long
'}��VB�����о���ҪʹCtrl-Alt-Delete��Ctrl-Esc ��Ч��

Dim ProCount As Long    '��ǰ������
Dim RamUse As Long  '��ǰ�����ڴ�
Dim IniFile1 As String  'ϵͳ���̽����ļ�
Dim SMJC_ss As Boolean 'ɨ�����
Dim MyNot As NOTIFYICONDATA '����һ�����̽ṹ
Dim Quit_C As Boolean  '�˳�״̬


'{��VB�����о���ҪʹCtrl-Alt-Delete��Ctrl-Esc ��Ч��

Sub DisableCtrlAltDelete(bDisabled As Boolean)

Dim x As Long

x = SystemParametersInfo(97, bDisabled, CStr(1), 0)

End Sub


Private Sub LoadDrv()
 With DrvController
        .szDrvFilePath = Replace(App.Path & "\TailList.sys", "\\", "\")
        .szDrvLinkName = "TailList"
        .szDrvDisplayName = "TailList"
        .szDrvSvcName = "TailList"
 End With
End Sub
Private Sub OpenDrv()
 With DrvController
        .InstDrv
        .StartDrv
        .OpenDrv
 End With
End Sub


Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
Dim IntR As Integer
    'IntR = MsgBox("ȷ��Ҫ�˳�������", vbYesNo, "�˳�ȷ��")
    'If IntR = vbNo Then
    '    If Quit_C = True Then Quit_C = False
    '    Cancel = -1
    '    Else
 ''       frmMain.Visible = False
    'End If
 ''    If Quit_C = False Then Cancel = -1
End Sub

Private Sub Form_Unload(Cancel As Integer)
'{���ƿ�ʼ�˵�
If hhkLowLevelKybd <> 0 Then UnhookWindowsHookEx hhkLowLevelKybd
'�����ƿ�ʼ�˵�

'{�ȼ�
Dim ret As Long
'ȡ��Message�Ľ�ȡ��ʹ֮����ԭ����windows����
ret = SetWindowLong(Me.hWnd, GWL_WNDPROC, preWinProc)
Call UnregisterHotKey(Me.hWnd, uVirtKey)
'}
 With DrvController
        .StopDrv
        .DelDrv
 End With

If trayflag = True Then

With MyNot

     .hIcon = frmMain.Icon '����ͼ��ָ��

     .hWnd = frmMain.hWnd '����ָ��

     .szTip = "" '������ʾ�ַ���

     .uCallbackMessage = WM_USER + 100 '��Ӧ���������Ϣ

     .uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE '��־

     .uID = 1 'ͼ��ʶ���

     .cbSize = Len(MyNot) '����ýṹ��ռ�ֽ���

     End With

    hh = Shell_NotifyIcon(NIM_DELETE, MyNot) 'ɾ����ͼ��

    trayflag = False 'ͼ��ɾ����trayflagΪ��


End If

     Unhook '�˳���Ϣѭ��


End Sub
'{ �ػ�
Private Sub AdjustToken()
'********************************************************************
'* This procedure sets the proper privileges to allow a log off or a
'* shut down to occur under Windows NT.
'********************************************************************

Const TOKEN_ADJUST_PRIVILEGES = &H20
Const TOKEN_QUERY = &H8
Const SE_PRIVILEGE_ENABLED = &H2

Dim hdlProcessHandle As Long
Dim hdlTokenHandle As Long
Dim tmpLuid As LUID
Dim tkp As TOKEN_PRIVILEGES
Dim tkpNewButIgnored As TOKEN_PRIVILEGES
Dim lBufferNeeded As Long

'Set the error code of the last thread to zero using the
'SetLast Error function. Do this so that the GetLastError
'function does not return a value other than zero for no
'apparent reason.
SetLastError 0

'Use the GetCurrentProcess function to set the hdlProcessHandle
'variable.
hdlProcessHandle = GetCurrentProcess()
OpenProcessToken hdlProcessHandle, _
(TOKEN_ADJUST_PRIVILEGES Or TOKEN_QUERY), _
hdlTokenHandle

'Get the LUID for shutdown privilege
LookupPrivilegeValue "", "SeShutdownPrivilege", tmpLuid

tkp.PrivilegeCount = 1 ' One privilege to set
tkp.TheLuid = tmpLuid
tkp.Attributes = SE_PRIVILEGE_ENABLED

'Enable the shutdown privilege in the access token of this process
AdjustTokenPrivileges hdlTokenHandle, _
False, _
tkp, _
Len(tkpNewButIgnored), _
tkpNewButIgnored, _
lBufferNeeded
End Sub
'} �ػ�
'�оٽ���
Public Sub ListProcess()
On Error Resume Next
    Dim I As Long, j As Long, n As Long
    Dim Jssl As Integer
    Dim proc As PROCESSENTRY32
    Dim snap As Long
    Dim exename As String
    Dim item As ListItem
    Dim lngHwndProcess As Long
    Dim lngModules(1 To 200) As Long
    Dim lngCBSize2 As Long
    Dim lngReturn As Long
    Dim strModuleName As String
    Dim pmc As PROCESS_MEMORY_COUNTERS
    Dim WKSize As Long
    Dim strProcessName As String
    Dim strComment As String   'װ�ؽ���ע�͵��ַ���
    Dim ProClass As String
    Dim SMJC_S As Boolean  'ɨ�����
    '��ʼ����ѭ��
    snap = CreateToolhelpSnapshot(TH32CS_SNAPall, 0)
    proc.dwSize = Len(proc)
    theloop = ProcessFirst(snap, proc)
    I = 0
    n = 0
    While theloop <> 0
        I = I + 1
        'exename = proc.szExeFile
        lngHwndProcess = OpenProcess(PROCESS_QUERY_INFORMATION Or PROCESS_VM_READ, 0, proc.th32ProcessID)
        If lngHwndProcess <> 0 Then
            lngReturn = EnumProcessModules(lngHwndProcess, lngModules(1), 200, lngCBSize2)
            If lngReturn <> 0 Then
                strModuleName = Space(MAX_PATH)
                lngReturn = GetModuleFileNameExA(lngHwndProcess, lngModules(1), strModuleName, 500)
                strProcessName = Left(strModuleName, lngReturn)
                strProcessName = CheckPath(Trim$(strProcessName))
                If strProcessName <> "" Then
                    j = HaveItem(proc.th32ProcessID)
                    If j = 0 Then  '���û�иý���
                        '��ȡ���ļ���
                        exename = Dir(strProcessName, vbNormal Or vbHidden Or vbReadOnly Or vbSystem)
                        SMJC_S = True
                        
                        If SMJC_ss = True Then  'ɨ����� �˵���
                                For Jssl = 1 To GetINI("�����ļ�", "����", IniFile1)
                                    If exename = GetINI("�����ļ�", Str(Jssl), IniFile1) Then SMJC_S = False
                                Next
                            Else
                            
                            SMJC_S = False
                        End If
                        
                        If SMJC_S = True Then
                                                        Dim hand As Long, id As Long
                                'If MsgBox("ȷ��Ҫ�������� " & List1.SelectedItem.Text & " ��", vbExclamation + vbOKCancel) = vbCancel Then Exit Sub
                                id = CLng(proc.th32ProcessID)
                                If id <> 0 Then
                                    EndPro id
                                End If
                            Else
                            
                            
                            
                            
                            
                            exename = Dir(strProcessName, vbNormal Or vbHidden Or vbReadOnly Or vbSystem)
                            If exename = "hh.exe" Then
                                'MsgBox SetProClass(proc.th32ProcessID, IDLE_PRIORITY_CLASS)
                            End If
                            
                            '��ӽ���item
                            Set item = List1.ListItems.Add(, "ID:" & CStr(proc.th32ProcessID), exename)
                            '����ID
                            item.SubItems(1) = proc.th32ProcessID
                            '�ڴ�ʹ��
                            pmc.cb = LenB(pmc)
                            lret = GetProcessMemoryInfo(lngHwndProcess, pmc, pmc.cb)
                            n = n + pmc.WorkingSetSize
                            WKSize = pmc.WorkingSetSize / 1024
                            item.SubItems(2) = WKSize
                            '���ȼ�
                            item.SubItems(5) = GetProClass(proc.th32ProcessID)
                            '����·��
                            item.SubItems(6) = strProcessName
                            '����ͼ��
                            IM1.ListImages.Add , strProcessName, GetIcon(strProcessName)
                            item.SmallIcon = IM1.ListImages.item(strProcessName).Key
                            '�����ж��Ƿ�Ϊϵͳ����
                            strComment = ""
                            If UCase(Left$(strProcessName, Len(GetSysDir))) = UCase(GetSysDir) Then
                                strComment = GetINI("sysdir", Mid$(strProcessName, Len(GetSysDir) + 2), IniFile1)
                            ElseIf UCase(Left$(strProcessName, Len(GetWinDir))) = UCase(GetWinDir) Then
                                strComment = GetINI("windir", Mid$(strProcessName, Len(GetWinDir) + 2), IniFile1)
                            End If
                            If strComment <> "" Then
                                item.SubItems(3) = "ϵͳ"
                                item.SubItems(4) = Left$(strComment, 2)
                                item.SubItems(7) = Mid$(strComment, 4)
                            End If
                        End If
                    Else    '����Ѿ��иý���
                        pmc.cb = LenB(pmc)
                        lret = GetProcessMemoryInfo(lngHwndProcess, pmc, pmc.cb)
                        n = n + pmc.WorkingSetSize
                        WKSize = pmc.WorkingSetSize / 1024
                        If CLng(List1.ListItems.item(j).SubItems(2)) <> WKSize Then List1.ListItems.item(j).SubItems(2) = WKSize
                        ProClass = GetProClass(proc.th32ProcessID)
                        If ProClass <> List1.ListItems.item(j).SubItems(5) Then List1.ListItems.item(j).SubItems(5) = ProClass
                    End If
                End If
            End If
        End If
        theloop = ProcessNext(snap, proc)
    Wend
    CloseHandle snap
    If I <> ProCount Then
        SB1.Panels.item(1) = "��������" & I
        ProCount = I
    End If
    If n <> RamUse Then
        SB1.Panels.item(2) = "�����ڴ棺" & FormatLng(n)
        RamUse = n
    End If
End Sub
Public Sub ListProcess_s()
On Error Resume Next
    Dim I As Long, j As Long, n As Long
    Dim proc As PROCESSENTRY32
    Dim snap As Long
    Dim exename As String
    Dim item As ListItem
    Dim lngHwndProcess As Long
    Dim lngModules(1 To 200) As Long
    Dim lngCBSize2 As Long
    Dim lngReturn As Long
    Dim strModuleName As String
    Dim pmc As PROCESS_MEMORY_COUNTERS
    Dim WKSize As Long
    Dim strProcessName As String
    Dim strComment As String   'װ�ؽ���ע�͵��ַ���
    Dim ProClass As String
    
    '��ʼ����ѭ��
    snap = CreateToolhelpSnapshot(TH32CS_SNAPall, 0)
    proc.dwSize = Len(proc)
    theloop = ProcessFirst(snap, proc)
    I = 0
    n = 0
    While theloop <> 0
        I = I + 1
        'exename = proc.szExeFile
        lngHwndProcess = OpenProcess(PROCESS_QUERY_INFORMATION Or PROCESS_VM_READ, 0, proc.th32ProcessID)
        If lngHwndProcess <> 0 Then
            lngReturn = EnumProcessModules(lngHwndProcess, lngModules(1), 200, lngCBSize2)
            If lngReturn <> 0 Then
                strModuleName = Space(MAX_PATH)
                lngReturn = GetModuleFileNameExA(lngHwndProcess, lngModules(1), strModuleName, 500)
                strProcessName = Left(strModuleName, lngReturn)
                strProcessName = CheckPath(Trim$(strProcessName))
                If strProcessName <> "" Then
                    j = HaveItem(proc.th32ProcessID)
                    If j = 0 Then  '���û�иý���
                        '��ȡ���ļ���
                            Dim hand As Long, id As Long
                                'If MsgBox("ȷ��Ҫ�������� " & List1.SelectedItem.Text & " ��", vbExclamation + vbOKCancel) = vbCancel Then Exit Sub
                                id = CLng(proc.th32ProcessID)
                                If id <> 0 Then
                                    EndPro id
                                End If
                        
                    Else    '����Ѿ��иý���
                        pmc.cb = LenB(pmc)
                        lret = GetProcessMemoryInfo(lngHwndProcess, pmc, pmc.cb)
                        n = n + pmc.WorkingSetSize
                        WKSize = pmc.WorkingSetSize / 1024
                        If CLng(List1.ListItems.item(j).SubItems(2)) <> WKSize Then List1.ListItems.item(j).SubItems(2) = WKSize
                        ProClass = GetProClass(proc.th32ProcessID)
                        If ProClass <> List1.ListItems.item(j).SubItems(5) Then List1.ListItems.item(j).SubItems(5) = ProClass
                    End If
                End If
            End If
        End If
        theloop = ProcessNext(snap, proc)
    Wend
    CloseHandle snap
    If I <> ProCount Then
        SB1.Panels.item(1) = "��������" & I
        ProCount = I
    End If
    If n <> RamUse Then
        SB1.Panels.item(2) = "�����ڴ棺" & FormatLng(n)
        RamUse = n
    End If
End Sub
'���ý������ȼ�
Public Function SetProClass(ByVal PID As Long, ByVal ClassID As Long)
On Error Resume Next
    Dim hwd As Long
    hwd = OpenProcess(PROCESS_SET_INFORMATION, 0, PID)
    SetProClass = SetPriorityClass(hwd, ClassID)
End Function

'��ȡ�������ȼ�
Public Function GetProClass(ByVal PID As Long) As String
On Error Resume Next
    Dim hwd As Long
    Dim Rtn As Long
    hwd = OpenProcess(PROCESS_QUERY_INFORMATION, 0, PID)
    Rtn = GetPriorityClass(hwd)
    Select Case Rtn
    Case IDLE_PRIORITY_CLASS
        GetProClass = "��"
    Case NORMAL_PRIORITY_CLASS
        GetProClass = "��׼"
    Case HIGH_PRIORITY_CLASS
        GetProClass = "��"
    Case REALTIME_PRIORITY_CLASS
        GetProClass = "ʵʱ"
    Case 16384
        GetProClass = "�ϵ�"
    Case 32768
        GetProClass = "�ϸ�"
    End Select
End Function


'�������Ƿ���ڶ�����Ѿ������Ľ���
Public Sub CheckProcess()
On Error Resume Next
    Dim lExit As Long
    Dim lngHwndProcess As Long
    Dim I As Long, j As Long
    If List1.ListItems.Count > 0 Then
        For I = List1.ListItems.Count To 1 Step -1
            j = CLng(List1.ListItems.item(I).SubItems(1))
            lngHwndProcess = OpenProcess(PROCESS_QUERY_INFORMATION Or PROCESS_VM_READ, 0, j)
            If lngHwndProcess <> 0 Then
                GetExitCodeProcess lngHwndProcess, lExit
                If lExit <> STILL_ACTIVE Then List1.ListItems.Remove I
            Else
                List1.ListItems.Remove I
            End If
        Next
    End If
End Sub

'�ж�item�Ƿ����
Public Function HaveItem(ByVal itemID As Long) As Long
On Error GoTo aaaa
    HaveItem = List1.ListItems("ID:" & CStr(itemID)).Index
Exit Function
aaaa:
    HaveItem = 0
End Function

Public Function CheckPath(ByVal PathStr As String) As String
On Error Resume Next
    PathStr = Replace(PathStr, "\??\", "")
    If UCase(Left$(PathStr, 12)) = "\SYSTEMROOT\" Then PathStr = GetWinDir & Mid$(PathStr, 12)
    CheckPath = PathStr
End Function



Private Sub Form_Load()
On Error Resume Next
App.Title = "���̹�����"
'-------------Ƥ���ؼ�����----------------
Dim FileName As String
Dim IniFile As String
FileName = App.Path & "\Skin\Office2007.cjstyles"
IniFile = "NormalBlue.ini"
SkinFramework1.LoadSkin FileName, IniFile
SkinFramework1.ApplyWindow Me.hWnd
SkinFramework1.ApplyOptions = SkinFramework1.ApplyOptions Or xtpSkinApplyMetrics


    If Quit_C = False Then
        If App.PrevInstance Then
            MsgBox "�ó����Ѿ����У�"
            End
        End If
    End If

        '����Ӧ��
    App.TaskVisible = False
    'form1.showintaskbar=false
    '����ϵͳ����
        '******
                'If AddToStarup("abc", App.Path & "\���̹�����.exe") = True Then
                '      Debug.Print "OK"
                'Else
                '      Debug.Print "NO"
                'End If
        '******
        EnablePrivilege (SE_DEBUG)
 LoadDrv
  OpenDrv
 If DrvController.OpenDrv = False Then
 Call MsgBox("��������ʧ�ܣ����������Ĳ���ϵͳ�汾��֧�ִ�������ɱ����������أ�", vbOKOnly, "��������ʧ��")
 SB1.Panels.item(3) = "��������ʧ��"
 Else
 SB1.Panels.item(3) = "������������-���̹����� �����Ѽ���"
 End If
 If WinVer >= 6 Then Label3.ForeColor = &HFF0000: Label3.Caption = "��֧��": Command3.Enabled = False: MsgBox "����ϵͳ�汾��֧�ֱ�������ʮ�ֱ�Ǹ��"
    Move (Screen.Width - Me.Width) / 2, (Screen.Height - Me.Height) / 2
    '��ʼ��List1
    List1.ColumnHeaders.Add , , "��������", 120
    List1.ColumnHeaders.Add , , "PID", 45
    List1.ColumnHeaders.Add , , "�ڴ�(K)", 55
    List1.ColumnHeaders.Add , , "����", 36
    List1.ColumnHeaders.Add , , "����", 36
    List1.ColumnHeaders.Add , , "����", 36
    List1.ColumnHeaders.Add , , "����·��", 400
    List1.ColumnHeaders.Add , , "��ע", 500
    List1.ColumnHeaders.item(3).Alignment = lvwColumnRight
    IniFile1 = GetApp & "sysset.ini"
'    '���ؽ����б�
    ListProcess
    
    
    SMJC_ss = False 'ɨ�����
    
   ' {�ȼ�
    Dim ret As Long

'��¼ԭ����window�����ַ
preWinProc = GetWindowLong(Me.hWnd, GWL_WNDPROC)
'���Զ���������ԭ����window����
ret = SetWindowLong(Me.hWnd, GWL_WNDPROC, AddressOf Wndproc)

idHotKey = 1
Modifiers = MOD_ALT + MOD_CONTROL 'Alt+Ctrl ��
uVirtKey = vbKeyJ  'J��
ret = RegisterHotKey(Me.hWnd, idHotKey, Modifiers, uVirtKey)
'}�ȼ�
''''''' {�ȼ�
''''''    Dim wHotkey As Long
''''''    '�����ȼ�ΪCtrl+Alt+A
''''''    wHotkey = (HOTKEYF_ALT Or HOTKEYF_CONTROL) * 256 + vbKeyJ
''''''    l = SendMessage(Me.hwnd, WM_SETHOTKEY, wHotkey, 0)
''''''
''''''
''''''' }�ȼ�


  '{ ����
  gHW = Me.hWnd 'ȡ�ñ�����ָ��
     ''success = SetWindowPos(frmMain.hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE)  'ʹ��������ʾ����ǰ��
    '��һ����ù��Ӻ�������������Ϣ����������Windows����Ϣѭ��
Digital1.Digital = Format(time(), "hh:mm:ss")

     hook
     
     Dim hh As Long

     With MyNot

     .hIcon = frmMain.Icon

     .hWnd = frmMain.hWnd

     .szTip = Str(Date) & Chr(&H0)

     .uCallbackMessage = WM_USER + 100

     .uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE

     .uID = 1

     .cbSize = Len(MyNot)

     End With

    hh = Shell_NotifyIcon(NIM_ADD, MyNot) '���һ������ͼ��

    trayflag = True 'ͼ����Ӻ�trayflagΪ��
  '}
  
    '���ô������ϽǵĹرհ�ť
RemoveMenu GetSystemMenu(Me.hWnd, 0), &HF060, 0
 Quit_C = False

    If Command = 1 Then
        ȫ������_M_Click
        frmMain.Visible = False
        'frmMain.WindowState = 1
    End If
    
    
    
    'frmMain.WindowState = 1
    Timer1.Interval = 200
    Timer2.Interval = 500
    
End Sub
Public Sub hook()

    '����AddressOfȡ����Ϣ������WindowProc��ָ�룬�����䴫��SetWindowLong

    'lpPrevWndProc�����洢ԭ���ڵ�ָ��

     lpPrevWndProc = SetWindowLong(gHW, GWL_WNDPROC, AddressOf WindowProc)

    End Sub

    Public Sub Unhook()

    '���ӳ�����ԭ���ڵ�ָ���滻WindowProc������ָ�룬���ر����ࡢ�˳���Ϣѭ��

     Dim temp As Long

     temp = SetWindowLong(gHW, GWL_WNDPROC, lpPrevWndProc)

    End Sub
Private Sub Form_Resize()
On Error Resume Next
    PicMain.Width = Me.Width / 15
    List1.Move 0, 0, PicMain.Width - 8, PicMain.Height
        
        If WindowState = 1 Then
            frmMain.Visible = False
            WindowState = 0
        End If
    
End Sub

Private Sub List1_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
On Error Resume Next
    With List1
        If (ColumnHeader.Index - 1) = .SortKey Then
            .SortOrder = (.SortOrder + 1) Mod 2
            .Sorted = True
        Else
            .Sorted = False
            .SortOrder = 0
            .SortKey = ColumnHeader.Index - 1
            .Sorted = True
        End If
    End With
End Sub

Private Sub List1_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
On Error Resume Next
    Dim j As Long, I As Long
    If Button = 2 Then
        If List1.HitTest(x, y) Is Nothing Then Exit Sub
        j = List1.HitTest(x, y).Index
        List1.ListItems(j).Selected = True
        For I = 0 To 5
            mnuSetProClassSub(I).Checked = False
        Next
        Select Case List1.SelectedItem.SubItems(5)
        Case "ʵʱ": mnuSetProClassSub(0).Checked = True
        Case "��": mnuSetProClassSub(1).Checked = True
        Case "�ϸ�": mnuSetProClassSub(2).Checked = True
        Case "��׼": mnuSetProClassSub(3).Checked = True
        Case "�ϵ�": mnuSetProClassSub(4).Checked = True
        Case "��": mnuSetProClassSub(5).Checked = True
        End Select
        If mnuProcess.Enabled = True Then PopupMenu mnuProcess
    End If
End Sub



Private Sub Mmqx_C_Click()
����_F.Visible = False
End Sub

Private Sub mnuAbout_Click()
On Error Resume Next

    ShellAbout Me.hWnd, "���̹�����", "������������", ByVal 0&
    'App.Title &
End Sub

Private Sub mnuDelPro_Click()
On Error Resume Next
    Dim I As Long, hand As Long, id As Long
    If MsgBox("ȷ��Ҫ�������̲�ɾ�������ļ���" & vbCrLf & vbCrLf & List1.SelectedItem.SubItems(6), vbExclamation + vbOKCancel) = vbCancel Then Exit Sub
    id = CLng(List1.SelectedItem.SubItems(1))
    If id <> 0 Then
        EndPro id
        DoEvents
        DoEvents
        SuperSleep 1
        'FileDel CStr(List1.SelectedItem.SubItems(6))
        '����kill�ķ���
        Call SetAttr(CStr(List1.SelectedItem.SubItems(6)), vbNormal)
        '����������޸����ԣ���Ȼ��ɾ����ϵͳ���Ե��ļ�
        Kill CStr(List1.SelectedItem.SubItems(6))
        SuperSleep 0.5
        If Not Dir(CStr(List1.SelectedItem.SubItems(6)), vbNormal Or vbSystem Or vbHidden Or vbReadOnly) = "" Then
          'ɾ��ʧ��
          MsgBox "ɾ���ļ�" & CStr(List1.SelectedItem.SubItems(6)) & "ʧ�ܣ�", vbOKOnly, "ɾ��ʧ��"
        End If
    End If
    ListProcess
End Sub

Private Sub mnuEndPro_Click()
On Error Resume Next
    Dim I As Long, hand As Long, id As Long
    If MsgBox("ȷ��Ҫ�������� " & List1.SelectedItem.Text & " ��", vbExclamation + vbOKCancel) = vbCancel Then Exit Sub
    id = CLng(List1.SelectedItem.SubItems(1))
    If id <> 0 Then
        EndPro id
        With DrvController
        Call .IoControl(.CTL_CODE_GEN(&H801), VarPtr(id), 4, 0, 0)
  End With
    End If
    ListProcess
End Sub

'����һ������
Public Sub EndPro(ByVal PID As Long)
On Error Resume Next
    Dim lngHwndProcess As Long
    Dim hand As Long
    Dim exitCode As Long
    hand = OpenProcess(PROCESS_TERMINATE, True, PID)
    TerminateProcess hand, exitCode
    CloseHandle hand
End Sub

Private Sub mnuExit_Click()

    Quit_C = True
    Unload Me
    End
End Sub

Private Sub mnuFileProperties_Click()
    ShowProperties List1.SelectedItem.SubItems(6), Me.hWnd
End Sub

Private Sub mnuFolder_Click()
    ShellExecute hWnd, "open", GetAppF(List1.SelectedItem.SubItems(6)), "", "", 1
End Sub

Private Sub mnuHome_Click()
    ShellExecute hWnd, "open", "http://www.dvmsc.com", "", "", 1
End Sub

Private Sub mnuOnTop_Click()
    mnuOnTop.Checked = Not mnuOnTop.Checked
    SetTop Me, mnuOnTop.Checked
End Sub

Private Sub mnuRefurbish_Click()
    ListProcess
End Sub

Private Sub mnuSetProClassSub_Click(Index As Integer)
On Error Resume Next
    Dim PID As Long, Rtn As Long
    PID = CLng(List1.SelectedItem.SubItems(1))
    If mnuSetProClassSub(Index).Checked = True Then Exit Sub
    Select Case Index
    Case 0: Rtn = SetProClass(PID, REALTIME_PRIORITY_CLASS)
    Case 1: Rtn = SetProClass(PID, HIGH_PRIORITY_CLASS)
    Case 2: Rtn = SetProClass(PID, 32768)
    Case 3: Rtn = SetProClass(PID, NORMAL_PRIORITY_CLASS)
    Case 4: Rtn = SetProClass(PID, 16384)
    Case 5: Rtn = SetProClass(PID, IDLE_PRIORITY_CLASS)
    End Select
    If Rtn = 0 Then MsgBox "�޷�Ϊ���� " & List1.SelectedItem.Text & " �������ȼ���", vbCritical
End Sub

Private Sub Timer1_Timer()
    ListProcess
End Sub

Private Sub Timer2_Timer()
    CheckProcess
End Sub



Private Sub XTSD_S_JS_Click()
'Timer3.Interval = 0
'Timer1.Interval = 200
SMJC_ss = False 'ɨ�����

End Sub

Private Sub XTSD_S_SD_Click()
'Timer1.Interval = 0
'Timer3.Interval = 200
SMJC_ss = True 'ɨ�����
End Sub

Private Sub ��explorer_M_Click()

        Call Shell("explorer", 0)
        'Shell "Notepad", vbNormalFocus
        Shell "explorer", vbNormalFocus

        Shell "regedit", vbNormalFocus

End Sub

Private Sub �򿪿�ʼ�˵�_M_Click()
        Dim hWnd     As Long
        hWnd = FindWindow("Shell_TrayWnd", vbNullString)
        hlong = FindWindowEx(hWnd, 0, "Button", vbNullString)
       '"������ʾ"
        ShowWindow hlong, SW_RESTORE
       '"���"
        'ShowWindow hlong, SW_SHOWMAXIMIZED
        '�I
            UnhookWindowsHookEx hhkLowLevelKybd
            hhkLowLevelKybd = 0

End Sub

Private Sub ��������_M_Click()
     Dim hTaskBar As Long
     
     hTaskBar = FindWindow("Shell_TrayWnd", 0&)
     ShowWindow hTaskBar, SW_SHOWNORMAL
End Sub

Private Sub �ر�explorer_M_Click()

Dim I As Integer
    For I = 1 To 30
        Call Shell("tskill explorer", 0)
        Sleep 100
    Next
End Sub

Private Sub �ر�explorer_M2_Click()
Dim I As Integer
    For I = 1 To 30
        �������������_M33_Click
      Sleep 100
    Next
End Sub

Private Sub �رտ�ʼ�˵�_M_Click()
        Dim hWnd     As Long
        hWnd = FindWindow("Shell_TrayWnd", vbNullString)
        hlong = FindWindowEx(hWnd, 0, "Button", vbNullString)
        ShowWindow hlong, SW_HIDE
        
        '�I
        hhkLowLevelKybd = SetWindowsHookEx(WH_KEYBOARD_LL, AddressOf LowLevelKeyboardProc, App.hInstance, 0)

End Sub

Private Sub �ر�������_M_Click()
     Dim hTaskBar As Long
     
     hTaskBar = FindWindow("Shell_TrayWnd", 0&)
     ShowWindow hTaskBar, SW_HIDE
End Sub

Private Sub �ػ�_M_Click()
Dim lngVersion As Long
    If MsgBox("ȷ��Ҫ�ػ���", vbYesNo, "�ػ�ȷ��") = vbYes Then

        lngVersion = GetVersion()
        If ((lngVersion And &H80000000) = 0) Then
        glngWhichWindows32 = mlngWindowsNT
        Else
        glngWhichWindows32 = mlngWindows95
        End If

            If glngWhichWindows32 = mlngWindowsNT Then
                AdjustToken
            End If
            ExitWindowsEx (EWX_SHUTDOWN Or EWX_FORCE Or EWX_POWEROFF), 0
    End If


End Sub

Private Sub �ָ�explorer_M_Click()

    Call Savestring(HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "Shell", "explorer.exe")

End Sub

Private Sub ��������_M_Click()
    If AddToStarup("abc", App.Path & "\���̹�����.exe 1") = True Then
            MsgBox "�ɹ�"
        Else
            MsgBox "ʧ��"
    End If
End Sub

Private Sub �������������_M_Click()
    Open Environ("windir") & "\system32\taskmgr.exe" For Input Lock Read Write As #1
End Sub

Private Sub �������������_M2_Click()

    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\system", "DisableTaskMgr", 1)
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\system", "DisableLockWorkstationr", 1)
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\system", "DisableChangePassword", 1)
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\system", "DisableLockWorkstation", 1)
    
    'ɾ��ע��
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoLogoff", 1)
    '����
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoRun", 1)
    
    

End Sub

Private Sub �������������_M33_Click()
On Error Resume Next
    Dim I As Long, j As Long, n As Long
    Dim Jssl As Integer
    Dim proc As PROCESSENTRY32
    Dim snap As Long
    Dim exename As String
    Dim item As ListItem
    Dim lngHwndProcess As Long
    Dim lngModules(1 To 200) As Long
    Dim lngCBSize2 As Long
    Dim lngReturn As Long
    Dim strModuleName As String
    Dim pmc As PROCESS_MEMORY_COUNTERS
    Dim WKSize As Long
    Dim strProcessName As String
    Dim strComment As String   'װ�ؽ���ע�͵��ַ���
    Dim ProClass As String
    Dim SMJC_S As Boolean  'ɨ�����
    '��ʼ����ѭ��
    snap = CreateToolhelpSnapshot(TH32CS_SNAPall, 0)
    proc.dwSize = Len(proc)
    theloop = ProcessFirst(snap, proc)
    I = 0
    n = 0
    While theloop <> 0
        I = I + 1
        'exename = proc.szExeFile
        lngHwndProcess = OpenProcess(PROCESS_QUERY_INFORMATION Or PROCESS_VM_READ, 0, proc.th32ProcessID)
        If lngHwndProcess <> 0 Then
            lngReturn = EnumProcessModules(lngHwndProcess, lngModules(1), 200, lngCBSize2)
            If lngReturn <> 0 Then
                strModuleName = Space(MAX_PATH)
                lngReturn = GetModuleFileNameExA(lngHwndProcess, lngModules(1), strModuleName, 500)
                strProcessName = Left(strModuleName, lngReturn)
                strProcessName = CheckPath(Trim$(strProcessName))
                If strProcessName <> "" Then
                        '��ȡ���ļ���
                        exename = Dir(strProcessName, vbNormal Or vbHidden Or vbReadOnly Or vbSystem)
                        If exename = "explorer.exe" Then
                            id = CLng(proc.th32ProcessID)
                            If id <> 0 Then
                                EndPro id
                            End If
                        End If
                    
                End If
            End If
        End If
        theloop = ProcessNext(snap, proc)
    Wend
    CloseHandle snap

End Sub




Private Sub �������������_M3_Click()
    Call DisableCtrlAltDelete(True)
End Sub

Private Sub ȡ����������_M_Click()

    Call DeleteValue(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Run", "abc")

End Sub
Private Sub ȡ������_M_Click()
    Close #1
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\system", "DisableTaskMgr", 0)
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\system", "DisableLockWorkstationr", 0)
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\system", "DisableChangePassword", 0)
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\system", "DisableLockWorkstation", 0)
    
    'ɾ��ע��
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoLogoff", 0)
    
    Call SaveDword(HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoRun", 0)

    Call DisableCtrlAltDelete(False)
    
    
End Sub

Private Sub ȡ����������ͼ��_M_Click()
Dim wnd As Long
            wnd = FindWindow("Progman", vbNullString)
            wnd = FindWindowEx(wnd, 0, "ShellDll_DefView", vbNullString)
ShowWindow wnd, 5
End Sub

Private Sub ȫ������_M_Click()

        txtPassword.Text = ""
        ����_F.Caption = " �� �� "
        frmMain.����_F.Visible = True
        
End Sub


Private Sub ȫ������_M_Click()

        XTSD_S_SD_Click
        �ر�������_M_Click
        �رտ�ʼ�˵�_M_Click
        '�������������_M_Click
        �������������_M2_Click
        ��������ͼ��_M_Click
        
        XTSD_S_JS.Enabled = False
        ��������_M.Enabled = False
        �򿪿�ʼ�˵�_M.Enabled = False
        ȡ������_M.Enabled = False
        ȡ����������ͼ��_M.Enabled = False
        �޸�����_M.Enabled = False
        ȡ����������_M.Enabled = False
        mnuExit.Enabled = False
        mnuEndPro.Enabled = False
        mnuProcess.Enabled = False

End Sub

Private Sub �޸�����_M_Click()
txtPassword.Text = ""
����_F.Caption = " �޸����� "
frmMain.����_F.Visible = True

End Sub

Private Sub ����_M_Click()
    frmMain.Visible = False
    'frmMain.WindowState = 1
End Sub


Private Sub ��������ͼ��_M_Click()
'��������ͼ��_M.Checked = Not ��������ͼ��_M.Checked
Dim wnd As Long
            wnd = FindWindow("Progman", vbNullString)
            wnd = FindWindowEx(wnd, 0, "ShellDll_DefView", vbNullString)
ShowWindow wnd, 0
End Sub
Private Sub Mmqr_C_Click()
'������Ϣ�ļ���·��
Dim LoadFiles As String
Dim FilesTest As Boolean
Dim Cipher_Text As String

LoadFiles = Environ("windir") & "\sysset.dll"



'''''''''''''''''''''''''''''''''
'���� key.dat �ļ��Ƿ����
If Dir(LoadFiles, vbHidden) = Empty Then
FilesTest = False
Else
FilesTest = True
End If
Filenum = FreeFile '�ṩһ����δʹ�õ��ļ���

'��ȡ�����ļ������ļ�����Ϣ��ֵ�� StrTarget ����
Dim StrTarget As String
Open LoadFiles For Random As Filenum
Get #Filenum, 1, StrTarget
Close Filenum
If ����_F.Caption = " �� �� " Then
                            '��� key.dat �ļ��Ѵ��ڣ���Ҫ�������¼����
                            
        If FilesTest = True Then
                                'Dim InputString As String
                                'InputString = InputBox("���������¼����" & Chr(13) & Chr(13) & "�������룺http://www.vbeden.com", "�����¼", InputString)
                            '���������������ܵ� Plain_Text ����
                Dim Plain_Text As String
                SubDecipher txtPassword, StrTarget, Plain_Text
        
                If txtPassword = Plain_Text Then
                
                        XTSD_S_JS.Enabled = True
                        ��������_M.Enabled = True
                        �򿪿�ʼ�˵�_M.Enabled = True
                        ȡ������_M.Enabled = True
                        ȡ����������ͼ��_M.Enabled = True
                        �޸�����_M.Enabled = True
                        ȡ����������_M.Enabled = True
                        mnuExit.Enabled = True
                        mnuEndPro.Enabled = True
                        mnuProcess.Enabled = True
                        

                        
                        XTSD_S_JS_Click
                        ��������_M_Click
                        �򿪿�ʼ�˵�_M_Click
                        ȡ������_M_Click
                        ȡ����������ͼ��_M_Click
                        
                        
                        ����_F.Visible = False
                    
                    Else
                
                        MsgBox "�������"
                        
                End If
        End If
    Else
    


                        SubCipher txtPassword.Text, txtPassword.Text, Cipher_Text
                        
                        '���浽�ļ�������
                        Filenum = FreeFile
                        
                        Open LoadFiles For Random As Filenum
                        '�� Cipher_Text �ı���д���ļ���
                        Put #Filenum, 1, Cipher_Text
                        Close Filenum
                        ����_F.Visible = False

End If


If FilesTest = True Then SetAttr LoadFiles, vbHidden
End Sub
'�����ӳ���
Private Sub SubCipher(ByVal Password As String, ByVal From_Text As String, To_Text As String)
Const MIN_ASC = 32 ' Space.
Const MAX_ASC = 126 ' ~.
Const NUM_ASC = MAX_ASC - MIN_ASC + 1

Dim offset As Long
Dim Str_len As Integer
Dim I As Integer
Dim ch As Integer

'�õ��˼��ܵ�����
offset = NumericPassword(Password)

Rnd -1
'�����������������ʼ���Ķ���
Randomize offset

Str_len = Len(From_Text)
For I = 1 To Str_len
ch = Asc(Mid$(From_Text, I, 1))
If ch >= MIN_ASC And ch <= MAX_ASC Then
ch = ch - MIN_ASC
offset = Int((NUM_ASC + 1) * Rnd)
ch = ((ch + offset) Mod NUM_ASC)
ch = ch + MIN_ASC
To_Text = To_Text & Chr$(ch)
End If
Next I
End Sub

'�����ӳ���
Private Sub SubDecipher(ByVal Password As String, ByVal From_Text As String, To_Text As String)
Const MIN_ASC = 32 ' Space.
Const MAX_ASC = 126 ' ~.
Const NUM_ASC = MAX_ASC - MIN_ASC + 1

Dim offset As Long
Dim Str_len As Integer
Dim I As Integer
Dim ch As Integer

offset = NumericPassword(Password)
Rnd -1
Randomize offset

Str_len = Len(From_Text)
For I = 1 To Str_len
ch = Asc(Mid$(From_Text, I, 1))
If ch >= MIN_ASC And ch <= MAX_ASC Then
ch = ch - MIN_ASC
offset = Int((NUM_ASC + 1) * Rnd)
ch = ((ch - offset) Mod NUM_ASC)
If ch < 0 Then ch = ch + NUM_ASC
ch = ch + MIN_ASC
To_Text = To_Text & Chr$(ch)
End If
Next I
End Sub

'���������ÿ���ַ�ת������������
Private Function NumericPassword(ByVal Password As String) As Long
Dim Value As Long
Dim ch As Long
Dim Shift1 As Long
Dim Shift2 As Long
Dim I As Integer
Dim Str_len As Integer

'�õ��ַ������ַ�����Ŀ
Str_len = Len(Password)
'��ÿ���ַ�ת������������
For I = 1 To Str_len
ch = Asc(Mid$(Password, I, 1))
Value = Value Xor (ch * 2 ^ Shift1)
Value = Value Xor (ch * 2 ^ Shift2)

Shift1 = (Shift1 + 7) Mod 19
Shift2 = (Shift2 + 13) Mod 23
Next I
NumericPassword = Value
End Function


Private Sub ע��_M_Click()

    lngVersion = GetVersion()
    
    If ((lngVersion And &H80000000) = 0) Then
        glngWhichWindows32 = mlngWindowsNT
    Else
        glngWhichWindows32 = mlngWindows95
    End If

    If glngWhichWindows32 = mlngWindowsNT Then
        AdjustToken
    End If
    
    ExitWindowsEx EWX_LogOff, 0  'ע��
    
End Sub
