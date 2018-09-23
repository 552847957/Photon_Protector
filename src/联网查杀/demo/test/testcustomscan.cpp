//////////////////////////////////////////////////////////////////////
//
//  @ File		:	testcustomscan.cpp
//  @ Version	:	1.0
//  @ Author	:	EasyLogic <liangguangcai@kingsoft.com>
//  @ Datetime	:	[2010-6-2, 17:19:52]
//  @ Brief		:	�����Զ���ɨ�蹦��
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"

#include "testcustomscan.h"
#include "public_def.h"
#include "kscomdll.h"
#include "shlobj.h"

#include <string>
#include <vector>
HELE NewText;
HWINDOW MyWindow;
//-------------------------------------------------------------------------

#define QUERY_SESSION_STATUS_TIME_OUT		500

BOOL g_bFullScan				= FALSE;	// Ϊ���ʾȫ��ɨ�裬����Ϊ�Զ���ɨ��
BOOL g_bCustomScanCompleted		= FALSE;	// ��ʶȫ��ɨ�����

BOOL g_bCustomScanNeedToStop	= FALSE;	// ��ֹͣɨ��
BOOL g_bNeedToPauseScanning		= FALSE;	// ��ͣɨ��
BOOL g_bNeedToResumeScanning	= FALSE;	// ����ɨ��

//-------------------------------------------------------------------------

bool SetText(HELE TextControl)
{
	NewText=TextControl;
	return true;
}
bool trims( const std::wstring& str, std::vector <std::wstring>& vcResult, char c)
{
	size_t fst = str.find_first_not_of( c );
	size_t lst = str.find_last_not_of( c );

	if( fst != std::wstring::npos )
		vcResult.push_back(str.substr(fst, lst - fst + 1));

	return true;
}

bool SplitString( 
				 /*[in]*/  const std::wstring& str, 
				 /*[out]*/ std::vector <std::wstring>& vcResult,
				 /*[in]*/  char delim
				 )
{
	//ad,dd,dfd,sdf

	size_t nIter = 0;
	size_t nLast = 0;
	std::wstring v;

	while( true )
	{
		nIter = str.find(delim, nIter); 
		trims(str.substr(nLast, nIter - nLast), vcResult, delim);
		if( nIter == std::wstring::npos )
			break;

		nLast = ++nIter;
	}
	return true;
}


//-------------------------------------------------------------------------

