// VCTestDlg.h : ͷ�ļ�
//

#pragma once

#include "ProcProtectCtrl.h"
// CVCTestDlg �Ի���
class CVCTestDlg : public CDialog
{
// ����
public:
	
	CVCTestDlg(CWnd* pParent = NULL);	// ��׼���캯��
	~CVCTestDlg();

// Attributes
protected:
	
	
public:
// Operations
protected:
public:

// �Ի�������
	enum { IDD = IDD_VCTEST_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV ֧��


// ʵ��
protected:
	HICON m_hIcon;
	
	// ���ɵ���Ϣӳ�亯��
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	long m_lPid;
	
	afx_msg void OnBnClickedBtnDisprotect();
	afx_msg void OnBnClickedBtnProtect();
};
