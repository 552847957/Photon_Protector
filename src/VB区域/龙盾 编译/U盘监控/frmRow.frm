VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmRow 
   Caption         =   "����-ɨ�����"
   ClientHeight    =   4200
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   5295
   LinkTopic       =   "Form2"
   ScaleHeight     =   4200
   ScaleWidth      =   5295
   StartUpPosition =   3  '����ȱʡ
   Begin VB.ListBox List1 
      Height          =   240
      Left            =   4560
      TabIndex        =   2
      Top             =   600
      Width           =   375
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   2760
      TabIndex        =   1
      Top             =   3720
      Width           =   975
   End
   Begin MSComctlLib.ListView FileList 
      Height          =   3255
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   5741
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
Attribute VB_Name = "frmRow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Function AddRow(ByVal Path As String, ByVal ScanMod As String)
Set item = FileList.ListItems.Add(, , Path)
item.SubItems(1) = "Wait"
item.SubItems(2) = ScanMod
DoCheck
End Function


Private Sub Form_Load()
With Me
'----------�б��ʼ��----------
    .FileList.ListItems.Clear               '����б�
    .FileList.ColumnHeaders.Clear           '����б�ͷ
    .FileList.View = lvwReport              '�����б���ʾ��ʽ
    .FileList.GridLines = True              '��ʾ������
    .FileList.LabelEdit = lvwManual         '��ֹ��ǩ�༭
    .FileList.FullRowSelect = True          'ѡ������
    .FileList.Checkboxes = False
    .FileList.ColumnHeaders.Add , , "·��", .FileList.Width / 2 '���б����������
    .FileList.ColumnHeaders.Add , , "״̬", .FileList.Width / 2 '���б����������
    .FileList.ColumnHeaders.Add , , "��ʽ", .FileList.Width / 2 '���б����������
End With
End Sub

Public Function DoCheck()
With Me
If .FileList.ListItems.Count <> 0 Then '���ɨ�����������Ŀ
  If .FileList.ListItems(1).SubItems(1) = "Wait" Then '�����һ����Ŀ��״̬�ǵȴ�
    Set item = .FileList.ListItems(1)
    DoScan item.Text, item.SubItems(2) '�Ե�һ����Ŀ����ɨ��
  Else '�����һ����Ŀ��״̬���ǵȴ�
  Exit Function '�˳�
  End If
Else '���û����Ŀ
If frmUSB.Visible = True Then
Unload frmUSB
End If
Exit Function '�˳�
End If
End With
End Function

Public Function DoScan(ByVal Path As String, ScanMod As String)
'Path���ļ�·��
On Error Resume Next
'ScanMod��Sim-ֻɨ���Ŀ¼;Adv-ɨ��ȫ��;Sin-�����ļ�
DoEvents
If Dir(Path) = "" Then Exit Function 'û���ҵ����ļ���·��
'�ָ�����ϵͳ�������ļ���
Dim XFSO As New FileSystemObject
Set fso = XFSO.GetFolder(Path)
For Each Folder In fso.SubFolders
 Call SetAttr(Folder, vbNormal)
Next

FileList.ListItems(1).SubItems(1) = "Check"
 Dim MyForm As New frmCheck
 Load MyForm
 With MyForm
 Dim FilePath As String
 Dim Result As String '���ܽ��
 Dim VirusDes As String '������ϴ���
 Dim singlemod As Boolean
    Dim StrSplit As String
 '������������
Select Case ScanMod
Case "Sim"
 Showfilelist Path, .List1
 For i = 0 To .List1.ListCount - 1
  .List1.ListIndex = i
  FilePath = Path & "\" & .List1.Text
  Result = ProcessScan(FilePath)
  If Result <> "SAFE" And Result <> "Error" Then '���������Ҳ���ǰ�ȫ
    If VirusDes = "" Then '�����û���κ�һ������
      VirusDes = FilePath & "|" & Result '��ֵ
      singlemod = True '�򿪵�������ģʽ
    Else
      VirusDes = VirusDes & "||" & FilePath & "|" & Result '����
      singlemod = False
    End If
  Else
   '���û�в鵽���Ǹ������Ļ�
   StrSplit = Split(FilePath, ".")(UBound(Split(FilePath, ".")))
   Debug.Print Left(FilePath, Len(FilePath) - Len(StrSplit) - 1)
   If Dir(Left(FilePath, Len(FilePath) - Len(StrSplit) - 1), vbDirectory) <> "" And Right(FilePath, 4) = ".exe" Then
   'ͬ���ļ���
   Result = "�ļ���ͬ���ļ�|���ļ���""" & Left(FilePath, Len(FilePath) - Len(StrSplit) - 1) & """�ļ���ͬ�������������ʶ�˳�����ɾ����"
    If VirusDes = "" Then '�����û���κ�һ������
      VirusDes = FilePath & "|" & Result '��ֵ
      singlemod = True '�򿪵�������ģʽ
    Else
      VirusDes = VirusDes & "||" & FilePath & "|" & Result '����
      singlemod = False
    End If
   End If
  End If
 Next
Case "Adv"
  sousuofile Path, .List1
 For i = 0 To .List1.ListCount - 1
  .List1.ListIndex = i
  FilePath = .List1.Text
  Result = ProcessScan(FilePath)
  Debug.Print FilePath & ":" & Result
  If Result <> "SAFE" And Result <> "Error" Then '���������Ҳ���ǰ�ȫ
    If VirusDes = "" Then '�����û���κ�һ������
      VirusDes = FilePath & "|" & Result '��ֵ
      singlemod = True '�򿪵�������ģʽ
    Else
      VirusDes = VirusDes & "||" & FilePath & "|" & Result '����
      singlemod = False
    End If
  Else
   '���û�в鵽���Ǹ������Ļ�
   If UBound(Split(FilePath, "\")) = 1 Then
   StrSplit = Split(FilePath, ".")(UBound(Split(FilePath, ".")))
   Debug.Print Left(FilePath, Len(FilePath) - Len(StrSplit) - 1)
   If Dir(Left(FilePath, Len(FilePath) - Len(StrSplit) - 1), vbDirectory) <> "" And Right(FilePath, 4) = ".exe" Then
   'ͬ���ļ���
   Result = "�ļ���ͬ���ļ�|���ļ���""" & Left(FilePath, Len(FilePath) - Len(StrSplit) - 1) & """�ļ���ͬ�������������ʶ�˳�����ɾ����"
    If VirusDes = "" Then '�����û���κ�һ������
      VirusDes = FilePath & "|" & Result '��ֵ
      singlemod = True '�򿪵�������ģʽ
    Else
      VirusDes = VirusDes & "||" & FilePath & "|" & Result '����
      singlemod = False
    End If
   End If
   End If
  End If
 Next
Case "Sin" '���ļ�
  Result = ProcessScan(Path)
  If Result <> "SAFE" And Result <> "Error" Then '���������Ҳ���ǰ�ȫ
      VirusDes = Path & "|" & Result '��ֵ
  End If
End Select
If VirusDes <> "" Then ' ����в���
  ShowTextTip VirusDes, singlemod '���ݣ�
End If
FileList.ListItems.Remove 1
End With
DoCheck
End Function
