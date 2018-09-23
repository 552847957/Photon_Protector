Attribute VB_Name = "modRemoveUsbDrive"
Option Explicit
'****************************************************************************************************************
'��ģ������������
'****************************************************************************************************************
'�ж�������������
Private Declare Function GetDriveType Lib "kernel32" Alias "GetDriveTypeA" (ByVal nDrive As String) As Long
Private Const DRIVE_UNKNOWN = 0        '�����������޷�ȷ��
Private Const DRIVE_NO_ROOT_DIR = 1    '��������Ŀ¼������
Private Const DRIVE_REMOVABLE = 2      '��������������ƶ���
Private Const DRIVE_FIXED = 3          'Ӳ��������
Private Const DRIVE_REMOTE = 4         'Network ������
Private Const DRIVE_CDROM = 5          '����������
Private Const DRIVE_RAMDISK = 6        'RAM �洢��
'****************************************************************************************************************
' CreateFile��ȡ�豸���
'����
'lpFileName                       �ļ���
'dwDesiredAccess                  ���ʷ�ʽ
'dwShareMode                      ����ʽ
'ATTRIBUTES lpSecurityAttributes  ��ȫ������ָ��
'dwCreationDisposition            ������ʽ
'dwFlagsAndAttributes             �ļ����Լ���־
' hTemplateFile                   ģ���ļ��ľ��
'CreateFile��������ô��ܶ࣬���������������򿪡��豸�������򣬵õ��豸�ľ����
'�����������CloseHandle�ر��豸�����
'����ͨ�ļ���������ͬ���豸�����ġ��ļ�������ʽ�̶�Ϊ��\\.\DeviceName��(ע����C�����и��ַ���д��Ϊ��[url=]\\\\.\\DeviceName[/url]��)
'DeviceName�������豸���������ڹ涨���豸����һ�¡�
'һ��أ�����CreateFile����豸���ʱ�����ʷ�ʽ��������Ϊ0��GENERIC_READ|GENERIC_WRITE
'����ʽ��������ΪFILE_SHARE_READ|FILE_SHARE_WRITE��������ʽ��������ΪOPEN_EXISTING��������������Ϊ0��NULL��
Private Declare Function CreateFile Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, lpSecurityAttributes As Any, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Private Const GENERIC_READ = &H80000000   '������豸���ж�����
Private Const FILE_SHARE_READ = &H1       '�����ȡ����
Private Const OPEN_EXISTING = 3           '�ļ������Ѿ����ڡ����豸���Ҫ��
Private Const FILE_SHARE_WRITE = &H2      '������ļ����й������
'****************************************************************************************************************
'DeviceIoControl˵��
'��;              ʵ�ֶ��豸�ķ��ʡ���ȡ��Ϣ����������������ݵȡ�
'����
'hDevice           �豸���
'dwIoControlCode   ������
'lpInBuffer        �������ݻ�����ָ��
'nInBufferSize     �������ݻ���������
'lpOutBuffer       ������ݻ�����ָ��
'nOutBufferSize    ������ݻ���������
'lpBytesReturned   �������ʵ�ʳ��ȵ�Ԫ����
'lpOverlapped      �ص������ṹָ��
Private Declare Function DeviceIoControl Lib "kernel32" (ByVal hDevice As Long, ByVal dwIoControlCode As Long, lpInBuffer As Any, ByVal nInBufferSize As Long, lpOutBuffer As Any, ByVal nOutBufferSize As Long, lpBytesReturned As Long, lpOverlapped As OVERLAPPED) As Long
Private Type SECURITY_ATTRIBUTES
    nLength As Long                    '�ṹ��Ĵ�С
    lpSecurityDescriptor As Long       '��ȫ��������һ��C-Style���ַ�������
    bInheritHandle As Long             '�����������Ķ����ǿ��Ա��������ӽ���ʹ�õ�
End Type
'��ѯ�洢�豸��������������
Private Enum STORAGE_PROPERTY_ID
    StorageDeviceProperty = 0          '��ѯ�豸����
    StorageAdapterProperty             '��ѯ����������
