VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmRow 
   Caption         =   "����-ɨ���б�"
   ClientHeight    =   4710
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5670
   LinkTopic       =   "Form1"
   ScaleHeight     =   4710
   ScaleWidth      =   5670
   StartUpPosition =   3  '����ȱʡ
   Begin MSComctlLib.ListView WaitList 
      Height          =   3615
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   4815
      _ExtentX        =   8493
      _ExtentY        =   6376
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
Private Sub Form_Load()
With Me
'----------�б��ʼ��----------
    .WaitList.ListItems.Clear               '����б�
    .WaitList.ColumnHeaders.Clear           '����б�ͷ
    .WaitList.View = lvwReport              '�����б���ʾ��ʽ
    .WaitList.GridLines = True              '��ʾ������
    .WaitList.LabelEdit = lvwManual         '��ֹ��ǩ�༭
    .WaitList.FullRowSelect = True          'ѡ������
    .WaitList.Checkboxes = False
    .WaitList.ColumnHeaders.Add , , "����", .WaitList.Width / 2 '���б����������
    .WaitList.ColumnHeaders.Add , , "���", .WaitList.Width / 2 '���б����������
End With
End Sub
