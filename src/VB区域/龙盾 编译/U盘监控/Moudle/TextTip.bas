Attribute VB_Name = "TextTip"
Public Function ShowTextTip(ByVal VirusDes As String, ByVal singlemod As Boolean) As Boolean
'���룺�ļ�|������|��������||�ļ�|������|��������
Dim MyTip As New frmTip
With MyTip
'----------�б��ʼ��----------
    .ListView.ListItems.Clear               '����б�
    .ListView.ColumnHeaders.Clear           '����б�ͷ
    .ListView.View = lvwReport              '�����б���ʾ��ʽ
    .ListView.GridLines = True              '��ʾ������
    .ListView.LabelEdit = lvwManual         '��ֹ��ǩ�༭
    .ListView.FullRowSelect = True          'ѡ������
    .ListView.Checkboxes = True
    .ListView.ColumnHeaders.Add , , "�ļ�", .ListView.Width / 2 '���б����������
    .ListView.ColumnHeaders.Add , , "������", .ListView.Width / 2 - 100 '���б����������
    .ListView.ColumnHeaders.Add , , "��������", 0 '���б����������

If Not singlemod = True Then
ReDim Astring(UBound(Split(VirusDes, "||"))) As String
'�Ȱ����ݷָ��һ���ļ�һ���ַ���
For i = 0 To UBound(Split(VirusDes, "||"))
Astring(i) = Split(VirusDes, "||")(i)
Next
'�ٰ����ݷָ���ļ�|������|����������һ����д��Listview
For x = 0 To UBound(Astring)
AddListItem Split(Astring(x), "|")(0), Split(Astring(x), "|")(1), Split(Astring(x), "|")(2), MyTip.ListView
Next
Else
AddListItem Split(VirusDes, "|")(0), Split(VirusDes, "|")(1), Split(VirusDes, "|")(2), MyTip.ListView
End If


.Show
Do Until .Visible = False
SuperSleep 1
Loop

ShowTextTip = MyTip.ChooseMod
End With
End Function

Private Function AddListItem(ByVal FirstText As String, ByVal SecondText As String, ByVal ThirdText As String, ByRef List As ListView)
Set itm = List.ListItems.Add(, , FirstText)
itm.SubItems(1) = SecondText
itm.SubItems(2) = ThirdText
End Function



