Attribute VB_Name = "mdRoundForm"
'����API����
Public Declare Function SetWindowRgn Lib "USER32" (ByVal hWnd As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long
Public Declare Function CreateRoundRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long) As Long
Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
'����CreateRoundRectRgn���ڴ���һ��Բ�Ǿ��Σ��þ�����X1��Y1-X2��Y2ȷ����
'����X3��Y3ȷ������Բ����Բ�ǻ���
'CreateRoundRectRgn���� ���ͼ�˵��
'X1,Y1 Long���������Ͻǵ�X��Y����
'X2,Y2 Long���������½ǵ�X��Y����
'X3 Long��Բ����Բ�Ŀ��䷶Χ��0��û��Բ�ǣ������ο�ȫԲ��
'Y3 Long��Բ����Բ�ĸߡ��䷶Χ��0��û��Բ�ǣ������θߣ�ȫԲ��
'SetWindowRgn���ڽ�CreateRoundRectRgn������Բ�����򸳸�����
'DeleteObject���ڽ�CreateRoundRectRgn����������ɾ�������Ǳ�Ҫ�ģ����򲻱�Ҫ��ռ�õ����ڴ�
'����������һ��ȫ�ֱ���,������������������£�
Dim outrgn As Long
'Ȼ��ֱ��ڴ���Activate()�¼���Unload�¼����������´���
'Private Sub Form_Activate()
'Call rgnform(Me, 20, 20) '�����ӹ���
'End Sub
'Private Sub Form_Unload(Cancel As Integer)
'DeleteObject outrgn '��Բ������ʹ�õ�����ϵͳ��Դ�ͷ�
'End Sub
'���������ǿ�ʼ��д�ӹ���
Public Sub rgnform(ByVal frmbox As Form, ByVal fw As Long, ByVal fh As Long)
Dim w As Long, h As Long
w = frmbox.ScaleX(frmbox.Width, vbTwips, vbPixels)
h = frmbox.ScaleY(frmbox.Height, vbTwips, vbPixels)
outrgn = CreateRoundRectRgn(0, 0, w, h, fw, fh)
Call SetWindowRgn(frmbox.hWnd, outrgn, True)
End Sub

