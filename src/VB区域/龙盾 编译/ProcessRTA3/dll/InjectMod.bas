Attribute VB_Name = "InjectMod"
'Download by http://www.codefans.net
Option Explicit
'dllע�����
'api����ģ��
'
'��ɫ��Ӱ  ����
'www.rekersoft.cn
'
'������ 2008/05/06
'�������������ڷ���ҵ��;��
'�뱣�����а�Ȩ��Ϣ��лл��

'����ѧ�� ����΢С�Ķ� 2010/7/19


Public Const MEM_COMMIT = 4096

Public Const MEM_DECOMMIT = &H4000

Public Const PAGE_READWRITE = 4


Public Declare Function VirtualAllocEx Lib "kernel32" (ByVal hProcess As Long, ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As Long

Public Declare Function VirtualFreeEx Lib "kernel32" (ByVal hProcess As Long, ByVal lpAddress As Long, ByVal dwSize As Long, ByVal dwFreeType As Long) As Long
'������api����������Ŀ������з���һ�οհ��ڴ湩����ʹ�á���vb��api����������Ҳ����ġ�

Public Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long

Public Declare Function GetModuleHandle Lib "kernel32" Alias "GetModuleHandleA" (ByVal lpModuleName As String) As Long
'�õ�������ַ��dllģ���ַ

Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Long, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
'����ע��lpBaseAddress�Ĵ��ͷ�ʽ��byval����api������е������ǲ�һ���ġ� _
 byval�Ǵ�ֵ��Ĭ����byref�Ǵ�ַ��Ҳ���Ǵ��ݵ��ǲ������ڴ��еĵ�ַ

Public Declare Function CreateRemoteThread Lib "kernel32" (ByVal hProcess As Long, ByVal lpThreadAttributes As Long, ByVal dwStackSize As Long, ByVal lpStartAddress As Long, ByVal lpParameter As Long, ByVal dwCreationFlags As Long, lpThreadId As Long) As Long

Public Declare Function GetModuleFileName Lib "kernel32" Alias "GetModuleFileNameA" (ByVal hModule As Long, ByVal lpFileName As String, ByVal nSize As Long) As Long

Public MyDllFileName As String

Public MyDllFileLength         As Long   'dll�ļ�������



Public Sub GetDllfilepath()

        Dim tmp As Long

        MyDllFileName = Space$(255)
        tmp = GetModuleFileName(DLLhandle, MyDllFileName, 255)
        If tmp <> 0 Then
            MyDllFileName = Left$(MyDllFileName, tmp)
            MyDllFileLength = strlen(ByVal MyDllFileName)
        End If

End Sub

Public Sub InjectMyself(ByVal Process As Long)

        'ע���ӳ���

        Dim MyDllFileBuffer         As Long   'д��dll�ļ������ڴ��ַ

        Dim MyAddr                  As Long   'ִ��Զ���̴߳������ʼ��ַ���������LoadLibraryA�ĵ�ַ

        Dim MyReturn                As Long
        
        Dim MyResult As Long
        
        '�õ����̵ľ��
        If Process = 0 Then GoTo errhandle
        
        MyDllFileBuffer = VirtualAllocEx(Process, 0, MyDllFileLength + 1, MEM_COMMIT, PAGE_READWRITE)
        '��Ŀ��������������һ��հ��ڴ������ڴ����ʼ��ַ������MyDllFileBuffer�С� _
         ����ڴ����������������dll�ļ�·��������Ϊ�������ݸ�LoadLibraryA��

        If MyDllFileBuffer = 0 Then GoTo errhandle
        
        MyReturn = WriteProcessMemory(Process, MyDllFileBuffer, ByVal (MyDllFileName), MyDllFileLength + 1, ByVal 0)
        '�ڷ���������ڴ�������д��dll·������ע��ڶ����������ݵ���MyDllFileBuffer�����ݣ� _
         ������MyDllFileBuffer���ڴ��ַ?

        If MyReturn = 0 Then GoTo errhandle

        MyAddr = GetProcAddress(GetModuleHandle("Kernel32"), "LoadLibraryA")
        '�õ�LoadLibraryA��������ʼ��ַ�����Ĳ����������Ǹղ�д���dll·��������LoadLibraryA�����ǲ�֪������������ġ� _
         ���������Ǿ���CreateRemoteThread������������������������?

        If MyAddr = 0 Then GoTo errhandle

        MyResult = CreateRemoteThread(Process, 0, 0, MyAddr, MyDllFileBuffer, 0, 0)
        '����,������CreateRemoteThread��Ŀ����̴���һ���̣߳��߳���ʼ��ַָ��LoadLibraryA�� _
         ��������MyDllFileBuffer�б����dll·��?


errhandle:
        Exit Sub
End Sub

