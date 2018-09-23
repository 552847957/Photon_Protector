//=============================================================================
/**
* @file ikcldcustomscanclient.h
* @brief 
* @author qiuruifeng <qiuruifeng@kingsoft.com>
* @date 2010-5-28   11:32
*/
//=============================================================================
#pragma once 

#include <Unknwn.h>
#include "kcldcustomscandata_def.h"

//////////////////////////////////////////////////////////////////////////

// {A63AD1AB-1AB4-4f29-A7C6-69BD3916E563}
extern "C" const __declspec(selectany)GUID IID_IKCldGetFullScanStatusInfo =
{ 0xa63ad1ab, 0x1ab4, 0x4f29, { 0xa7, 0xc6, 0x69, 0xbd, 0x39, 0x16, 0xe5, 0x63 } };
MIDL_INTERFACE("{A63AD1AB-1AB4-4f29-A7C6-69BD3916E563}")
IKCldGetFullScanStatusInfo : public IUnknown
{
public:
	/**
	* @brief		��ȡȫ��ɨ��״̬��Ϣ
	* @remark		�ⲿ����Ҫ�ͷ��ڴ棬����ͷź���Զ��ͷ��ڴ�
	* @param[out]	ppInfo ����ɨ��״̬��Ϣ
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE GetInfo(
		/*[out]*/	S_KCLD_FULL_SCAN_STATUS** ppInfo
		) = 0;
};

// {98001E17-818E-4dd1-B79B-13EA88E03460}
extern "C" const __declspec(selectany)GUID IID_IKCldGetCustomScanStatusInfo =
{ 0x98001e17, 0x818e, 0x4dd1, { 0xb7, 0x9b, 0x13, 0xea, 0x88, 0xe0, 0x34, 0x60 } };
MIDL_INTERFACE("{98001E17-818E-4dd1-B79B-13EA88E03460}")
IKCldGetCustomScanStatusInfo : public IUnknown
{
public:
	/**
	* @brief		��ȡȫ��ɨ��״̬��Ϣ
	* @remark		�ⲿ����Ҫ�ͷ��ڴ棬����ͷź���Զ��ͷ��ڴ�
	* @param[out]	ppInfo ����ɨ��״̬��Ϣ
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE GetInfo(
		/*[out]*/	S_KCLD_CUSTOM_SCAN_STATUS** ppInfo
		) = 0;
};


// {E8FBEA13-5BEA-42e3-AB9A-FC96D4EE917B}
extern "C" const __declspec(selectany)GUID IID_IKCldFileVirusThreatsInfo =
{ 0xe8fbea13, 0x5bea, 0x42e3, { 0xab, 0x9a, 0xfc, 0x96, 0xd4, 0xee, 0x91, 0x7b } };
MIDL_INTERFACE("{E8FBEA13-5BEA-42e3-AB9A-FC96D4EE917B}")
IKCldGetFileVirusThreatsInfo : public IUnknown
{
public:
	/**
	* @brief		��ȡ���ļ�������в���б�ĳ���
	* @remark		���� GetCount ����ļ�������в���б�ĳ��Ⱥ󣬾Ϳ��Ե���
	*				GetInfo ������������ȡ����в���б��е�����
	* @param[out]	pdwCount �����ļ�������в���б�ĳ���
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE GetCount(DWORD* pdwCount) = 0;

	/**
	* @brief		�����ļ�������в���б���ĳ����Ŀ
	* @remark		ֱ��ȡ������б���Ŀ��޸��б��е���Ŀ��
	*				�ⲿ����Ҫ�ͷ��ڴ棬����ͷź���Զ��ͷ��ڴ�
	* @param[in]	dwIndex �ļ������б��������� 0 ��ʼ
	* @param[out]	ppInfo �������Ŀ��������Ϣ
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE GetInfo(
		/*[in]*/	const DWORD dwIndex,
		/*[out]*/	KCLD_FILEVIRUS_THREAT** ppInfo
		) = 0;
};

// {635941CF-456F-454c-8C1D-18F877C6B046}
extern "C" const __declspec(selectany)GUID IID_IKCldGetProcessResultInfo =
{ 0x635941cf, 0x456f, 0x454c, { 0x8c, 0x1d, 0x18, 0xf8, 0x77, 0xc6, 0xb0, 0x46 } };
MIDL_INTERFACE("{635941CF-456F-454c-8C1D-18F877C6B046}")
IKCldGetProcessResultInfo : public IUnknown
{
public:
	/**
	* @brief		��ȡ��в�Ĵ������б�ĳ���
	* @remark		���� GetCount �����в�Ĵ������б�ĳ��Ⱥ󣬾Ϳ��Ե���
	*				GetInfo ������������ȡ����в�Ĵ������б��е�����
	* @param[out]	pdwCount ������в�Ĵ������б�ĳ���
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE GetCount(DWORD* pdwCount) = 0;

	/**
	* @brief		������в�Ĵ������б���ĳ����Ŀ
	* @remark		�ⲿ����Ҫ�ͷ��ڴ棬����ͷź���Զ��ͷ��ڴ�
	* @param[in]	dwIndex ��в�Ĵ������������� 0 ��ʼ
	* @param[out]	ppInfo �������Ŀ��������Ϣ
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE GetInfo(
		/*[in]*/	const DWORD dwIndex,
		/*[out]*/	S_KCLD_THREAT_PROCESS_RESULT** ppInfo
		) = 0;
};