End Enum
'��ѯ�洢�豸���Ե�����
Private Enum STORAGE_QUERY_TYPE
    PropertyStandardQuery = 0          '��ȡ����
    PropertyExistsQuery                '�����Ƿ�֧��
    PropertyMaskQuery                  '��ȡָ��������
    PropertyQueryMaxDefined            '��֤����
End Enum
'��ѯ������������ݽṹ
Private Type STORAGE_PROPERTY_QUERY
    PropertyId As STORAGE_PROPERTY_ID  '�豸/������
    QueryType As STORAGE_QUERY_TYPE    '��ѯ����
    AdditionalParameters(0) As Byte    '���������(�������������Ե�1���ֽ�)
End Type
Private Type OVERLAPPED
    Internal As Long                  '����������ϵͳʹ�á����ڱ���ϵͳ״̬����GetOverLappedRseult�ķ���ֵ��û������ERROR_IO_PENDINGʱ������Ϊ��Ч��
    InternalHigh As Long              '��Ա����������ϵͳʹ�á����ڱ����첽�������ݵĳ��ȡ���GetOverLappedRseult����TRUEʱ������Ϊ��Ч��
    offset As Long                    'ָ����ʼ�����첽������ļ���һ��λ�á���λ���Ǿ����ļ���ͷ����ƫ��ֵ���ڵ���ReadFile��WriteFile֮ǰ���������ô˷�����
    OffsetHigh As Long                'ָ����ʼ�첽���䴦���ֽ�ƫ�Ƶĸ�λ�ֲ��֡�
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
    DeviceTypeModifier As Byte      'SCSI-2������豸����
    RemovableMedia As Byte          '�Ƿ���ƶ�
    CommandQueueing As Byte         '�Ƿ�֧���������
    VendorIdOffset As Long          '�����趨ֵ��ƫ��
    ProductIdOffset As Long         '��ƷID��ƫ��
    ProductRevisionOffset As Long   '��Ʒ�汾��ƫ��
    SerialNumberOffset As Long      '���кŵ�ƫ��
    BusType As STORAGE_BUS_TYPE     '��������
    RawPropertiesLength As Long     '������������ݳ���
    RawDeviceProperties(0) As Byte  '�������������(�������������Ե�1���ֽ�)
End Type
'���������   IOCTL_STORAGE_QUERY_PROPERTY
Private Const IOCTL_STORAGE_BASE As Long = &H2D
Private Const METHOD_BUFFERED = 0
Private Const FILE_ANY_ACCESS = 0
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
Public Function GetDriveBusType(ByVal strDriveLetter As String) As String
    Dim hDevice As Long
    Dim utDevDesc As STORAGE_DEVICE_DESCRIPTOR
    hDevice = CreateFile("\\.\" & strDriveLetter, GENERIC_READ, FILE_SHARE_READ Or FILE_SHARE_WRITE, ByVal 0&, OPEN_EXISTING, 0, 0)
    If hDevice <> -1 Then
        utDevDesc.Size = LenB(utDevDesc)
        Call GetDisksProperty(hDevice, utDevDesc)
        Select Case utDevDesc.BusType
            Case BusType1394
                GetDriveBusType = "1394"
            Case BusTypeAta
                GetDriveBusType = "Ata"
            Case BusTypeAtapi
                GetDriveBusType = "Atapi"
            Case BusTypeFibre
                GetDriveBusType = "Fibre"
            Case BusTypeRAID
                GetDriveBusType = "RAID"
            Case BusTypeScsi
                GetDriveBusType = "Scsi"
            Case BusTypeSsa
                GetDriveBusType = "Ssa"
            Case BusTypeUsb
                GetDriveBusType = "Usb"
            Case BusTypeUnknown
                GetDriveBusType = "δ֪"
            Case Else
        End Select
        Call CloseHandle(hDevice)
    End If
End Function
