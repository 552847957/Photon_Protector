VERSION 5.00
Begin VB.Form MainForm 
   Caption         =   "����ٳ��޸�"
   ClientHeight    =   8025
   ClientLeft      =   165
   ClientTop       =   825
   ClientWidth     =   4380
   LinkTopic       =   "Form1"
   ScaleHeight     =   8025
   ScaleWidth      =   4380
   StartUpPosition =   3  '����ȱʡ
   Begin VB.ListBox List1 
      Height          =   7980
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   4455
   End
   Begin VB.Label Label1 
      Height          =   135
      Left            =   120
      TabIndex        =   1
      Top             =   0
      Visible         =   0   'False
      Width           =   135
   End
   Begin VB.Menu YW_Regedit_File 
      Caption         =   "�ļ�(&F)"
      Begin VB.Menu YW_Regedit_File_New 
         Caption         =   "�½�(&N)"
      End
      Begin VB.Menu YW_Regedit_File_Refresh 
         Caption         =   "ˢ��(&E)"
      End
      Begin VB.Menu YW_Regedit_File_OneOk 
         Caption         =   "һ���޸�"
      End
      Begin VB.Menu YW_Regedit_File_Delimiter1 
         Caption         =   "-"
      End
      Begin VB.Menu YW_Regedit_File_Close 
         Caption         =   "�رճ���(&C)"
      End
   End
   Begin VB.Menu YW_Regedit_RightMenu 
      Caption         =   "�Ҽ��˵�"
      Visible         =   0   'False
      Begin VB.Menu YW_Regedit_RightMenu_Point 
         Caption         =   "ָ��"
      End
      Begin VB.Menu YW_Regedit_RightMenu_Delete 
         Caption         =   "ɾ��"
      End
   End
End
Attribute VB_Name = "MainForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
'��ע���
Dim YW_Regedit_Return As Long
YW_Regedit_Return = RegOpenKey(HKEY_LOCAL_MACHINE, _
"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options", _
YW_Regedit_Hkey) '��ע���
If YW_Regedit_Return <> 0 Then
MsgBox ("��ע���ʧ��!")
End
End If

Select Case Command
Case ""
Case "-Quiet"
Me.Hide
Call YW_Regedit_Scanning
Call YW_Regedit_File_OneOk_Click
Case "-quiet"
Me.Hide
Call YW_Regedit_Scanning
Call YW_Regedit_File_OneOk_Click
End Select
Call YW_Regedit_Scanning
If List1.ListCount = 0 Then
MsgBox "û�о���ٳֵ���"
End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
Dim YW_Regedit_Return As Long
YW_Regedit_Return = RegCloseKey(YW_Regedit_Hkey)
If YW_Regedit_Return <> 0 Then
MsgBox ("�ر�ע���ʧ��!")
End If
End Sub

Private Sub List1_Click()
YW_Regedit_Focus2 = List1.List(List1.ListIndex)
PopupMenu YW_Regedit_RightMenu
End Sub

Private Sub YW_Regedit_File_Close_Click()
End
End Sub

Private Sub YW_Regedit_File_OneOk_Click()
On Error GoTo YW_Regedit_File_OneOk_Click_Error
Dim YW_Regedit_File_OneOk_Click1 As Long
For YW_Regedit_File_OneOk_Click1 = 1 To List1.ListCount
YW_Regedit_RightMenu_Delete_Click1 = RegDeleteKey( _
YW_Regedit_Hkey, List1.List(YW_Regedit_File_OneOk_Click1 - 1))
If YW_Regedit_RightMenu_Delete_Click1 <> 0 Then
MsgBox ("ɾ��ʧ��")
Exit For
End If
Next
Call YW_Regedit_Scanning
Exit Sub
YW_Regedit_File_OneOk_Click_Error:
MsgBox ("�޷�ɾ����ֵ!")
Call YW_Regedit_Scanning
End Sub

Private Sub YW_Regedit_File_Refresh_Click()
On Error GoTo YW_Regedit_File_Refresh_Click_Error
Call YW_Regedit_Scanning
Exit Sub
YW_Regedit_File_Refresh_Click_Error:
MsgBox ("�޷�����ɨ��ģ��!")
End Sub

