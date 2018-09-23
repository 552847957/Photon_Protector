// IniControl.cpp: implementation of the IniControl class.
//
//////////////////////////////////////////////////////////////////////

//#include "stdafx.h"
//#include "prmdlg.h"
#include "IniControl.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

#define MAX_ALLSECTIONS 2048  //ȫ���Ķ���
#define MAX_SECTION 260  //һ����������
#define MAX_ALLKEYS 6000  //ȫ���ļ���
#define MAX_KEY 260  //һ����������
 
//----------------------------------------------------------------------------------
/*
 ������CIni
 �汾��v2.0
 �����£�
 v2.0
 ��С����2004��2��14�����˽�
 ����߼������Ĺ���
 v1.0
 ��С����2003��ĳ��
 һ��������
 
 ��������
 ���������.ini�ļ����в���
 */
 
//�ļ� 1:

#pragma once
 
//#include "afxTempl.h"
 
class CIni
{
private:
 CString m_strFileName;
public:
 CIni(CString strFileName):m_strFileName(strFileName)
 {
 }
public:
 //һ���Բ�����
 BOOL SetFileName(LPCTSTR lpFileName);  //�����ļ���
 CString GetFileName(void); //����ļ���
 BOOL SetValue(LPCTSTR lpSection, LPCTSTR lpKey, LPCTSTR lpValue,bool bCreate=true); //���ü�ֵ��bCreate��ָ����������δ����ʱ���Ƿ񴴽���
 CString GetValue(LPCTSTR lpSection, LPCTSTR lpKey); //�õ���ֵ.
 BOOL DelSection(LPCTSTR strSection);  //ɾ������
 BOOL DelKey(LPCTSTR lpSection, LPCTSTR lpKey);  //ɾ������
 

public:
 //�߼�������
 int GetSections(CStringArray& arrSection);  //ö�ٳ�ȫ���Ķ���
 int GetKeyValues(CStringArray& arrKey,CStringArray& arrValue,LPCTSTR lpSection);  //ö�ٳ�һ���ڵ�ȫ��������ֵ
 
 BOOL DelAllSections();
 
};



BOOL CIni::SetFileName(LPCTSTR lpFileName)
{
 CFile file;
 CFileStatus status;
 
 if(!file.GetStatus(lpFileName,status))
  return TRUE;
 
 m_strFileName=lpFileName;
 return FALSE;
}
 
CString CIni::GetFileName(void)
{
 return m_strFileName;
}
 
BOOL CIni::SetValue(LPCTSTR lpSection, LPCTSTR lpKey, LPCTSTR lpValue,bool bCreate)
{
 TCHAR lpTemp[MAX_PATH] ={0};
 
 //����if����ʾ�������bCreateΪfalseʱ����û���������ʱ�򷵻�TRUE����ʾ����
 //!*&*none-value*&!* ���Ǹ������ַ�û���ر����壬������д�Ƿ�ֹ������ͬ��
 if (!bCreate)
 {
  GetPrivateProfileString(lpSection,lpKey,"!*&*none-value*&!*",lpTemp,MAX_PATH,m_strFileName);
  if(strcmp(lpTemp,"!*&*none-value*&!*")==0)
   return TRUE;
 }
 
 if(WritePrivateProfileString(lpSection,lpKey,lpValue,m_strFileName))
  return FALSE;
 else
  return GetLastError();
}
 
CString CIni::GetValue(LPCTSTR lpSection, LPCTSTR lpKey)
{
 DWORD dValue;
 TCHAR lpValue[MAX_PATH] ={0};
 
 dValue=GetPrivateProfileString(lpSection,lpKey,"",lpValue,MAX_PATH,m_strFileName);
 return lpValue;
}
 
BOOL CIni::DelSection(LPCTSTR lpSection)
{
 if(WritePrivateProfileString(lpSection,NULL,NULL,m_strFileName))
  return FALSE;
 else
  return GetLastError();
}
 
BOOL CIni::DelKey(LPCTSTR lpSection, LPCTSTR lpKey)
{
 if(WritePrivateProfileString(lpSection,lpKey,NULL,m_strFileName))
  return FALSE;
 else
  return GetLastError();
}
 

