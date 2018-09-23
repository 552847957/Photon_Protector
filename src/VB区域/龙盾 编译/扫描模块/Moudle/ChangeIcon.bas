Attribute VB_Name = "ChangeIcon"
Option Explicit
Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const HKEY_CURRENT_USER = &H80000001
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_USERS = &H80000003
Public Const HKEY_PERFORMANCE_DATA = &H80000004
Public Const HKEY_CURRENT_CONFIG = &H80000005
Public Const HKEY_DYN_DATA = &H80000006
'�����Ϻ�����һЩע���ĳ������������� hKey��

Enum ValueType
REG_NONE = 0
REG_SZ = 1
REG_EXPAND_SZ = 2
REG_BINARY = 3
REG_DWORD = 4
REG_DWORD_BIG_ENDIAN = 5
REG_MULTI_SZ = 7
End Enum

'�����ö������������ dwType��

Declare Function RegCreateKey Lib "advapi32.dll" Alias "RegCreateKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, phkResult As Long) As Long   '�����������������ע��������
Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long   '������������رմ򿪵�ע���
Declare Function RegSetValue Lib "advapi32.dll" Alias "RegSetValueA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal dwType As Long, ByVal lpData As String, ByVal cbData As Long) As Long '�������������дע���ļ�ֵ





Public Function ChangeFile(ByVal Name As String, ByVal ShellPath As String, ByVal IconPath As String)
Dim ret As Long, hKey As Long, ExePath As String
ret = RegCreateKey(HKEY_CLASSES_ROOT, "." & Name, hKey) '���� .abc�ļ�
ret = RegSetValue(HKEY_CLASSES_ROOT, "." & Name, REG_SZ, Name & "file", Len(Name & "file") + 1) '�����ļ�������,ע�����һ�����֣����� "userfile"���ֽ��� + 1
ret = RegCreateKey(HKEY_CLASSES_ROOT, Name & "file", hKey)          '����"userfile"
ret = RegCreateKey(HKEY_CLASSES_ROOT, Name & "file\shell", hKey)      '�������Ĳ���
ret = RegCreateKey(HKEY_CLASSES_ROOT, Name & "file\shell\open", hKey) '���嶨�����������
ret = RegCreateKey(HKEY_CLASSES_ROOT, Name & "file\shell\open\command", hKey) '��������Ķ���
If ShellPath <> "" Then
ExePath = ShellPath        '���VB��������
ret = RegSetValue(HKEY_CLASSES_ROOT, Name & "file\shell\open\command", REG_SZ, ExePath, LenB(StrConv(ExePath, vbFromUnicode)) + 1)
'��ؼ���һ������ "userfile" �Ĵ򿪣�open)���������ǵĳ����������
          
End If
Dim iconfile
ret = RegCreateKey(HKEY_CLASSES_ROOT, Name & "file\DefaultIcon", hKey)
iconfile = IconPath
ret = RegSetValue(HKEY_CLASSES_ROOT, Name & "file\DefaultIcon", REG_SZ, iconfile, LenB(StrConv(iconfile, vbFromUnicode)) + 1)

RegCloseKey hKey
End Function
