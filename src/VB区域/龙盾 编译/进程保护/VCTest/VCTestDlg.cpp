// VCTestDlg.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "VCTest.h"
#include "VCTestDlg.h"
#include "ProcProtectCtrl_i.c"
#include ".\vctestdlg.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#endif
	HANDLE hMapping;
	LPSTR lpData;
	CString MyStr;
		DWORD		dwResult = -1;
			IProcProtect*				m_pProcProtect;
// ����Ӧ�ó��򡰹��ڡ��˵���� CAboutDlg �Ի���

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// �Ի�������
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��
	VOID   CALLBACK   TimerProc(HWND   hwnd,UINT   uMsg,UINT   idEvent,DWORD   dwTime);
// ʵ��
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CVCTestDlg �Ի���



CVCTestDlg::CVCTestDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CVCTestDlg::IDD, pParent)
	, m_lPid(-1)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	
	HRESULT				hResult;

	::CoInitialize(NULL);
	hResult = ::CoCreateInstance(CLSID_ProcProtect, NULL, CLSCTX_INPROC_SERVER, IID_IProcProtect, (void**)&m_pProcProtect);
	if(!SUCCEEDED(hResult))
	{
		m_pProcProtect->Register(_T("YitProcProtectCtrlSample"));
		::AfxMessageBox(_T("ProcProtect component create failed!"));
	}


}

CVCTestDlg::~CVCTestDlg()
{
	if(m_pProcProtect)
	{
		m_pProcProtect->Release();
	}
}


void CVCTestDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT_PID, m_lPid);
}

BEGIN_MESSAGE_MAP(CVCTestDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BTN_DISPROTECT, OnBnClickedBtnDisprotect)
	ON_BN_CLICKED(IDC_BTN_PROTECT, OnBnClickedBtnProtect)
END_MESSAGE_MAP()


// CVCTestDlg ��Ϣ�������

BOOL CVCTestDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// ��\������...\���˵�����ӵ�ϵͳ�˵��С�

	// IDM_ABOUTBOX ������ϵͳ���Χ�ڡ�
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// ���ô˶Ի����ͼ�ꡣ��Ӧ�ó��������ڲ��ǶԻ���ʱ����ܽ��Զ�
	//  ִ�д˲���
	SetIcon(m_hIcon, TRUE);			// ���ô�ͼ��
	SetIcon(m_hIcon, FALSE);		// ����Сͼ��

	// TODO: �ڴ���Ӷ���ĳ�ʼ������
	
	return TRUE;  // ���������˿ؼ��Ľ��㣬���򷵻� TRUE
}

void CVCTestDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// �����Ի��������С����ť������Ҫ����Ĵ���
//  �����Ƹ�ͼ�ꡣ����ʹ���ĵ�/��ͼģ�͵� MFC Ӧ�ó���
//  �⽫�ɿ���Զ���ɡ�

void CVCTestDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // ���ڻ��Ƶ��豸������

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// ʹͼ���ڹ��������о���
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// ����ͼ��
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
		// TODO: �ڴ���ӿؼ�֪ͨ����������
	CString MyString;
	ShowWindow(SW_HIDE);
	hMapping=CreateFileMapping((HANDLE)0xFFFFFFFF,NULL,PAGE_READWRITE,0,0x100,"PPProtectSelf");
	if (hMapping==NULL)
	{
		AfxMessageBox("�����ļ�ӳ��ʧ��");
		return;
	}
	lpData=(LPSTR)MapViewOfFile(hMapping,FILE_MAP_ALL_ACCESS,0,0,0);
	if (lpData==NULL)
	{
		AfxMessageBox("ӳ���ļ���ͼʧ�ܣ�");
		return;
	}
	//AfxMessageBox("�趨��ʱ��");
	//SetTimer(1,1000,TimerProc);
Back:
	if (strcmp("Unload",lpData)==0)
	{
		ShowWindow(SW_SHOW);
		if(m_pProcProtect)
		{
			m_pProcProtect->Release();
		}
		exit(0);
	}

	if (strcmp("Wait",lpData)==0)
	{
		Sleep (1000);
		goto Back;
	}
	else
	{
		MyString.Format("%s",lpData);
		dwResult=_ttoi(MyString);
		m_pProcProtect->Protect(dwResult, TRUE, &dwResult);
		if(dwResult != -1)
		{
			::MessageBox(NULL,"�ɹ��������̣�","���ӷ�����-���̱���",MB_ICONWARNING);
		}
		else
		{
			::MessageBox(NULL,"��������ʧ�ܣ�","���ӷ�����-���̱���",MB_ICONWARNING);
		}
		if (!strcmp("Wait",lpData)==0)
		{
				Sleep (1500);
		}
		
		goto Back;
		
		
	}
}