int CIni::GetSections(CStringArray& arrSection)
{
 /*
 ������������
 GetPrivateProfileSectionNames - �� ini �ļ��л�� Section ������
 ��� ini �������� Section: [sec1] �� [sec2]���򷵻ص��� 'sec1',0,'sec2',0,0 �����㲻֪��  
 ini ������Щ section ��ʱ���������� api ����ȡ���� 
 */
 int i;  
 int iPos=0;  
 int iMaxCount;
 TCHAR chSectionNames[MAX_ALLSECTIONS]={0}; //�ܵ���������ַ���
 TCHAR chSection[MAX_SECTION]={0}; //���һ��������
 GetPrivateProfileSectionNames(chSectionNames,MAX_ALLSECTIONS,m_strFileName);
 
 //����ѭ�����ضϵ�����������0
 for(i=0;i<MAX_ALLSECTIONS;i++)
 {
  if (chSectionNames[i]==0)
   if (chSectionNames[i]==chSectionNames[i+1])
    break;
 }
 
 iMaxCount=i+1; //Ҫ��һ��0��Ԫ�ء����ҳ�ȫ���ַ����Ľ������֡�
 arrSection.RemoveAll();//���ԭ����
 
 for(i=0;i<iMaxCount;i++)
 {
  chSection[iPos++]=chSectionNames[i];
  if(chSectionNames[i]==0)
  {   
   arrSection.Add(chSection);
   memset(chSection,0,MAX_SECTION);
   iPos=0;
  }
 
 }
 
 return (int)arrSection.GetSize();
}
 
int CIni::GetKeyValues(CStringArray& arrKey,CStringArray& arrValue, LPCTSTR lpSection)
{
 /*
 ������������
 GetPrivateProfileSection- �� ini �ļ��л��һ��Section��ȫ��������ֵ��
 ���ini����һ���Σ������� "��1=ֵ1" "��2=ֵ2"���򷵻ص��� '��1=ֵ1',0,'��2=ֵ2',0,0 �����㲻֪��  
 ���һ�����е����м���ֵ����������� 
 */
 int i;  
 int iPos=0;
 CString strKeyValue;
 int iMaxCount;
 TCHAR chKeyNames[MAX_ALLKEYS]={0}; //�ܵ���������ַ���
 TCHAR chKey[MAX_KEY]={0}; //�������һ������
 
 GetPrivateProfileSection(lpSection,chKeyNames,MAX_ALLKEYS,m_strFileName);
 
 for(i=0;i<MAX_ALLKEYS;i++)
 {
  if (chKeyNames[i]==0)
   if (chKeyNames[i]==chKeyNames[i+1])
    break;
 }
 
 iMaxCount=i+1; //Ҫ��һ��0��Ԫ�ء����ҳ�ȫ���ַ����Ľ������֡�
 arrKey.RemoveAll();//���ԭ����
 arrValue.RemoveAll();
 
 for(i=0;i<iMaxCount;i++)
 {
  chKey[iPos++]=chKeyNames[i];
  if(chKeyNames[i]==0)
  {
   strKeyValue=chKey;
   arrKey.Add(strKeyValue.Left(strKeyValue.Find("=")));
   arrValue.Add(strKeyValue.Mid(strKeyValue.Find("=")+1));
   memset(chKey,0,MAX_KEY);
   iPos=0;
  }
 
 }
 
 return (int)arrKey.GetSize();
}
 
BOOL CIni::DelAllSections()
{
 int nSection;
 CStringArray arrSection;
 nSection=GetSections(arrSection);
 for(int i=0;i<nSection;i++)
 {
  if(DelSection(arrSection[i]))
   return GetLastError();
 }
 return FALSE;
}

/*
ʹ�÷�����
CIni ini("c:\\a.ini");
int n;

/*���ֵ
TRACE("%s",ini.GetValue("��1","��1"));
 */

/*���ֵ
ini.SetValue("�Զ����","��1","ֵ");
ini.SetValue("�Զ����2","��1","ֵ",false);
 */

/*ö��ȫ������
CStringArray arrSection;
n=ini.GetSections(arrSection);
for(int i=0;i<n;i++)
TRACE("%s\n",arrSection[i]);
 */

/*ö��ȫ��������ֵ
CStringArray arrKey,arrValue;
n=ini.GetKeyValues(arrKey,arrValue,"��1");
for(int i=0;i<n;i++)
TRACE("����%s\nֵ��%s\n",arrKey[i],arrValue[i]);
*/

/*ɾ����ֵ
ini.DelKey("��1","��1");
*/

/*ɾ����
ini.DelSection("��1");
*/

/*ɾ��ȫ��
ini.DelAllSections();
*/
*/
