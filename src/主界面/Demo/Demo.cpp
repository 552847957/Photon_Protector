/*
////////////////////////////////////////////////////
//           ������������������                     //
//            2013.2                              //
////////////////////////////////////////////////////
*/
#include "stdafx.h"
#include<windows.h>
#include "Tlhelp32.h"
#include <stdio.h>
#include "psapi.h"
#include "ShellAPI.h"
#include <fstream>
#define WM_NOTIFYICON  WM_USER + 0x01
	CXPage1   m_page1;
	CXPage2   m_page2;
	CXPage3   m_page3;
	CXPage6   m_page6;
	CXPage5   m_page5;
	CXPage9   m_page9;
	HELE theFrame[9];
BOOL IsStart=false;
HELE OpenNum;//��������ʾ������������
CMainWnd  mainWnd;
POINT Mypt;
HWND MyHWnd;
//����
HELE hStatic;
HELE hStatic2;
HELE hRichEdit=NULL;
HELE hRichEdit2=NULL;
HELE hList;
LOGFONT  Font1;
LOGFONT  Font2;
LOGFONT  Font3;
LOGFONT  Font4;
LOGFONT  Font5;
LOGFONT  Font6;
LOGFONT  Font7;
HMENUX hMenu;
HWINDOW m_hWindow;
HWINDOW hWindowAbout;
HXCGUI hImageList;
HWINDOW hFlashWnd;
HXCGUI hFlash;
HELE m_BtnClose;
HANDLE hMapping;   //�����ڴ�ӳ�����
LPSTR lpData;   
HELE USBRTA,ProcessRTA,RegRTA,Protect;
NOTIFYICONDATA nid = {0}; //����ͼ��
struct item_info
{
	HSTRING  hString;//����
	HELE hProgress; //������
	HELE hButton; //�鿴��ť
};
struct  THreadTest
{
	int a;
	int b;
};
BOOL CALLBACK KillProcessClick(HELE hEle,POINT *pPt);
BOOL FindAndKillProcessByName(LPCTSTR strProcessName);
BOOL CALLBACK ReFreshClick(HELE hEle,POINT *pPt);
BOOL CALLBACK MainFrameClick(HELE hEle,POINT *pPt);
BOOL CALLBACK MainFrameOtherClick(HELE hEle,POINT *pPt);
BOOL CALLBACK My_MenuSelect(HWINDOW hWindow,int id);  //�˵�ѡ��
BOOL CALLBACK My_MenuExit(HWINDOW hWindow); //�˵��˳�
BOOL FirstInstance();////�ж��Ƿ��ظ�����
BOOL CreateNew(LPCTSTR FilePath,wchar_t* Command=L"");//�����½���
/////С���ߵ���¼�
BOOL CALLBACK OnEventListViewSelect(HELE hEle,HELE hEventEle,int groupIndex,int itemIndex);
BOOL SetState(HELE BtnEle,BOOL OnOrOFF);//���ð�ť״̬
BOOL FindProcess(char* ProcessName);//���ҽ����Ƿ����
char* WstrTopChar(LPWSTR wstr);  //ת�����ַ�����խ�ַ���
BOOL ReRead();////���¶�ȡ
BOOL CALLBACK ReReadClick_USB(HELE hEle,POINT *pPt);
BOOL CALLBACK ReReadClick_Reg(HELE hEle,POINT *pPt);
BOOL CALLBACK ReReadClick_Pro(HELE hEle,POINT *pPt);
BOOL CALLBACK ReReadClick_Sel(HELE hEle,POINT *pPt);
DWORD WINAPI ThreadReRead (LPVOID pParam);//��ȡ�߳�
BOOL MyMessageBox();//��������
/*ϵͳ�Ż�*/
BOOL CALLBACK Repair(HELE hEle,POINT *pPt);
BOOL CALLBACK Clear(HELE hEle,POINT *pPt);
BOOL CALLBACK Improve(HELE hEle,POINT *pPt);
BOOL CALLBACK Process(HELE hEle,POINT *pPt);
BOOL CALLBACK KillFile(HELE hEle,POINT *pPt);
/*����ɨ��*/
BOOL CALLBACK AllDiskScan(HELE hEle,POINT *pPt);
BOOL CALLBACK TargetScan(HELE hEle,POINT *pPt);
BOOL CALLBACK NetScan(HELE hEle,POINT *pPt);
BOOL CALLBACK WndProc(HWINDOW hWindow, WPARAM wParam, LPARAM lParam); 
BOOL ExitPhoton();//�˳�����
BOOL CALLBACK WndDestroy(HWINDOW hWindow);  //�˳���Ϣ����
BOOL CALLBACK OnEventBtnClick_Min(HELE hEle,POINT *pPt);
//��ȡ����ϵͳ������
wchar_t* GetSystemName();




BOOL CALLBACK EleMouseClick(HELE hEle,POINT *pPt)
{
	 POINT pt=*pPt;
	 pt.x=Mypt.x;
	 pt.y=Mypt.y;
    hMenu=XMenu_Create();
		XMenu_AddItem(hMenu,201,L"��������");
		XMenu_AddItem(hMenu,202,L"���� ������������");
		XMenu_AddItem(hMenu,203,L"�˳�");
	ClientToScreen(MyHWnd,&pt);
	XMenu_Popup(hMenu,MyHWnd,pt.x+644 ,pt.y+18);
    return false;
}

BOOL CALLBACK ChangeFlash(HELE hEle,POINT *pPt);