//���û��϶���С������ʱϵͳ���ô˺���ȡ�ù����ʾ��
HCURSOR CVCTestDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CVCTestDlg::OnBnClickedBtnDisprotect()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	//UpdateData();
	
	m_pProcProtect->Protect(m_lPid, FALSE, &dwResult);
	if(dwResult != -1)
	{
		::AfxMessageBox(_T("�ɹ�ȡ������!"));
	}
	else
	{
		::AfxMessageBox(_T("ȡ������ʧ��!"));
	}

}



VOID   CALLBACK   TimerProc(HWND   hwnd,UINT   uMsg,UINT   idEvent,DWORD   dwTime)   
{   

}  

void CVCTestDlg::OnBnClickedBtnProtect()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	CString MyString;
	ShowWindow(SW_HIDE);
	hMapping=CreateFileMapping((HANDLE)0xFFFFFFFF,NULL,PAGE_READWRITE,0,0x100,"PPProtectSelf");
	if (hMapping==NULL)
	{
		AfxMessageBox("�����ļ�ӳ��ʧ��");
		return;
	}
	lpData=(LPSTR)MapViewOfFile(hMapping,FILE_MAP_ALL_ACCESS,0,0,0);
	if (lpData==NULL)
	{
		AfxMessageBox("ӳ���ļ���ͼʧ�ܣ�");
		return;
	}
	//AfxMessageBox("�趨��ʱ��");
	//SetTimer(1,1000,TimerProc);
Back:
	if (strcmp("Unload",lpData)==0)
	{
		ShowWindow(SW_SHOW);
		exit(0);
		return;
	}

	if (strcmp("Wait",lpData)==0)
	{
		Sleep (1000);
		goto Back;
	}
	else
	{
		MyString.Format("%s",lpData);
		dwResult=_ttoi(MyString);
		m_pProcProtect->Protect(dwResult, TRUE, &dwResult);
		if(dwResult != -1)
		{
			::MessageBox(NULL,"�ɹ��������̣�","���ӷ�����-���̱���",MB_ICONWARNING);
		}
		else
		{
			::MessageBox(NULL,"��������ʧ�ܣ�","���ӷ�����-���̱���",MB_ICONWARNING);
		}
		if (!strcmp("Wait",lpData)==0)
		{
				Sleep (1500);
		}
		
		goto Back;
		
		
	}



	/*
	DWORD MyPro=-1;
	UpdateData();
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
if(strcmp("DragonShield.exe",mype.szExeFile)==0)
{
MyPro = mype.th32ProcessID;
m_pProcProtect->Protect(MyPro, TRUE, &dwResult);
goto Next;
}
else
mybRet=Process32Next(myhProcess,&mype);
}
Next:

//���н��̿���
myhProcess=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0); //TH32CS_SNAPPROCESS�������н���
//��ʼ���̲���
mybRet=Process32First(myhProcess,&mype);
//ѭ���Ƚϣ��ó�ProcessID
while(mybRet)
{
if(strcmp("PhotonProtect.exe",mype.szExeFile)==0)
{
MyPro = mype.th32ProcessID;
m_pProcProtect->Protect(MyPro, TRUE, &dwResult);
goto Next1;
}
else
mybRet=Process32Next(myhProcess,&mype);
}
Next1:
//���н��̿���
myhProcess=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0); //TH32CS_SNAPPROCESS�������н���
//��ʼ���̲���
mybRet=Process32First(myhProcess,&mype);
//ѭ���Ƚϣ��ó�ProcessID
while(mybRet)
{
if(strcmp("ProcessRTA.exe",mype.szExeFile)==0)
{
MyPro = mype.th32ProcessID;
m_pProcProtect->Protect(MyPro, TRUE, &dwResult);
goto Next2;
}
else
mybRet=Process32Next(myhProcess,&mype);
}
Next2:*/
return;
}
