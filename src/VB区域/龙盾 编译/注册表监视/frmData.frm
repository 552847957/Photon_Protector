VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.ocx"
Begin VB.Form frmData 
   Caption         =   "frmData"
   ClientHeight    =   5085
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5085
   Icon            =   "frmData.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5085
   ScaleWidth      =   5085
   StartUpPosition =   3  '����ȱʡ
   Begin VB.ListBox VirusList 
      Height          =   1860
      Left            =   600
      TabIndex        =   1
      Top             =   2880
      Width           =   3975
   End
   Begin MSComctlLib.ListView VirusData 
      Height          =   2055
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Width           =   3975
      _ExtentX        =   7011
      _ExtentY        =   3625
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   50
      Left            =   4560
      Top             =   3000
   End
End
Attribute VB_Name = "frmData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub Form_Load()
On Error Resume Next
With Me
'----------�б��ʼ��----------
    .VirusData.ListItems.Clear               '����б�
    .VirusData.ColumnHeaders.Clear           '����б�ͷ
    .VirusData.View = lvwReport              '�����б���ʾ��ʽ
    .VirusData.GridLines = True              '��ʾ������
    .VirusData.LabelEdit = lvwManual         '��ֹ��ǩ�༭
    .VirusData.FullRowSelect = True          'ѡ������
    .VirusData.Checkboxes = False
    .VirusData.ColumnHeaders.Add , , "������", .VirusData.Width / 2 '���б����������
    .VirusData.ColumnHeaders.Add , , "����", .VirusData.Width / 2 '���б����������
    .VirusData.ColumnHeaders.Add , , "����", .VirusData.Width / 2 '���б����������

End With


'��ȡ������
  If Dir(App.Path & "\ProcessData\VirusData.Vda") = "" Then
  MsgBox "δ�ҵ��������ļ�������ʧ�ܣ�", vbOKOnly, "������������ ע�����"
   End
  End If
    Dim n%, a
    Open App.Path & "\ProcessData\VirusData.Vda" For Binary As #1
    a = StrConv(InputB(LOF(1), 1), vbUnicode)
    Close #1
    b = Split(a, vbCrLf)
    Dim Number
    Dim total
Again:
    Number = Number + 1
    total = UBound(b) + 2
    If Number = total Then
      GoTo OutLoadVirus:
    Else
      n = Val(Number)
      VirusList.AddItem b(n - 1), n - 1
      GoTo Again:
   End If
OutLoadVirus:

Timer1.Enabled = True
End Sub
Private Function AddListItem(ByVal FirstText, ByVal SecondText As String, ByVal ThirdText As String, ByRef List)
Set itm = List.ListItems.Add(, , FirstText)
itm.SubItems(1) = SecondText
itm.SubItems(2) = ThirdText
End Function

Private Sub Timer1_Timer()
Dim MyString As String
For I = 0 To VirusList.ListCount - 1
VirusList.ListIndex = I
MyString = VirusList.Text
AddListItem Split(MyString, "|")(0), Split(MyString, "|")(1), Split(MyString, "|")(2), Me.VirusData
Next
Timer1.Enabled = False
End Sub
