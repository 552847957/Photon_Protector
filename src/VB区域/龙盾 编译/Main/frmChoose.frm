VERSION 5.00
Begin VB.Form frmChoose 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "ȫ��ɨ��"
   ClientHeight    =   2415
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5250
   Icon            =   "frmChoose.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2415
   ScaleWidth      =   5250
   StartUpPosition =   2  '��Ļ����
   Begin VB.CommandButton Command2 
      Caption         =   "��ɽ�ư�ȫ������ɱ"
      Height          =   375
      Left            =   2880
      TabIndex        =   1
      Top             =   1800
      Width           =   1815
   End
   Begin VB.CommandButton Command1 
      Caption         =   "���ӷ������߲�ɱ"
      Height          =   375
      Left            =   480
      TabIndex        =   0
      Top             =   1800
      Width           =   1815
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   1575
      Left            =   240
      TabIndex        =   2
      Top             =   120
      Width           =   4695
   End
End
Attribute VB_Name = "frmChoose"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
frmMain.DoScan False, True, ""
Unload Me
End Sub

Private Sub Command2_Click()
If Not Dir(App.Path & "\NetScanner\Photon-NetScanner.exe") = "" Then
MsgBox "���ֶ����С�Photon-NetScanner.exe�������Է��������ʧ�ܣ�"
Shell "explorer.exe /select, """ & App.Path & "\NetScanner\Photon-NetScanner.exe""", vbNormalFocus
Else
Dim frmText As New frmMsg
frmText.Label1.Caption = "����ʧ�ܣ�������û����ȷ��װ��������������1000���Ҳ������������"
frmText.Show
End If
Unload Me
End Sub

Private Sub Form_Load()
Label1.Caption = "���ӷ�����ȫ�̲�ɱ������ģʽ��" & vbCrLf & _
                 "1.���ӷ������߲�ɱ��ʹ�����߲����⣬��ɱ�ʽϵͣ���û�������������ṩ����" & vbCrLf & _
                 "2.��ɽ�ư�ȫ������ɱ��ʹ�ý�ɽ�ư�ȫ����ƽ̨�ṩ��API��ɱ����ɱ�ʼ��ߣ��������������硣"
                 
End Sub
