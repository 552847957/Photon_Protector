VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "����-�ƶ��������ļ����޸�����"
   ClientHeight    =   5325
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7020
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   Picture         =   "Form1.frx":0CCA
   ScaleHeight     =   5325
   ScaleWidth      =   7020
   StartUpPosition =   2  '��Ļ����
   Begin VB.Frame Frame1 
      BackColor       =   &H00FFFFFF&
      Caption         =   "�޸��ļ���"
      Height          =   3735
      Left            =   240
      TabIndex        =   0
      Top             =   1440
      Width           =   6495
      Begin VB.CommandButton Command1 
         Caption         =   "�޸�"
         Height          =   375
         Left            =   5160
         TabIndex        =   2
         Top             =   3240
         Width           =   1215
      End
      Begin VB.ListBox List1 
         Height          =   2760
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   6255
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
DoEvents
Dim Path As String
For x = 0 To List1.ListCount - 1
Path = List1.List(x)
Call SetAttr(Path, vbNormal)
FileCopy App.Path & "\Folder\desktop.ini", Path & "\desktop.ini"
FileCopy App.Path & "\Folder\�ļ��а�ȫ��֤ͼ��.ico", Path & "\�ļ��а�ȫ��֤ͼ��.ico"
Call SetAttr(Path, vbSystem)
Next
MsgBox "�޸��ɹ�", vbInformation, "�����"
Unload Me
End Sub

Private Sub Form_Load()
Dim I As Drive
Dim MyFSO As New FileSystemObject
For Each I In MyFSO.Drives
If MyFSO.GetDrive(I).DriveType = Removable Then
ShowFolderList (I)
End If
Next
End Sub
Public Sub ShowFolderList(folderspec)
     Dim fs, f, f1, s, sf
     Dim hs, h, h1, hf
     Set fs = CreateObject("Scripting.FileSystemObject")
     Set f = fs.GetFolder(folderspec)
     Set sf = f.SubFolders
     For Each f1 In sf
     Form1.List1.AddItem folderspec & f1.Name
     Next
End Sub
