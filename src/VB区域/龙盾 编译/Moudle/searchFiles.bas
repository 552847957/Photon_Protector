Attribute VB_Name = "searchFiles"
Public FilePathGroup(1000000) As String
Public filePathNum
Public Sub ShowFolderList(folderspec)
     Dim fs, f, f1, s, sf
     Dim hs, h, h1, hf
     Set fs = CreateObject("Scripting.FileSystemObject")
     Set f = fs.GetFolder(folderspec)
     Set sf = f.SubFolders
     For Each f1 In sf
     'frmMain.lstFiles.AddItem folderspec & f1.Name
     Next
End Sub



'����ĳ�ļ����µ��ļ�
Public Sub Showfilelist(folderspec, List As ListBox)
     Dim fs, f, f1, fc, s
     Set fs = CreateObject("Scripting.FileSystemObject")
     Set f = fs.GetFolder(folderspec)
     Set fc = f.Files
     For Each f1 In fc
     If selectover = True Then Exit Sub
     If frmMain.StopScan = True Then
   Do Until frmMain.StopScan = False Or frmMain.TeScan = True
   SuperSleep 1
   Loop
   If frmMain.StopScan = False Then
   End If
   If frmMain.TeScan = True Then
   frmMain.Lbl_Object.Caption = ""
   frmMain.Lbl_Status.Caption = "��ֹ"
   frmMain.Lbl_Target.Caption = "����"
   selectover = True
   
   FileList.ListItems.Remove 1
   frmMain.Time.Enabled = False
   frmRow.DoClean
   Exit Sub
   End If
   End If
     
FilePathGroup(filePathNum) = f1.Name
frmMain.Lbl_Status.Caption = "�����ļ���......" & FilePathGroup(filePathNum)
filePathNum = filePathNum + 1
     Next
End Sub


'����ĳ�ļ��м����ļ����е������ļ�
Public Sub sousuofile(MyPath As String, List As ListBox)
On Error Resume Next
DoEvents 'ת�ÿ���Ȩ����ֹ������
Dim Myname As String
Dim a As String
Dim b() As String
Dim dir_i() As String
Dim i, idir As Long


If Right(MyPath, 1) <> "\" Then MyPath = MyPath + "\"
Myname = Dir(MyPath, vbDirectory Or vbNormal Or vbHidden Or vbReadOnly Or vbSystem)
Do While Myname <> ""
If Myname <> "." And Myname <> ".." Then
If (GetAttr(MyPath & Myname) And vbDirectory) = vbDirectory Then '����ҵ�����Ŀ¼
idir = idir + 1
ReDim Preserve dir_i(idir) As String
dir_i(idir - 1) = Myname
Else
If selectover = True Then Exit Sub
If frmMain.StopScan = True Then
   Do Until frmMain.StopScan = False Or frmMain.TeScan = True
   SuperSleep 1
   Loop
   If frmMain.StopScan = False Then
   End If
   If frmMain.TeScan = True Then
   frmMain.Lbl_Object.Caption = ""
   frmMain.Lbl_Status.Caption = "��ֹ"
   frmMain.Lbl_Target.Caption = "����"
   selectover = True
   
   FileList.ListItems.Remove 1
   frmMain.Time.Enabled = False
   frmRow.DoClean
   Exit Sub
   End If
End If
FilePathGroup(filePathNum) = MyPath & Myname
'List.AddItem MyPath & Myname   '���ҵ����ļ���ʾ���б����
frmMain.Lbl_Status.Caption = "�����ļ���......" & FilePathGroup(filePathNum)
filePathNum = filePathNum + 1
End If
End If
Myname = Dir '������һ��
Loop
For i = 0 To idir - 1
Call sousuofile(MyPath + dir_i(i), List)
Next i
ReDim dir_i(0) As String
End Sub

       '��������Դ���Ŀ¼�е��ļ�
       'Fn.Name       '�õ��ļ���
       'Fn.Size       '�õ��ļ���С
       'Fn.Path       '�õ��ļ�·��
       'Fn.Type       '�õ��ļ�����
       'Fn.DateLastModified       '�õ��ļ������޸�����

