Attribute VB_Name = "mdHardDisk"
Option Explicit

'***************************************************************************************************************
'��ȡ��ǰ�����߼��������ĸ�������·��

'GetLogicalDriveStrings˵��
'��ȡһ���ִ������а����˵�ǰ�����߼��������ĸ�������·��
'����ֵ
'Long��װ�ص�lpBuffer���ַ��������ų�����ֹ�ַ������绺�����ĳ��Ȳ�������������·�����򷵻�ֵ�ͱ��Ҫ��Ļ�������С�����ʾʧ�ܡ�������GetLastError
'������
'���� ���ͼ�˵��
'nBufferLength Long��lpBuffer�ִ��ĳ���
'lpBuffer String������װ���߼����������Ƶ��ִ���ÿ�����ֶ���һ��NULL�ַ��ָ��������һ�����ֺ���������NULL��ʾ��ֹ������ֹ��

Private Declare Function GetLogicalDriveStrings Lib "kernel32" Alias "GetLogicalDriveStringsA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long

'****************************************************************************************************************
'�ж�������������

Private Declare Function GetDriveType Lib "kernel32" Alias "GetDriveTypeA" (ByVal nDrive As String) As Long

Private Const DRIVE_UNKNOWN = 0        '�����������޷�ȷ��
Private Const DRIVE_NO_ROOT_DIR = 1 '��������Ŀ¼������
Private Const DRIVE_REMOVABLE = 2    '��������������ƶ���
Private Const DRIVE_FIXED = 3       'Ӳ��������
Private Const DRIVE_REMOTE = 4       'Network ������
Private Const DRIVE_CDROM = 5       '����������
Private Const DRIVE_RAMDISK = 6        'RAM �洢��

'****************************************************************************************************************

' CreateFile��ȡ�豸���

'����
'lpFileName                       �ļ���
'dwDesiredAccess                ���ʷ�ʽ
'dwShareMode                   ����ʽ
'ATTRIBUTES lpSecurityAttributes   ��ȫ������ָ��
'dwCreationDisposition          ������ʽ
'dwFlagsAndAttributes          �ļ����Լ���־
' hTemplateFile                ģ���ļ��ľ��

'CreateFile��������ô��ܶ࣬���������������򿪡��豸�������򣬵õ��豸�ľ����
'�����������CloseHandle�ر��豸�����
'����ͨ�ļ���������ͬ���豸�����ġ��ļ�������ʽ�̶�Ϊ��\\.\DeviceName��(ע����C�����и��ַ���д��Ϊ��\\\\.\\DeviceName��)
'DeviceName�������豸���������ڹ涨���豸����һ�¡�
'һ��أ�����CreateFile����豸���ʱ�����ʷ�ʽ��������Ϊ0��GENERIC_READ|GENERIC_WRITE
'����ʽ��������ΪFILE_SHARE_READ|FILE_SHARE_WRITE��������ʽ��������ΪOPEN_EXISTING��������������Ϊ0��NULL��

Private Declare Function CreateFile Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, lpSecurityAttributes As SECURITY_ATTRIBUTES, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Private Const GENERIC_READ = &H80000000 '������豸���ж�����
Private Const FILE_SHARE_READ = &H1    '�����ȡ����
Private Const OPEN_EXISTING = 3           '�ļ������Ѿ����ڡ����豸���Ҫ��
Private Const FILE_SHARE_WRITE = &H2    '������ļ����й������

'****************************************************************************************************************

'DeviceIoControl˵��

'��;              ʵ�ֶ��豸�ķ��ʡ���ȡ��Ϣ����������������ݵȡ�

'����
'hDevice           �豸���
'dwIoControlCode ������
'lpInBuffer        �������ݻ�����ָ��
'nInBufferSize     �������ݻ���������
'lpOutBuffer    ������ݻ�����ָ��
'nOutBufferSize ������ݻ���������
'lpBytesReturned �������ʵ�ʳ��ȵ�Ԫ����
'lpOverlapped    �ص������ṹָ��
Private Declare Function DeviceIoControl Lib "kernel32" (ByVal hDevice As Long, ByVal dwIoControlCode As Long, lpInBuffer As Any, ByVal nInBufferSize As Long, lpOutBuffer As Any, ByVal nOutBufferSize As Long, lpBytesReturned As Long, lpOverlapped As OVERLAPPED) As Long

