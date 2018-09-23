Attribute VB_Name = "modSubClass"


'REG_SZ = 1
'REG_BINARY = 3
'REG_DOWRD = 4
'REG_MULTI_SZ = 7
'REG_EXPAND_SZ = 2
'
'\REGISTRY\MACHINE
'\REGISTRY\USER

Option Explicit
    '��ý��̵ľ��
    Private Declare Function OpenProcess Lib "KERNEL32" (ByVal dwDesiredAccess As Long, _
            ByVal blnheritHandle As Long, ByVal dwAppProcessId As Long) As Long
              
    '��ֹ����
    Private Declare Function TerminateProcess Lib "KERNEL32" (ByVal ApphProcess As Long, _
            ByVal uExitCode As Long) As Long
    '����һ��ϵͳ����
    Private Declare Function CreateToolhelp32Snapshot Lib "KERNEL32" _
            (ByVal lFlags As Long, lProcessID As Long) As Long
    '���ϵͳ�����еĵ�һ�����̵���Ϣ
    Private Declare Function ProcessFirst Lib "KERNEL32" Alias "Process32First" _
            (ByVal mSnapShot As Long, uProcess As PROCESSENTRY32) As Long
    '���ϵͳ�����е���һ�����̵���Ϣ
    Private Declare Function ProcessNext Lib "KERNEL32" Alias "Process32Next" _
            (ByVal mSnapShot As Long, uProcess As PROCESSENTRY32) As Long
    Private Type PROCESSENTRY32
        dwSize As Long
        cntUsage As Long
        th32ProcessID As Long
        th32DefaultHeapID As Long
        th32ModuleID As Long
        cntThreads As Long
        th32ParentProcessID As Long
        pcPriClassBase As Long
        dwFlags As Long
        szExeFile As String * 260&
    End Type
    Private Const TH32CS_SNAPPROCESS As Long = 2&
    Dim mresult
                                                 
Private Type POINTAPI
    x As Long
    y As Long
End Type

Private Type MINMAXINFO
    ptReserved As POINTAPI
    ptMaxSize As POINTAPI
    ptMaxPosition As POINTAPI
    ptMinTrackSize As POINTAPI
    ptMaxTrackSize As POINTAPI
End Type

Private Declare Sub CopyMemory Lib "KERNEL32" Alias "RtlMoveMemory" (pDest As Any, pSource As Any, ByVal ByteLen As Long)

Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long

Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long

Private Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long
'**************************************************************************
'��ȡSID���API����
Private Declare Function GetSidSubAuthorityCount Lib "advapi32.dll" (pSid As Any) As Long
Private Declare Function GetSidIdentifierAuthority Lib "advapi32.dll" (pSid As Any) As Long
Private Declare Function GetSidSubAuthority Lib "advapi32.dll" (pSid As Any, ByVal nSubAuthority As Long) As Long
Private Declare Function LookupAccountName Lib "advapi32.dll" Alias "LookupAccountNameA" (ByVal IpSystemName As String, ByVal IpAccountName As String, pSid As Byte, cbSid As Long, ByVal ReferencedDomainName As String, cbReferencedDomainName As Long, peUse As Integer) As Long
Private Declare Sub CopyByValMemory Lib "KERNEL32" Alias "RtlMoveMemory" (Destination As Any, ByVal Source As Long, ByVal length As Long)
'***************************************************************************
Private Declare Sub Sleep Lib "KERNEL32" (ByVal dwMilliseconds As Long)
Private Type COPYDATASTRUCT
    dwData As Long
    cbData As Long
    lpData As Long
End Type
Private Const WM_COPYDATA = &H4A
Private lpPrevWndProc As Long
Private Const WM_NCDESTROY = &H82
Private Const GWL_WNDPROC = -4
Private Const WM_HOTKEY = &H312
Private Const WM_GETMINMAXINFO = &H24
Private Const WM_USER = &H400
Public Const WM_TRAYICON = WM_USER + 123 '������Ϣ
Private Const WM_RBUTTONDOWN = &H204
Private Const WM_RBUTTONUP = &H205
Public gblnIsEnd As Boolean '�Ƿ��˳�״̬
Public gstrArray() As String '��Ϣ����
Public glngCount As Long '��Ϣ����
Public gblnIsShow As Boolean '�Ƿ���ʾ״̬

