VERSION 5.00
Object = "{20DD27F9-A698-4CD1-B995-1ED20DBDB6B9}#1.0#0"; "bkDLControl.ocx"
Object = "{000822E6-C8BA-4BA1-A0CB-E04840D54F97}#2.0#0"; "���ܶ�̬������.ocx"
Object = "{BD0C1912-66C3-49CC-8B12-7B347BF6C846}#15.3#0"; "Codejock.SkinFramework.v15.3.1.ocx"
Begin VB.Form frmDLTest 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "������������ ��װ��������"
   ClientHeight    =   6060
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9375
   Icon            =   "frmDLTest1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   Picture         =   "frmDLTest1.frx":169B1
   ScaleHeight     =   6060
   ScaleWidth      =   9375
   StartUpPosition =   2  '��Ļ����
   Begin VB.CommandButton cmdBegin 
      Caption         =   "�� ʼ"
      Height          =   375
      Left            =   3720
      TabIndex        =   5
      Top             =   4680
      Width           =   1575
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   1320
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   6240
      Visible         =   0   'False
      Width           =   6855
   End
   Begin ����1.bkDLControl DL 
      Height          =   375
      Left            =   10320
      Top             =   6360
      Visible         =   0   'False
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   661
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "����"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.ListBox lstOut 
      Appearance      =   0  'Flat
      Columns         =   1
      Height          =   1470
      ItemData        =   "frmDLTest1.frx":2673B
      Left            =   960
      List            =   "frmDLTest1.frx":2673D
      TabIndex        =   1
      Top             =   6360
      Visible         =   0   'False
      Width           =   7095
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "ȡ ��"
      Enabled         =   0   'False
      Height          =   375
      Left            =   8160
      TabIndex        =   0
      Top             =   6360
      Visible         =   0   'False
      Width           =   1575
   End
   Begin ���ܶ�̬������.CoolBar CoolBar1 
      Height          =   255
      Left            =   960
      TabIndex        =   4
      Top             =   3840
      Width           =   7335
      _ExtentX        =   12938
      _ExtentY        =   450
   End
   Begin VB.Label lbl_Pro 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "����"
         Size            =   12
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   2640
      TabIndex        =   6
      Top             =   4080
      Width           =   5520
   End
   Begin XtremeSkinFramework.SkinFramework SkinFramework1 
      Left            =   480
      Top             =   6360
      _Version        =   983043
      _ExtentX        =   635
      _ExtentY        =   635
      _StockProps     =   0
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "���ȣ�"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   3830
      Width           =   735
   End
End
Attribute VB_Name = "frmDLTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
''PS��FTP�ռ�δ�����������޷����ӷ���������ַΪwww.dvmsc.com����δ������FTP�ռ䡣

Option Explicit
Dim IniPath As String
Dim Ready As Boolean
Dim Path As String
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Const TH32CS_SNAPHEAPLIST = &H1
Const TH32CS_SNAPPROCESS = &H2
Const TH32CS_SNAPTHREAD = &H4
Const TH32CS_SNAPMODULE = &H8
Const TH32CS_SNAPALL = (TH32CS_SNAPHEAPLIST Or TH32CS_SNAPPROCESS Or TH32CS_SNAPTHREAD Or TH32CS_SNAPMODULE)
Const TH32CS_INHERIT = &H80000000
Const MAX_PATH As Integer = 260
Private Type PROCESSENTRY32
    dwSize As Long
    cntUsage As Long
    th32ProcessID As Long
    th32DefaultHeapID As Long
    th32ModuleID As Long
    cntThreads As Long
    th32ParentProcessID As Long
    pcPriClassBase As Long
    dwFlags As Long
    szExeFile As String * MAX_PATH
End Type
Private Declare Function CreateToolhelp32Snapshot Lib "kernel32" (ByVal lFlags As Long, ByVal lProcessID As Long) As Long
Private Declare Function Process32First Lib "kernel32" (ByVal hSnapShot As Long, uProcess As PROCESSENTRY32) As Long
Private Declare Function Process32Next Lib "kernel32" (ByVal hSnapShot As Long, uProcess As PROCESSENTRY32) As Long
Private Declare Sub ExitProcess Lib "kernel32" (ByVal uExitCode As Long)
Private Declare Function GetExitCodeProcess Lib "kernel32" (ByVal hProcess As Long, lpExitCode As Long) As Long

 

Function exitproc(ByVal exefile As String) As Boolean
exitproc = False
Dim r
    Dim hSnapShot As Long, uProcess As PROCESSENTRY32
    hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0&)
    uProcess.dwSize = Len(uProcess)
    r = Process32First(hSnapShot, uProcess)
       Do While r
        If Left$(uProcess.szExeFile, IIf(InStr(1, uProcess.szExeFile, Chr$(0)) > 0, InStr(1, uProcess.szExeFile, Chr$(0)) - 1, 0)) = exefile Then
        exitproc = True
        Exit Do
        End If
        'Retrieve information about the next process recorded in our system snapshot
        r = Process32Next(hSnapShot, uProcess)
    Loop