// {DBD0490A-E102-4b84-BC0D-A725FE077E3F}
extern "C" const __declspec(selectany)GUID CLSID_KCldCustomScanClient =
{ 0xdbd0490a, 0xe102, 0x4b84, { 0xbc, 0xd, 0xa7, 0x25, 0xfe, 0x7, 0x7e, 0x3f } };

// {14EE3F04-F87E-4361-AA27-BB7E7DC225D5}
extern "C" const __declspec(selectany)GUID IID_IKCldCustomScanClient =
{ 0x14ee3f04, 0xf87e, 0x4361, { 0xaa, 0x27, 0xbb, 0x7e, 0x7d, 0xc2, 0x25, 0xd5 } };


MIDL_INTERFACE("{14EE3F04-F87E-4361-AA27-BB7E7DC225D5}")
IKCldCustomScanClient : public IUnknown
{
public:
	/**
	* @brief		����
	* @remark		
	* @param[in]	pReserved ��������
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE Init(LPVOID ) = 0;

	/**
	* @brief		����ȫ��ɨ��
	* @remark		
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE StartFullScan() = 0;

	/**
	* @brief		�Զ���ɨ��ʱ���ɨ��·��
	* @remark		
	* @param[in]	pszPath ����ӵ�ɨ��·��
	* @param[in]	bScanSubDir Ϊ����ɨ��·�� pszPath �µ���Ŀ¼
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE AppendScanTargetPath(
		/*[in]*/	const wchar_t*					pszPath,
		/*[in]*/	const BOOL						bScanSubDir = TRUE
		) = 0;

	/**
	* @brief		�����Զ���ɨ��
	* @remark		�ȵ��� AppendScanTargetPath ���ɨ��·�����ٵ��ô�
	*				�ӿڿ�ʼ�Զ���ɨ��
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE StartCustomScan() = 0;

	/**
	* @brief		ֹͣɨ��
	* @remark		
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE StopScan() = 0;

	/**
	* @brief		��ͣɨ��
	* @remark		
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE PauseScan() = 0;

	/**
	* @brief		�ָ�ɨ��
	* @remark		
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE ResumeScan() = 0;

	/**
	* @brief		��ѯȫ��ɨ��״̬��Ϣ
	* @remark		
	* @param[out]	ppScanStatus �����ѯ����״̬��Ϣ������ӿ�ָ��ĵ�ַ
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE QueryFullScanStatus(
		/*[out]*/	IKCldGetFullScanStatusInfo**	ppStatusInfo
		) = 0;

	/**
	* @brief		��ѯ�Զ���ɨ��״̬��Ϣ
	* @remark		
	* @param[out]	ppScanStatus �����ѯ����״̬��Ϣ������ӿ�ָ��ĵ�ַ
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE QueryCustomScanStatus(
		/*[out]*/	IKCldGetCustomScanStatusInfo**	ppStatusInfo
		) = 0;

	/**
	* @brief		��ѯɨ���з��ֵ��ļ�������в���б�
	* @remark		
	* @param[in]	pQuerySetting ��Ҫ��ѯ������
	* @param[out]	ppThreatsInfo ������в��Ϣ������ӿ�ָ��ĵ�ַ
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE QueryFileVirusThreats(
		/*[in]*/	const KCLD_QUERY_THREAT*		pQuerySetting,
		/*[out]*/	IKCldGetFileVirusThreatsInfo**	ppThreatsInfo
		) = 0;

	/**
	* @brief		�Է��ֵ���в���д���
	* @remark		
	* @param[in]	pProcessScanTarget ��Ҫ�������в
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE ProcessScanResult(
		/*[in]*/	const KCLD_PROCESS_SCAN_TARGET*	pProcessScanTarget
		) = 0;

	/**
	* @brief		��ѯɨ�赽����в�Ĵ�����
	* @remark		
	* @param[in]	uThreatCount Ҫ��ѯ����в ID �б���
	* @param[in]	pThreatIDs Ҫ��ѯ����в ID �б�
	* @param[out]	ppResultInfo ������в�Ĵ�����
	* @return		0 �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE QueryScanThreatProcessResult(
		/*[in]*/	unsigned int					uThreatCount,
		/*[in]*/	const DWORD*					pThreatIDs,
		/*[out]*/	IKCldGetProcessResultInfo**		ppResultInfo
		);

	/**
	* @brief		����Ƿ���Ҫ����
	* @remark		
	* @param[out]	pbNeedReBoot ��ʾ�Ƿ���Ҫ����
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE QueryNeedReboot(
		/*[out]*/	BOOL* pbNeedReBoot
		) = 0;

	/**
	* @brief		����
	* @remark		
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE UnInit() = 0;

	/**
	* @brief		���ӽ���ɨ���Ŀ��
	* @remark		
	* @param[in]	pTarget ɨ��Ŀ��
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE AppendScanProcessTarget(
		/*[in]*/	const S_KCLD_SCAN_PROCESS_TARGET* pTarget
		) = 0;

	/**
	* @brief		�����Ƿ��ϱ�����
	* @remark		
	* @param[in]	bAutoUploadFile true Ϊ�����ϱ�, false Ϊ��ֹ�Զ��ϱ�
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE SetAutoUploadFile(
		/*[in]*/	BOOL bAutoUploadFile
		) = 0;

	/**
	* @brief		��ȡ�Ƿ��ϱ�����
	* @remark		
	* @param[in]	bAutoUploadFile true Ϊ�����ϱ�, false Ϊ��ֹ�Զ��ϱ�
	* @return		S_OK �ɹ�������Ϊ������
	**/
	virtual HRESULT STDMETHODCALLTYPE GetAutoUploadFile(
		/*[out]*/	BOOL& bAutoUploadFile
		) = 0;
};



