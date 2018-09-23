VERSION 5.00
Object = "{BD0C1912-66C3-49CC-8B12-7B347BF6C846}#15.3#0"; "Codejock.SkinFramework.v15.3.1.ocx"
Begin VB.Form FrmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "ǿ��ɾ���ļ� (֧���Ϸ�)"
   ClientHeight    =   4275
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5835
   Icon            =   "FrmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   4275
   ScaleWidth      =   5835
   StartUpPosition =   2  '��Ļ����
   Begin VB.CommandButton CmdExit 
      Caption         =   "�˳�����"
      Height          =   375
      Left            =   4440
      TabIndex        =   5
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton CmdKillFile 
      Caption         =   "��ʼɾ��"
      Height          =   375
      Left            =   3360
      TabIndex        =   4
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton CmdClearLst 
      Caption         =   "����б�"
      Height          =   375
      Left            =   2280
      TabIndex        =   3
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton CmdShowPath 
      Caption         =   "���Ŀ¼"
      Height          =   375
      Left            =   1200
      TabIndex        =   2
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton CmdShowOpen 
      Caption         =   "����ļ�"
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   3720
      Width           =   975
   End
   Begin VB.ListBox LstFile 
      Appearance      =   0  'Flat
      Height          =   3090
      Left            =   120
      OLEDropMode     =   1  'Manual
      TabIndex        =   0
      Top             =   120
      Width           =   5535
   End
   Begin XtremeSkinFramework.SkinFramework SkinFramework1 
      Left            =   4800
      Top             =   4200
      _Version        =   983043
      _ExtentX        =   635
      _ExtentY        =   635
      _StockProps     =   0
   End
   Begin VB.Label Label1 
      Caption         =   "ע�⣺�����߽���ֱ��ǿ��ɾ��Ŀ���ļ���������ļ�����ʹ���У�����������ɾ����"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   3240
      Width           =   5535
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lparam As Any) As Long
Private Const LB_SETHORIZONTALEXTENT = &H194
Dim DrvController As New cls_Driver


Private Sub Form_Initialize()
'    SetButtonFlat CmdShowOpen.hWnd
'    SetButtonFlat CmdShowPath.hWnd
'    SetButtonFlat CmdClearLst.hWnd
'    SetButtonFlat CmdKillFile.hWnd
'    SetButtonFlat CmdAbout.hWnd
'    SetButtonFlat CmdExit.hWnd
'-------------Ƥ���ؼ�����----------------
Dim FileName As String
Dim IniFile As String
FileName = App.Path & "\Skin\Office2007.cjstyles"
IniFile = "NormalBlue.ini"
SkinFramework1.LoadSkin FileName, IniFile
SkinFramework1.ApplyWindow Me.hWnd
SkinFramework1.ApplyOptions = SkinFramework1.ApplyOptions Or xtpSkinApplyMetrics

End Sub