End Function


Private Sub cmdBegin_Click()
'    With DL
'        .FileURL = Text1.Text
'        .SaveFilePath = App.Path
'        LogItem "��������" & Text1.Text
'        .BeginDownload
'    End With
'    cmdCancel.Enabled = True
    CoolBar1.BeReady
StartDownload
cmdBegin.Enabled = False
End Sub

Private Sub cmdCancel_Click()
    DL.CancelDownload
End Sub

Private Sub DL_DLBeginDownload()
    CoolBar1.StartScroll
    LogItem "��ʼ���ش�" & DL.FileURL
End Sub

Private Sub DL_DLCanceled()
    LogItem "ȡ������"
End Sub

Private Sub DL_DLComplete(Bytes As Long)
On Error Resume Next
    'download terminated - bytes is > 0 if successful (file size)
    cmdCancel.Enabled = False
    If Bytes > 0& Then
        LogItem "���" & SizeString(Bytes) & "���ز����浽" & DL.SaveFileName
    Else
        Exit Sub
    End If
    If Path <> "Nothing" Then
     Dim ExePath
     ExePath = Replace(Split(Path, "/")(UBound(Split(Path, "/"))), " ", "")
     End If
'    MsgBox ExePath
    Debug.Print ExePath & "     " & Dir(App.Path & "\" & ExePath)
If ExePath <> "" And Dir(App.Path & "\Temp\" & ExePath) <> "" Then
FileCopy App.Path & "\Temp\" & ExePath, App.Path & "\Temp\Update.exe"
 Kill App.Path & "\Temp\" & ExePath
End If
If Dir(App.Path & "\Temp\Update.exe") <> "" Then
Shell App.Path & "\Temp\Update.exe", vbNormalFocus
Do Until exitproc("Update.exe") = False
SuperSleep 1
Loop
MsgBox "������ɣ���л����֧�֡�", vbInformation, "������������-�Զ�����"
Shell App.Path & "\DragonShield.exe"
End
End If
lbl_Pro.Caption = "���������ӳɹ��������ʼ���и��¡�"
cmdBegin.Enabled = True
End Sub

'Returns IP address of successful connection
Private Sub DL_DLConnected(ConnAddr As String)
    LogItem "���ӵ� " & ConnAddr
End Sub
'Error!  See UC code for different possible errors
'This event is always followed by DLComplete returning 0 bytes
Private Sub DL_DLError(E As bkDLError, Error As String)
Dim strErrType As String
    Select Case E
        Case bkDLEUnavailable
            strErrType = "���������ļ�"
        Case bkDLERedirect
            strErrType = "�ض���"
        Case bkDLEZeroLength
            strErrType = "û���ֽڷ���"
            MsgBox "δ���ӵ��������������������ӣ�"
            End
        Case bkDLESaveError
            strErrType = "�ļ��������"
        Case bkDLEUnknown
            strErrType = "��������"
    End Select
    LogItem "���� - " & strErrType & ": " & Error
    Ready = True
End Sub

Private Sub DL_DLFileSize(Bytes As Long)
    'Size in bytes.  returned when connection to file is complete
    'and download actually begins
    LogItem "�ļ���СΪ" & SizeString(Bytes) & " (" & CStr(Bytes) & " bytes)"
End Sub

Private Sub DL_DLMIMEType(MIMEType As String)
    'handy info!
    LogItem "MIME������ " & MIMEType
End Sub

Private Sub DL_DLProgress(Percent As Single, BytesRead As Long, TotalBytes As Long)
  CoolBar1.SetValue Percent * 100
  lbl_Pro.Caption = "�����أ�" & Format(Percent, "0%") & "     �ܴ�С��" & SizeString(TotalBytes)
End Sub

Private Sub DL_DLRedirect(ConnAddr As String)
    'Returns path to file if redirected
    'This event wont fire at all if FailOnRedirect is True! (DLError instead)
    'LogItem Index, "�ض���" & ConnAddr
End Sub

Private Sub Form_Load()
If Dir(App.Path & "\Update.ini") <> "" Then
Kill App.Path & "\Update.ini"
End If
If Command <> "Ready" Then

'End
End If
cmdBegin.Enabled = False
    'initialize sample inputs
Dim filename As String
Dim IniFile As String
 Path = "Nothing"
filename = App.Path & "\Skin\Office2007.cjstyles"
IniFile = "NormalBlue.ini"
SkinFramework1.LoadSkin filename, IniFile
SkinFramework1.ApplyWindow Me.hWnd
SkinFramework1.ApplyOptions = SkinFramework1.ApplyOptions Or xtpSkinApplyMetrics
LogItem "���ӷ�������ȡ������Ϣ��"
If Dir(App.Path & "\Update.ini") <> "" Then
 Kill App.Path & "\Update.ini"
End If
    With DL
        .FileURL = "ftp://dvmsc:linweizhe@142.54.162.174/databases/DragonShieldUpdate/Update.ini"
        .SaveFilePath = App.Path
        LogItem "��������" & .FileURL
        .BeginDownload
    End With
CoolBar1.BeReady
IniPath = App.Path & "\Update.ini"
    cmdCancel.Enabled = True
    If Dir(App.Path & "\Temp\Update.exe") <> "" Then
    Kill App.Path & "\Temp\Update.exe" '�ɵ��ϴε��ļ�
    End If
lbl_Pro.Caption = "���ӷ������У�����FTP�ռ��е㲻�ȶ�" & vbCrLf & "���������ĵȴ�������������"
End Sub
Public Function StartDownload()
'Dim i, x

'ReDim File(UBound(Split(ReadString("Update", "File", IniPath), ";"))) As String
'Dim UrlPath As String
'Dim Temp As String
'Temp = ReadString("Update", "File", IniPath)
'MsgBox Temp
'If Temp = "" Then MsgBox "û����Ҫ���µ��ļ�", vbInformation, "�Զ�������ʾ": End
'For i = 0 To UBound(Split(Temp, ";"))
' File(i) = Split(Temp, ";")(i)
'Next
''ȡ��������Ҫ���µ��ļ�
'For x = 0 To UBound(File)
CoolBar1.SetValue 0
CoolBar1.BeReady
Dim MyFSO As New FileSystemObject
If Dir(App.Path & "\DragonShield.exe") = "" Then 'û��
 Path = ReadString("Update", "Install", IniPath)
  MsgBox "û�з��ֲ����������������򣬽�����������", vbInformation, "�������ز�����������"
 If Path = "" Then MsgBox "δ�ҵ���װ�ļ�����ȴ�����Ա�ϴ���": Unload Me: End
Else '��
 Dim Ver As String
 Ver = MyFSO.GetFileVersion(App.Path & "\DragonShield.exe")
 Path = ReadString("Update", Ver, IniPath)
 If Path = "" Then MsgBox "û�з��ָ��µİ汾�����½�����": Unload Me: End
 MsgBox "������ʼ���²����������֣��뱣�����糩ͨ", vbInformation, "������ʼ����"
 
End If
 'LogItem "  Url��" & "ftp://ChineseSF:linweizhe@ChineseSF.svfree.net/" & Path
     With DL
        .FileURL = "ftp://dvmsc:linweizhe@142.54.162.174/" & Path
        .SaveFilePath = App.Path & "\Temp"
        LogItem "��������" & "ftp://dvmsc:linweizhe@142.54.162.174/" & Path
        .BeginDownload
    End With
'    Do Until Ready <> False
'     SuperSleep 1
'     Loop
'Next
End Function
Public Function SuperSleep(DealyTime As Single) '�˴�ԭΪlong���޸�Ϊsingle����ʱ1ms :SK<2<8h
Dim TimerCount As Single
    TimerCount = Timer + DealyTime '����X�� ZJ9x6|q
    While TimerCount - Timer > 0
        DoEvents
        Sleep 1
    Wend
    Text1 = "SuperSleep " & DealyTime
End Function


Private Sub LogItem(strItem As String)
    With lstOut
        .AddItem "> " & strItem
        If .NewIndex > .TopIndex + 17 Then
            .TopIndex = .NewIndex - 16
        End If
    End With
End Sub

Private Function SizeString(lBytes As Long) As String
    If lBytes < &H400& Then
        SizeString = CStr(lBytes) & "b"
    ElseIf lBytes < &H100000 Then
        SizeString = CStr(lBytes \ 1024) & "k"
    ElseIf lBytes < &H20000000 Then
        SizeString = Replace$(Format$((lBytes \ 1024) / 1024, "0.0"), ".0", vbNullString) & "M"
    Else
        SizeString = Replace$(Format$((lBytes \ (1024 ^ 2)) / 1024, "#,##0.0"), ".0", vbNullString) & "G"
    End If
End Function



Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
If MsgBox("��ȷ���˳���װ������", vbYesNo, "�����ڹرմ˳���") = vbNo Then
Cancel = 1
End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
On Error Resume Next
Kill App.Path & "\Temp\Update.exe" 'ɾ�������ļ�
End Sub

Private Sub lblProg_Click()

End Sub