Private Sub YW_Regedit_RightMenu_Delete_Click()
On Error GoTo YW_Regedit_RightMenu_Delete_Click_Error
Dim YW_Regedit_RightMenu_Delete_Click1 As Long
YW_Regedit_RightMenu_Delete_Click1 = MsgBox("ȷ��ɾ��?", 33)
If YW_Regedit_RightMenu_Delete_Click1 = 1 Then
YW_Regedit_RightMenu_Delete_Click1 = RegDeleteKey( _
YW_Regedit_Hkey, YW_Regedit_Focus2)
If YW_Regedit_RightMenu_Delete_Click1 = 0 Then
MsgBox ("ɾ���ɹ�")
Else
MsgBox ("ɾ��ʧ��")
End If
Call YW_Regedit_Scanning
End If
Exit Sub
YW_Regedit_RightMenu_Delete_Click_Error:
MsgBox ("�޷�ɾ����ֵ!")
Call YW_Regedit_Scanning
End Sub

Private Sub YW_Regedit_File_New_Click()
On Error GoTo YW_Regedit_File_New_Error
Dim YW_Regedit_RightMenu_New_Click1 As Long
Dim YW_Regedit_RightMenu_New_Click3 As String
Dim YW_Regedit_RightMenu_New_Click4 As String
Dim YW_Regedit_RightMenu_New_Click5 As Long
YW_Regedit_RightMenu_New_Click3 = InputBox("����������:", "����ٳ��޸�")
YW_Regedit_RightMenu_New_Click4 = InputBox("������ָ���ַ:", "����ٳ��޸�")
YW_Regedit_RightMenu_New_Click1 = RegCreateKey(YW_Regedit_Hkey, _
YW_Regedit_RightMenu_New_Click3, YW_Regedit_RightMenu_New_Click5)
If YW_Regedit_RightMenu_New_Click1 = 0 Then
YW_Regedit_RightMenu_New_Click1 = RegSetValueEx(YW_Regedit_RightMenu_New_Click5, _
"Debugger", 0, REG_SZ, ByVal YW_Regedit_RightMenu_New_Click4, _
Len(YW_Regedit_RightMenu_New_Click4))
Else
MsgBox ("д��ע���ʱ��������!")
End If
If YW_Regedit_RightMenu_New_Click1 = 0 Then
MsgBox ("д��ע���ɹ�")
Else
MsgBox ("д��ע���ʱ��������!")
End If

Call YW_Regedit_Scanning
Exit Sub
YW_Regedit_File_New_Error:
MsgBox ("�޷��½���ֵ!")
Call YW_Regedit_Scanning
End Sub

Private Sub YW_Regedit_RightMenu_Point_Click()
On Error GoTo YW_Regedit_RightMenu_Point_Click_Error
Dim YW_Regedit_RightMenu_Point_Click1 As Long
Dim YW_Regedit_RightMenu_Point_Click2 As Long
Dim YW_Regedit_RightMenu_Point_Click3 As Long
Dim YW_Regedit_RightMenu_Point_Click4 As String
YW_Regedit_RightMenu_Point_Click1 = RegOpenKey(HKEY_LOCAL_MACHINE, _
"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\" & _
YW_Regedit_Focus2, YW_Regedit_RightMenu_Point_Click2)
If YW_Regedit_RightMenu_Point_Click1 = 0 Then
YW_Regedit_RightMenu_Point_Click4 = Space(REG_SIZE)
YW_Regedit_RightMenu_Point_Click1 = RegQueryValueEx(YW_Regedit_RightMenu_Point_Click2, _
"Debugger", 0, YW_Regedit_RightMenu_Point_Click3, _
ByVal YW_Regedit_RightMenu_Point_Click4, REG_SIZE)
If YW_Regedit_RightMenu_Point_Click1 = 0 Then
MsgBox ("ָ��->" & YW_Regedit_RightMenu_Point_Click4)
Else
MsgBox ("��ȡע���ʱ��������!")
End If
Else
MsgBox ("��ע���ʱ��������!")
Exit Sub
End If
Call YW_Regedit_Scanning
Exit Sub
YW_Regedit_RightMenu_Point_Click_Error:
MsgBox ("�޷���ȡ��ֵ!")
Call YW_Regedit_Scanning
End Sub
