Attribute VB_Name = "mdProcessScan"

Public Function ProcessScan(ByVal Path As String) As String
'=========����ɨ��ģ��========
'����ֵ���ͣ�
'��ȫ��SAFE
'����Error
'���������ز������ݣ���ʽ��������|��������
'=========��������========
'On Error GoTo Err:
DoEvents 'ת�ÿ���Ȩ
Dim Filestring As String
Dim FindString As String
Filestring = GetChecksum(Path) '����ļ�������
Debug.Print Filestring
FindString = FindVirus(Filestring) '���Ҳ���
If FindString <> "SAFE" Then '����ڲ��������ҵ�����Ӧ�Ĳ���
ProcessScan = FindString '���ز������ݣ���ʽ��������|��������
Else  '�����ȫ
ProcessScan = "SAFE"
End If
Exit Function
Err:
ProcessScan = "Error" '����������ء�ERROR��

End Function

Private Function FindVirus(ByVal MD5 As String) As String
'�Ѳ鲡����
On Error Resume Next
Set FindString = frmData.VirusData.FindItem(MD5)
If FindString Is Nothing Then  'û�ҵ�
  '���أ���SAFE��
    FindVirus = "SAFE"
    Exit Function
Else
  '���أ�������|��������
  FindVirus = frmData.VirusData.ListItems(FindString.Index).SubItems(1) & "|" & frmData.VirusData.ListItems(FindString.Index).SubItems(2)
  Exit Function
End If
FindVirus = "SAFE"

End Function

