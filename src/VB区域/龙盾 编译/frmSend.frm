VERSION 5.00
Begin VB.Form frmSend 
   Caption         =   "Form1"
   ClientHeight    =   1020
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   3600
   LinkTopic       =   "Form1"
   ScaleHeight     =   1020
   ScaleWidth      =   3600
   StartUpPosition =   3  '����ȱʡ
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   255
      Left            =   2520
      TabIndex        =   1
      Top             =   720
      Width           =   735
   End
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   240
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   120
      Width           =   2775
   End
End
Attribute VB_Name = "frmSend"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'*************************************************************************
'**ģ �� ������������
'**˵    �������ݴ������ȷ�����Ͷ���,���䷢���ַ���
'**�� �� �ˣ�LionKing1990
'**��    �ڣ�2010��3��19��
'**��    ����V1.0
'**��    ע��'����API���Ҷ��������� , ��API��������治̫һ��
'*************************************************************************

'���Ҵ��ڼ�����
Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
'��ʵ��PostMessage,����Ҫ��������,'Ͷ��һ����Ϣ
Private Declare Function SendMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'��д����
Private Const PROCESS_ALL_ACCESS As Long = &H1F0FFF
Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Private Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
'�Զ������Ϣ
Private Const WM_USER = &H400
Private Const Msg_GetAddress = WM_USER + 1
Private Const Msg_GetData = WM_USER + 2
Private Const Msg_AddressReady = WM_USER + 3
'HOOK,�ܷ���
Private WithEvents Hook As cSubclass
Attribute Hook.VB_VarHelpID = -1

'��Ϣ����
Private Sub Hook_MsgCome(ByVal bBefore As Boolean, bHandled As Boolean, lReturn As Long, lng_hWnd As Long, uMsg As Long, wParam As Long, lParam As Long)
If bBefore Then
    Select Case uMsg
    Case Msg_AddressReady
        '�ڴ��������,���õ���ַ,��ʼд��
        WriteData wParam, lParam
    Case Else
    End Select
End If
End Sub


'HOOK��ʼ������
Private Sub Form_Load()
    Text1.Text = "����:Lionking1990"
    Set Hook = New cSubclass
    Hook.AddWindowMsgs Me.hwnd
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Hook.DeleteWindowMsg Me.hwnd
End Sub

