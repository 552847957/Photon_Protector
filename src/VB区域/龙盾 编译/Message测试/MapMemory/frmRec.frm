VERSION 5.00
Begin VB.Form frmRec 
   Caption         =   "消息接受窗体"
   ClientHeight    =   1920
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   3630
   LinkTopic       =   "Form1"
   ScaleHeight     =   1920
   ScaleWidth      =   3630
   StartUpPosition =   3  '窗口缺省
   Begin VB.TextBox Text2 
      Height          =   270
      Left            =   240
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   840
      Width           =   2655
   End
   Begin VB.TextBox Text1 
      Height          =   270
      Left            =   360
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   360
      Width           =   2535
   End
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   720
      Top             =   1200
   End
End
Attribute VB_Name = "frmRec"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Const LenStr As Long = 65535 * 10
Dim strShare As String
Private Sub Form_Load()
hMemShare2 = CreateFileMapping(&HFFFFFFFF, _
        0, _
        PAGE_READWRITE, _
         0, _
        LenStr, _
        "PhotonMemorySpace")
    If hMemShare2 = 0 Then
        'Err.LastDllError
        MsgBox "创建内存映射文件失败!", vbCritical, "错误"
    End If
    If (Err.LastDllError = ERROR_ALREADY_EXISTS) Then
        '指定内存文件已存在
    End If
    
    lShareData2 = MapViewOfFile(hMemShare2, FILE_MAP_WRITE, 0, 0, 0)
    If lShareData2 = 0 Then
        MsgBox "为映射文件对象创建视失败!", vbCritical, "错误"
    End If
Timer1.Enabled = True
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If lShareData2 <> 0 Then
        Call UnmapViewOfFile(ByVal lShareData2) '解除映射
        lShareData2 = 0
    End If
    
    If hMemShare2 <> 0 Then
        Call CloseHandle(hMemShare2) '关闭映射
        hMemShare2 = 0
    End If
End Sub
Public Function ReadMem() As String
    sData = String(LenStr, vbNullChar)
    Call lstrcpyn(ByVal sData, ByVal lShareData2, LenStr)
    ReadMem = sData
End Function

Private Sub WriteMem(ByVal Text)
    sData = Text
    Call lstrcpyn(ByVal lShareData2, ByVal sData, LenStr)
End Sub

Private Sub Timer1_Timer()
Text2.Text = ReadMem()
strShare = Text2.Text
If strShare = Text1.Text Then Exit Sub
Text1.Text = strShare
DoCommand Text1.Text
End Sub
Private Sub DoCommand(ByVal Text As String)
If Text = "ProcessRTA.Open" Then
'运行自动加载。。。
ElseIf Text = "ProcessRTA.Unload" Then

Unload MYRECEIVER
Unload Me
End If
End Sub