BOOL CALLBACK WndProc(HWINDOW hWindow, WPARAM wParam, LPARAM lParam)
{
	if ((wParam == IDI_SMALL) && (lParam == WM_LBUTTONDOWN))  // ����������ʱ��Ӧ
	{
		XWnd_ShowWindow(hWindow,SW_SHOW);
	}
	return true;
}
BOOL CMainWnd::Create() //�������ںͰ�ť
{
	m_SkinIndex=0;
	m_hWindow=XWnd_CreateWindow(0,0,798,578,L"������������",NULL, XC_SY_BORDER | XC_SY_ROUND | XC_SY_CENTER); //��������
	MyHWnd=XWnd_GetHWnd(m_hWindow);

	HMODULE hIns=GetModuleHandle(NULL);
    HICON hIcon=(HICON)LoadImage(hIns,L"image\\����LOGO.ico",IMAGE_ICON,256,256,LR_LOADFROMFILE);
    XWnd_SetIcon(m_hWindow,hIcon,TRUE);
	XWnd_SetIcon(m_hWindow,hIcon,FALSE);
	
	nid.cbSize = sizeof(NOTIFYICONDATA);
	nid.hWnd = MyHWnd;
	nid.uID = IDI_SMALL;
	nid.hIcon = XWnd_GetIcon(m_hWindow,true);
	nid.uCallbackMessage = WM_NOTIFYICON;
	nid.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
	_tcscpy(nid.szTip, _T("������������"));
	::Shell_NotifyIcon(NIM_ADD, &nid);
	 
	 
	
	if(m_hWindow)
	{

		XWnd_EnableMaxButton(m_hWindow,false);
		Mypt.x=XWnd_GetClientLeft(m_hWindow);
        Mypt.y=XWnd_GetClientTop(m_hWindow);
		XWnd_SetBorderSize(m_hWindow,0,0,0,0);
		XWnd_EnableDragWindow(m_hWindow,TRUE);
		XWnd_SetRoundSize(m_hWindow,9);
		/*
		HELE hPicTitle=XPic_Create(6,3,121,20,m_hWindow);
		XPic_SetImage(hPicTitle,XImage_LoadFile(L"image\\title.png"));
		XEle_SetBkTransparent(hPicTitle,TRUE);
		XEle_EnableMouseThrough(hPicTitle,TRUE);
		*/
		m_hThemeBackground=XImage_LoadFile(L"image\\skin\\frame1.jpg");
		m_hThemeBorder=XImage_LoadFileAdaptive(L"image\\skin\\framemod_sim.png",12,48,122,166);

		XImage_SetDrawType(m_hThemeBackground,XC_IMAGE_TILE);
		XWnd_SetImageNC(m_hWindow,m_hThemeBackground);
		XWnd_SetImage(m_hWindow,m_hThemeBorder);

		m_hBottomText=XStatic_Create(20,575,100,18,L"��ӭʹ�ò�����������",m_hWindow);
		XStatic_AdjustSize(m_hBottomText);
		XEle_SetTextColor(m_hBottomText,RGB(255,255,255));
		XEle_SetBkTransparent(m_hBottomText,TRUE);
		XEle_EnableMouseThrough(m_hBottomText,TRUE);
		HELE m_hBottomText2=XStatic_Create(415,555,100,50,GetSystemName(),m_hWindow);
		XStatic_AdjustSize(m_hBottomText2);
		XEle_SetTextColor(m_hBottomText2,RGB(255,255,255));
		XEle_SetBkTransparent(m_hBottomText2,TRUE);
		XEle_EnableMouseThrough(m_hBottomText2,TRUE);

		RECT rect;
		XEle_GetClientRect(m_hBottomText,&rect);
		m_bottomText_width=rect.right-rect.left;


		//47*22
		m_hBtnClose=XBtn_Create(10,0,47,22,NULL,m_hWindow);
		XEle_SetBkTransparent(m_hBtnClose,TRUE);
		XEle_EnableFocus(m_hBtnClose,FALSE);
		XBtn_SetImageLeave(m_hBtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",0,0,47,22));
		XBtn_SetImageStay(m_hBtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",47,0,47,22));
		XBtn_SetImageDown(m_hBtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",94,0,47,22));

		//44*22
		m_hBtnMax=XBtn_Create(10,0,33,22,NULL,m_hWindow);
		XEle_SetBkTransparent(m_hBtnMax,TRUE);
		XEle_EnableFocus(m_hBtnMax,FALSE);
		XBtn_SetImageLeave(m_hBtnMax,XImage_LoadFileRect(L"image\\sys_button_max.png",0,0,33,22));
		XBtn_SetImageStay(m_hBtnMax,XImage_LoadFileRect(L"image\\sys_button_max.png",33,0,33,22));
		XBtn_SetImageDown(m_hBtnMax,XImage_LoadFileRect(L"image\\sys_button_max.png",66,0,33,22));

		m_hBtnMin=XBtn_Create(10,0,33,22,NULL,m_hWindow);
		XEle_SetBkTransparent(m_hBtnMin,TRUE);
		XEle_EnableFocus(m_hBtnMin,FALSE);
		XBtn_SetImageLeave(m_hBtnMin,XImage_LoadFileRect(L"image\\sys_button_min.png",0,0,33,22));
		XBtn_SetImageStay(m_hBtnMin,XImage_LoadFileRect(L"image\\sys_button_min.png",33,0,33,22));
		XBtn_SetImageDown(m_hBtnMin,XImage_LoadFileRect(L"image\\sys_button_min.png",66,0,33,22));
		/////////////////////////////�����˵�////////////////////////////////
		m_hBtnMenu=XBtn_Create(10,0,33,22,NULL,m_hWindow);
		XEle_SetBkTransparent(m_hBtnMenu,TRUE);
		XEle_EnableFocus(m_hBtnMenu,FALSE);
		XBtn_SetImageLeave(m_hBtnMenu,XImage_LoadFileRect(L"image\\title_bar_menu.png",0,0,33,22));
		XBtn_SetImageStay(m_hBtnMenu,XImage_LoadFileRect(L"image\\title_bar_menu.png",33,0,33,22));
		XBtn_SetImageDown(m_hBtnMenu,XImage_LoadFileRect(L"image\\title_bar_menu.png",66,0,33,22));
		XEle_RegisterEvent(m_hBtnMenu,XE_BNCLICK ,EleMouseClick);


		m_hBtnSkin=XBtn_Create(10,0,22,18,NULL,m_hWindow);
		XEle_SetBkTransparent(m_hBtnSkin,TRUE);
		XEle_EnableFocus(m_hBtnSkin,FALSE);
		XBtn_SetImageLeave(m_hBtnSkin,XImage_LoadFileRect(L"image\\SkinButtom.png",0,0,22,18));
		XBtn_SetImageStay(m_hBtnSkin,XImage_LoadFileRect(L"image\\SkinButtom.png",22,0,22,18));
		XBtn_SetImageDown(m_hBtnSkin,XImage_LoadFileRect(L"image\\SkinButtom.png",44,0,22,18));

		
		//LOGO
		HELE hPicLogo=XPic_Create(3,25,280,80,m_hWindow);
		XEle_SetBkTransparent(hPicLogo,TRUE);
		XPic_SetImage(hPicLogo,XImage_LoadFile(L"image\\logo.png"));
		XEle_EnableMouseThrough(hPicLogo,TRUE);
		
		
		CreateToolButtonAndPage();//����ҳ���л���ť����ҳ��

		XCGUI_RegEleEvent(m_hBtnClose,XE_BNCLICK,&CMainWnd::OnEventBtnClick_Close);
		XEle_RegisterEvent(m_hBtnMin,XE_BNCLICK,OnEventBtnClick_Min);
		XCGUI_RegEleEvent(m_hBtnSkin,XE_BNCLICK,&CMainWnd::OnEventBtnClick_ChangeSkin);

		AdjustLayout();
		XWnd_ShowWindow(m_hWindow,SW_SHOW); //��ʾ����
		//hFlashWnd=XWnd_CreateWindowEx(NULL,NULL,L"flash",WS_CHILD,3,110,800,440,MyHWnd,0); //����FLASH��������
		//hFlash=XFlash_Create(hFlashWnd); //����FLASH�ؼ�
		//StartFlash();
		/*m_BtnClose=XBtn_Create(750,550,47,22,NULL,m_hWindow);
		XEle_SetBkTransparent(m_BtnClose,TRUE);
		XEle_EnableFocus(m_BtnClose,FALSE);
		XBtn_SetImageLeave(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_play.png",0,0,47,22));
		XBtn_SetImageStay(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_play.png",47,0,47,22));
		XBtn_SetImageDown(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_play.png",94,0,47,22));
	    
		XEle_RegisterEvent(m_BtnClose,XE_BNCLICK,ChangeFlash);*///FLASH���Ű�ť����ֹͣʹ��
		//���������˵�
		hMenu=XMenu_Create();
		XMenu_AddItem(hMenu,201,L"�ٷ���վ");
		XMenu_AddItem(hMenu,202,L"��������");
		XMenu_AddItem(hMenu,203,L"���� ������������");
		XWnd_RegisterMessage(m_hWindow,XWM_MENUSELECT,My_MenuSelect);
		XWnd_RegisterMessage(m_hWindow,XWM_MENUEXIT,My_MenuExit);
		//XWnd_ShowWindow(hFlashWnd,SW_SHOW);
		XWnd_RegisterMessage(m_hWindow,WM_NOTIFYICON,WndProc);
		XWnd_RegisterMessage(m_hWindow,WM_DESTROY,WndDestroy);
		return TRUE;
	}
	 
	return FALSE;
}

BOOL CALLBACK OnEventBtnClick_Min(HELE hEle,POINT *pPt)
{
	SendMessage(XEle_GetHWnd(hEle),WM_SYSCOMMAND,SC_MINIMIZE,NULL);
	return false;
}
///////////////////////////////���̹���///////////////////////////////

BOOL DosPathToNtPath(LPTSTR pszDosPath, LPTSTR pszNtPath)
{
	TCHAR			szDriveStr[500];
	TCHAR			szDrive[3];
	TCHAR			szDevName[100];
	INT				cchDevName;
	INT				i;
	
	//������
	if(!pszDosPath || !pszNtPath )
		return FALSE;

	//��ȡ���ش����ַ���
	if(GetLogicalDriveStrings(sizeof(szDriveStr), szDriveStr))
	{
		for(i = 0; szDriveStr[i]; i += 4)
		{
			if(!lstrcmpi(&(szDriveStr[i]), _T("A:\\")) || !lstrcmpi(&(szDriveStr[i]), _T("B:\\")))
				continue;

			szDrive[0] = szDriveStr[i];
			szDrive[1] = szDriveStr[i + 1];
			szDrive[2] = '\0';
			if(!QueryDosDevice(szDrive, szDevName, 100))//��ѯ Dos �豸��
				return FALSE;

			cchDevName = lstrlen(szDevName);
			if(_tcsnicmp(pszDosPath, szDevName, cchDevName) == 0)//����
			{
				lstrcpy(pszNtPath, szDrive);//����������
				lstrcat(pszNtPath, pszDosPath + cchDevName);//����·��

				return TRUE;
			}			
		}
	}

	lstrcpy(pszNtPath, pszDosPath);
	
	return FALSE;
}

//��ȡ��������·��
BOOL GetProcessFullPath(DWORD dwPID, TCHAR pszFullPath[MAX_PATH])
{
	TCHAR		szImagePath[MAX_PATH];
	HANDLE		hProcess;
	
	if(!pszFullPath)
		return FALSE;
	
	pszFullPath[0] = '\0';
	hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, 0, dwPID);
	if(!hProcess)
		return FALSE;

	if(!GetProcessImageFileName(hProcess, szImagePath, MAX_PATH))
	{
		CloseHandle(hProcess);
		return FALSE;
	}

	if(!DosPathToNtPath(szImagePath, pszFullPath))
	{
		CloseHandle(hProcess);
		return FALSE;
	}

	CloseHandle(hProcess);

	return TRUE;
}




//�����б�Ԫ��
void AdjustList(HELE hList)
{
	int headerHiehgt=XList_GetHeaderHeight(hList);
	int itemHeight=XList_GetItemHeight(hList);
	int top=headerHiehgt;

	int columnLeft1=XList_GetSpacingLeft(hList)+XList_GetColumnWidth(hList,0)+XList_GetColumnWidth(hList,1)+5;
	int columnLeft2=columnLeft1+XList_GetColumnWidth(hList,2)-80;

	RECT rcProgress,rcButton;
	int count=XList_GetItemCount(hList);
	for(int i=0;i<count;i++)
	{
		item_info *pItem=(item_info*)XList_GetItemData(hList,i);
		if(pItem)
		{

			//������
			rcProgress.left=columnLeft1;
			rcProgress.top=top-5;
			rcProgress.right=rcProgress.left+100;
			rcProgress.bottom=rcProgress.top;
			XEle_SetRect(pItem->hProgress,&rcProgress);

			//��ť
			rcButton.left=columnLeft2;
			rcButton.top=top-5;
			rcButton.right=rcButton.left+60;
			rcButton.bottom=rcButton.top;
			XEle_SetRect(pItem->hButton,&rcButton);
			top+=itemHeight;
		}
	}
}

//�б�ͷ��ȸı�
BOOL CALLBACK MyEventListHeaderChange(HELE hEle,HELE hEventEle,int index,int width)
{
	AdjustList(hEle);
	return true;
}

//�б��Ի�
void CALLBACK MyList_OnDrawItem(HELE hEle,list_drawItem_ *pDrawItem)
{
	RECT rc=pDrawItem->rect;
	rc.top++;
	//���Ʊ���
	if(STATE_SELECT==pDrawItem->state)
	{
		XDraw_FillSolidRect_(pDrawItem->hDraw,&rc,RGB(240,188,132));
	}else
	{
		if(0==pDrawItem->index%2)
			XDraw_FillSolidRect_(pDrawItem->hDraw,&rc,RGB(187,232,254));
		else
			XDraw_FillSolidRect_(pDrawItem->hDraw,&rc,RGB(255,255,255));
	}
	//����ͼ��
	HXCGUI hImageList=XList_GetImageList(hEle);
	RECT rect=pDrawItem->rect;
	if(hImageList && pDrawItem->imageId>-1)
	{
		rect.left+=3;
		XImageList_DrawImage(hImageList,pDrawItem->hDraw,pDrawItem->imageId,rect.left,pDrawItem->rect.top+3);

		rect.left+=43;
	}else
		rect.left+=3;

	//�����ı�
	if(0==pDrawItem->subIndex)
	{
		RECT rcText=rect;
		rcText.bottom=rcText.top+25;
		rcText.top=rcText.bottom-20;

		XDraw_DrawText_(pDrawItem->hDraw,pDrawItem->pText,wcslen(pDrawItem->pText),&rcText,DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS);

		item_info *pItem=(item_info*)XList_GetItemData(hEle,pDrawItem->index);
		if(pItem)
		{
			rcText.top=rcText.bottom;
			rcText.bottom=rcText.top+20;
			COLORREF color=XDraw_SetTextColor_(pDrawItem->hDraw,RGB(128,128,128));
			XDraw_DrawText_(pDrawItem->hDraw,XStr_GetBuffer(pItem->hString),XStr_GetLength(pItem->hString),&rcText,DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS);
			XDraw_SetTextColor_(pDrawItem->hDraw,color);
		}
	}else
		XDraw_DrawText_(pDrawItem->hDraw,pDrawItem->pText,wcslen(pDrawItem->pText),&rect,DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS);
}

void CALLBACK MyEventDestroy(HELE hEle)
{
	int count=XList_GetItemCount(hEle);
	for(int i=0;i<count;i++)
	{
		item_info *pItem=(item_info*)XList_GetItemData(hEle,i);
		if(pItem)
		{
			XStr_Destroy(pItem->hString);
			delete pItem;
		}
	}
}
BOOL CALLBACK MyRMouse(HELE hEle,HELE hEventEle,int index)
{
	//XMessageBox(hList,XList_GetItemText(hList,index,0),NULL,MB_OK);
	wchar_t* MyString=XList_GetItemText(hList,index,0);
	 XRichEdit_DeleteAll(hRichEdit);
	 //XRichEdit_InsertTextEx(hRichEdit,L"��������",0,0,&Font2,FALSE,NULL);
	XRichEdit_InsertTextEx(hRichEdit,MyString,-1,-1,&Font2,FALSE,NULL);
	//XRichEdit_InsertTextEx(hRichEdit2,L"\n�ļ�·����",1,-1,&Font2,FALSE,NULL);
	XRichEdit_DeleteAll(hRichEdit2);
	XRichEdit_InsertTextEx(hRichEdit2,XList_GetItemText(hList,index,1),-1,-1,&Font2,FALSE,NULL);
	//XRichEdit_InsertTextEx(hRichEdit,MyString,0,0,&Font2,FALSE,NULL);
	XEle_RedrawEle(hRichEdit,0);
	XEle_RedrawEle(hRichEdit2,0);
	 return FALSE;
}


void My_AddItem(HELE hList,int index,int pos,wchar_t *pText)
{
	item_info *pItem=new item_info;
	pItem->hString=XStr_Create();
	XStr_SetString(pItem->hString,pText);
	pItem->hProgress=XProgBar_Create(230,60,100,20,true,hList);
	pItem->hButton=XBtn_Create(100,10,60,20,L"����",hList);
	XEle_SetBkTransparent(pItem->hProgress,true);
	XEle_SetBkTransparent(pItem->hButton,true);
	XEle_SetToolTips(pItem->hButton,L"��ʾ�����˵�");
	XEle_EnableToolTips(pItem->hButton,true);
	XProgBar_SetPos(pItem->hProgress,pos);
	XProgBar_EnablePercent(pItem->hProgress,true);
	XList_SetItemData(hList,index,(int)pItem);
	//XEle_RegisterEvent(pItem->hButton,XE_BNCLICK,MyRMouse);
}
////////////////////////////////////////////////////////////////////////////
void CMainWnd::AdjustLayout()
{
	RECT rect;
	XWnd_GetClientRect(m_hWindow,&rect);

	RECT rc=rect;
	rc.left++;
	rc.right--;
	rc.top =110;
	rc.bottom-=26;

	XEle_SetRect(m_page1.m_hEle,&rc);
	XEle_SetRect(m_page2.m_hEle,&rc);
	XEle_SetRect(m_page3.m_hEle,&rc);
	XEle_SetRect(m_page5.m_hEle,&rc);
	XEle_SetRect(m_page6.m_hEle,&rc);
	XEle_SetRect(m_page9.m_hEle,&rc);

	m_page1.AdjustLayout();
	m_page2.AdjustLayout();
	m_page9.AdjustLayout();

	rc.left=10;
	rc.right=rc.left+m_bottomText_width;
	rc.top=rect.bottom-23;
	rc.bottom=rc.top+18;
	XEle_SetRect(m_hBottomText,&rc);

	rc.top=0;
	rc.right=rect.right-5;
	rc.left=rc.right-47;
	rc.bottom=rc.top+22;
	XEle_SetRect(m_hBtnClose,&rc);

	rc.right=rc.left;
	rc.left=rc.right-33;
	XEle_SetRect(m_hBtnMax,&rc);

	rc.right=rc.left;
	rc.left=rc.right-33;
	XEle_SetRect(m_hBtnMin,&rc);

	rc.right=rc.left;
	rc.left=rc.right-33;
	XEle_SetRect(m_hBtnMenu,&rc);

	rc.right=rc.left-5;
	rc.left=rc.right-22;
	rc.bottom=18;
	XEle_SetRect(m_hBtnSkin,&rc);
}

void CMainWnd::CreateToolButtonAndPage()
{
	int left=349+74;
	int top=28;
	m_hImage_check_leave=XImage_LoadFile(L"image\\toolBar\\toolbar_normal.png");
	m_hImage_check_stay=XImage_LoadFile(L"image\\toolBar\\toolbar_hover.png");
	m_hImage_check_down=XImage_LoadFile(L"image\\toolBar\\toolbar_pushed.png");

	HIMAGE hIcon=XImage_LoadFile(L"image\\toolBar\\ico_Examine.png");
	HELE hRadio1=CreateToolButton(left,top,hIcon,L"��ҳ"); left+=74;
	//hIcon=XImage_LoadFile(L"image\\toolBar\\ico_dsmain.png");
	//HELE hRadio2=CreateToolButton(left,top,hIcon,L"��ɱ"); left+=74;
	//hIcon=XImage_LoadFile(L"image\\toolBar\\ico_VulRepair.png");
	//HELE hRadio3=CreateToolButton(left,top,hIcon,L"©���޸�"); left+=74;
	hIcon=XImage_LoadFile(L"image\\toolBar\\ico_SysRepair.png");
	HELE hRadio4=CreateToolButton(left,top,hIcon,L"ϵͳ�Ż�"); left+=74;
	hIcon=XImage_LoadFile(L"image\\toolBar\\ico_ProcessMonitor.png");
	HELE hRadio5=CreateToolButton(left,top,hIcon,L"ϵͳ����"); left+=74;
	hIcon=XImage_LoadFile(L"image\\toolBar\\ico_SpeedupOpt.png");
	HELE hRadio6=CreateToolButton(left,top,hIcon,L"ʵʱ����"); left+=74;
	//hIcon=XImage_LoadFile(L"image\\toolBar\\ico_diannaomenzhen.png");
	//HELE hRadio7=CreateToolButton(left,top,hIcon,L"������"); left+=74;
	//hIcon=XImage_LoadFile(L"image\\toolBar\\ico_softmgr.png");
	//HELE hRadio8=CreateToolButton(left,top,hIcon,L"�������"); left+=74;
	hIcon=XImage_LoadFile(L"image\\toolBar\\ico_AdvTools.png");
	HELE hRadio9=CreateToolButton(left,top,hIcon,L"������"); left+=74;

	XBtn_SetCheck(hRadio1,TRUE);

	m_page1.Create();
	m_page2.Create();
	m_page3.Create();
	m_page5.Create();
	m_page6.Create();
	m_page9.Create();

	XRadio_SetBindEle(hRadio1,m_page1.m_hEle);
	//XRadio_SetBindEle(hRadio2,m_page2.m_hEle);
	XRadio_SetBindEle(hRadio4,m_page3.m_hEle);
	XRadio_SetBindEle(hRadio5,m_page5.m_hEle);
    XRadio_SetBindEle(hRadio6,m_page6.m_hEle); 
	XRadio_SetBindEle(hRadio9,m_page9.m_hEle);
	/*XEle_RegisterEvent(hRadio1,XE_BNCLICK ,MainFrameClick);
	XEle_RegisterEvent(hRadio2,XE_BNCLICK ,MainFrameOtherClick);
	XEle_RegisterEvent(hRadio5,XE_BNCLICK ,MainFrameOtherClick);
	XEle_RegisterEvent(hRadio6,XE_BNCLICK ,MainFrameOtherClick);
    XEle_RegisterEvent(hRadio9,XE_BNCLICK ,MainFrameOtherClick);*/
	//XEle_RegisterEvent(m_hRadio1,XE_BNCLICK ,MainFrameOtherClick);
}

HELE CMainWnd::CreateToolButton(int x,int y,HIMAGE hIcon,wchar_t *pName)
{
	HELE hRadio=XRadio_Create(x,y,74,82,pName,m_hWindow);
	XRadio_EnableButtonStyle(hRadio,TRUE);
	XRadio_SetGroupID(hRadio,1);

	XBtn_SetIcon(hRadio,hIcon);
	XBtn_SetIconAlign(hRadio,XC_ICON_ALIGN_TOP);
	XEle_SetBkTransparent(hRadio,TRUE);
	XEle_SetTextColor(hRadio,RGB(255,255,255));
	XBtn_SetOffset(hRadio,0,-3);

	XRadio_SetImageLeave_UnCheck(hRadio,m_hImage_check_leave);
	XRadio_SetImageStay_UnCheck(hRadio,m_hImage_check_stay);
	XRadio_SetImageDown_UnCheck(hRadio,m_hImage_check_down);

	XRadio_SetImageLeave_Check(hRadio,m_hImage_check_down);
	XRadio_SetImageStay_Check(hRadio,m_hImage_check_down);
	XRadio_SetImageDown_Check(hRadio,m_hImage_check_down);

	XEle_EnableFocus(hRadio,FALSE);
	return hRadio;
}

BOOL CMainWnd::OnEventBtnClick_Close(HELE hEle,HELE hEleEvent) //��ť����¼���Ӧ
{
	if(hEle!=hEleEvent) return FALSE;
	XWnd_ShowWindow(m_hWindow,SW_HIDE);
	return FALSE;
}

BOOL CMainWnd::OnEventBtnClick_ChangeSkin(HELE hEle,HELE hEleEvent)
{
	if(hEle!=hEleEvent) return FALSE;

	CSkinDlg  *pSkinDlg=new CSkinDlg;
	pSkinDlg->Create();

	return FALSE;
}

//////////////////////////////////////////////
void CXPage1::Create()
{
	
	
	m_hEle=XPic_Create(2,110,300,465,mainWnd.m_hWindow);
	XPic_SetImage(m_hEle, XImage_LoadFileAdaptive(L"image\\page2\\page.png",10,72,76,190));
	XEle_SetBkTransparent(m_hEle,TRUE);
	//XEle_ShowEle(m_hEle,FALSE);

	HELE hButton=XBtn_Create(30,158,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(hButton,TRUE);
	XEle_EnableFocus(hButton,FALSE);
	XBtn_SetImageLeave(hButton,XImage_LoadFile(L"image\\page2\\saomiao_leave.png"));
	XBtn_SetImageStay(hButton,XImage_LoadFile(L"image\\page2\\saomiao_stay.png"));
	XBtn_SetImageDown(hButton,XImage_LoadFile(L"image\\page2\\saomiao_down.png"));
	XEle_RegisterEvent(hButton,XE_BNCLICK,AllDiskScan);
	HELE ahButton=XBtn_Create(200,158,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(ahButton,TRUE);
	XEle_EnableFocus(ahButton,FALSE);
	XBtn_SetImageLeave(ahButton,XImage_LoadFile(L"image\\page2\\saomiao_leave2.png"));
	XBtn_SetImageStay(ahButton,XImage_LoadFile(L"image\\page2\\saomiao_stay2.png"));
	XBtn_SetImageDown(ahButton,XImage_LoadFile(L"image\\page2\\saomiao_down2.png"));
	XEle_RegisterEvent(ahButton,XE_BNCLICK,TargetScan);
	HELE bhButton=XBtn_Create(370,158,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(bhButton,TRUE);
	XEle_EnableFocus(bhButton,FALSE);
	XBtn_SetImageLeave(bhButton,XImage_LoadFile(L"image\\page2\\saomiao_leave3.png"));
	XBtn_SetImageStay(bhButton,XImage_LoadFile(L"image\\page2\\saomiao_stay3.png"));
	XBtn_SetImageDown(bhButton,XImage_LoadFile(L"image\\page2\\saomiao_down3.png"));
	XEle_RegisterEvent(bhButton,XE_BNCLICK,NetScan);

	HELE    hEleT=NULL;
	HIMAGE  hImageT=NULL;
	/*
	//�����ͼƬ
	HELE hPicRadar=XPic_Create(18,20,126,109,m_hEle);
	XPic_SetImage(hPicRadar,XImage_LoadFile(L"image\\page1\\Radar0.png"));
	XEle_SetBkTransparent(hPicRadar,TRUE);
	
	//��������Ϸ�����
	HELE hPicText=XPic_Create(155,20,352,93,m_hEle);
	XPic_SetImage(hPicText,XImage_LoadFile(L"image\\page1\\text1.png"));
	XEle_SetBkTransparent(hPicText,TRUE);
	*/
	/*
	//�������
	HELE hButton=XBtn_Create(200,195,174,72,NULL,m_hEle);
	XBtn_SetImageLeave(hButton,XImage_LoadFile(L"image\\page1\\button1_leave.png"));
	XBtn_SetImageStay(hButton,XImage_LoadFile(L"image\\page1\\button1_stay.png"));
	XBtn_SetImageDown(hButton,XImage_LoadFile(L"image\\page1\\button1_leave.png"));
	XEle_SetBkTransparent(hButton,TRUE);
	XEle_EnableFocus(hButton,FALSE);*/
	
	//////////�Ҳ�����//////////////////////////
	//����
	m_hPane_right=XPic_Create(0,00,0,0,m_hEle);
	XPic_SetImage(m_hPane_right,XImage_LoadFile(L"image\\page1\\page1_right.png"));
	XEle_SetBkTransparent(m_hPane_right,TRUE);


	OpenNum= XStatic_Create(129,108,200,50,L"�ѿ��� 0 �㱣��\n\n����δ��ȫ����",m_hPane_right);
	XEle_SetTextColor(OpenNum,RGB(220,20,60));
	XEle_SetBkTransparent(OpenNum,true);

	//��������
	m_hBtn_all_opened=XBtn_Create(10,155,242,64,NULL,m_hPane_right);
	XBtn_SetImageLeave(m_hBtn_all_opened,XImage_LoadFile(L"image\\page1\\all_opened.png"));
	XBtn_SetImageStay(m_hBtn_all_opened,XImage_LoadFile(L"image\\page1\\all_opened_stay.png"));
	XBtn_SetImageDown(m_hBtn_all_opened,XImage_LoadFile(L"image\\page1\\all_opened.png"));
	XEle_SetBkTransparent(m_hBtn_all_opened,TRUE);
	XEle_EnableFocus(m_hBtn_all_opened,FALSE);
	/*
	//����ǰ��ͼ��
	hEleT=XPic_Create(33,80,18,18,m_hPane_right);
	XPic_SetImage(hEleT,XImage_LoadFile(L"image\\page1\\reminderdlgflag.png"));
	XEle_SetBkTransparent(hEleT,TRUE);

	//����⽱��4G���̿ռ�
	hEleT=XTextLink_Create(53,80,125,18,L"����⽱��4G���̿ռ�",m_hPane_right);
	XEle_SetTextColor(hEleT,RGB(26,102,162));
	XEle_SetBkTransparent(hEleT,TRUE);
	
	//�ָ�
	hEleT=XStatic_Create(175,81,12,18,L"|",m_hPane_right);
	XEle_SetTextColor(hEleT,RGB(128,128,128));
	XEle_SetBkTransparent(hEleT,TRUE);

	//���ע��
	hEleT=XTextLink_Create(188,80,50,18,L"���ע��",m_hPane_right);
	XEle_SetTextColor(hEleT,RGB(230,113,56));
	XEle_SetBkTransparent(hEleT,TRUE);
	*/
	//ʵʱ�����ѿ���,������ť 54*55
	hEleT=XBtn_Create(55,100,54,55,NULL,m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	int x=0;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),100); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_AddAnimationFrame(hEleT,XImage_LoadFileRect(L"image\\page1\\state_safe.png",x,0,54,55),200); x+=54;
	XBtn_EnableAnimation(hEleT,TRUE,TRUE);
	XEle_EnableFocus(hEleT,false);
	/*
	//ʵʱ�����ѿ��� ���ְ�ť
	hEleT=XTextLink_Create(75,120,130,25,L"ʵʱ�����ѿ���",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XEle_SetTextColor(hEleT,RGB(49,109,30));
	XEle_SetFont(hEleT, XFont_Create2(L"����",18,TRUE));
	XTextLink_AdjustSize(hEleT);
	
	//ľ�����ǽ,ͼ��
	hImageT=XImage_LoadFile(L"image\\page1\\item_opened.png");
	hEleT=XPic_Create(20,160,37,22,m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XPic_SetImage(hEleT,hImageT);

	//ľ�����ǽ
	hEleT=XTextLink_Create(80,162,60,20,L"ľ�����ǽ",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XEle_SetTextColor(hEleT,RGB(49,109,30));

	//����
	hEleT=XTextLink_Create(220,162,100,20,L"����",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XTextLink_AdjustSize(hEleT);

	//360����,ͼ��
	hEleT=XPic_Create(20,190,37,22,m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XPic_SetImage(hEleT,hImageT);

	//360����
	hEleT=XTextLink_Create(80,192,50,20,L"360����",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XEle_SetTextColor(hEleT,RGB(49,109,30));

	//����
	hEleT=XTextLink_Create(220,192,100,20,L"����",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XTextLink_AdjustSize(hEleT);

	//IE��ҳ������,ͼ��
	hImageT=XImage_LoadFile(L"image\\page1\\item_closed.png");
	hEleT=XPic_Create(20,220,37,22,m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XPic_SetImage(hEleT,hImageT);

	//IE��ҳ������
	hEleT=XTextLink_Create(80,222,75,20,L"IE��ҳ������",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XEle_SetTextColor(hEleT,RGB(230,113,56));

	//����
	hEleT=XTextLink_Create(220,222,100,20,L"����",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XTextLink_AdjustSize(hEleT);
	*/
	/////////ͼ���б���ͼ////////////////////////
	CreateListView();

	//CreateRightBottom(); //�б����·�����
}	

void  CXPage1::CreateListView()
{
	HELE hStaticText=XStatic_Create(2,240,260,138,L"������Ѿ��߱��Ĺ��ܣ�",m_hPane_right);
	XEle_SetBkTransparent(hStaticText,true);
	HELE hListView=XListView_Create(2,260,260,138,m_hPane_right);
	XSView_SetSpacing(hListView,0,0,0,0);
	XListView_SetIconSize(hListView,30,30);
	XListView_SetViewLeftAlign(hListView,0);
	XListView_SetViewTopAlign(hListView,0);
	XListView_SetColumnSpacing(hListView,1);
	XListView_SetItemBorderSpacing(hListView,17,10,17,8);
	XEle_SetBkTransparent(hListView,TRUE);
	XEle_SetBkTransparent(XSView_GetView(hListView),TRUE);

	XListView_AddItem(hListView,L"��������");
	XListView_AddItem(hListView,L"ע�����");
	XListView_AddItem(hListView,L"��������");
	XListView_AddItem(hListView,L"U������");

	XListView_AddItem(hListView,L"ϵͳ�Ż�");
	XListView_AddItem(hListView,L"������ɱ");
	XListView_AddItem(hListView,L"©���޸�");
	XListView_AddItem(hListView,L"ϵͳ����");

	HXCGUI hImageList=XImageList_Create(50,50);
	XImageList_EnableFixedSize(hImageList,TRUE);
	XListView_SetImageList(hListView,hImageList);
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\recommend\\1.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\recommend\\2.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\recommend\\3.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\recommend\\4.png"));

	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\recommend\\5.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\recommend\\6.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\recommend\\7.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\recommend\\8.png"));

	XListView_SetItemIcon(hListView,-1,0,0);
	XListView_SetItemIcon(hListView,-1,1,1);
	XListView_SetItemIcon(hListView,-1,2,2);
	XListView_SetItemIcon(hListView,-1,3,3);

	XListView_SetItemIcon(hListView,-1,4,4);
	XListView_SetItemIcon(hListView,-1,5,5);
	XListView_SetItemIcon(hListView,-1,6,6);
	XListView_SetItemIcon(hListView,-1,7,7);

	HIMAGE  hImageStay=XImage_LoadFileRect(L"image\\recommend\\hover_btn.png",64,0,64,68);
	HIMAGE  hImageSelect=XImage_LoadFileRect(L"image\\recommend\\hover_btn.png",128,0,64,68);
	for (int i=0;i<8;i++)
	{
		XListView_SetItemImageStay(hListView,-1,i,hImageStay);
		XListView_SetItemImageSelect(hListView,-1,i,hImageSelect);
	}

	XSView_EnableVScroll(hListView,FALSE);
}

void  CXPage1::CreateRightBottom()
{

	//�����ҵ��
	HELE hEleT=XTextLink_Create(20,405,100,20,L"�����ҵ��",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XEle_SetTextColor(hEleT,RGB(26,102,162));
	XTextLink_AdjustSize(hEleT);

	//��̳����
	hEleT=XTextLink_Create(100,405,100,20,L"��̳����",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XEle_SetTextColor(hEleT,RGB(26,102,162));
	XTextLink_AdjustSize(hEleT);

	//��ɱ�쳣�ָ�
	hEleT=XTextLink_Create(165,405,100,20,L"��ɱ�쳣�ָ�",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XEle_SetTextColor(hEleT,RGB(26,102,162));
	XTextLink_AdjustSize(hEleT);

	//360ɱ����AV-C��������"���"����
	hEleT=XTextLink_Create(20,432,100,20,L"360ɱ����AV-C��������\"���\"����",m_hPane_right);
	XEle_SetBkTransparent(hEleT,TRUE);
	XEle_SetTextColor(hEleT,RGB(177,21,6));
	XTextLink_AdjustSize(hEleT);
}

void CXPage1::AdjustLayout()
{
	RECT rect;
	XEle_GetClientRect(m_hEle,&rect);
	
	rect.left=rect.right-265;
	XEle_SetRect(m_hPane_right,&rect);
}

/////////////////////////////////////////////////////////
void CXPage2::Create()
{
	
	m_hEle=XPic_Create(2,110,300,465,mainWnd.m_hWindow);
	XPic_SetImage(m_hEle, XImage_LoadFileAdaptive(L"image\\page2\\page.png",10,72,76,190));
	XEle_SetBkTransparent(m_hEle,TRUE);
	XEle_ShowEle(m_hEle,FALSE);

	HELE hButton=XBtn_Create(30,158,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(hButton,TRUE);
	XEle_EnableFocus(hButton,FALSE);
	XBtn_SetImageLeave(hButton,XImage_LoadFile(L"image\\page2\\saomiao_leave.png"));
	XBtn_SetImageStay(hButton,XImage_LoadFile(L"image\\page2\\saomiao_stay.png"));
	XBtn_SetImageDown(hButton,XImage_LoadFile(L"image\\page2\\saomiao_down.png"));
	XEle_RegisterEvent(hButton,XE_BNCLICK,AllDiskScan);
	HELE ahButton=XBtn_Create(200,158,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(ahButton,TRUE);
	XEle_EnableFocus(ahButton,FALSE);
	XBtn_SetImageLeave(ahButton,XImage_LoadFile(L"image\\page2\\saomiao_leave2.png"));
	XBtn_SetImageStay(ahButton,XImage_LoadFile(L"image\\page2\\saomiao_stay2.png"));
	XBtn_SetImageDown(ahButton,XImage_LoadFile(L"image\\page2\\saomiao_down2.png"));
	XEle_RegisterEvent(ahButton,XE_BNCLICK,TargetScan);
}

void CXPage2::AdjustLayout()
{

}

//////////////////////////////////////////////////////////////////////////
void CXPage3::Create()
{
	m_hEle=XPic_Create(2,110,300,465,mainWnd.m_hWindow);
	XPic_SetImage(m_hEle,XImage_LoadFileAdaptive(L"image\\page3\\bg.png",446,562,68,105));
	XEle_SetBkTransparent(m_hEle,TRUE);
	XEle_ShowEle(m_hEle,FALSE);
	/*
	m_hList=XList_Create(0,64,613,358,m_hEle);
	//XSView_SetSpacing(m_hList,0,0,0,0);
	XEle_EnableBorder(m_hList,FALSE);
	XList_EnableCheckBox(m_hList,TRUE);
	XEle_SetBkTransparent(m_hList,TRUE);
	XEle_SetBkTransparent(XSView_GetView(m_hList),TRUE);
	XList_AddColumn(m_hList,100,L"����"); //����
	XList_AddColumn(m_hList,80,L"��������"); //��������
	XList_AddColumn(m_hList,220,L"����"); //����
	XList_AddColumn(m_hList,80,L"��������"); //��������
	XList_AddColumn(m_hList,80,L"״̬"); //״̬

	wchar_t name[256]={0};
	for (int i=0;i<50;i++)
	{
		wsprintf(name,L"���� - %d",i+1);
		XList_AddItem(m_hList,name);
		XList_SetItemText(m_hList,i,1,L"KB370050");
		XList_SetItemText(m_hList,i,2,L"Windows �ں���Ȩ©��");
		XList_SetItemText(m_hList,i,3,L"2012-12-21");
		XList_SetItemText(m_hList,i,4,L"δ�޸�");
	}
	*/
	//right
	/*
	m_hRichEdit=XRichEdit_Create(625,64,220,358,m_hEle);
	XSView_SetSpacing(m_hRichEdit,0,0,0,0);
	XEle_EnableBorder(m_hRichEdit,FALSE);
	XEle_SetBkTransparent(m_hRichEdit,TRUE);
	XEle_SetBkTransparent(XSView_GetView(m_hRichEdit),TRUE);

	LOGFONT fontInfo;
	XC_InitFont(&fontInfo,L"����",12,TRUE);
	XRichEdit_InsertTextEx(m_hRichEdit,L"360ϵͳ�����޸�\n",0,0,&fontInfo);

	XRichEdit_InsertText(m_hRichEdit,L"�ڰ�װ΢�������緢���������޷�\n����ϵͳ�����⣬�ܹ������ٰ�������\n������⣬˳������ϵͳ��\n\n",1,0);

	XRichEdit_InsertTextEx(m_hRichEdit,L"�����ǲ��ǰ�װ��Խ��Խ�ã�\n",5,0,&fontInfo);
	XRichEdit_InsertText(m_hRichEdit,L"���ǵġ������װ�˲���Ҫ��װ�Ĳ�\n���������˷�ϵͳ��Դ�����п��ܵ���\nϵͳ������360©���޸������������\n������������ܰ�װ��������ʡϵͳ��\nԴ����֤���԰�ȫ��\n\n",6,0);

	XRichEdit_InsertTextEx(m_hRichEdit,L"360��ȫ��ʿ\n",12,0,&fontInfo);
	XRichEdit_InsertText(m_hRichEdit,L"�򲹶���ʡ����ͳһ������ҵ��ȫ��\n",13,0);
	*/
	HELE hButton1=XBtn_Create(108,105,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(hButton1,TRUE);
	XEle_EnableFocus(hButton1,FALSE);
	XBtn_SetImageLeave(hButton1,XImage_LoadFile(L"image\\page3\\loudong.png"));
	XBtn_SetImageStay(hButton1,XImage_LoadFile(L"image\\page3\\loudong2.png"));
	XBtn_SetImageDown(hButton1,XImage_LoadFile(L"image\\page3\\loudong3.png"));
	HELE hButton2=XBtn_Create(308,105,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(hButton2,TRUE);
	XEle_EnableFocus(hButton2,FALSE);
	XBtn_SetImageLeave(hButton2,XImage_LoadFile(L"image\\page3\\qingli.png"));
	XBtn_SetImageStay(hButton2,XImage_LoadFile(L"image\\page3\\qingli2.png"));
	XBtn_SetImageDown(hButton2,XImage_LoadFile(L"image\\page3\\qingli3.png"));
	HELE hButton3=XBtn_Create(508,105,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(hButton3,TRUE);
	XEle_EnableFocus(hButton3,FALSE);
	XBtn_SetImageLeave(hButton3,XImage_LoadFile(L"image\\page3\\youhua.png"));
	XBtn_SetImageStay(hButton3,XImage_LoadFile(L"image\\page3\\youhua2.png"));
	XBtn_SetImageDown(hButton3,XImage_LoadFile(L"image\\page3\\youhua3.png"));
	XEle_RegisterEvent(hButton1,XE_BNCLICK,Repair);
	XEle_RegisterEvent(hButton2,XE_BNCLICK,Clear);
	XEle_RegisterEvent(hButton3,XE_BNCLICK,Improve);
}

void CXPage3::AdjustLayout()
{

}

///////////////////////////////////////////////////////////////////////
BOOL ReFresh()
{
	XList_DeleteAllItems(hList);
	HANDLE myhProcess;
	PROCESSENTRY32 mype;
	mype.dwSize = sizeof(PROCESSENTRY32); 
	BOOL mybRet;
	//���н��̿���
	myhProcess=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0); //TH32CS_SNAPPROCESS�������н���
	//��ʼ���̲���
	mybRet=Process32First(myhProcess,&mype);
	//ѭ���Ƚϣ��ó�ProcessID
	HIMAGE MyImage;
	//char* cPID;
	//cPID="4";
	//wchar_t* PID;
	while(mybRet)
	{
		wchar_t pszFullPath[MAX_PATH];
		GetProcessFullPath(mype.th32ProcessID,pszFullPath);
		//////�ļ�·��
		//���ͼ��
		MyImage = XImage_LoadFileFromExtractIcon(pszFullPath);
		//���ͼ���б����Ŀ��ʵ��Ӧ�еĲ�����
		XImageList_AddImage(hImageList,MyImage);
		if (XImageList_GetCount(hImageList)!=XList_GetItemCount(hList))
		{
		XImageList_AddImage(hImageList,XImage_LoadFile(L".\\ProcessMonitor.ico"));
		//XList_AddItem(hList,L"..",XList_GetItemCount(hList)-1);
		//XMessageBox(m_hWindow,L"..");
		}
		
		//����ļ���С
		XList_AddItem(hList,mype.szExeFile,(XList_GetItemCount(hList)-1));
		//XList_SetItemText(hList,(XList_GetItemCount(hList)-1),1,PID);
		XList_SetItemText(hList,(XList_GetItemCount(hList)-1),1,pszFullPath);
		My_AddItem(hList,(XList_GetItemCount(hList)-1),20,pszFullPath);
		
		

		mybRet=Process32Next(myhProcess,&mype);
	}
	XList_EnableGrid(hList,false);
	XList_SetItemHeight(hList,50);
	AdjustList(hList);
	return true;
}

void CXPage5::Create()
{
	
	
	m_hEle=XPic_Create(2,110,300,465,mainWnd.m_hWindow);
	XPic_SetImage(m_hEle,XImage_LoadFileAdaptive(L"image\\page5\\bg.png",14,215,107,142));
	XEle_SetBkTransparent(m_hEle,TRUE);
	XEle_ShowEle(m_hEle,FALSE);

	HELE hButton1=XBtn_Create(108,105,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(hButton1,TRUE);
	XEle_EnableFocus(hButton1,FALSE);
	XBtn_SetImageLeave(hButton1,XImage_LoadFile(L"image\\SysTool\\Process1.png"));
	XBtn_SetImageStay(hButton1,XImage_LoadFile(L"image\\SysTool\\Process2.png"));
	XBtn_SetImageDown(hButton1,XImage_LoadFile(L"image\\SysTool\\Process3.png"));
	HELE hButton2=XBtn_Create(408,105,140,140,NULL,m_hEle);
	XEle_SetBkTransparent(hButton2,TRUE);
	XEle_EnableFocus(hButton2,FALSE);
	XBtn_SetImageLeave(hButton2,XImage_LoadFile(L"image\\SysTool\\KillFile1.png"));
	XBtn_SetImageStay(hButton2,XImage_LoadFile(L"image\\SysTool\\KillFile2.png"));
	XBtn_SetImageDown(hButton2,XImage_LoadFile(L"image\\SysTool\\KillFile3.png"));
	XEle_RegisterEvent(hButton1,XE_BNCLICK,Process);
	XEle_RegisterEvent(hButton2,XE_BNCLICK,KillFile);
	/*
	//HWINDOW hWindow=XWnd_CreateWindow(0,0,950,600,L"�����Ż�-���̹�����");
	
	//����ͼƬ�б�
	hImageList=XImageList_Create(40,40);
	//XImageList_EnableFixedSize(hImageList,true);
	//���ͼƬ
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\1.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\2.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\3.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\4.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\5.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\6.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\7.png"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\8.png"));
	
	//�����б�Ԫ��
	hList=XList_Create(3,3,560,430,m_hEle);
	//����ͼƬ�б�
	XList_SetImageList(hList,hImageList);
	//����б�ͷ
	XList_AddColumn(hList,270,L"��������");
	XList_AddColumn(hList,500,L"����·��");
	
	ReFresh();

	
	

	XEle_RegisterEvent(hList,XE_LIST_HEADER_CHANGE,MyEventListHeaderChange);
	XEle_RegisterEvent(hList,XE_DESTROY,MyEventDestroy);
	XList_SetUserDrawItem(hList,MyList_OnDrawItem);
	XEle_RegisterEvent(hList,XE_LIST_SELECT,MyRMouse);

	hStatic=XStatic_Create(566,3,220,20,L"������",m_hEle);
    XEle_SetBkTransparent(hStatic,true); //���ñ���͸��
	hStatic2=XStatic_Create(566,73,220,20,L"����·��",m_hEle);
    XEle_SetBkTransparent(hStatic,true); //���ñ���͸��

	hRichEdit=XRichEdit_Create(566,23,220,50,m_hEle); //����RichEdit
	hRichEdit2=XRichEdit_Create(566,93,220,50,m_hEle); //����RichEdit
	////�������̰�ť
	HELE m_hBtnKill=XBtn_Create(590,200,133,43,NULL,m_hEle);
	XEle_SetBkTransparent(m_hBtnKill,TRUE);
	XEle_EnableFocus(m_hBtnKill,FALSE);
	XBtn_SetImageLeave(m_hBtnKill,XImage_LoadFileRect(L"image\\ProcessMonitor\\btn.png",0,0,133,43));
	XBtn_SetImageStay(m_hBtnKill,XImage_LoadFileRect(L"image\\ProcessMonitor\\btn2.png",0,0,133,43));
	XBtn_SetImageDown(m_hBtnKill,XImage_LoadFileRect(L"image\\ProcessMonitor\\btn.png",0,0,133,43));
	XEle_RegisterEvent(m_hBtnKill,XE_BNCLICK,KillProcessClick);
	//////ˢ���б�ť
	HELE m_hBtnReFresh=XBtn_Create(590,270,133,43,NULL,m_hEle);
	XEle_SetBkTransparent(m_hBtnReFresh,TRUE);
	XEle_EnableFocus(m_hBtnReFresh,FALSE);
	XBtn_SetImageLeave(m_hBtnReFresh,XImage_LoadFileRect(L"image\\ProcessMonitor\\btnrefresh.png",0,0,133,43));
	XBtn_SetImageStay(m_hBtnReFresh,XImage_LoadFileRect(L"image\\ProcessMonitor\\btnrefresh2.png",0,0,133,43));
	XBtn_SetImageDown(m_hBtnReFresh,XImage_LoadFileRect(L"image\\ProcessMonitor\\btnrefresh.png",0,0,133,43));
	XEle_RegisterEvent(m_hBtnReFresh,XE_BNCLICK,ReFreshClick);



	XC_InitFont(&Font1,L"����",12);
    XC_InitFont(&Font2,L"����",16);
    XC_InitFont(&Font3,L"����",20);
    XC_InitFont(&Font4,L"����",28);
    XC_InitFont(&Font5,L"����",16,TRUE);
    XC_InitFont(&Font6,L"����",16,FALSE,TRUE);
    XC_InitFont(&Font7,L"����",16,FALSE,FALSE,TRUE);
	 //XRichEdit_SetText(hRichEdit,L"......45787");
	   XRichEdit_SetReadOnly(hRichEdit,TRUE);
	  // XRichEdit_InsertTextEx(hRichEdit,L"aaa",0,0,&Font2,FALSE,NULL);
	//XWnd_ShowWindow(m_hWindow,SW_SHOW);	//��ʾ����

	//XWnd_SetTransparentAlpha(m_hWindow,220); //����͸����
	//XWnd_SetTransparentFlag(m_hWindow,XC_WIND_TRANSPARENT_SHADOW);//����͸������,�߿���Ӱ

	/*
	HELE hTabBar=XTabBar_Create(5,5,730,31,m_hEle);
	XEle_EnableBorder(hTabBar,FALSE);
	XEle_SetBkTransparent(hTabBar,TRUE);
	XTabBar_SetLabelSpacing(hTabBar,0);
	XTabBar_AddLabel(hTabBar,L"   ����ۼ�   ");
	XTabBar_AddLabel(hTabBar,L"   һ������   ");
	XTabBar_AddLabel(hTabBar,L"   ��������   ");
	XTabBar_AddLabel(hTabBar,L"   ������   ");
	XTabBar_AddLabel(hTabBar,L"   ����ע���  ");
	XTabBar_AddLabel(hTabBar,L"   ���Ҵ��ļ�  ");

	HIMAGE  hImageLeave = XImage_LoadFileAdaptive(L"image\\page5\\tab_leave.png",9,103,10,25);
	HIMAGE  hImageStay = XImage_LoadFileAdaptive(L"image\\page5\\tab_stay.png",9,103,10,25);
	HIMAGE  hImageCheck = XImage_LoadFileAdaptive(L"image\\page5\\tab_check.png",9,102,8,21);

	for (int i=0;i<6;i++)
	{
		HELE hButton=XTabBar_GetLabel(hTabBar,i);
		XEle_EnableFocus(hButton,FALSE);
		XEle_SetBkTransparent(hButton,TRUE);
		XBtn_SetOffset(hButton,0,3);

		XBtn_SetImageLeave(hButton,hImageLeave);
		XBtn_SetImageStay(hButton,hImageStay);
		XBtn_SetImageDown(hButton,hImageCheck);
		XBtn_SetImageCheck(hButton,hImageCheck);
	}


	HELE hListBox=XListBox_Create(2,100,612,360,m_hEle);
	XListBox_SetItemHeight(hListBox,60);
	XListBox_EnableCheckBox(hListBox,TRUE);
	XEle_SetBkTransparent(hListBox,TRUE);
	XEle_SetBkTransparent(XSView_GetView(hListBox),TRUE);
	XEle_EnableBorder(hListBox,FALSE);

	HIMAGE  hImageIcon = XImage_LoadFile(L"image\\page5\\1.png");
	HXCGUI  hImageList=XImageList_Create(35,36);
	XImageList_AddImage(hImageList,hImageIcon);
	XListBox_SetImageList(hListBox,hImageList);


	HFONTX hFontInfo=XFont_Create2(L"����",12,TRUE);
	wchar_t name[256]={0};
	for (int i=0;i<10;i++)
	{
		XListBox_AddString(hListBox,L"",0);

		wsprintf(name,L"Windows ʹ�úۼ� - %d",i);
		itemBindEle_  info;
		info.hEle=XStatic_Create(0,0,100,20,name);
		info.left=60;
		info.top=15;
		info.height=20;
		info.width=150;
		XListBox_SetItemBindEle(hListBox,i,&info);
		XEle_SetFont(info.hEle,hFontInfo);
		XEle_SetBkTransparent(info.hEle,TRUE);

		info.hEle=XStatic_Create(0,0,100,20,L"Windows�����кۼ�,���ĵ��ۼ���.");
		info.left=60;
		info.top=35;
		info.height=20;
		info.width=200;
		XListBox_SetItemBindEle(hListBox,i,&info);
		XEle_SetTextColor(info.hEle,RGB(128,128,128));
		XEle_SetBkTransparent(info.hEle,TRUE);

		info.hEle=XStatic_Create(0,0,100,20,L"��Ҫ��˽");
		info.left=480;
		info.top=25;
		info.height=20;
		info.width=60;
		XListBox_SetItemBindEle(hListBox,i,&info);
		XEle_SetTextColor(info.hEle,RGB(255,0,0));
		XEle_SetBkTransparent(info.hEle,TRUE);
	}
	*/
	//XMessageBox(NULL,L"�򿪡�����",L"������������",1);
}

void CXPage5::AdjustLayout()
{

}
void CXPage6::Create()
{
	m_hEle=XPic_Create(2,110,300,465,mainWnd.m_hWindow);
	XPic_SetImage(m_hEle,XImage_LoadFileAdaptive(L"image\\page6\\RTA.png",14,215,107,142));
	XEle_SetBkTransparent(m_hEle,TRUE);
	XEle_ShowEle(m_hEle,FALSE);
	/*
	HELE m_Text=XStatic_Create(200,130,100,50,L"����/��������",m_hEle);
	XStatic_AdjustSize(m_Text);
	//XEle_SetTextColor(m_Text,RGB(255,255,255));
	XEle_SetBkTransparent(m_Text,TRUE);
	XEle_EnableMouseThrough(m_Text,TRUE);
	*/
	////USBRTA
	USBRTA=XBtn_Create(550,204,70,29,NULL,m_hEle);
	XEle_SetBkTransparent(USBRTA,TRUE);
	XEle_EnableFocus(USBRTA,FALSE);
	SetState(USBRTA,true);

	////ProcessRTA
	ProcessRTA=XBtn_Create(550,108,70,29,NULL,m_hEle);
	XEle_SetBkTransparent(ProcessRTA,TRUE);
	XEle_EnableFocus(ProcessRTA,FALSE);
	SetState(ProcessRTA,true);
	////RegRTA
	RegRTA=XBtn_Create(550,156,70,29,NULL,m_hEle);
	XEle_SetBkTransparent(RegRTA,TRUE);
	XEle_EnableFocus(RegRTA,FALSE);
	SetState(RegRTA,true);
	////Protect
	Protect=XBtn_Create(550,252,70,29,NULL,m_hEle);
	XEle_SetBkTransparent(Protect,TRUE);
	XEle_EnableFocus(Protect,FALSE);
	SetState(Protect,true);
    XEle_RegisterEvent(Protect,XE_BNCLICK,ReReadClick_Sel);
	XEle_RegisterEvent(USBRTA,XE_BNCLICK,ReReadClick_USB);
	XEle_RegisterEvent(ProcessRTA,XE_BNCLICK,ReReadClick_Pro);
	XEle_RegisterEvent(RegRTA,XE_BNCLICK,ReReadClick_Reg);
	
	/*if(FindProcess("QQ.exe"))
		MessageBox(MyHWnd,_T("����QQ~"),_T("FindProcess"),MB_OK);*/
}

/////////////////////////////////////////////////////////////////////////

void CXPage9::Create()
{
	m_hEle=XPic_Create(2,110,300,465,mainWnd.m_hWindow);
	XEle_ShowEle(m_hEle,FALSE);
	XPic_SetImage(m_hEle, XImage_LoadFileAdaptive(L"image\\page9\\bg.png",10,340,10,150));
	XEle_SetBkTransparent(m_hEle,TRUE);

	m_hListView=XListView_Create(2,10,844,420,m_hEle);
	XListView_SetIconSize(m_hListView,58,58);
	XListView_SetItemBorderSpacing(m_hListView,16,5,16,8);
	XListView_SetColumnSpacing(m_hListView,10);
	XListView_SetRowSpacing(m_hListView,35);
	XSView_SetSpacing(m_hListView,0,0,0,0);
	XEle_SetBkTransparent(m_hListView,TRUE);
	XEle_SetBkTransparent(XSView_GetView(m_hListView),TRUE);
	XEle_EnableBorder(m_hListView,FALSE);

	HELE hScrollBar=XSView_GetVScrollBar(m_hListView);
	XSBar_EnableScrollButton2(hScrollBar,FALSE);
	XSBar_SetImage(hScrollBar,XImage_LoadFileAdaptive(L"image\\ScrollBar\\bkg.png",1,15,10,55));//16*65
	XSBar_SetImageLeaveSlider(hScrollBar,XImage_LoadFileAdaptive(L"image\\ScrollBar\\slider_leave.png",3,13,15,45));
	XSBar_SetImageStaySlider(hScrollBar,XImage_LoadFileAdaptive(L"image\\ScrollBar\\slider_stay.png",3,13,15,45));
	XSBar_SetImageDownSlider(hScrollBar,XImage_LoadFileAdaptive(L"image\\ScrollBar\\slider_down.png",3,13,15,45));

	XEle_SetBkTransparent(hScrollBar,TRUE);

	HXCGUI hImageLsit=XImageList_Create(58,58);
	XImageList_EnableFixedSize(hImageLsit,FALSE);
	wchar_t iconName[256]={0};
	for (int i=1;i<10;i++)
	{
		wsprintf(iconName,L"image\\AppIcon\\%d.png",i);
		XImageList_AddImage(hImageLsit,XImage_LoadFile(iconName));
	}

	XListView_SetImageList(m_hListView,hImageLsit);
	XListView_AddItem(m_hListView,L"ǿ��ɾ���ļ�",0);
	XListView_AddItem(m_hListView,L"U�ָ̻�����",1);
	XListView_AddItem(m_hListView,L"���׽��̹���",2);
	XListView_AddItem(m_hListView,L"�߼����̹���",3);
	XListView_AddItem(m_hListView,L"ע����޸�",4);
	XListView_AddItem(m_hListView,L"U��С����",5);

	HIMAGE hImageStay=XImage_LoadFile(L"image\\page9\\listView_stay.png");
	HIMAGE hImageSelect=XImage_LoadFile(L"image\\page9\\listView_select.png");
	for (int i=0;i<10;i++)
	{
		XListView_SetItemImageStay(m_hListView,-1,i,hImageStay);
		XListView_SetItemImageSelect(m_hListView,-1,i,hImageSelect);
	}
	
	XEle_RegisterEvent(m_hListView,XE_LISTVIEW_SELECT,OnEventListViewSelect);

	//�ײ�
	m_hBottom=XPic_Create(0,100,100,30,m_hEle);
	XPic_SetImage(m_hBottom,XImage_LoadFileAdaptive(L"image\\page9\\bottomBar.png",420,450,5,30));
	XEle_SetBkTransparent(m_hBottom,TRUE);
	/*
	//���С����
	XBtn_Create(625,6,100,28,L"���С����",m_hBottom);
	
	//����
	XBtn_Create(750,6,60,28,L"����",m_hBottom);*/

}

void CXPage9::AdjustLayout()
{
	RECT rect;
	XEle_GetClientRect(m_hEle,&rect);

	RECT rc;
	rc.left=20;
	rc.right=rect.right-5;
	rc.top=10;
	rc.bottom=rect.bottom-40;
	XEle_SetRect(m_hListView,&rc);

	rc.top=rc.bottom;
	rc.bottom=rect.bottom-2;
	rc.left=0;
	rc.right=rect.right;
	XEle_SetRect(m_hBottom,&rc);
}
// �б���Ԫ��,��ѡ���¼�.
BOOL CALLBACK OnEventListViewSelect(HELE hEle,HELE hEventEle,int groupIndex,int itemIndex)
{
    XTRACE("��ѡ�� groupIndex=%d itemIndex=%d \n",groupIndex,itemIndex);
    XTRACE("---------------\n");
	switch(itemIndex)
	{
	case 0:
		if (!CreateNew(_T(".\\Tools\\KillFiles\\KillFile.exe")))
			MessageBox(NULL,_T("����Ӧ��ʧ�ܣ�"),_T("������������"),MB_OK);
		break;
	case 1:
		if (!CreateNew(_T(".\\Tools\\FixFolders\\������������-�ƶ��������ļ����޸�����.exe")))
			MessageBox(NULL,_T("����Ӧ��ʧ�ܣ�"),_T("������������"),MB_OK);
		break;
	case 2:
		if (!CreateNew(_T(".\\Tools\\ProcessMonitor\\SimProcessMonitor.exe")))
			MessageBox(NULL,_T("����Ӧ��ʧ�ܣ�"),_T("������������"),MB_OK);
		break;
	case 3:
		if (!CreateNew(_T(".\\Tools\\ProcessMonitor\\ProcessMonitor.exe")))
			MessageBox(NULL,_T("����Ӧ��ʧ�ܣ�"),_T("������������"),MB_OK);
		break;
	case 4:
		if (!CreateNew(_T(".\\Tools\\RegMonitor\\RegTools.exe")))
			MessageBox(NULL,_T("����Ӧ��ʧ�ܣ�"),_T("������������"),MB_OK);
		break;
	case 5:
	   if (!CreateNew(_T("explorer.exe"),L".\\Tools\\USBTools\\"))
			MessageBox(NULL,_T("����Ӧ��ʧ�ܣ�"),_T("������������"),MB_OK);
		break;
	//case 1:

	}
	//XListView_SetSelectItem(m_page9.m_hListView,groupIndex,itemIndex,false);
    return false;
}
///////////////////////////////////////////////////////////////////////////

void CSkinDlg::Create()
{
	int width=380;
	int height=320;

	RECT rect;
	XEle_GetRect(mainWnd.m_hBtnSkin,&rect);

	POINT pt;
	pt.x=rect.right-width;
	pt.y=rect.bottom;

	HWND hMainWnd=XWnd_GetHWnd(mainWnd.m_hWindow);
	ClientToScreen(hMainWnd,&pt);

	m_hWindow=XWnd_CreateWindow(pt.x,pt.y,width,height,L"Skin",hMainWnd,XC_SY_ROUND);
	XWnd_SetRoundSize(m_hWindow,9);

	XWnd_SetImageNC(m_hWindow,mainWnd.m_hThemeBackground);
	XWnd_SetImage(m_hWindow,mainWnd.m_hThemeBorder);

	HELE hPicTitle=XPic_Create(10,10,360,25,m_hWindow);
	XEle_SetBkTransparent(hPicTitle,TRUE);
	XPic_SetImage(hPicTitle,XImage_LoadFile(L"image\\skinDlg\\titleBG.png"));
	
	HELE hStaticTitle=XStatic_Create(10,5,100,20,L"����Ƥ��",hPicTitle);
	XEle_SetBkTransparent(hStaticTitle,TRUE);
	XEle_SetTextColor(hStaticTitle,RGB(255,255,255));

	m_hListView=XListView_Create(20,45,350,205,m_hWindow);
	XListView_SetIconSize(m_hListView,97,62);
	XListView_SetItemBorderSpacing(m_hListView,3,3,3,3);
	XListView_SetViewLeftAlign(m_hListView,0);
	XListView_SetViewTopAlign(m_hListView,0);
	XEle_SetTextColor(m_hListView,RGB(255,255,255));
	XEle_EnableBorder(m_hListView,FALSE);
	XEle_SetBkTransparent(m_hListView,TRUE);
	XEle_SetBkTransparent(XSView_GetView(m_hListView),TRUE);

	HXCGUI hImageList=XImageList_Create(97,62);
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\skin\\skin1.jpg"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\skin\\skin2.jpg"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\skin\\skin3.jpg"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\skin\\skin4.jpg"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\skin\\skin5.jpg"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\skin\\skin6.jpg"));
	XImageList_AddImage(hImageList,XImage_LoadFile(L"image\\skin\\skin7.jpg"));

	XListView_SetImageList(m_hListView,hImageList);
	XListView_AddItem(m_hListView,L"Ĭ��Ƥ��",0);
	XListView_AddItem(m_hListView,L"���ž�ʿ",1);
	XListView_AddItem(m_hListView,L"�����ǿ�",2);
	//XListView_AddItem(m_hListView,L"��ɫ֮��",3);
	//XListView_AddItem(m_hListView,L"�ܶ���С��",4);
	XListView_AddItem(m_hListView,L"��������",5);
	XListView_AddItem(m_hListView,L"�ŵ�ľ��",6);
	
	HIMAGE  hImageStay=XImage_LoadFile(L"image\\skinDlg\\listView_stay.png");
	HIMAGE  hImageSelect=XImage_LoadFile(L"image\\skinDlg\\listView_select.png");
	for (int i=0;i<7;i++)
	{
		XListView_SetItemImageStay(m_hListView,-1,i,hImageStay);
		XListView_SetItemImageSelect(m_hListView,-1,i,hImageSelect);
	}
	XListView_SetSelectItem(m_hListView,-1,mainWnd.m_SkinIndex,TRUE);

	HELE hScrollBar=XSView_GetVScrollBar(m_hListView);
	XEle_SetBkTransparent(hScrollBar,TRUE);
	XSBar_EnableScrollButton2(hScrollBar,FALSE);
	XSBar_SetImageLeaveSlider(hScrollBar,XImage_LoadFileAdaptive(L"image\\skinDlg\\ScrollBar_leave.png",1,14,10,40));
	XSBar_SetImageStaySlider(hScrollBar,XImage_LoadFileAdaptive(L"image\\skinDlg\\ScrollBar_stay.png",1,14,10,40));
	XSBar_SetImageDownSlider(hScrollBar,XImage_LoadFileAdaptive(L"image\\skinDlg\\ScrollBar_stay.png",1,14,10,40));

	XCGUI_RegEleEvent(m_hListView,XE_LISTVIEW_SELECT,&CSkinDlg::OnEventListViewSelect);
	XCGUI_RegWndMessage(m_hWindow,WM_KILLFOCUS,&CSkinDlg::OnWndKillFocus);
	
	XWnd_ShowWindow(m_hWindow,SW_SHOW);
}

BOOL CSkinDlg::OnEventListViewSelect(HELE hEle,HELE hEventEle,int groupIndex,int itemIndex)
{
	if(itemIndex<0) return FALSE;

	if(mainWnd.m_SkinIndex!=itemIndex) //�л�Ƥ��
	{
		mainWnd.m_SkinIndex=itemIndex;
		switch(itemIndex)
		{
		case 0: mainWnd.m_hThemeBackground=XImage_LoadFile(L"image\\skin\\frame1.jpg"); break;
		case 1: mainWnd.m_hThemeBackground=XImage_LoadFile(L"image\\skin\\frame2.jpg"); break;
		case 2: mainWnd.m_hThemeBackground=XImage_LoadFile(L"image\\skin\\frame3.jpg"); break;
		case 3: mainWnd.m_hThemeBackground=XImage_LoadFile(L"image\\skin\\frame6.jpg"); break;
		case 4: mainWnd.m_hThemeBackground=XImage_LoadFile(L"image\\skin\\frame7.jpg"); break;
		//case 5: mainWnd.m_hThemeBackground=XImage_LoadFile(L"image\\skin\\frame6.jpg"); break;
		//case 6: mainWnd.m_hThemeBackground=XImage_LoadFile(L"image\\skin\\frame7.jpg"); break;
		}
		
		XImage_SetDrawType(mainWnd.m_hThemeBackground,XC_IMAGE_TILE);

		XWnd_SetImageNC(mainWnd.m_hWindow,mainWnd.m_hThemeBackground);
		XWnd_SetImageNC(m_hWindow,mainWnd.m_hThemeBackground);

		XWnd_RedrawWnd(mainWnd.m_hWindow);
		XWnd_RedrawWnd(m_hWindow);
	}
	return FALSE;
}

BOOL CSkinDlg::OnWndKillFocus(HWINDOW hWindow)
{
	HWND hWnd=XWnd_GetHWnd(m_hWindow);
	::DestroyWindow(hWnd);
	delete this;
	return TRUE;
}

BOOL ConnectInit()
{
	//TestShareString
	
	hMapping=CreateFileMapping((HANDLE)0xFFFFFFFF,NULL,PAGE_READWRITE,0,0x100,_T("PhotonMemorySpace"));   
	if(hMapping==NULL)   
	{ 
		//AfxMessageBox("�����ڴ��ļ�ӳ��ʧ�ܣ�");
		return false;
	}
	//���ļ�����ͼӳ�䵽һ�����̵ĵ�ַ�ռ��ϣ�����LPVOID���͵��ڴ�ָ��
	lpData=(LPSTR)MapViewOfFile(hMapping,FILE_MAP_ALL_ACCESS,0,0,0);   
	if(lpData==NULL)   
	{   
		//AfxMessageBox("ӳ���ļ���ͼʧ�ܣ�");
		return false;
	}
	
	XTRACE(lpData);
	
	return true;
}
int APIENTRY _tWinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,LPTSTR lpCmdLine, int nCmdShow)
{
	
	XInitXCGUI();
	
	if(mainWnd.Create())//��������
	{
		if (!ConnectInit())//��ʼ�������ڴ�
		{
			MessageBox(MyHWnd,_T("����1001 �޷������ڴ�ӳ��"),_T("��������"),MB_OK);
	        ::DestroyWindow(MyHWnd);
			return 0;
		}
		/*
		if (!CreateNew(_T("USBRTA.exe")))
		{
			MessageBox(MyHWnd,_T+("����1200 �޷���������"),_T("��������"),MB_OK);
		}
		*/
		wchar_t strReadPro[100],strReadReg[100],strReadUSB[100];
		wchar_t* strProIni=strReadPro;
		wchar_t* strRegIni=strReadReg;
		wchar_t* strUSBIni=strReadUSB;
		
        //WritePrivateProfileString ("RTA","Message",p,".\\chat.ini");
		GetPrivateProfileString(L"Main", L"ProcessRTA", L"0", strProIni, sizeof(strProIni),_T(".\\Set.ini")); 
		if(wcscmp(strProIni,L"1")==0)
		{
			CreateNew(_T("ProcessRTA.exe"));
		}
		GetPrivateProfileString(L"Main", L"RegRTA", L"0", strRegIni, sizeof(strRegIni),_T(".\\Set.ini")); 
		if(wcscmp(strRegIni,L"1")==0)
		{
			CreateNew(_T("RegRTA.exe"));
		}
		GetPrivateProfileString(L"Main", L"USBRTA", L"0", strUSBIni, sizeof(strUSBIni),_T(".\\Set.ini")); 
		if(wcscmp(strUSBIni,L"1")==0)
		{
			CreateNew(_T("USBRTA.exe"));
		}
		//MyMessageBox();
	    system("regsvr32 /s ProcProtectCtrl.dll");
		if (FindProcess("Protect.exe") && FindProcess("ProtectProcess.exe"))
		{
			//CreateNew(_T("Protect.exe"));
		}
		ReRead();
		sprintf(lpData,"Protect.ReLoad");
		XRunXCGUI();
	}
	return 0;
}

BOOL FirstInstance()
{
  //�������������ж��Ƿ��Ѿ���ʵ��������
  if (!FindWindow(NULL,_T("������������"))==NULL)
  {
	  return FALSE;                             
  }
  else
	  return TRUE;     
  
}



BOOL CALLBACK My_MenuSelect(HWINDOW hWindow,int id)  //�˵�ѡ��
{

	//HELE hPic;
    XTRACE("�˵�ID=%d\n",id);
	switch (id)
	{
	case 201:
		CreateNew(_T(".\\ProgramUpdate.exe"));
		break;
	case 202:
		hWindowAbout=XWnd_CreateWindow(0,0,520,290,L"������������-����",NULL, XC_SY_BORDER | XC_SY_ROUND | XC_SY_CENTER); //��������
        if(hWindowAbout) //�����ɹ�
            XWnd_ShowWindow(hWindowAbout,SW_SHOW); //��ʾ����
		//hPic=XPic_Create(0,0,520,290,hWindowAbout);
		//XPic_SetImage(hPic,XImage_LoadFile(L"image\\about.jpg",true)); //����ͼƬ
		XWnd_EnableCloseButton(hWindowAbout,true,true);
		XWnd_SetImage(hWindowAbout,XImage_LoadFile(L"image\\about.jpg",true));
		break;
	case 203:
		//XWnd_CloseWindow(hWindowAbout);
		XWnd_CloseWindow(hWindow);
		break;
	}

    return true;
}

BOOL CALLBACK My_MenuExit(HWINDOW hWindow) //�˵��˳�
{
    XTRACE("�˵��˳�\n");
    return false;
}
BOOL CALLBACK ReFreshClick(HELE hEle,POINT *pPt)
{
	ReFresh();
	return true;
}
BOOL CALLBACK KillProcessClick(HELE hEle,POINT *pPt)
{
	wchar_t* ProcessName;
	ProcessName=XList_GetItemText(hList,XList_GetSelectItem(hList),0);
	if (ProcessName!=L"")
	FindAndKillProcessByName(ProcessName);
	ReFresh();
	return false;

}
BOOL FindAndKillProcessByName(LPCTSTR strProcessName)
{
        if(NULL == strProcessName)
        {
                return FALSE;
        }
        HANDLE handle32Snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        if (INVALID_HANDLE_VALUE == handle32Snapshot)
        {
                        return FALSE;
        }
        PROCESSENTRY32 pEntry;       
        pEntry.dwSize = sizeof( PROCESSENTRY32 );
        //Search for all the process and terminate it
        if(Process32First(handle32Snapshot, &pEntry))
        {
                BOOL bFound = FALSE;
                if (!_tcsicmp(pEntry.szExeFile, strProcessName))
                {
                        bFound = TRUE;
                        }
                while((!bFound)&&Process32Next(handle32Snapshot, &pEntry))
                {
                        if (!_tcsicmp(pEntry.szExeFile, strProcessName))
                        {
                                bFound = TRUE;
                        }
                }
                if(bFound)
                {
                        CloseHandle(handle32Snapshot);
                        HANDLE handLe =  OpenProcess(PROCESS_TERMINATE , FALSE, pEntry.th32ProcessID);
                        BOOL bResult = TerminateProcess(handLe,0);
                        return bResult;
                }
        }
        CloseHandle(handle32Snapshot);
        return FALSE;
}
////////////////FLASH����ģ��////////////////////////////////
BOOL CMainWnd::StartFlash()
{
	HWND hWnd=MyHWnd;
    XFlash_OpenFlashFile(hFlash,L"C:\\PhotonCoolLogo.swf"); //��FLASH�ļ�
		XBtn_SetImageLeave(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",0,0,47,22));
		XBtn_SetImageStay(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",47,0,47,22));
		XBtn_SetImageDown(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",94,0,47,22));
	 
	return true;
}
BOOL CALLBACK MainFrameClick(HELE hEle,POINT *pPt)
{
	return true;
}
BOOL CALLBACK MainFrameOtherClick(HELE hEle,POINT *pPt)
{
	/*
	int Index =XRadio_GetGroupID(hEle);
	XEle_ShowEle(m_page1.m_hEle,false);
	XEle_ShowEle(m_page2.m_hEle,false);
	XEle_ShowEle(m_page3.m_hEle,false);
	XEle_ShowEle(m_page5.m_hEle,false);
	XEle_ShowEle(m_page6.m_hEle,false);
	XEle_ShowEle(m_page9.m_hEle,false);
	switch(Index)
	{
	case 1:XEle_ShowEle(m_page1.m_hEle,true);break;
	case 2:XEle_ShowEle(m_page2.m_hEle,true);break;
		case 3:XEle_ShowEle(m_page3.m_hEle,true);break;
		case 5:XEle_ShowEle(m_page5.m_hEle,true);break;
		case 6:XEle_ShowEle(m_page6.m_hEle,true);break;
        case 9:XEle_ShowEle(m_page9.m_hEle,true);break;
	}*/

	XWnd_ShowWindow(hFlashWnd,SW_HIDE);
	return true;
}
BOOL CALLBACK ChangeFlash(HELE hEle,POINT *pPt)
{
	if (!IsStart)
	{
		hFlashWnd=XWnd_CreateWindowEx(NULL,NULL,L"flash",WS_CHILD,3,110,800,440,MyHWnd,0); //����FLASH��������
		hFlash=XFlash_Create(hFlashWnd);
		XFlash_OpenFlashFile(hFlash,L"C:\\PhotonCoolLogo.swf"); //��FLASH�ļ�
		XBtn_SetImageLeave(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",0,0,47,22));
		XBtn_SetImageStay(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",47,0,47,22));
		XBtn_SetImageDown(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_close.png",94,0,47,22));
		XWnd_ShowWindow(hFlashWnd,SW_SHOW);
		IsStart=true;
	}
	else
	{
		XFlash_Destroy(hFlash);
		XWnd_CloseWindow(hFlashWnd);
		XWnd_ShowWindow(hFlashWnd,SW_HIDE);
		XBtn_SetImageLeave(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_play.png",0,0,47,22));
		XBtn_SetImageStay(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_play.png",47,0,47,22));
		XBtn_SetImageDown(m_BtnClose,XImage_LoadFileRect(L"image\\sys_button_play.png",94,0,47,22));
		IsStart=false;
	}
	return true;
}
////////////////FLASH����ģ��END/////////////////////////////
////////////////��������ģ��/////////////////////////////////
BOOL CreateNew(LPCTSTR FilePath,wchar_t* Command)
{/*
    PROCESS_INFORMATION pi;
	STARTUPINFO si;
	//��ʼ������
	memset(&si,0,sizeof(si));
	si.cb=sizeof(si);
	si.wShowWindow=SW_SHOW;
	si.dwFlags=STARTF_USESHOWWINDOW;
	BOOL bRet = CreateProcess((LPCTSTR) FilePath,
		(wchar_t*)Command,
		(LPSECURITY_ATTRIBUTES) NULL,
		(LPSECURITY_ATTRIBUTES) NULL,
		false,
		DETACHED_PROCESS,
		(LPVOID) NULL,
		NULL,
		(LPSTARTUPINFO) &si,
		(LPPROCESS_INFORMATION) &pi);*/
	ShellExecute(NULL,L"open",FilePath,Command,NULL,SW_SHOWNORMAL);
	/*if(bRet)
    {
		return true;
	}
	else*/
		return true;
}
////////////////��������ģ��END//////////////////////////////

BOOL SetState(HELE BtnEle,BOOL OnOrOFF)
{
	if (OnOrOFF)
	{	
		XBtn_SetImageLeave(BtnEle,XImage_LoadFileRect(L"image\\page6\\on.png",0,0,133,43));
		XBtn_SetImageStay(BtnEle,XImage_LoadFileRect(L"image\\page6\\on2.png",0,0,133,43));
		XBtn_SetImageDown(BtnEle,XImage_LoadFileRect(L"image\\page6\\on.png",0,0,133,43));
	}
	else
	{
		XBtn_SetImageLeave(BtnEle,XImage_LoadFileRect(L"image\\page6\\off.png",0,0,133,43));
		XBtn_SetImageStay(BtnEle,XImage_LoadFileRect(L"image\\page6\\off2.png",0,0,133,43));
		XBtn_SetImageDown(BtnEle,XImage_LoadFileRect(L"image\\page6\\off.png",0,0,133,43));
	}
	return true;
}

BOOL ReRead()
{
	SetState(ProcessRTA,FindProcess("ProcessRTA.exe"));
	SetState(USBRTA,FindProcess("USBRTA.exe"));
	SetState(RegRTA,FindProcess("RegRTA.exe"));
    SetState(Protect,FindProcess("ProtectProcess.exe"));
	int i=0;
	if (FindProcess("ProcessRTA.exe"))
		i++;
	if (FindProcess("USBRTA.exe"))
		i++;
	if (FindProcess("RegRTA.exe"))
		i++;
	if (FindProcess("ProtectProcess.exe"))
		i++;
	switch (i)
	{
		case 0:
			XEle_SetTextColor(OpenNum,RGB(220,20,60));
			XStatic_SetText(OpenNum,L"�ѿ��� 0 �㱣��\n\n����δ����");
			break;
		case 1:
			XEle_SetTextColor(OpenNum,RGB(210,105,30));
			XStatic_SetText(OpenNum,L"�ѿ��� 1 �㱣��\n\n����δ��ȫ����");
			break;
		case 2:
			XEle_SetTextColor(OpenNum,RGB(210,105,30));
			XStatic_SetText(OpenNum,L"�ѿ��� 2 �㱣��\n\n����δ��ȫ����");
			break;
		case 3:
			XEle_SetTextColor(OpenNum,RGB(210,105,30));
			XStatic_SetText(OpenNum,L"�ѿ��� 3 �㱣��\n\n����δ��ȫ����");
			break;
		case 4:
			XEle_SetTextColor(OpenNum,RGB(0,100,0));
			XStatic_SetText(OpenNum,L"�ѿ��� 4 �㱣��\n\n������ȫ����");
			break;
	}
	XEle_RedrawEle(OpenNum,0);
	XEle_RedrawEle(ProcessRTA,0);
	XEle_RedrawEle(USBRTA,0);
	XEle_RedrawEle(RegRTA,0);
	XEle_RedrawEle(Protect,0);
	return true;
}
char* WstrTopChar(LPWSTR wstr)  /////ת���ַ���
{
	DWORD dwNum = WideCharToMultiByte(CP_MACCP,NULL,wstr,-1,NULL,0,NULL,FALSE);
	char *psText;
	psText = new char[dwNum];
	if(!psText)
	{
		delete []psText;
	}
	WideCharToMultiByte (CP_MACCP,NULL,wstr,-1,psText,dwNum,NULL,FALSE);
	return psText;

}
BOOL FindProcess(char* ProcessName)///�жϽ����Ƿ����
{
	HANDLE myhProcess;
	PROCESSENTRY32 mype;
	mype.dwSize = sizeof(PROCESSENTRY32); 
	BOOL mybRet;
	//���н��̿���
	myhProcess=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0); //TH32CS_SNAPPROCESS�������н���
	//��ʼ���̲���
	mybRet=Process32First(myhProcess,&mype);
	//ѭ���Ƚϣ��ó�ProcessID
	while(mybRet)
	{
		if(stricmp(WstrTopChar(mype.szExeFile),ProcessName)==0)
		{
			//MessageBox(MyHWnd,_T(".."),_T("157"),MB_OK);
			return true;
		}
		else
			mybRet=Process32Next(myhProcess,&mype);
		
	}
	return false;
}
BOOL CALLBACK ReReadClick_USB(HELE hEle,POINT *pPt)
{
	THreadTest *mythreadTest=new THreadTest();
     mythreadTest->a=1;//��������ֵ
	CreateThread(NULL,0,ThreadReRead,mythreadTest,NULL,NULL);
	return true;
}
BOOL CALLBACK ReReadClick_Pro(HELE hEle,POINT *pPt)
{
	THreadTest *mythreadTest=new THreadTest();
     mythreadTest->a=2;//��������ֵ
	CreateThread(NULL,0,ThreadReRead,mythreadTest,NULL,NULL);
	return true;
}
BOOL CALLBACK ReReadClick_Reg(HELE hEle,POINT *pPt)
{
	THreadTest *mythreadTest=new THreadTest();
     mythreadTest->a=3;//��������ֵ
	CreateThread(NULL,0,ThreadReRead,mythreadTest,NULL,NULL);
	return true;
}
BOOL CALLBACK ReReadClick_Sel(HELE hEle,POINT *pPt)
{
	THreadTest *mythreadTest=new THreadTest();
     mythreadTest->a=4;//��������ֵ
	CreateThread(NULL,0,ThreadReRead,mythreadTest,NULL,NULL);
	return true;
}
DWORD WINAPI ThreadReRead (LPVOID pParam) 
{
	THreadTest* mythread=(THreadTest*)pParam;
	switch(mythread->a)
	{
	case 1:/*USB*/
		if(FindProcess("USBRTA.exe"))
		{
			sprintf(lpData,"NULL");
	        Sleep(1000);
			sprintf(lpData,"USBRTA.Unload");
		}
		else
		{
			CreateNew(_T("USBRTA.exe"),L"");
			
		}
		break;
	case 2:/*Pro*/
		if(FindProcess("ProcessRTA.exe"))
		{
			sprintf(lpData,"NULL");
	        Sleep(1000);
			sprintf(lpData,"ProcessRTA.Unload");
		}
		else
		{
			CreateNew(_T("ProcessRTA.exe"),L"");
		}
		break;
	case 3:/*Reg*/
		if(FindProcess("RegRTA.exe"))
		{
			sprintf(lpData,"NULL");
	        Sleep(1000);
			sprintf(lpData,"RegRTA.Unload");
		}
		else
		{
			CreateNew(_T("RegRTA.exe"),L"");
		}
		break;
	case 4:/*SelfProtect*/
		if(FindProcess("ProtectProcess.exe"))
		{
			sprintf(lpData,"NULL");
	        Sleep(1000);
			sprintf(lpData,"Protect.Unload");
		}
		else
		{
			CreateNew(_T("Protect.exe"),L"");
		}
		break;
	case 5:/*AllDiskScan*/
		if(!FindProcess("ScanMod.exe"))
		{
			CreateNew(_T(".\\ScanMod.exe"));
		}
		sprintf(lpData,"NULL");
		Sleep(1000);
		sprintf(lpData,"ScanMod.Scan.AdvAllDisk");
		break;
	case 6:/*TargetScan*/
        if(!FindProcess("ScanMod.exe"))
		{
			CreateNew(_T(".\\ScanMod.exe"));
		}
		sprintf(lpData,"NULL");
		Sleep(1000);
		sprintf(lpData,"ScanMod.Choose");
		break;
	case 7:
		//CreateNew(_T(".\\NetScanner\\Photon-NetScanner.exe"),L"");
		 //ShellExecute(NULL,L"open",L"..\\Photon-NetScanner.exe",NULL,L".\\NetScanner\\",SW_SHOWNORMAL);
		//ShellExecute(NULL,L"open",L".\\koemsec1.exe",L"-Start",L".\\NetScanner\\",SW_SHOWNORMAL);
		//ShellExecute(NULL,L"open",L".\\koemsec1.exe",L"-Service",L".\\NetScanner\\",SW_SHOWNORMAL);
		ShellExecute(NULL,L"open",L"explorer.exe",L"/select,.\\Photon-NetScanner.exe",L".\\NetScanner\\",SW_SHOWNORMAL);
		 //XMessageBox(m_hWindow,L"���ڴ򿪵Ĵ�����˫�����С�Photon-NetScanner.exe��",L"Ϊ��ֹ�������ֶ�������",1);
		break;
	}
	XTRACE(lpData);
	Sleep(1500);
	sprintf(lpData,"NULL");
	Sleep(1500);
	sprintf(lpData,"Protect.ReLoad");
	ReRead();
	Sleep(5000);
	ReRead();
	return 0;
}
BOOL CALLBACK Repair(HELE hEle,POINT *pPt)
{
	CreateNew(_T(".\\PhotonRepair.exe"),L"");
	return true;
}
BOOL CALLBACK Clear(HELE hEle,POINT *pPt)
{
	CreateNew(_T(".\\PhotonClear.exe"),L"");
	return true;
}
BOOL CALLBACK Process(HELE hEle,POINT *pPt)
{
	CreateNew(_T(".\\Tools\\ProcessMonitor\\ProcessMonitor.exe"),L"");
	return true;
}
BOOL CALLBACK KillFile(HELE hEle,POINT *pPt)
{
	CreateNew(_T(".\\Tools\\KillFiles\\KillFile.exe"),L"");
	return true;
}
BOOL CALLBACK Improve(HELE hEle,POINT *pPt)
{
	CreateNew(_T(".\\PhotonMajorization.exe"),L"");
	return true;
}
BOOL CALLBACK AllDiskScan(HELE hEle,POINT *pPt)
{
	THreadTest *mythreadTest=new THreadTest();
     mythreadTest->a=5;//��������ֵ
	CreateThread(NULL,0,ThreadReRead,mythreadTest,NULL,NULL);
	return true;
}
BOOL CALLBACK TargetScan(HELE hEle,POINT *pPt)
{
	THreadTest *mythreadTest=new THreadTest();
     mythreadTest->a=6;//��������ֵ
	CreateThread(NULL,0,ThreadReRead,mythreadTest,NULL,NULL);
	return true;
}
BOOL CALLBACK NetScan(HELE hEle,POINT *pPt)
{
	THreadTest *mythreadTest=new THreadTest();
     mythreadTest->a=7;//��������ֵ
	CreateThread(NULL,0,ThreadReRead,mythreadTest,NULL,NULL);
	return true;
}
BOOL ExitPhoton()
{
	sprintf(lpData,"NULL");
	if(FindProcess("ProtectProcess.exe"))//���˳����ұ���������󵯴�
	{
		Sleep(1000);
		sprintf(lpData,"Protect.Unload");
	}
	if(FindProcess("RegRTA.exe"))
	{
		Sleep(1000);
		sprintf(lpData,"RegRTA.Unload");
	}
	if(FindProcess("ProcessRTA.exe"))
	{
		Sleep(1000);
		sprintf(lpData,"ProcessRTA.Unload");
	}
	if(FindProcess("USBRTA.exe"))
	{
		Sleep(1000);
		sprintf(lpData,"USBRTA.Unload");
	}
	return true;
}
BOOL CALLBACK WndDestroy(HWINDOW hWindow)//�������١���
{
	//MessageBox(NULL,_T("�˳���~~"),_T(""),MB_OK);
	ExitPhoton();
	return false;
}

//��ȡ����ϵͳ������
wchar_t* GetSystemName()
{
	SYSTEM_INFO info;        //��SYSTEM_INFO�ṹ�ж�64λAMD������ 
	GetSystemInfo(&info);    //����GetSystemInfo�������ṹ 
	OSVERSIONINFOEX os; 
	os.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);   

	
	if(GetVersionEx((OSVERSIONINFO *)&os))
	{ 
		//������ݰ汾��Ϣ�жϲ���ϵͳ���� 
		switch(os.dwMajorVersion)//�ж����汾��
		{
		case 4:
			switch(os.dwMinorVersion)//�жϴΰ汾�� 
			{ 
			case 0:
				if(os.dwPlatformId==VER_PLATFORM_WIN32_NT)
					return L"Microsoft Windows NT 4.0����֧��ȫ�����ܣ�"; //1996��7�·��� 
				else if(os.dwPlatformId==VER_PLATFORM_WIN32_WINDOWS)
					return L"Microsoft Windows 95����֧��ȫ�����ܣ�";
				break;
			case 10:
				return L"Microsoft Windows 98����֧��ȫ�����ܣ�";
				break;
			case 90:
				return L"Microsoft Windows Me����֧��ȫ�����ܣ�";
				break;
			}
			break;

		case 5:
			switch(os.dwMinorVersion)	//�ٱȽ�dwMinorVersion��ֵ
			{ 
			case 0:
				return L"Microsoft Windows 2000����֧��ȫ�����ܣ�";//1999��12�·���
				break;

			case 1:
				return L"Microsoft Windows XP��֧��ȫ�����ܣ�";//2001��8�·���
				break;

			case 2:
				if(os.wProductType==VER_NT_WORKSTATION 
					&& info.wProcessorArchitecture==PROCESSOR_ARCHITECTURE_AMD64)
				{
					return L"Microsoft Windows XP Professional x64 Edition����֧��ȫ�����ܣ�";
				}
				else if(GetSystemMetrics(SM_SERVERR2)==0)
					return L"Microsoft Windows Server 2003����֧��ȫ�����ܣ�";//2003��3�·��� 
				else if(GetSystemMetrics(SM_SERVERR2)!=0)
					return L"Microsoft Windows Server 2003 R2����֧��ȫ�����ܣ�";
				break;
			}
			break;

		case 6:
			switch(os.dwMinorVersion)
			{
			case 0:
				if(os.wProductType == VER_NT_WORKSTATION)
					return L"Microsoft Windows Vista����֧��ȫ�����ܣ�";
				else
					return L"Microsoft Windows Server 2008����֧��ȫ�����ܣ�";//�������汾 
				break;
			case 1:
				if(os.wProductType == VER_NT_WORKSTATION)
					return L"Microsoft Windows 7����֧��ȫ�����ܣ�";
				else
					return L"Microsoft Windows Server 2008 R2����֧��ȫ�����ܣ�";
				break;
			}
			break;
		}
	}//if(GetVersionEx((OSVERSIONINFO *)&os))
	return L"δ֪����ϵͳ����֧��ȫ�����ܣ�";

} 

