VERSION 5.00
Begin VB.Form Form_Map 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "�����������֡�����ʵʱ����"
   ClientHeight    =   6195
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10410
   Icon            =   "Form_Map.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   6195
   ScaleWidth      =   10410
   StartUpPosition =   3  '����ȱʡ
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   960
      TabIndex        =   5
      Top             =   1440
      Width           =   2415
   End
   Begin VB.CommandButton cmdExit 
      Caption         =   "�˳�"
      Height          =   435
      Left            =   1440
      TabIndex        =   3
      Top             =   3600
      Width           =   1395
   End
   Begin VB.TextBox Text_Memory 
      BeginProperty Font 
         Name            =   "����"
         Size            =   12
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1230
      Left            =   3870
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Text            =   "Form_Map.frx":169B1
      Top             =   390
      Width           =   6195
   End
   Begin VB.CommandButton cmdReadMem 
      Caption         =   "�������ڴ����"
      Height          =   435
      Left            =   2760
      TabIndex        =   2
      Top             =   2880
      Width           =   1575
   End
   Begin VB.CommandButton cmdWriteMem 
      Caption         =   "д�����ڴ����"
      Height          =   435
      Left            =   240
      TabIndex        =   1
      Top             =   2880
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "�����ڴ����ֵ��"
      BeginProperty Font 
         Name            =   "����"
         Size            =   12
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   540
      TabIndex        =   4
      Top             =   660
      Width           =   1935
   End
End
Attribute VB_Name = "Form_Map"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private sData2 As String
Const LenStr As Long = 65535 * 10

Private Sub cmdExit_Click()
    Unload Me
End Sub

Public Function ReadMem() As String
    sData2 = String(LenStr, vbNullChar)
    Call lstrcpyn(ByVal sData2, ByVal lShareData, LenStr)
    Text_Memory.Text = ""
    Text_Memory.SelText = sData2
    ReadMem = Text_Memory
End Function

Public Function WriteMem(ByVal WText) As Boolean
    Text_Memory.Text = WText
    sData2 = Text_Memory.Text
    Call lstrcpyn(ByVal lShareData, ByVal sData2, LenStr)
    WriteMem = True
End Function

Private Sub cmdReadMem_Click()
MsgBox ReadMem
End Sub

Private Sub cmdWriteMem_Click()
WriteMem Text_Memory.Text
End Sub

Private Sub Command1_Click()
MsgBox CheckProcess("explorer.exe", "C:\Documents and Settings\Administrator\����\�½��ļ��� (3)\�������������.exe")

End Sub

Private Sub Form_Load()
If App.PrevInstance Then
MsgBox "�Ѿ���������/�����������������ظ�������"
End
End If
Me.Hide
    Text_Memory.Text = ""
    hMemShare = CreateFileMapping(&HFFFFFFFF, _
        0, _
        PAGE_READWRITE, _
         0, _
        LenStr, _
        "PPProcessRTAChat")
    If hMemShare = 0 Then
        'Err.LastDllError
        MsgBox "�����ڴ�ӳ���ļ�ʧ��!", vbCritical, "����"
        End
    End If
    If (Err.LastDllError = ERROR_ALREADY_EXISTS) Then
        'ָ���ڴ��ļ��Ѵ���
    End If
    lShareData = MapViewOfFile(hMemShare, FILE_MAP_WRITE, 0, 0, 0)
    If lShareData = 0 Then
        MsgBox "Ϊӳ���ļ����󴴽���ʧ��!", vbCritical, "����"
        End
    End If
    'Debug.Print "lShareData="; lShareData
    'sdata2 = String(LenStr, &H0)
    sData2 = String(LenStr, vbNullChar)
    Call lstrcpyn(ByVal sData2, ByVal lShareData, LenStr)
    Text_Memory.Text = ""
    Text_Memory.SelText = sData2
    
    MYRECEIVER.Show
    Load frmData
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If lShareData <> 0 Then
        Call UnmapViewOfFile(ByVal lShareData) '���ӳ��
        lShareData = 0
    End If
    
    If hMemShare <> 0 Then
        Call CloseHandle(hMemShare) '�ر�ӳ��
        hMemShare = 0
    End If
End Sub
