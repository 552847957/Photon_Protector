Attribute VB_Name = "DllMod"
Option Explicit
'Download by http://www.codefans.net
Function DLLMain(ByVal hinstDLL As Long, ByVal fdwReason As Long, ByVal lpvReserved As Long) As Long

        Const DLL_PROCESS_ATTACH     As Long = 1

        Const DLL_THREAD_ATTACH     As Long = 2

        Const DLL_PROCESS_DETACH    As Long = 0

        Const DLL_THREAD_DETACH     As Long = 3
 
        If fdwReason = DLL_PROCESS_ATTACH Then 'dll����
                CreateIExprSrvObj 0, 4, 0
                Call KillvbaSetSystemError '
                
                CreateProcessAddr = HookOn("kernel32", "CreateProcessInternalW", GetFunAddr(AddressOf CreateProcessCallBack), GetFunAddr(AddressOf CreateProcessJmpBack)) 'Hook
                DLLhandle = hinstDLL
                
                Call GetDllfilepath '�õ���DLL·��
                
                MapMemFile
                
                GetData ShareMem

        ElseIf fdwReason = DLL_PROCESS_DETACH Then  'dllж��
                'CreateIExprSrvObj 0, 4, 0
                Call HookOff(CreateProcessAddr)
        End If

        '7C80235D  |.  E8 4E740100   call    CreateProcessInternalW

        DLLMain = 1
End Function

Sub Main()

End Sub


