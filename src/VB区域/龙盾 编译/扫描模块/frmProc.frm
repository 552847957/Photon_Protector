VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.ocx"
Begin VB.Form frmProc 
   Caption         =   "����ɨ��"
   ClientHeight    =   5100
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7695
   Icon            =   "frmProc.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5100
   ScaleWidth      =   7695
   StartUpPosition =   2  '��Ļ����
   Begin VB.CommandButton CmdExit 
      Caption         =   "���"
      Height          =   375
      Left            =   6120
      TabIndex        =   2
      Top             =   4440
      Width           =   1335
   End
   Begin VB.CommandButton CmdDelete 
      Caption         =   "ɾ��ѡ����Ŀ"
      Height          =   375
      Left            =   4080
      TabIndex        =   1
      Top             =   4440
      Width           =   1695
   End
   Begin MSComctlLib.ListView lvwPrss 
      Height          =   3975
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   7215
      _ExtentX        =   12726
      _ExtentY        =   7011
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
End
Attribute VB_Name = "frmProc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    '��ý��̵ľ��
    Private Declare Function OpenProcess Lib "KERNEL32" (ByVal dwDesiredAccess As Long, _
            ByVal blnheritHandle As Long, ByVal dwAppProcessId As Long) As Long
              
    '��ֹ����
    Private Declare Function TerminateProcess Lib "KERNEL32" (ByVal ApphProcess As Long, _
            ByVal uExitCode As Long) As Long
    '����һ��ϵͳ����
    Private Declare Function CreateToolhelp32Snapshot Lib "KERNEL32" _
            (ByVal lFlags As Long, lProcessID As Long) As Long
    '���ϵͳ�����еĵ�һ�����̵���Ϣ
    Private Declare Function ProcessFirst Lib "KERNEL32" Alias "Process32First" _
            (ByVal mSnapShot As Long, uProcess As PROCESSENTRY32) As Long
    '���ϵͳ�����е���һ�����̵���Ϣ
    Private Declare Function ProcessNext Lib "KERNEL32" Alias "Process32Next" _
            (ByVal mSnapShot As Long, uProcess As PROCESSENTRY32) As Long
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
        szExeFile As String * 260&
    End Type
    Private Const TH32CS_SNAPPROCESS As Long = 2&
    Dim mresult

Private Sub CmdDelete_Click()
On Error Resume Next
    If lvwPrss.ListItems.Count = 0 Then
        Exit Sub
    End If
    
    Dim Name As String
        Dim mProcID As Long
        Dim i
        Dim itm
    For i = 1 To lvwPrss.ListItems.Count
      Set itm = lvwPrss.ListItems(i)
      If itm.Checked = True Then
       If Name <> "" Then
        Name = Name & vbCrLf & itm.SubItems(1)
       Else
        Name = itm.SubItems(1)
       End If
      End If
    Next
      If Name = "" Then Exit Sub
    
    For i = 1 To lvwPrss.ListItems.Count
      Set itm = lvwPrss.ListItems(i)
      If itm.Checked = True Then
    '�򿪽���
    mProcID = OpenProcess(1&, -1&, itm.Text)
    '��ֹ����
    TerminateProcess mProcID, 0&
       End If
      
    Next
    DoEvents
    doList

End Sub

Private Sub CmdExit_Click()
Unload Me
End Sub

Private Sub Form_Load()
   '����ListView�ؼ���
    lvwPrss.ListItems.Clear
    lvwPrss.ColumnHeaders.Clear
    lvwPrss.ColumnHeaders.Add , , "����ID", 1500
    lvwPrss.ColumnHeaders.Add , , "������", 3000
    lvwPrss.ColumnHeaders.Add , , "����·��", 10000
    lvwPrss.LabelEdit = lvwManual
    lvwPrss.FullRowSelect = True
    lvwPrss.HideSelection = False
    lvwPrss.HideColumnHeaders = False
    lvwPrss.View = lvwReport
    lvwPrss.Checkboxes = True
    doList
End Sub
Private Sub doList()
On Error Resume Next
    Dim uProcess As PROCESSENTRY32
    Dim mSnapShot As Long
    Dim mName As String
    Dim i As Integer
    Dim mlistitem As ListItem
    Dim msg As String
    lvwPrss.ListItems.Clear
    DoEvents
    '��ȡ���̳��ȣ���
    uProcess.dwSize = Len(uProcess)
    '����һ��ϵͳ����
    mSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0&)
    If mSnapShot Then
        '��ȡ��һ������
        mresult = ProcessFirst(mSnapShot, uProcess)
        'ʧ���򷵻�false
        Do While mresult
            '���ؽ��̳���ֵ+1��Chr(0)�����ã��������ֹ�޸Ľ���
            i = InStr(1, uProcess.szExeFile, Chr(0))
            'ת����Сд
            mName = LCase$(Left$(uProcess.szExeFile, i - 1))
            '��listview�ؼ�����ӵ�ǰ������
            Debug.Print ProcessScan(GetProcessPath(mName)) & "|" & mName
            
            If ProcessScan(GetProcessPath(mName)) <> "SAFE" And ProcessScan(GetProcessPath(mName)) <> "Error" Then
            Set mlistitem = lvwPrss.ListItems.Add(, , Text:=uProcess.th32ProcessID)
            '��ӽ�����
            mlistitem.SubItems(1) = mName
            mlistitem.SubItems(2) = GetProcessPath(mName)
            End If
            
            '��ȡ��һ������
            mresult = ProcessNext(mSnapShot, uProcess)
        Loop
    Else
        ErrMsgProc (msg)
    End If
    If lvwPrss.ListItems.Count = 0 Then
    lvwPrss.ListItems.Add , , "��"
    lvwPrss.ListItems(1).SubItems(1) = "δ���ֲ������̣������ɼ���"
    CmdDelete.Enabled = False
    Else
    Dim x As Integer
    For x = 1 To lvwPrss.ListItems.Count
     lvwPrss.ListItems(x).Checked = True
    Next
    End If
End Sub
Sub ErrMsgProc(mMsg As String)
    MsgBox mMsg & vbCrLf & Err.Number & Space(5) & Err.Description
End Sub
