VERSION 5.00
Begin VB.Form frmChoose 
   BackColor       =   &H00C0FFC0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "����-ʵʱ����"
   ClientHeight    =   3765
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6075
   Icon            =   "frmChoose.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3765
   ScaleWidth      =   6075
   StartUpPosition =   2  '��Ļ����
   Begin VB.CommandButton Command2 
      Caption         =   "�򿪸߼�ʵʱ������Ring0��"
      Height          =   495
      Left            =   720
      TabIndex        =   2
      Top             =   3000
      Width           =   4335
   End
   Begin VB.CommandButton Command1 
      Caption         =   "�򿪳���ʵʱ������WMI��"
      Height          =   495
      Left            =   720
      TabIndex        =   0
      Top             =   2280
      Width           =   4335
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "    ����ʵʱ�����������ַ�ʽ��"
      Height          =   1815
      Left            =   360
      TabIndex        =   1
      Top             =   120
      Width           =   5295
   End
End
Attribute VB_Name = "frmChoose"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
frmWatch.Show
Unload Me
End Sub

Private Sub Command2_Click()
If frmMain.exitproc("ProcessRTA.exe") = True Then
  strShare = "ProcessRTA"
  SuperSleep 1
 strShare = "ProcessRTA.Show"
Else
  Shell App.Path & "\ProcessRTA.exe"
End If
Unload Me
End Sub

Private Sub Form_Load()
Label1.Caption = "����ʵʱ����ӵ�����ַ�ʽ��" & vbCrLf _
& "1.WMI���� �ŵ㣺�ȶ��Ը� ȱ�㣺ֻ����ͬһʱ������ͬһ�����̣��п��ܷ���ľ�����У����п���ռ��10%��20%��ϵͳ��Դ" & vbCrLf _
& "2.Ring0 Hook���� �ŵ㣺д��ϵͳ�ײ㣬�������ܸߣ�ռ����Դ�� ȱ�㣺���ȶ����ڴ򿪵����ļ�ʱ���ܳ����ӳ١�ͣ�͵�����" & vbCrLf _
& "��ѡ��һ�����������WMI���Ӱ���������Ring0 Hook���Ӱ�������Ľ��̣��뾡����Ҫ�������������򿪣���ֹ����ϵͳ����"

End Sub