'����API

Private Declare Function Process32First Lib "KERNEL32" (ByVal hSnapShot As Long, lppe As PROCESSENTRY32) As Long
Private Declare Function Process32Next Lib "KERNEL32" (ByVal hSnapShot As Long, lppe As PROCESSENTRY32) As Long


Private Declare Sub CloseHandle Lib "KERNEL32" (ByVal hPass As Long)

'�ر�ָ�����ƵĽ���
Private Sub KillProcess(sProcess As String)
Dim lSnapShot As Long
Dim lNextProcess As Long
Dim tPE As PROCESSENTRY32
lSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0&)
If lSnapShot <> -1 Then
tPE.dwSize = Len(tPE)
lNextProcess = Process32First(lSnapShot, tPE)
Do While lNextProcess
If LCase$(sProcess) = LCase$(Left(tPE.szExeFile, InStr(1, tPE.szExeFile, Chr(0)) - 1)) Then
Dim lProcess As Long
Dim lExitCode As Long
lProcess = OpenProcess(1, False, tPE.th32ProcessID)
TerminateProcess lProcess, lExitCode
CloseHandle lProcess
End If
lNextProcess = Process32Next(lSnapShot, tPE)
Loop
CloseHandle (lSnapShot)
End If
End Sub

'��ʼִ����Ϣ����
Public Sub StartHook(hwnd As Long)
    lpPrevWndProc = SetWindowLong(hwnd, GWL_WNDPROC, AddressOf WindowProc)
End Sub

'ж����Ϣ����
Public Sub Unhook(hwnd As Long)
    If lpPrevWndProc <> 0 Then SetWindowLong hwnd, GWL_WNDPROC, lpPrevWndProc
End Sub

