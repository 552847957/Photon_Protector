VERSION 5.00
Begin VB.Form frmInit 
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   2265
   ClientLeft      =   60
   ClientTop       =   0
   ClientWidth     =   5430
   ControlBox      =   0   'False
   Icon            =   "frmInit.frx":0000
   LinkTopic       =   "Form1"
   Picture         =   "frmInit.frx":145F5
   ScaleHeight     =   2265
   ScaleWidth      =   5430
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��Ļ����
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   360
      Top             =   1800
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "����"
         Size            =   12
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1800
      TabIndex        =   0
      Top             =   1800
      Width           =   3375
   End
End
Attribute VB_Name = "frmInit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
On Error Resume Next
If App.PrevInstance Then
 MsgBox "�Ѿ����������򣬽�ֹ�ظ��������������ɲ���Ԥ֪��ϵͳ���ش���", vbOKOnly, "���ӷ�����"
 End
End If
Shell "regsvr32 /s """ & App.Path & "\GDirectUI.dll"""
App.TaskVisible = False
Me.Hide
If Command = "-start" Then
frmMain.Hide
Else
frmMain.Show
End If
frmRec.Show

Timer1.Enabled = True
End Sub

Private Sub Timer1_Timer()
On Error Resume Next

IniPath = App.Path & "\Set.ini"
Label1.Caption = "���ط�����Ŀ�С������Ժ�"

Dim ProPid As Double, Pid As Double
Pid = 0
ProPid = 0
If Not exitproc("Protect.exe") = True Then
ProPid = Shell(App.Path & "Protect.exe")
End If

If ReadString("Main", "ProcessRTA", IniPath) = 1 Then
 Pid = Shell(App.Path & "\ProcessRTA.exe")
End If

If ReadString("Main", "RegRTA", IniPath) = 1 Then
Pid = Shell(App.Path & "\RegRTA.exe")
End If

If ReadString("Main", "USBRTA", IniPath) = 1 Then
 Pid = Shell(App.Path & "\USBRTA.exe")
End If

If Not Dir(App.Path & "\Protect.exe") = "" Then
Shell App.Path & "\Protect.exe"
Else
MsgBox "����ţ�1000����δ�ҵ�������޷��������̱����������°�װ�������"
End If

strShare = "Protect"
SuperSleep 1
strShare = "Protect.ReLoad"

Timer1.Enabled = False
Unload Me
End Sub

