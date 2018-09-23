Attribute VB_Name = "HookFunction"
Option Explicit
'д�뵽�����ļ���ȥ
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
'��ȡ�����ļ��е�ֵ
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long



'���໯������Ϣ������ʱ��Ҫʹ�õ�API���ܳ�������������˵����
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDst As Any, pSrc As Any, ByVal ByteLen As Long)

Private Const GWL_WNDPROC = -4
Private Const WM_DEVICECHANGE As Long = &H219
Private Const DBT_DEVICEARRIVAL As Long = &H8000&
Private Const DBT_DEVICEREMOVECOMPLETE As Long = &H8004&
'�豸���ͣ��߼����
Private Const DBT_DEVTYP_VOLUME As Long = &H2

'��WM_DEVICECHANGE��Ϣ������Ľṹ��ͷ����Ϣ

Private Type DEV_BROADCAST_HDR
    lSize As Long
    lDevicetype As Long   '�豸����
    lReserved As Long
End Type

'�豸Ϊ�߼���ʱ��Ӧ�Ľṹ����Ϣ
Private Type DEV_BROADCAST_VOLUME
    lSize As Long
    lDevicetype As Long
    lReserved As Long
    lUnitMask As Long   '���߼�����Ӧ������
    iFlag As Integer
End Type

Private info As DEV_BROADCAST_HDR
Private info_volume As DEV_BROADCAST_VOLUME

Private PrevProc As Long  'ԭ���Ĵ�����Ϣ��������ַ


Public Sub HookForm(f As Form)

    PrevProc = SetWindowLong(f.hwnd, GWL_WNDPROC, AddressOf WindowProc)

End Sub

Public Sub UnHookForm(f As Form)

    SetWindowLong f.hwnd, GWL_WNDPROC, PrevProc

End Sub


Private Function WindowProc(ByVal hwnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

    Select Case uMsg
    
        '����USB DISK ����յ�����Ϣ
        Case WM_DEVICECHANGE
         If wParam = DBT_DEVICEARRIVAL Then
              '������USBDISK����ӳ�������̵���
              'info.lDevicetype =2
              '��DBT_DEVTYP_VOLUME
              '���ò���lParam��ȡ�ṹ��ͷ����Ϣ
              CopyMemory info, ByVal lParam, Len(info)
             If info.lDevicetype = DBT_DEVTYP_VOLUME Then
               CopyMemory info_volume, ByVal lParam, Len(info_volume)
               '��⵽���߼�����ӵ�ϵͳ�У�����ʾ���豸��Ŀ¼��ȫ���ļ���
               Dim drivepathname
               drivepathname = Chr(GetDriveName(info_volume.lUnitMask))
Loap:
               If Dir(drivepathname & ":\") = "" Then
               SuperSleep 0.5
               GoTo Loap:
               End If
               frmUSB.Show
               frmUSB.Time = 0
               frmUSB.USB.Caption = frmUSB.USB.Caption & drivepathname & ":\;"
               Dim MyFSO As New FileSystemObject
               If ReadString("USBRTA", "CheckMod", App.Path & "\Data\Set.ini") <> "" Then
                 Dim Drv As Drive
                 Set Drv = MyFSO.GetDrive(drivepathname & ":\")
                 Debug.Print Drv.TotalSize / 1024 / 1024 / 1024
                 Dim Total As Integer
                 Total = Drv.TotalSize / 1024 / 1024 / 1024
                 If Total > 8 Then
                   frmRow.AddRow drivepathname & ":", "Sim"
                 Else '����8GB�����ɨ��
                 frmRow.AddRow drivepathname & ":", ReadString("USBRTA", "CheckMod", App.Path & "\Data\Set.ini")
                 End If
               End If
               '��ȡɨ�跽ʽ�����������������
               
             End If
         End If
         
         If wParam = DBT_DEVICEREMOVECOMPLETE Then
             '������USBDISK����ӳ�������̵���
             'info.lDevicetype =2
             '��DBT_DEVTYP_VOLUME
             '���ò���lParam��ȡ�ṹ��ͷ����Ϣ
             CopyMemory info, ByVal lParam, Len(info)
             If info.lDevicetype = DBT_DEVTYP_VOLUME Then
               CopyMemory info_volume, ByVal lParam, Len(info_volume)
               'Call ShowTip("����-U��ʵʱ����", "�ƶ��豸" & Chr(GetDriveName(info_volume.lUnitMask)) & ":\" & "�Ѱγ���", 4)
             End If
         End If
           
     End Select

    ' ����ԭ���Ĵ�����Ϣ������
    WindowProc = CallWindowProc(PrevProc, hwnd, uMsg, wParam, lParam)

End Function

'���������32λLONG�����ݣ�ֻ��һλΪ1�����ض�Ӧ�ľ���ASCII��ֵ
'������1��A��2��B��4��C�ȵ�
Private Function GetDriveName(ByVal lUnitMask As Long) As Byte
    Dim i As Long
    i = 0
    
    While lUnitMask Mod 2 <> 1
       lUnitMask = lUnitMask \ 2
       i = i + 1
    Wend
    
    GetDriveName = Asc("A") + i
End Function

'��ʾ�����߼����Ŀ¼���ļ����б���Ҫ�ڹ���������Microsoft Scripting Runtime�⡣
Private Function ListFiles(strPath As String, ByRef List As ListBox)
  Dim fso As New Scripting.FileSystemObject
  Dim objFolder As Folder
  Dim objFile As File

  Set objFolder = fso.GetFolder(strPath)

  For Each objFile In objFolder.Files
    List.AddItem strPath & objFile.Name
  Next
End Function

Public Function ListDiskFiles(strPath As String, ByRef List As ListBox)
ListFiles strPath, List
End Function

'��ini�ļ�
 Public Function ReadString(ByVal Caption As String, ByVal Item As String, ByVal Path As String) As String
    On Error Resume Next
    Dim sBuffer As String
    sBuffer = Space(32767)
    GetPrivateProfileString Caption, Item, vbNullString, sBuffer, 32766, Path
    ReadString = Left(sBuffer, InStr(sBuffer, vbNullChar) - 1)
 End Function

'дini�ļ�
 Public Function WriteString(ByVal Caption As String, ByVal Item As String, ByVal ItemValue As String, ByVal Path As String) As Long
    Dim sBuffer As String
    sBuffer = Space(32766)
    sBuffer = ItemValue & vbNullChar
    WriteString = WritePrivateProfileString(Caption, Item, sBuffer, Path)
 End Function

