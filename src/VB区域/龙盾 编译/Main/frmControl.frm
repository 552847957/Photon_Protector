VERSION 5.00
Begin VB.Form frmControl 
   ClientHeight    =   1515
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   3420
   Icon            =   "frmControl.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   1515
   ScaleWidth      =   3420
   StartUpPosition =   3  '����ȱʡ
End
Attribute VB_Name = "frmControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Function CallMode(ByVal mode) As Boolean
On Error Resume Next
Dim Pid As Double
Pid = 0
Select Case mode
Case 1
'����ʵʱ����
If exitproc("ProcessRTA.exe") = True Then
  strShare = "ProcessRTA"
  SuperSleep 1
  strShare = "ProcessRTA.Unload"
  Call WriteString("Main", "ProcessRTA", 0, IniPath)
  Call ShowTip("���ӷ�����", "����/����ʵʱ�����ѹر�", 4)
Else
  If Not Dir(App.Path & "\ProcessRTA.exe") = "" Then
  Pid = Shell(App.Path & "\ProcessRTA.exe")
  End If
  Call WriteString("Main", "ProcessRTA", 1, IniPath)
  Call ShowTip("���ӷ�����", "����/����ʵʱ�����ѿ���", 4)
End If

Case 2
'����ʵʱ����
If exitproc("ProcessRTA.exe") = True Then
'  Auto.Enabled = False
  strShare = "ProcessRTA"
  SuperSleep 1
  strShare = "ProcessRTA.Unload"
  'MsgBox "��Ǹ����ʱ�޷��رգ�������Ŭ�����������⣬�����󽫹رա�", vbOK, "���ӷ�����"
  Call WriteString("Main", "ProcessRTA", 0, IniPath)
  Call ShowTip("���ӷ�����", "����/����ʵʱ�����ѹر�", 4)
Else
  If Not Dir(App.Path & "\ProcessRTA.exe") = "" Then
  Pid = Shell(App.Path & "\ProcessRTA.exe")
  End If
  Call WriteString("Main", "ProcessRTA", 1, IniPath)
  Call ShowTip("���ӷ�����", "����/����ʵʱ�����ѿ���", 4)
End If

Case 3
'ע���ʵʱ����

If exitproc("RegRTA.exe") = True Then
  strShare = "RegRTA"
  SuperSleep 1
  strShare = "RegRTA.Unload"
  Call WriteString("Main", "RegRTA", 0, IniPath)
  Call ShowTip("���ӷ�����", "ע���ʵʱ�����ѹر�", 4)
Else
  '����ģ��
  If Not Dir(App.Path & "\RegRTA.exe") = "" Then
  Pid = Shell(App.Path & "\RegRTA.exe")
  End If
  Call WriteString("Main", "RegRTA", 1, IniPath)
  Call ShowTip("���ӷ�����", "ע���ʵʱ�����ѿ���", 4)
End If
Case 4
If exitproc("USBRTA.exe") = True Then
  strShare = "USBRTA"
  SuperSleep 1
  strShare = "USBRTA.Close"
  Call WriteString("Main", "USBRTA", 0, IniPath)
  Call ShowTip("���ӷ�����", "U�̲�������ѹر�", 4)
Else
  If Not Dir(App.Path & "\USBRTA.exe") = "" Then
  Pid = Shell(App.Path & "\USBRTA.exe")
  End If
  Call WriteString("Main", "USBRTA", 1, IniPath)
  Call ShowTip("���ӷ�����", "U�̲�������ѿ���", 4)
End If
Case 5
If exitproc("ProtectProcess.exe") = True Then
  strShare = "Protect"
  SuperSleep 1
  strShare = "Protect.Unload"
  Call ShowTip("���ӷ�����", "���ұ����ѹر�", 4)
Else
  If Not Dir(App.Path & "\Protect.exe") = "" Then
  Pid = Shell(App.Path & "\Protect.exe")
  End If
  Call ShowTip("���ӷ�����", "���ұ����ѿ���", 4)
End If
End Select
SuperSleep 1
strShare = "Protect"
SuperSleep 1
strShare = "Protect.ReLoad"

frmMain.ReRead
End Function

