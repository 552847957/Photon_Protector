Attribute VB_Name = "mdTop"
Declare Function SetWindowPos Lib "user32" (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Public Const SWP_NOMOVE = &H2 '���ƶ�����
Public Const SWP_NOSIZE = &H1 '���ı䴰��ߴ�
Public Const Flag = SWP_NOMOVE Or SWP_NOSIZE
Public Const HWND_TOPMOST = -1 '����������ǰ��
Public Const HWND_NOTOPMOST = -2 '���岻����ǰ��

