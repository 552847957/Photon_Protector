Attribute VB_Name = "mdTwipToPixel"

Option Explicit
Private Declare Function apiGetDC Lib "user32" Alias "GetDC" _
(ByVal hwnd As Long) As Long
Private Declare Function apiReleaseDC Lib "user32" Alias "ReleaseDC" _
(ByVal hwnd As Long, ByVal hdc As Long) As Long
Private Declare Function apiGetDeviceCaps Lib "gdi32" Alias "GetDeviceCaps" _
(ByVal hdc As Long, ByVal nIndex As Long) As Long

Private Const LOGPIXELSX = 88
Private Const LOGPIXELSY = 90

Public Const DIRECTION_VERTICAL = 1
Public Const DIRECTION_HORIZONTAL = 0

'===============================================================================
'-��������:         gFunTwipsToPixels
'-��������:         ת���̵�����
'-�������˵��:     ����1:rlngTwips Long ��Ҫת���ĵ�
'                   ����2:rlngDirection Long DIRECTION_VERTICAL��Y���� DIRECTION_HORIZONTALΪX����
'-���ز���˵��:     ת��������ֵ
'-ʹ���﷨ʾ��:     gFunTwipsToPixels 50,DIRECTION_VERTICAL
'-�ο�:
'-ʹ��ע��:
'-������:           97,2000,XP compatible
'-����:             ����磨�ο�΢��KB)���Ľ��������
'-�������ڣ�        2002-08-26 ,2002-11-15
'===============================================================================
Function gFunTwipsToPixels(rlngTwips As Long, rlngDirection As Long) As Long
On Error GoTo Err_gFunTwipsToPixels
Dim lngDeviceHandle As Long
Dim lngPixelsPerInch As Long
lngDeviceHandle = apiGetDC(0)
If rlngDirection = DIRECTION_HORIZONTAL Then  'ˮƽX����
lngPixelsPerInch = apiGetDeviceCaps(lngDeviceHandle, LOGPIXELSX)
Else       '��ֱY����
lngPixelsPerInch = apiGetDeviceCaps(lngDeviceHandle, LOGPIXELSY)
End If
lngDeviceHandle = apiReleaseDC(0, lngDeviceHandle)
gFunTwipsToPixels = rlngTwips / 1440 * lngPixelsPerInch
Exit_gFunTwipsToPixels:
On Error Resume Next
Exit Function
Err_gFunTwipsToPixels:
MsgBox Err.Description, vbOKOnly + vbCritical, "Error: " & Err.Number
Resume Exit_gFunTwipsToPixels
End Function
'===============================================================================
'-��������:         gFunPixelsToTwips
'-��������:         ת�����ص���
'-�������˵��:     ����1:rlngPixels Long ��Ҫת��������
'                   ����2:rlngDirection Long DIRECTION_VERTICAL��Y���� DIRECTION_HORIZONTALΪX����
'-���ز���˵��:     ת�����ֵ
'-ʹ���﷨ʾ��:     gFunPixelsToTwips 50,DIRECTION_VERTICAL
'-�ο�:
'-ʹ��ע��:
'-������:           97,2000,XP compatible
'-����:             ����磨�ο�΢��KB)���Ľ��������
'-�������ڣ�        2002-08-26 ,2002-11-15
'===============================================================================
Function gFunPixelsToTwips(rlngPixels As Long, rlngDirection As Long) As Long
On Error GoTo Err_gFunPixelsToTwips
Dim lngDeviceHandle As Long
Dim lngPixelsPerInch As Long
lngDeviceHandle = apiGetDC(0)
If rlngDirection = DIRECTION_HORIZONTAL Then  'ˮƽX����
lngPixelsPerInch = apiGetDeviceCaps(lngDeviceHandle, LOGPIXELSX)
Else       '��ֱY����
lngPixelsPerInch = apiGetDeviceCaps(lngDeviceHandle, LOGPIXELSY)
End If
lngDeviceHandle = apiReleaseDC(0, lngDeviceHandle)
gFunPixelsToTwips = rlngPixels * 1440 / lngPixelsPerInch
Exit_gFunPixelsToTwips:
On Error Resume Next
Exit Function
Err_gFunPixelsToTwips:
MsgBox Err.Description, vbOKOnly + vbCritical, "Error: " & Err.Number
Resume Exit_gFunPixelsToTwips
End Function