'��Ϣ���˺���
Private Function WindowProc(ByVal hwnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    Dim objCd As COPYDATASTRUCT
    Dim strTmp As String, strFullRegPath As String, strType As String
    Dim strValue As String, strRegType As String, strOutType As String
    Dim strProcessPath As String, strCmpData As String, strRegPath As String
    Dim strFindAllowData As String, strFindNotAllowData As String
    Select Case uMsg
        Case WM_NCDESTROY
            Unhook hwnd
        Case WM_HOTKEY
'            Call HotKeyFunctions(wParam)
'            Exit Function
        Case WM_GETMINMAXINFO
'            Dim MinMax As MINMAXINFO
'            CopyMemory MinMax, ByVal lParam, Len(MinMax)
'            MinMax.ptMinTrackSize.x = 610
'            MinMax.ptMinTrackSize.y = 420
'            CopyMemory ByVal lParam, MinMax, Len(MinMax)
'            WindowProc = 1
'            Exit Function
        Case WM_COPYDATA
            '��ȡDLL��������Ϣ
            CopyMemory objCd, ByVal lParam, Len(objCd)
            strTmp = Space(objCd.cbData)
            CopyMemory ByVal strTmp, ByVal objCd.lpData, objCd.cbData
            '����Ϣ���з���
            strType = Left(strTmp, InStr(strTmp, ":"))
            strFullRegPath = GetFullPath(strTmp)
            strProcessPath = GetRegProcessPathEx(strFullRegPath)
            strRegPath = GetRegistryPath(strFullRegPath)
            strCmpData = strProcessPath & "," & GetRegistryPath(strFullRegPath)
            strFindAllowData = IsIniDataExist("AllowPath", strCmpData, strIniFilePath)
            strFindNotAllowData = IsIniDataExist("DisAllowPath", strCmpData, strIniFilePath)
            If strFindAllowData <> "" Then
                WindowProc = 1000
                Exit Function
            End If
            If strFindNotAllowData <> "" Then
                WindowProc = 0
                Exit Function
            End If
            If gblnIsShow Then
                ReDim Preserve gstrArray(0 To glngCount)
                gstrArray(glngCount) = GetRegProcessPath(strFullRegPath) & "," & strProcessPath
                glngCount = glngCount + 1
                Do While IsArraryInitialize(gstrArray) And gblnIsShow
                    DoEvents
                    Sleep 10
                Loop
            End If
            '�Է�������Ľ��������ʾ�ʹ���
            If Not gblnIsEnd Then
                Dim DesString As String
                Select Case strType
                    Case "����ֵ:"
                        strRegType = GetRegistryType(strFullRegPath)
                        DesString = DesString & "|" & "ע���·��:" & strRegPath
                        If strValue = "^_*_*_^" Then
                            strOutType = "����"
                        Else
                            strOutType = "�޸�"
                        End If
                        'frmRegMonitor.txtRegPath.Text = strRegPath
                        If strOutType = "����" Then
                            'frmRegMonitor.txtType = "����<" & GetRegValueName(strFullRegPath) & ">" & "ֵ������<" & GetRegTypeString(strRegType) & ">"
                            DesString = DesString & "����ע���ֵ:" & GetRegValueName(strFullRegPath) & "|" & "ֵ����:" & GetRegTypeString(strRegType)
                        Else
                            'frmRegMonitor.txtType = "�޸�<" & GetRegValueName(strFullRegPath) & ">ֵΪ<" & GetRegValue(strFullRegPath) & ">ֵ������<" & GetRegTypeString(strRegType) & ">"
                            DesString = DesString & "�޸�ע���ֵ:" & GetRegValueName(strFullRegPath) & "|" & "�޸�Ϊ:" & GetRegValue(strFullRegPath) & "|" & "ֵ����:" & GetRegTypeString(strRegType)

                        End If
                    Case "ɾ��ֵ:"
                        'frmRegMonitor.txtRegPath.Text = strRegPath
                        'frmRegMonitor.txtType = "ɾ��ֵ<" & GetRegValueName(strFullRegPath) & ">"
                        'frmRegMonitor.txtProcessPath.Text = GetRegProcessPath(strFullRegPath)
                        DesString = DesString & "|" & "ע���·��:" & strRegPath & "|" _
                        & "ɾ��ע���ֵ:" & GetRegValueName(strFullRegPath) & "|" & _
                        "����·��:" & GetRegProcessPathEx(strFullRegPath)
                    Case "ɾ����:"
                        'frmRegMonitor.txtRegPath.Text = strRegPath
                        'frmRegMonitor.txtType = "ɾ����<" & GetRegValueName(strFullRegPath) & ">"
                        'frmRegMonitor.txtProcessPath.Text = GetRegProcessPath(strFullRegPath)
                        DesString = DesString & "|" & "ע���·��:" & strRegPath & "|" _
                        & "ɾ��ע�����Ŀ:" & GetRegValueName(strFullRegPath) & "|" & _
                        "����·��:" & GetRegProcessPathEx(strFullRegPath)
                    Case "������:"
                        'frmRegMonitor.txtRegPath.Text = strRegPath
                        'frmRegMonitor.txtType = "������<" & GetRegValueName(strFullRegPath) & ">"
                        'frmRegMonitor.txtProcessPath.Text = GetRegProcessPath(strFullRegPath)
                        DesString = DesString & "|" & "ע���·��:" & strRegPath & "|" _
                        & "����ע�����Ŀ:" & GetRegValueName(strFullRegPath) & "|" & _
                        "����·��:" & GetRegProcessPathEx(strFullRegPath)
                End Select
                'frmRegMonitor.txtProcessPath.Text = GetRegProcessPath(strFullRegPath)
              '  frmRegMonitor.timerCheck = True
                'gblnIsShow = True
                Debug.Print GetRegProcessPathEx(strFullRegPath)
                Debug.Print frmRegMonitor.txtType
                
              '  frmRegMonitor.Show 1
                '���û�ѡ��Ľ�����д���
                WriteLog "============="
                WriteLog Now
                WriteLog "�޸�·����" & strRegPath
                WriteLog "�޸���Ŀ��" & GetRegValueName(strFullRegPath)
                If CheckProcess(GetRegProcessPathEx(strFullRegPath), DesString) = True Then
'                    If frmRegMonitor.chkAllow.Value = 1 Then
'                        If strFindAllowData = "" Then
'                            WriteIniStr "AllowPath", GetMaxIndex("AllowPath", strIniFilePath), strCmpData, strIniFilePath
'                        End If
'                    End If
                    WindowProc = 1000
                Else
'                    If frmRegMonitor.chkAllow.Value = 1 Then
'                        If strFindNotAllowData = "" Then
'                            WriteIniStr "DisAllowPath", GetMaxIndex("DisAllowPath", strIniFilePath), strCmpData, strIniFilePath
'                        End If
'                    End If
                    WindowProc = 0
                End If
            Else
                WindowProc = 1000
            End If
            Exit Function
        Case WM_TRAYICON
            If lParam = WM_RBUTTONDOWN Then
                SetForegroundWindow hwnd
            ElseIf lParam = WM_RBUTTONUP Then
                frmRegMonitor.PopupMenu frmRegMonitor.mnuPopMenu
            End If
    End Select
    WindowProc = CallWindowProc(lpPrevWndProc, hwnd, uMsg, wParam, lParam)
End Function

'�����Ƿ��ʼ��
Public Function IsArraryInitialize(strArray() As String) As Boolean
    On Error GoTo Err
    Dim I As Long
    I = UBound(strArray)
    IsArraryInitialize = True
    Exit Function
Err:
    IsArraryInitialize = False
End Function

'��ȡָ���û���Ӧ��SID
Private Function GetSidString(ByVal strUserName) As String
    Dim strBuffer As String
    Dim pSia As Long
    Dim pSiaByte(5) As Byte
    Dim pSid(512) As Byte
    Dim pSubAuthorityCount As Long
    Dim bSubAuthorityCount As Byte
    Dim pAuthority As Long
    Dim lAuthority As Long
    Dim lngReturn As Long
    Dim pDomain As Long
    Dim I As Integer, dAuthority As Long
    lngReturn = LookupAccountName(vbNullString, strUserName, pSid(0), 512, pDomain, 512, 1)
    pSia = GetSidIdentifierAuthority(pSid(0))
    CopyByValMemory pSiaByte(0), pSia, 6
    strBuffer = "S-" & pSid(0) & "-" & pSiaByte(5)
    pSubAuthorityCount = GetSidSubAuthorityCount(pSid(0))
    CopyByValMemory bSubAuthorityCount, pSubAuthorityCount, 1
    For I = 0 To bSubAuthorityCount - 1
        pAuthority = GetSidSubAuthority(pSid(0), I)
        CopyByValMemory lAuthority, pAuthority, LenB(lAuthority)
        dAuthority = lAuthority
        If ((lAuthority And &H80000000) <> 0) Then
            dAuthority = lAuthority And &H7FFFFFFF
            dAuthority = dAuthority + 2 ^ 31
        End If
        strBuffer = strBuffer & "-" & dAuthority
    Next
    GetSidString = strBuffer
End Function

'�Ƴ�ĳ����Ϣ
Public Sub RemoveItem(ByVal strItem As String)
    Dim I As Long, strArray() As String, j As Long
    For I = 0 To glngCount - 1
        If gstrArray(I) <> strItem Then
            ReDim Preserve strArray(0 To j)
            strArray(j) = gstrArray(I)
            j = j + 1
        End If
    Next
    Erase gstrArray
    glngCount = j
    gstrArray = strArray
End Sub



Public Function CheckProcess(ByVal ProcessPath As String, ByVal ResString As String) As Boolean

On Error GoTo Err:
Dim YesNo As Boolean
Dim ID As String, Result As String
Result = ReadString("RegRules", """" & ProcessPath & """", App.Path & "\Rules.ini")
If Result = "" Then 'û�м�¼��������һ��Ĭ�ϵļ�¼
  WriteString "RegRules", """" & ProcessPath & """", "2", App.Path & "\Rules.ini"
End If
'���¶�ȡ
Result = ReadString("RegRules", """" & ProcessPath & """", App.Path & "\Rules.ini")
 If Result = "1" Then '���εĶ���
 WriteLog "����Ŀ�꣺" & """" & ProcessPath & """" & "����ע����ѷ���"
 CheckProcess = True
 Exit Function
 ElseIf Result = "0" Then '�����εĶ���
 WriteLog "������Ŀ�꣺" & """" & ProcessPath & """" & "����ע����ѽ�ֹ"
 CheckProcess = False
 Exit Function
 ElseIf Result = "3" Then 'Ҫɱ���Ķ���
 WriteLog "������Ŀ�꣺" & """" & ProcessPath & """" & "����ע����ѽ�������"
 KillIt (ProcessPath)
 CheckProcess = False
 Exit Function
 End If
 'Ĭ��2
 '���в���ɨ��
 Dim ScanResult
 ScanResult = ProcessScan(ProcessPath)
 If ScanResult <> "SAFE" And ScanResult <> "Error" Then
  
   Dim VirusForm As New frmVirusTip
    VirusForm.PicIcon = GetIconFromFile(ProcessPath, 0, True)
    VirusForm.Tip.Caption = "���ֲ�������д��ע����ѱ����������������أ�"
    VirusForm.TextRes.Text = ProcessPath & vbCrLf & Replace(ResString, "|", vbCrLf)
    
    VirusForm.Show vbModal
    If VirusForm.ChooseMod = True Then 'ɱ��
     Call SetAttr(ProcessPath, vbNormal)
     Call KillIt(ProcessPath)
     Call Kill(ProcessPath)
     WriteLog "��ɾ��"
    Else '��ɱ��
     Call SetAttr(ProcessPath, vbNormal)
     Call KillIt(ProcessPath)
     WriteLog "δɾ�����ѽ�������"
    End If
     WriteLog "������" & ProcessPath
     WriteLog "����������" & ScanResult
     CheckProcess = False
     Exit Function
Else
Dim MyForm As New frmTip
MyForm.PicIcon = GetIconFromFile(ProcessPath, 0, True)
MyForm.Text1.Text = Replace(ResString, "|", vbCrLf)
Dim MyFSO As New FileSystemObject
Dim StrDrv As String
StrDrv = Left(ProcessPath, 3)
If Right(StrDrv, 2) <> ":\" Then '������Ǳ�׼·����
  MyForm.Option2.Value = True
MyForm.Tip = "���ɽ������ڲ���ע����벻Ҫ�������������ĳ��򣡲���ע���ᵼ�²������򿪻����еȡ�"
GoTo Kip:
End If
If MyFSO.GetDrive(StrDrv).DriveType <> Fixed Then '����ǲ��Ǳ��س��ֵĶ���
 MyForm.Option2.Value = True
MyForm.Tip = "�Ǳ��ش��������еĽ������ڲ���ע����벻Ҫ���������������ļ�������ע���ᵼ�²������򿪻����еȡ�"
Else
 MyForm.Option1.Value = True
MyForm.Tip = "���ش��������еĽ������ڲ���ע����벻Ҫ���������������ļ��������ڱ��ش����У�������ϵͳ�Զ����еĳ���Ĭ��30����С�"
End If
Kip:
MyForm.Command1.Caption = "��"
MyForm.Show vbModal

'���ѡ���Ժ�Ҳ��ô����
If MyForm.ChooseNum <> 1 And MyForm.ChooseNum <> 2 Then
Dim MyForm2 As New frmTip
MyForm2.PicIcon = GetIconFromFile(ProcessPath, 0, True)
   If MyForm.ChooseNum = 3 Then
   WriteString "RegRules", """" & ProcessPath & """", "1", App.Path & "\Rules.ini"
   MyForm2.Text1 = "�ļ���" & ProcessPath & vbCrLf & "�Ѿ���ӵ������������ֵ������б������أ���ɨ�衣"
   WriteLog "Ŀ�꣺" & """" & ProcessPath & """" & "��ӵ������б�"
   ElseIf MyForm.ChooseNum = 4 Then
   MyForm2.Text1 = "�ļ���" & ProcessPath & vbCrLf & "�Ѿ���ӵ������������ֵĺ������б���ֹ���У���ֹ����"
   If MyForm.KillPro = True Then '���ѡ������ֹ
   WriteString "RegRules", """" & ProcessPath & """", "3", App.Path & "\Rules.ini"
   WriteLog "Ŀ�꣺" & """" & ProcessPath & """" & "��ӵ��Զ����������б�"
   Else
   WriteString "RegRules", """" & ProcessPath & """", "0", App.Path & "\Rules.ini"
   WriteLog "Ŀ�꣺" & """" & ProcessPath & """" & "��ӵ��������б�"
   End If
   End If
MyForm2.Option1.Visible = False
MyForm2.Option2.Visible = False
MyForm2.Check1.Visible = False
MyForm2.Check2.Visible = False
MyForm2.Command2.Caption = "��֪����"
MyForm2.Label2.Visible = False
MyForm2.Label3.Caption = "��ӹ���"
MyForm2.Show
End If

If MyForm.ChooseNum = 1 Then
WriteLog "Ŀ�꣺" & """" & ProcessPath & """" & "�ѷ���"
CheckProcess = True
ElseIf MyForm.ChooseNum = 2 Then
WriteLog "Ŀ�꣺" & """" & ProcessPath & """" & "����ֹ"
CheckProcess = False
ElseIf MyForm.ChooseNum = 3 Then
WriteLog "Ŀ�꣺" & """" & ProcessPath & """" & "�ѷ���"
CheckProcess = True
ElseIf MyForm.ChooseNum = 4 Then
WriteLog "Ŀ�꣺" & """" & ProcessPath & """" & "����ֹ"
CheckProcess = False
End If
If MyForm.KillPro = True Then
WriteLog "Ŀ�꣺" & """" & ProcessPath & """" & "�ѽ�������"
KillIt (ProcessPath)
End If

End If
Err:
End Function

Public Function KillIt(ByVal ProcessPath As String)
On Error Resume Next
    Dim uProcess As PROCESSENTRY32
    Dim mSnapShot As Long
    Dim mName As String
    Dim I As Integer
    Dim mlistitem As ListItem
    Dim Msg As String
    DoEvents
    '��ȡ���̳��ȣ���
    uProcess.dwSize = Len(uProcess)
    '����һ��ϵͳ����
    mSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0&)
    If mSnapShot Then
        '��ȡ��һ������
        mresult = ProcessFirst(mSnapShot, uProcess)
        'ʧ���򷵻�false
        Do While mresult
            '���ؽ��̳���ֵ+1��Chr(0)�����ã��������ֹ�޸Ľ���
            I = InStr(1, uProcess.szExeFile, Chr(0))
            'ת����Сд
            mName = LCase$(Left$(uProcess.szExeFile, I - 1))
            '��listview�ؼ�����ӵ�ǰ������
            '��ӽ�����
            If LCase(GetProcessPath(mName)) = LCase(ProcessPath) Then
            KillProcess (mName)
            End If

            '��ȡ��һ������
            mresult = ProcessNext(mSnapShot, uProcess)
        Loop
    Else
        ErrMsgProc (Msg)
    End If

End Function
Sub ErrMsgProc(mMsg As String)
    MsgBox mMsg & vbCrLf & Err.Number & Space(5) & Err.Description
End Sub

Public Function WriteLog(ByVal Text As String)
Open App.Path & "\RegLog.dat" For Binary As #1
    Put #1, LOF(1) + 1, Text & vbCrLf
Close #1
End Function
