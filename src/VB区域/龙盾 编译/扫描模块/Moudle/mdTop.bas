Attribute VB_Name = "mdTop"
Declare Function SetWindowPos Lib "user32" (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Public Const SWP_NOMOVE = &H2 '���ƶ�����
Public Const SWP_NOSIZE = &H1 '���ı䴰��ߴ�
Public Const Flag = SWP_NOMOVE Or SWP_NOSIZE
Public Const HWND_TOPMOST = -1 '����������ǰ��
Public Const HWND_NOTOPMOST = -2 '���岻����ǰ��

Public Const BIF_RETURNONLYFSDIRS = 1
Public Const BIF_DONTGOBELOWDOMAIN = 2
Public Declare Function SHBrowseForFolder Lib "shell32.dll" Alias "SHBrowseForFolderA" (LpBrowseInfo As BROWSEINFO) As Long
Public Declare Function SHGetPathFromIDlist Lib "shell32.dll" Alias "SHGetPathFromIDListA" (ByVal pidl As Long, ByVal pszPath As String) As Long
Public Type BROWSEINFO
hOwner As Long
pidlroot As Long
pszDisplayName As String
lpszTitle As String
ulFlags As Long
lpfn As Long
lparam As Long
iImage As Long
End Type
Public Function GetFolder(ByVal hWnd As Long, Optional Title As String) As String
    Dim bi As BROWSEINFO
    Dim pidl As Long
    Dim folder As String
    folder = Space(255)
With bi
   If IsNumeric(hWnd) Then .hOwner = hWnd
   .ulFlags = BIF_RETURNONLYFSDIRS
   .pidlroot = 0
   If Title <> "" Then
      .lpszTitle = Title & Chr$(0)
   Else
      .lpszTitle = "ѡ��Ŀ¼" & Chr$(0)
    End If
End With
pidl = SHBrowseForFolder(bi)
If SHGetPathFromIDlist(ByVal pidl, ByVal folder) Then
    GetFolder = Left(folder, InStr(folder, Chr$(0)) - 1)
Else
    GetFolder = ""
End If
End Function
