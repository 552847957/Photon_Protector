VERSION 5.00
Begin VB.Form Killer 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  '����ȱʡ
End
Attribute VB_Name = "Killer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public KillName As String
Private Sub Form_Load()
Me.Hide
On Error Resume Next
Do Until KillName <> ""
SuperSleep 1
Loop
Call Kill(KillName)
If Dir(KillName) = "" Then
WriteProLog "�ɹ�ɾ��" & KillName
Else
WriteProLog KillName & "ɾ��ʧ��"
End If
Unload Me
End Sub