DWORD WINAPI CustomScanThreadProc(LPVOID lpParameter)
{
	IKCldCustomScanClient* pCustomScan =
		reinterpret_cast<IKCldCustomScanClient*>(lpParameter);

	HRESULT hResult = E_FAIL;

	IKCldGetFullScanStatusInfo*		pGetFullInfo			= NULL;
	IKCldGetCustomScanStatusInfo*	pGetCustomInfo			= NULL;
	IKCldGetFileVirusThreatsInfo*	pGetThreatsInfo			= NULL;
	IKCldGetProcessResultInfo*		pGetProcessResultInfo	= NULL;

	S_KCLD_FULL_SCAN_STATUS*		pFullScanStatus;
	S_KCLD_CUSTOM_SCAN_STATUS*		pCustomScanStatus;

	DWORD							dwProcess			= 0;	// ����
	BOOL							bCompleted			= FALSE;// ��ʶɨ�����
	DWORD							dwNewThreatCount	= 0;	// ��������в��Ŀ
	DWORD							dwTotalThreatCount	= 0;	// ����в��
	DWORD							dwDisplayInterval	= 0;	// ��ʾ���
	std::vector<std::wstring>		vecScanTargetFiles;			// ����ɨ��Ŀ��
	std::vector<std::wstring>::iterator itervecScanTargetFiles;
	KCLD_FILEVIRUS_THREAT* pFileVirus = NULL;
	std::vector<DWORD> vecThreatIDs;
	wchar_t* DesText;
	/*
	* ��ѯɨ��״ֱ̬��ɨ��������
	*/
	MyWindow=XWnd_CreateWindow(0,0,800,500,L"���ӷ�����ɱ��ģ��");//��������
    if(MyWindow)
    {
		//����������
		HELE hProgBar1=XProgBar_Create(61,70,560,20,true,MyWindow);
		XProgBar_SetPos(hProgBar1,25); //���ý���
		XProgBar_EnablePercent(hProgBar1,true);
		XWnd_ShowWindow(MyWindow,SW_SHOW);//��ʾ����

		NewText=XStatic_Create(10,10,668,57,L"����ɨ�裺",MyWindow);
        XEle_SetBkTransparent(NewText,true); //���ñ���͸��
    }
	while (true)
	{
		if (g_bCustomScanNeedToStop)
		{
			//::printf("****�û�ֹͣɨ��****\n");
			hResult = pCustomScan->StopScan();
			PRINT_FUNCTION_CALL_ERR_MSG("StopScan", hResult);

			g_bCustomScanCompleted = TRUE;

			::printf("����������˳�......\n");
			::_getch();
			goto Exit0;
		}

		if (g_bNeedToPauseScanning)
		{
			hResult = pCustomScan->PauseScan();
			PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
				"PauseScan",
				hResult
				);

			g_bNeedToPauseScanning = FALSE;

			while (!g_bNeedToResumeScanning)
			{
				::Sleep(200);
			}
		}

		if (g_bNeedToResumeScanning)
		{
			hResult = pCustomScan->ResumeScan();
			PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
				"ResumeScan",
				hResult
				);

			g_bNeedToResumeScanning = FALSE;
		}

		vecScanTargetFiles.clear();

		if (g_bFullScan)
		{
			hResult = pCustomScan->QueryFullScanStatus(
				&pGetFullInfo
				);
			PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
				"pCustomScan->QueryFullScanStatus",
				hResult
				);

			hResult = pGetFullInfo->GetInfo(&pFullScanStatus);
			PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
				"pGetFullInfo->GetInfo",
				hResult
				);

			bCompleted = (pFullScanStatus->scanStatus.emSessionStatus == em_KCLD_CUSTOM_ScanStatus_Complete);

			// ɨ����ȣ�����100�򱣳����ϴ���ͬ��
			if (pFullScanStatus->scanStatus.progress.dwStreamProgress <= 100)
			{
				dwProcess = pFullScanStatus->scanStatus.progress.dwStreamProgress;
			}
			
			// ����ɨ��Ŀ��
			if (NULL != pFullScanStatus->scanStatus.currentTarget.pszTargetName)
			{
				SplitString(
					std::wstring(pFullScanStatus->scanStatus.currentTarget.pszTargetName),
					vecScanTargetFiles,
					'\n'
					);
			}
		}
		else
		{
			hResult = pCustomScan->QueryCustomScanStatus(
				&pGetCustomInfo
				);
			PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
				"pCustomScan->QueryCustomScanStatus",
				hResult
				);

			hResult = pGetCustomInfo->GetInfo(&pCustomScanStatus);
			PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
				"pGetCustomInfo->GetInfo",
				hResult
				);

			bCompleted = (pCustomScanStatus->emSessionStatus == em_KCLD_CUSTOM_ScanStatus_Complete);

			// ɨ����ȣ�����100�򱣳����ϴ���ͬ��
			if (pCustomScanStatus->progress.dwStreamProgress <= 100)
			{
				dwProcess = pCustomScanStatus->progress.dwStreamProgress;
			}

			// ����ɨ��Ŀ��
			if (NULL != pCustomScanStatus->currentTarget.pszTargetName)
			{
				SplitString(
					std::wstring(pCustomScanStatus->currentTarget.pszTargetName),
					vecScanTargetFiles,
					'\n'
					);
			}
		}

		if (dwProcess > 100)
		{
			dwProcess = 0;
		}

		if (vecScanTargetFiles.size() > 0)
		{
			dwDisplayInterval = static_cast<DWORD>(QUERY_SESSION_STATUS_TIME_OUT / vecScanTargetFiles.size());
		}
		
		for (itervecScanTargetFiles = vecScanTargetFiles.begin();
			itervecScanTargetFiles != vecScanTargetFiles.end();
			++itervecScanTargetFiles)
		{
			 system("cls");
			 
			::wsprintf(
				DesText,
				L"ɨ�����:\t%%%-3u \n����ɨ��:\n\t%ls\n",
				dwProcess,
				itervecScanTargetFiles->c_str()
				);
			//XStatic_SetText(NewText,DesText);
			/*for (i=1;i+10;i<dwProcess)
			{
				::printf("��");
			}*/
			::Sleep(dwDisplayInterval);
		}

		// ����Ƿ�ɨ�����
		if (bCompleted)
		{
			system("cls");
			::printf("\n\n********ɨ�����********\n\n");
			::Sleep(500);
			break;
		}

		if (NULL != pGetFullInfo)
		{
			pGetFullInfo->Release();
			pGetFullInfo = NULL;
		}

		if (NULL != pGetCustomInfo)
		{
			pGetCustomInfo->Release();
			pGetCustomInfo = NULL;
		}
	}

	/*
	* ����
	*/
	KCLD_QUERY_THREAT querySetting;
	querySetting.dwStartIndex = 0;
	if (g_bFullScan)
	{
		querySetting.dwTotalCount = pFullScanStatus->scanStatus.dwFindThread;
	}
	else
	{
		querySetting.dwTotalCount = pCustomScanStatus->dwFindThread;
	}

	hResult = pCustomScan->QueryFileVirusThreats(
		&querySetting,
		&pGetThreatsInfo
		);
	PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
		"pCustomScan->QueryFileVirusThreats",
		hResult
		);

	hResult = pGetThreatsInfo->GetCount(&dwTotalThreatCount);
	PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
		"pGetThreatsInfo->GetCount",
		hResult
		);

	if (dwTotalThreatCount == 0)
	{
		::printf("û�з�����в�����ĵ��Ժܰ�ȫ��\n");
	}
	else
	{
		::printf("������в\n");
		::printf("-----------------------------------------------------\n");
		::printf("���\t|\t����\t\t|\t�ļ�·��\n");
		::printf("-----------------------------------------------------\n");

		for (int j = 0; j != dwTotalThreatCount; ++j)
		{
			hResult = pGetThreatsInfo->GetInfo(j, &pFileVirus);
			PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
				"pGetThreatsInfo->GetInfo",
				hResult
				);

			vecThreatIDs.push_back(pFileVirus->dwThreatID);
			::wprintf(
				L"%6d\t\t|\t%15d\t\t|\t%ls\n",
				pFileVirus->dwFoundThreatIndex,
				pFileVirus->dwThreatID,
				pFileVirus->pszFileFullPath
				);
		}

		::printf("����Y�޸���в������N���޸���в��[Y/N]\n");
		if (::toupper(::_getch()) != L'Y')
		{
			goto Exit0;
		}
		::printf("��ʼ�޸�����ȴ�......\n");

		KCLD_PROCESS_SCAN_TARGET processTargets;
		processTargets.bClearAllThread = TRUE;
		processTargets.dwThreatIndexCount = dwTotalThreatCount;
		processTargets.pdwThreatIndexList = &(vecThreatIDs[0]);

		hResult = pCustomScan->ProcessScanResult(&processTargets);
		PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
			"pCustomScan->ProcessScanResult",
			hResult
			);

		::printf("�޸����\n");

		hResult = pCustomScan->QueryScanThreatProcessResult(
			static_cast<unsigned int>(vecThreatIDs.size()),
			&(vecThreatIDs[0]),
			&pGetProcessResultInfo
			);
		PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
			"QueryScanThreatProcessResult",
			hResult
			);

		DWORD dwResultCount = 0;
		hResult = pGetProcessResultInfo->GetCount(&dwResultCount);
		PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
			"pGetProcessResultInfo->GetCount",
			hResult
			);

		if (0 == dwResultCount)
		{
			::printf("û����в��������\n");
		}
		else
		{
			::printf("-----------------------------------------------------\n");
			::printf("\t���\t|\t���̱�ʶ\n");
			::printf("-----------------------------------------------------\n");
			for (int i = 0; i != dwResultCount; ++i)
			{
				S_KCLD_THREAT_PROCESS_RESULT*	pProcessResult	= NULL;
				hResult = pGetProcessResultInfo->GetInfo(i, &pProcessResult);
				PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
					"pGetProcessResultInfo->GetInfo",
					hResult
					);

				::printf("\t%d\t\t|\t%#010x\n",
					pProcessResult->dwThreadIndex,
					pProcessResult->eResult
					);
			}
			::printf("-----------------------------------------------------\n");
		}


		//::printf("�Ƿ���Ҫ��������\n");

		BOOL bNeedToReboot = FALSE;
		hResult = pCustomScan->QueryNeedReboot(&bNeedToReboot);
		if (!bNeedToReboot)
		{
			::printf("����Ҫ�������Ծ�����ɱ��δ���\n");
		}
		else
		{
			::printf("��Ҫ����������ɱ��δ���\n");
		}
	}

	g_bCustomScanCompleted = TRUE;
	::printf("����������˳�ɨ�裡\n");