Private Type SECURITY_ATTRIBUTES

nLength As Long                    '�ṹ��Ĵ�С
lpSecurityDescriptor As Long    '��ȫ��������һ��C-Style���ַ�������
bInheritHandle As Long          '�����������Ķ����ǿ��Ա��������ӽ���ʹ�õ�

End Type

'��ѯ�洢�豸��������������
Private Enum STORAGE_PROPERTY_ID

StorageDeviceProperty = 0       '��ѯ�豸����
StorageAdapterProperty          '��ѯ����������

End Enum

'��ѯ�洢�豸���Ե�����
Private Enum STORAGE_QUERY_TYPE

PropertyStandardQuery = 0       '��ȡ����
PropertyExistsQuery             '�����Ƿ�֧��
PropertyMaskQuery                '��ȡָ��������
PropertyQueryMaxDefined          '��֤����

End Enum

'��ѯ������������ݽṹ
Private Type STORAGE_PROPERTY_QUERY

PropertyId As STORAGE_PROPERTY_ID   '�豸/������
QueryType As STORAGE_QUERY_TYPE '��ѯ����
AdditionalParameters(0) As Byte '���������(�������������Ե�1���ֽ�)

End Type

Private Type OVERLAPPED

Internal As Long                '����������ϵͳʹ�á����ڱ���ϵͳ״̬����GetOverLappedRseult�ķ���ֵ��û������ERROR_IO_PENDINGʱ������Ϊ��Ч��
InternalHigh As Long              '��Ա����������ϵͳʹ�á����ڱ����첽�������ݵĳ��ȡ���GetOverLappedRseult����TRUEʱ������Ϊ��Ч��
offset As Long                    'ָ����ʼ�����첽������ļ���һ��λ�á���λ���Ǿ����ļ���ͷ����ƫ��ֵ���ڵ���ReadFile��WriteFile֮ǰ���������ô˷�����
OffsetHigh As Long             'ָ����ʼ�첽���䴦���ֽ�ƫ�Ƶĸ�λ�ֲ��֡�
hEvent As Long                    'ָ��һ���¼��ľ�������������������Ϊ�ź�״̬��

End Type

'�洢�豸����������
Private Enum STORAGE_BUS_TYPE

BusTypeUnknown = 0
BusTypeScsi
BusTypeAtapi
BusTypeAta
BusType1394
BusTypeSsa
BusTypeFibre
BusTypeUsb
BusTypeRAID
BusTypeMaxReserved = &H7F

End Enum

'��ѯ������������ݽṹ
Private Type STORAGE_DEVICE_DESCRIPTOR

Version As Long                 '�汾
Size As Long                    '�ṹ��С
DeviceType As Byte              '�豸����
DeviceTypeModifier As Byte    'SCSI-2������豸����
RemovableMedia As Byte       '�Ƿ���ƶ�
CommandQueueing As Byte       '�Ƿ�֧���������
VendorIdOffset As Long       '�����趨ֵ��ƫ��
ProductIdOffset As Long       '��ƷID��ƫ��
ProductRevisionOffset As Long '��Ʒ�汾��ƫ��
SerialNumberOffset As Long    '���кŵ�ƫ��
BusType As STORAGE_BUS_TYPE     '��������
RawPropertiesLength As Long     '������������ݳ���
RawDeviceProperties(0) As Byte   '�������������(�������������Ե�1���ֽ�)

End Type

'��������� IOCTL_STORAGE_QUERY_PROPERTY
Private Const IOCTL_STORAGE_BASE As Long = &H2D
Private Const METHOD_BUFFERED = 0
Private Const FILE_ANY_ACCESS = 0

'�ж����������
Public Function TellDriveType(ByVal sDriveLetter As String) As String

