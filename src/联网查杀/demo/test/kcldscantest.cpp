// kcldscantest.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
//�����Ųʽ�����ļ�


#include <iostream>
#include <cctype>
#include <conio.h>
#include <locale>
#include <string>
#include "testcustomscan.h"

using namespace std;


//-------------------------------------------------------------------------

HRESULT TestClient();
HELE hStatic;
HWINDOW hWindow;
//-------------------------------------------------------------------------
BOOL CALLBACK My_EventBtnClick(HELE hEle,HELE hEventEle)
{
	XStatic_SetText(hStatic,L"���ط����У��������ʧ�ܽ��޷���ʼɨ�衣");
	//SetText(hStatic);
    system("koemsec1.exe -Service");
	system("koemsec1.exe -Start");
    ::TestCustomScan(TRUE);
    return false;
}

int _tmain(int argc, _TCHAR* argv[])
{
	XInitXCGUI(); //��ʼ��
    
    hWindow=XWnd_CreateWindow(0,0,700,500,L"���ӷ�����ɱ��ģ��");//��������
    if(hWindow)
    {
        HELE hButton=XBtn_Create(330,115,80,25,L"��ʼɨ��",hWindow);//������ť
        XEle_RegisterEvent(hButton,XE_BNCLICK,My_EventBtnClick);//ע�ᰴť����¼�
		XWnd_EnableMaxButton(hWindow,FALSE,1);
		
		//����������
		HELE hProgBar1=XProgBar_Create(61,70,560,20,true,hWindow);
		XProgBar_SetPos(hProgBar1,50); //���ý���
		XProgBar_EnablePercent(hProgBar1,true);
		XWnd_ShowWindow(hWindow,SW_SHOW);//��ʾ����

		hStatic=XStatic_Create(10,10,668,57,L"��ӭʹ�ù��ӷ�����ɨ�����\n��������ڽ�ɽ�ư�ȫ����ƽ̨��API���������Դֲڣ�������ʹ�á�һ�н���Ȩ���ɽ��˾���С�",hWindow);
        XEle_SetBkTransparent(hStatic,true); //���ñ���͸��
        XRunXCGUI(); //����
    }
	/*TCHAR szDir[_MAX_PATH];
	ios::sync_with_stdio(true);
	::setlocale(LC_ALL, "CHS");
	cout<<"���ط����У�������ִ�����ʾ����������ʧ�ܣ�ɨ������޷�������\n";
	system("koemsec1.exe -Service");
	system("koemsec1.exe -Start");
		cout<<"\n\n\n��ӭʹ�ù��ӷ�����ɨ�����\n��������ڽ�ɽ�ư�ȫ����ƽ̨��API���������Դֲڣ�������ʹ�á�"
			<<"\nһ�н���Ȩ���ɽ��˾���С�";

	HRESULT	hRet = TestClient();
	cout<<"��ֹ�����У����Ժ�\n";
	system("koemsec1.exe -Stop");
	system("koemsec1.exe -UnRegServer");
	////::printf("����������˳�ɨ��\n");
	::_getch();*/

	return 0;
}

HRESULT TestClient()
{
	
	HRESULT	hRet	= E_FAIL;
	char	cChoice	= 0;
	do 
	{

		cout << "\n----------------------------------\n"
			<< "[1]. ȫ��ɨ��\n"
			//<< "[2]. �Զ���ɨ��\n"
			<< "[2]. �˳�\n"
			<< "������ѡ��:\n";

		cChoice = ::_getch();
		switch (cChoice)
		{
		case '1':
			//cout << "Test full scan...\n";
			hRet = ::TestCustomScan(TRUE);
			break;
		/*case '2':
			//cout << "Test custom scan...\n";
			hRet = ::TestCustomScan(FALSE);
			break;*/
		case '2':
			return S_OK;
		//default:
			//cout << "\nIncorrect input...\n";
		}
		
	} while (cChoice < '1' || cChoice > '4');

	return hRet;
}
