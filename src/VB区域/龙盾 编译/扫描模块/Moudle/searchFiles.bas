Attribute VB_Name = "searchFiles"

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
Private Sub Showfilelist(folderspec)
     Dim fs, f, f1, fc, s
     Set fs = CreateObject("Scripting.FileSystemObject")
     Set f = fs.GetFolder(folderspec)
     Set fc = f.Files
     For Each f1 In fc
     'List1.AddItem f1.Name
     Next
End Sub


'����ĳ�ļ��м����ļ����е������ļ�
Public Sub sousuofile(MyPath As String)
On Error Resume Next
DoEvents 'ת�ÿ���Ȩ����ֹ������

Dim Myname As String
Dim a As String
Dim B() As String
Dim dir_i() As String
Dim I, idir As Long
If Right(MyPath, 1) <> "\" Then MyPath = MyPath + "\"
Myname = Dir(MyPath, vbDirectory Or vbNormal Or vbHidden Or vbReadOnly Or vbSystem)
Do While Myname <> ""
If Myname <> "." And Myname <> ".." Then
If (GetAttr(MyPath & Myname) And vbDirectory) = vbDirectory Then '����ҵ�����Ŀ¼
idir = idir + 1
ReDim Preserve dir_i(idir) As String
dir_i(idir - 1) = Myname
Else

'frmMain.lstFiles.AddItem MyPath & Myname   '���ҵ����ļ���ʾ���б����

End If
End If
Myname = Dir '������һ��
Loop
For I = 0 To idir - 1
Call sousuofile(MyPath + dir_i(I))
Next I
ReDim dir_i(0) As String
End Sub

       '��������Դ���Ŀ¼�е��ļ�
       'Fn.Name       '�õ��ļ���
       'Fn.Size       '�õ��ļ���С
       'Fn.Path       '�õ��ļ�·��
       'Fn.Type       '�õ��ļ�����
       'Fn.DateLastModified       '�õ��ļ������޸�����

