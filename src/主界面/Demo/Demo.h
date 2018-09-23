#pragma once

#include "resource.h"


class CXPage1 : public CXEventMsg  //��������
{
public:
	HELE  m_hEle;
	HELE  m_hPane_right;
	HELE  m_hBtn_all_opened;  //ʵʱ�����ѿ���

	void  Create();
	void  CreateListView();
	void  CreateRightBottom();

	void  AdjustLayout();
};


//��ɱľ��
class CXPage2 : public CXEventMsg 
{
public:
	HELE  m_hEle;
	void  Create();
	void  AdjustLayout();
};

//©��ɨ��
class CXPage3 : public CXEventMsg 
{
public:
	HELE  m_hEle;
	HELE  m_hList;
	HELE  m_hRichEdit;

	void  Create();
	void  AdjustLayout();
};

//��������
class CXPage5 : public CXEventMsg 
{
public:
	HELE  m_hEle;

	void  Create();
	void  AdjustLayout();
};

class CXPage6 : public CXEventMsg 
{
public:
	HELE  m_hEle;

	void  Create();
	void  AdjustLayout();
};

//���ܴ�ȫ
class CXPage9 : public CXEventMsg 
{
public:
	HELE  m_hEle;
	HELE  m_hListView;
	HELE  m_hBottom;

	void  Create();
	void  AdjustLayout();
};

class CSkinDlg : public CXEventMsg 
{
public:
	HWINDOW  m_hWindow;
	HELE     m_hListView;

	void Create();
	BOOL OnEventListViewSelect(HELE hEle,HELE hEventEle,int groupIndex,int itemIndex);
	BOOL OnWndKillFocus(HWINDOW hWindow);
};


//�����
class CMainWnd : public CXEventMsg
{
public:
	
	HWINDOW m_hWindow;
	BOOL GetProcessFullPath(DWORD dwPID, TCHAR pszFullPath[MAX_PATH]);
	BOOL DosPathToNtPath(LPTSTR pszDosPath, LPTSTR pszNtPath);
	BOOL StartFlash();
	HIMAGE  m_hThemeBackground; //���ⱳ��ͼƬ
	HIMAGE  m_hThemeBorder; //���ⱳ��ͼƬ
	int     m_SkinIndex;   //��ǰƤ�� Ĭ��Ϊ0

	HIMAGE  m_hImage_check_leave;
	HIMAGE  m_hImage_check_stay;
	HIMAGE  m_hImage_check_down;
	
	HELE    m_hBottomText;
	int     m_bottomText_width;

	HELE    m_hBtnClose;
	HELE    m_hBtnMax;
	HELE    m_hBtnMin;
	HELE    m_hBtnMenu;
	HELE    m_hBtnSkin;



	BOOL Create(); //�������ںͰ�ť

	void CreateToolButtonAndPage();
	HELE CreateToolButton(int x,int y,HIMAGE hIcon,wchar_t *pName);

	void AdjustLayout(); 
	BOOL OnEventBtnClick_Close(HELE hEle,HELE hEleEvent);
	BOOL OnEventBtnClick_ChangeSkin(HELE hEle,HELE hEleEvent);
    
};