Exit0:
	if (NULL != pGetFullInfo)
	{
		pGetFullInfo->Release();
		pGetFullInfo = NULL;
	}

	if (NULL != pGetCustomInfo)
	{
		pGetCustomInfo->Release();
		pGetCustomInfo = NULL;
	}

	return hResult;
}

//-------------------------------------------------------------------------

HRESULT TestCustomScan(BOOL bFullScanning)
{
	

	g_bFullScan		= bFullScanning;

	HRESULT hResult = E_FAIL;
	IKCldCustomScanClient* pCustomScan = NULL;
	KSCOMDll scom_dll;

	hResult = scom_dll.Open(L"kcldscan.dll");
	PROCESS_COM_ERROR(hResult);

	scom_dll.GetClassObject(
		CLSID_KCldCustomScanClient,
		IID_IKCldCustomScanClient,
		(void**)&pCustomScan
		);
	if (NULL == pCustomScan)
		return 0;
	/*
	system("Cls");
	::printf("***************************��ʾ***************************\n");
	::printf("**\tɨ�迪ʼ�������ԣ�\n");
	::printf("**\t  1.���ո����ͣ\n");
	::printf("**\t  2.���������ֹͣɨ��\n");
	::printf("**********************************************************\n");
	*/

	if (g_bFullScan)
	{	// ȫ��
		/*::printf("���ڰ����������ʼɨ��\n");*/
		/*::_getch();*/
		
		hResult = pCustomScan->StartFullScan();
		PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
			"StartScan",
			hResult
			);
	}
	else
	{	// �Զ���
		/*
		* ���·��
		*/
		/*wchar_t pwszDesktop[MAX_PATH] = {0};
		if (::SHGetSpecialFolderPathW(
			NULL,
			pwszDesktop,
			CSIDL_DESKTOP,
			FALSE))
		{
			hResult = pCustomScan->AppendScanTargetPath(
				pwszDesktop,
				TRUE	// ɨ��Ŀ¼
				);
			PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
				"AppendScanTargetPath",
				hResult
				);
		}
		
		*/
		/*hResult = pCustomScan->AppendScanTargetPath(
			WStr,
			TRUE	// ��ɨ��Ŀ¼
			);
		PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
			"AppendScanTargetPath",
			hResult
			);
		*/
		/*
		* ��ʼɨ��
		*/
		//::printf("ɨ�迪ʼ\n");
		/*::wprintf(
			L"[1]. \"%ls\" (ɨ����Ŀ¼)\n[2]. \"%ls\" (��ɨ����Ŀ¼)\n",
			pwszDesktop,
			L"D:\\test"
			);*/
		//::printf("���ڰ����������ʼ��\n");
		//::_getch();

		hResult = pCustomScan->StartCustomScan();
		PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
			"StartCustomScan",
			hResult
			);
	}


	/*
	* �����߳��Բ�ѯɨ��״̬
	*/
	HANDLE hQueryThread = ::CreateThread(
		NULL,
		0,
		CustomScanThreadProc,
		pCustomScan,
		0,
		NULL
		);
	if (NULL == hQueryThread)
	{
		PROCESS_COM_ERROR_WITH_FUNCTION_CALL_MSG(
			"CreateThread",
			(hResult = HRESULT_FROM_WIN32(::GetLastError()))
			);
	}

	BOOL bPauseScanning = FALSE;
	char cChoice = 0;
	do 
	{
		cChoice = ::_getch();
		if (g_bCustomScanCompleted)
		{
			break;
		}

		switch (cChoice)
		{
		case ' ':
			bPauseScanning = !bPauseScanning;

			if (bPauseScanning)
			{
				g_bNeedToPauseScanning = TRUE;
			}
			else
			{
				g_bNeedToResumeScanning = TRUE;
			}

			break;
		default:
			g_bCustomScanNeedToStop = TRUE;
			break;
		}
	} while (!g_bCustomScanNeedToStop && !g_bCustomScanCompleted);


	::WaitForSingleObject(
		hQueryThread,
		INFINITE
		);

Exit0:

	if (NULL != pCustomScan)
	{
		pCustomScan->Release();
	}
	return hResult;
}