Select Case GetDriveType(sDriveLetter)

       Case DRIVE_UNKNOWN

       TellDriveType = "�����������޷�ȷ��"

       Case DRIVE_NO_ROOT_DIR

       TellDriveType = "��������Ŀ¼������"

       Case DRIVE_CDROM

       TellDriveType = "����������"

       Case DRIVE_FIXED

       TellDriveType = "�̶�������"

       Case DRIVE_RAMDISK

       TellDriveType = "RAM��"

       Case DRIVE_REMOTE

       TellDriveType = "Զ�̣����磩������"

       Case DRIVE_REMOVABLE

       If UCase$(Left$(sDriveLetter, 1)) = "A" Or UCase$(Left$(sDriveLetter, 1)) = "B" Then

         TellDriveType = "����"

       Else

         TellDriveType = "����"

       End If

       TellDriveType = "���ƶ������� - " & TellDriveType

       Case Else

       TellDriveType = "δ֪"

End Select

TellDriveType = TellDriveType & " - " & GetDriveBusType(sDriveLetter) & "����"

End Function

'��ȡ��������
Private Function GetDisksProperty(ByVal hDevice As Long, utDevDesc As STORAGE_DEVICE_DESCRIPTOR) As Boolean

Dim ut As OVERLAPPED
Dim utQuery As STORAGE_PROPERTY_QUERY
Dim lOutBytes As Long

With utQuery

       .PropertyId = StorageDeviceProperty
       .QueryType = PropertyStandardQuery

End With

GetDisksProperty = DeviceIoControl(hDevice, IOCTL_STORAGE_QUERY_PROPERTY, utQuery, LenB(utQuery), utDevDesc, LenB(utDevDesc), lOutBytes, ut)

End Function

Private Function CTL_CODE(ByVal lDeviceType As Long, ByVal lFunction As Long, ByVal lMethod As Long, ByVal lAccess As Long) As Long

CTL_CODE = (lDeviceType * 2 ^ 16&) Or (lAccess * 2 ^ 14&) Or (lFunction * 2 ^ 2) Or (lMethod)

End Function

'��ȡ�豸������Ϣ��ϣ���õ�ϵͳ������װ�ĸ��̶ֹ��ĺͿ��ƶ���Ӳ�̡����̺�CD/DVD-ROM/R/W�Ľӿ����͡����кš���ƷID����Ϣ��
Private Function IOCTL_STORAGE_QUERY_PROPERTY() As Long

IOCTL_STORAGE_QUERY_PROPERTY = CTL_CODE(IOCTL_STORAGE_BASE, &H500, METHOD_BUFFERED, FILE_ANY_ACCESS)

End Function

'��ȡ��������������


Public Function findUsbHardDisk() As String

Dim r&, allDrives$, JustOneDrive$, pos%, DriveType&
Dim Diskfound%              '�Ƿ��ƶ�Ӳ��
Dim AllDiskID$              'ϵͳ����Ӳ���̷�
Dim retBusType$          '������������

allDrives$ = Space$(64)     '����������

r& = GetLogicalDriveStrings(Len(allDrives$), allDrives$)   '��ȡϵͳ�����е��߼���������
allDrives$ = Left$(allDrives$, r&)                      '����β������Ŀո��ַ�

Do

       pos% = InStr(allDrives$, Chr$(0))           '����Chr(0)��λ�û�ȡ����������

       If pos% Then

         JustOneDrive$ = Left$(allDrives$, pos%) '�õ�������������Chr(0)

         pos% = InStr(JustOneDrive$, Chr$(0))

         JustOneDrive$ = Mid$(JustOneDrive$, 1, pos% - 2) '����Chr(0)��"\"

         allDrives$ = Mid$(allDrives$, pos% + 1, Len(allDrives$)) '���뱾�ε�һ���ַ���������ϡ�

         DriveType& = GetDriveType(JustOneDrive$)                 '�ж�����������

         If DriveType& = DRIVE_FIXED Then

            retBusType$ = GetDriveBusType(JustOneDrive$)

            If retBusType$ = "Usb" Then

                   AllDiskID$ = AllDiskID$ & JustOneDrive$ & "|"      '�ۼӷ��ֵ��ƶ�Ӳ���̷�
                   Diskfound% = True

            End If

         End If

       End If

Loop Until allDrives$ = "" 'ֱ�����һ��

findUsbHardDisk = AllDiskID$

End Function