Private Sub Form_Load()
Dim a As Boolean, b As Boolean, c As Boolean
    With DrvController
        .szDrvFilePath = Replace(App.Path & "\SuperKillFile.sys", "\\", "\")
        .szDrvLinkName = "\\.\SuperKillFile"
        .szDrvDisplayName = "SuperKillFile"
        .szDrvSvcName = "SuperKillFile"
        .szDrvDeviceName = "\Device\SuperKillFile"
        a = .InstDrv
        b = .StartDrv
        c = .OpenDrv
    End With
    If a = False Or b = False Or c = False Then MsgBox "��������ʧ��,�����˳�": End
'���ǰһ�����г���û��ͨ��Unload���Ļ�������޷�ͨ�������������ʱ�޷����������������


End Sub

Private Sub Form_Unload(Cancel As Integer)
    With DrvController
        .StopDrv
        .DelDrv
    End With
    'ж��������ɨ�ع���
End Sub

Private Sub LstFile_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
'OLE��קʱ������ļ�
On Error GoTo Err
Dim i As Long
    Me.Caption = "���ڼ����ļ�...���Ե�"
    For i = 1 To Data.Files.Count
    '������ļ�������ļ���������ļ�ȫ���г���
        If (GetAttr(Data.Files.Item(i)) And vbDirectory) = vbDirectory Then
            Findfile Data.Files.Item(i), LstFile
        Else
        'ֻ����ļ�
            LstFile.AddItem Data.Files.Item(i)
        End If
    Next
    addHorScrlBarListBox LstFile
    Me.Caption = "ǿ��ɾ���ļ� (֧���Ϸ�)"
Err:
    'MsgBox "����"
    Me.Caption = "ǿ��ɾ���ļ� (֧���Ϸ�)"
End Sub

Private Sub CmdShowOpen_Click()
Dim Filter As String
Dim FilePath As String
'����ShowOpen �Զ��庯����������CommonDialog���Զ��庯��
    Filter = "���п�������ɾ�����ļ�|*.*"
    Filter = Replace(Filter, "|", Chr(0))
    ShowOpen Me.hWnd, FilePath, , Filter, , , 0
    If FilePath = "" Then Exit Sub
    LstFile.AddItem FilePath
    addHorScrlBarListBox LstFile
End Sub

Private Sub CmdShowPath_Click()
Dim FilePath As String, i As Long
    ShowDir Me.hWnd, FilePath
    Me.Caption = "���ڼ����ļ�...���Ե�"
    '����Ŀ¼��ʹ���Զ��庯��ShowDir
    For i = 1 To intresult
        mydirectory(i) = ""
    Next
    Findfile FilePath, LstFile
    Me.Caption = "ǿ��ɾ���ļ� (֧���Ϸ�)"
    addHorScrlBarListBox LstFile
End Sub

Private Sub CmdClearLst_Click()
    LstFile.Clear '���
End Sub

Private Sub CmdKillFile_Click()
If LstFile.ListCount = 0 Then Exit Sub '���û�ж������˳�
'���Ƶ�ǰ�棬��ʡ��Դ
Dim FileName As String, i As Long, k As Long
Dim ret As Byte
'��������
    Call VarPtr("VIRTUALIZER_START") '��������
    For i = 0 To LstFile.ListCount - 1
        FileName = LstFile.List(i)
        SetAttr FileName, vbNormal '�ı��ļ�������Ϊ����
        Me.Caption = "����ɾ��: " & FileName
        With DrvController '������������ʼɾ��
            Call .IoControl(.CTL_CODE_GEN(&H360), VarPtr("\??\" & FileName), 4, ret, Len(ret))
        End With
    Next
    '����������ɾ������
    Call VarPtr("VIRTUALIZER_END")
    For k = intresult - 1 To 1 Step -1
        Me.Caption = "ɾ��Ŀ¼: " & mydirectory(k)
        SetAttr mydirectory(k), vbNormal
        fRmdir mydirectory(k)
        '�ı�Ŀ¼���ԣ�Ȼ��ɾ��֮
    Next
    Me.Caption = "ǿ��ɾ���ļ� (֧���Ϸ�)"
    LstFile.Clear
    MsgBox "���!"
End Sub

Private Sub CmdAbout_Click()
    MsgBox "ԭ���ߣ�ilisuan  jupiter" & vbNewLine & "���Ͽ�Դ���룬�����޸ĺ���¼�ڲ����������֡�"
End Sub

Private Sub CmdExit_Click()
'    With DrvController
'        .StopDrv
'        .DelDrv
'    End With
    Unload Me
    '����ɾ���������е���ࡣ
End Sub


Private Sub addHorScrlBarListBox(ByVal refControlListBox As Object)
'ΪListBox����Զ���ScrollBar������
Dim nRet As Long, l As Long, lMax As Long, nNewWidth As Integer
    For l = 0 To LstFile.ListCount - 1
        If lMax < TextWidth(LstFile.List(l)) Then
            lMax = TextWidth(LstFile.List(l))
        End If
    Next l
    lMax = lMax + 120
    nNewWidth = lMax / 15
    nRet = SendMessage(refControlListBox.hWnd, LB_SETHORIZONTALEXTENT, nNewWidth, ByVal 0&)
End Sub

Private Function fRmdir(Path As String)
On Error GoTo Err
'�����ļ���
    RmDir Path
Err:
End Function
