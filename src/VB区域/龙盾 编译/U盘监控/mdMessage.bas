Attribute VB_Name = "mdMessage"
Public strShare As New CSharedString

Public Function StartMis(ByVal Path As String, ByVal way As Integer)
'Path:The path of the usb driver.
'Way:The message type of click
If way = 1 Then '��U��
If Dir(Path) <> "" Then
OpenFile Path, , vbNormalFocus
Else
MsgBox "·������ȷ����U��ʧ�ܣ�"
End If
ElseIf way = 2 Then '�޸�U��
FixUSB Path
'Shell App.Path & "\ScanMod.exe"
'strShare = "ScanMod"
'SuperSleep 1
'strShare = "ScanMod.Scan.Adv" & Path
ElseIf way = 3 Then '�˳�U��
RemoveUSB Path
End If
frmMain.ReReadDrv
End Function

Public Function FixUSB(ByVal Path As String)
On Error Resume Next
DoEvents
Form1.Label1.Caption = "������������ ������"
                WriteLog now & ":"
                WriteLog "--�޸����ƶ��豸" & Path
SuperSleep 1
Dim OldPath
OldPath = Path
     Dim fs, f, f1, s, sf
     Dim hs, h, h1, hf
     Set fs = CreateObject("Scripting.FileSystemObject")
     Set f = fs.GetFolder(OldPath)
     Set sf = f.SubFolders
     For Each f1 In sf
     If Right(OldPath, 1) = "\" Then
     Path = OldPath & f1.Name
     Else
     Path = OldPath & "\" & f1.Name
     End If
     Debug.Print Path
     DoEvents
Call SetAttr(Path, vbNormal)
FileCopy App.Path & "\desktop.dll", Path & "\desktop.ini"
FileCopy App.Path & "\�ļ��а�ȫ��֤ͼ��.dll", Path & "\�ļ��а�ȫ��֤ͼ��.ico"
Call SetAttr(Path, vbSystem)
Debug.Print App.Path & "\desktop.dll" & "----" & Path & "\desktop.ini"
     Next
OpenFile OldPath, , vbNormalFocus
Form1.Label1.Caption = "������������ U�̼��"

End Function

Public Function RemoveUSB(ByVal Path As String)
    Dim lngLenPath As Long, blnIsUsb As Boolean, strPath As String
    lngLenPath = Len(Path)
    If lngLenPath <= 3 And Dir(Path, 1 Or 2 Or 4 Or vbDirectory) <> "" Then
        If lngLenPath = 2 Then
            If GetDriveBusType(Path) <> "Usb" Then
             '   MsgBox "ֻ�ܽ���USB�豸��������", vbCritical, "����"
                
                Exit Function
            End If
            strPath = Path & "\"
        ElseIf lngLenPath = 1 Then
            If GetDriveBusType(Path & ":") <> "Usb" Then
            '    MsgBox "ֻ�ܽ���USB�豸��������", vbCritical, "����"
                
                Exit Function
            End If
            strPath = Path & ":\"
        Else
            If GetDriveBusType(Left(Path, 2)) <> "Usb" Then
               ' MsgBox "ֻ�ܽ���USB�豸������", vbCritical, "����"
                txtUsbDrive.SetFocus
                Exit Function
            End If
            strPath = Path
        End If
        blnIsUsb = True
    Else
     '   MsgBox "USB�̷�������Ҫ��", vbCritical, "����"
        
        Exit Function
    End If
    '����ֻ��Ȿ������Ϊ�ڻ�ȡ���������͵�ʱ����һ���������WINDOWSû���Լ��ر������������
    '�����������Ȼ��Ҳ����ʹ��CloseLoackFiles������������н���
    If CloseLockFileHandle(Left(strPath, 2), GetCurrentProcessId) Then
        If blnIsUsb Then
            If RemoveUsbDrive("\\.\" & Left(strPath, 2), True) Then
                'MsgBox "ж��UBS�豸�ɹ���", , "��ʾ"
            Else
                'MsgBox "ж��UBS�豸ʧ�ܣ�", vbCritical, "��ʾ"
            End If
        End If
    Else
       ' MsgBox "�����������ļ���û������", vbCritical, "��ʾ"
    End If
End Function
