//=============================================================================
/**
* @file kcldcustomscandata_def.h
* @brief 
* @author qiuruifeng <qiuruifeng@kingsoft.com>
* @date 2010-5-28   14:48
*/
//=============================================================================
#pragma once 

/**
* @brief �������Ͷ���
*/
typedef enum _EM_KCLD_CUSTOM_SCAN_THREAT_TYPE
{
	em_KCLD_ThreatType_MalwareInSystem = 0,			///< ϵͳ�������
	em_KCLD_ThreatType_FileVirus,					///< �ļ�����
	em_KCLD_ThreatType_SystemRepairPoint,			///< ϵͳ�޸���
	em_KCLD_Max_Threat_Type = 16					///< ��в���͵����ֵ
} EM_KCLD_CUSTOM_SCAN_THREAT_TYPE;


/**
* @brief ScanSession��״̬
*/
typedef enum _EM_KCLD_CUSTOM_SCAN_STATUS
{
	em_KCLD_CUSTOM_ScanStatus_None          = 0,	///< ��Ч״̬
	em_KCLD_CUSTOM_ScanStatus_Ready         = 1,	///< �������,׼������(���ݵ�״̬)
	em_KCLD_CUSTOM_ScanStatus_Running       = 2,	///< ������������
	em_KCLD_CUSTOM_ScanStatus_Paused        = 3,	///< ������ͣ
	em_KCLD_CUSTOM_ScanStatus_Complete      = 4,	///< �������(�п����Ǳ���ֹ���µ����)
	em_KCLD_CUSTOM_ScanStatus_NetDetecting  = 5,	///< �ȴ�������
} EM_KCLD_CUSTOM_SCAN_STATUS;

/**
 * @brief ָ����Ҫɨ���Ŀ������
 */
typedef enum _EM_KCLD_SCANTARGET_TYPE
{
    em_KCLD_Target_None              = 0x00000000,	///< ��ЧĿ��
    em_KCLD_Target_Win32_Directory   = 0x00010003,	///< Win32Ŀ¼,TargetNameΪ·���ַ�����TargetID��ȡֵΪ��0��������Ŀ¼��1����������Ŀ¼��		 
	em_KCLD_Target_Win32_File        = 0x00010005,	///< Win32�ļ�,��Ҫָ��TargetNameΪҪɨ���ļ���ȫ·����TargetIDΪ�ա�	
	em_KCLD_Target_All_Malware       = 0x00010200,	///< ���ж����������TargetNameΪ�գ�TargetIDΪ��
	em_KCLD_Target_Malware           = 0x00010201,	///< �����������,TargetNameΪ�գ���Ҫָ��TargetIDΪ�������ID
	em_KCLD_Target_All_SysRprPoints,				///< ����ϵͳ�޸��㣬TargetNameΪ�գ�TargetIDΪ��
	em_KCLD_Target_SysRprPoints,					///< ϵͳ�޸���,TargetNameΪ�գ���Ҫָ��TargetIDΪϵͳ�޸���ID
	em_KCLD_Target_Computer,						///< �ҵĵ��ԣ�TargetNameΪ�գ�TargetIDΪ��
	em_KCLD_Target_Autoruns,						///< ����������TargetNameΪ�գ�TargetIDΪ��
	em_KCLD_Target_Critical_Area,					///< �ؼ�����TargetNameΪ�գ�TargetIDΪ��
    em_KCLD_Target_Removable,						///< �ƶ��洢�豸
	em_KCLD_Target_Memory							///< �ڴ�ɨ��
} EM_KCLD_SCANTARGET_TYPE;

/**
 * @brief ��Ҫɨ���Ŀ������
 */
typedef struct _S_KCLD_CUSTOM_SCAN_TARGET
{
	EM_KCLD_SCANTARGET_TYPE		emTargetType;		///< ��Ҫɨ�������
	const wchar_t*				pszTargetName;		///< ��Ҫɨ�������,��emTargetType���
	DWORD						dwTargetID;			///< ��Ҫɨ���ID,��emTargetType���
} S_KCLD_CUSTOM_SCAN_TARGET;

/**
* @brief ��ȡ������Ϣ
*/
typedef struct _S_KCLD_PROGRESS_INFO
{
	DWORD dwTimeProgress;							///< ʣ���ʱ��(ms)
	DWORD dwStreamProgress;							///< ��ȡ�����������Ľ���  (0 - 100)      	
	DWORD dwFilesProgress;							///< ��ȡ�����ļ����Ľ���  (0 - 100)
	DWORD dwFilesTotalCount;						///< ��ȡɨ���ļ�������	
} S_KCLD_PROGRESS_INFO;

/**
 * @brief ��ǰ����ɨ���״̬
 */
typedef struct _S_KCLD_CUSTOM_SCAN_STATUS
{
	S_KCLD_CUSTOM_SCAN_TARGET	currentTarget;				///< ��ǰ����ɨ��ؼ����򣬼�����ɨ���Ŀ�궨��
	EM_KCLD_CUSTOM_SCAN_STATUS  emSessionStatus;			///< ����״̬
	S_KCLD_PROGRESS_INFO		progress;					///< ������Ϣ
	DWORD                       dwTotalQuantity;			///< �ܵ�������
	DWORD                       dwFinishedQuantity;			///< ��ɵ�������
	DWORD                       dwFindThread;				///< ������в������
	DWORD                       dwProcessSucceed;			///< �ɹ�������в������
	DWORD						FoundThreatsCountDetail[em_KCLD_Max_Threat_Type]; ///< ���ݲ�ͬ����в����,������ص����� 
	__time64_t		            tmSessionStartTime;             ///< ɨ��������ʱ���
	__time64_t		            tmSessionCurrentTime;           ///< ��ǰʱ���,���ڼ����Ѿ�ɨ���˶���ʱ��
	__time64_t                  tmSessionEndTime;               ///< ɨ�������ʱ��㣨��������ɣ�Ҳ�����Ǳ��жϣ�ԭ���SessionSatus��
    HRESULT                     hErrCode;					///< ������
} S_KCLD_CUSTOM_SCAN_STATUS;

/**
* @brief �����Ĵ�����
*/
typedef enum _EM_KCLD_THREAT_PROCESS_RESULT
{
	em_KCLD_Threat_Process_No_Op                            =  0x00000001,   ///< δ����
	em_KCLD_Threat_Process_Unknown_Fail                     =  0x80000001,   ///< δ֪ʧ��

	em_KCLD_Threat_Process_Delay                            =  0x00000002,   ///< �ӳٴ���
	em_KCLD_Threat_Process_Skip                             =  0x00000003,   ///< ����

	// �ļ���صĽ��
	em_KCLD_Threat_Process_Clean_File_Success               =  0x00000004,   ///< ���(�޸�)�ļ��ɹ�
	em_KCLD_Threat_Process_Clean_File_Fail                  =  0x80000004,   ///< ���(�޸�)�ļ�ʧ��
	em_KCLD_Threat_Process_Delete_File_Success              =  0x00000005,   ///< ɾ���ļ��ɹ�
	em_KCLD_Threat_Process_Delete_File_Fail                 =  0x80000005,   ///< ɾ���ļ�ʧ��

	em_KCLD_Threat_Process_Reboot_Clean_File_Success        =  0x00000006,   ///< ����������ļ�(���óɹ�)
	em_KCLD_Threat_Process_Reboot_Clean_File_Fail           =  0x80000006,   ///< ����������ļ�(����ʧ��)
	em_KCLD_Threat_Process_Reboot_Delete_File_Success       =  0x00000007,   ///< ������ɾ���ļ�(���óɹ�)
	em_KCLD_Threat_Process_Reboot_Delete_File_Fail          =  0x80000007,   ///< ������ɾ���ļ�(����ʧ��)
	em_KCLD_Threat_Process_Rename_File_Success              =  0x00000008,   ///< �������ļ��ɹ�
	em_KCLD_Threat_Process_Rename_File_Fail                 =  0x80000008,   ///< �������ļ�ʧ��

	em_KCLD_Threat_Process_Quarantine_File_Success          =  0x00000009,   ///< �����ļ��ɹ�
	em_KCLD_Threat_Process_Quarantine_File_Fail             =  0x80000009,   ///< �����ļ�ʧ��
	em_KCLD_Threat_Process_Reboot_Quarantine_File_Success   =  0x0000000A,   ///< ����������ļ�(���óɹ�)
	em_KCLD_Threat_Process_Reboot_Quarantine_File_Fail      =  0x8000000A,   ///< ����������ļ�(����ʧ��)

	em_KCLD_Threat_Process_File_NoExist					   =  0x81000001,    ///< �ļ�������

	em_KCLD_Threat_Process_File_InWPL					   =  0x00000020,    ///< �ļ��ڴ���������
	em_KCLD_Threat_Process_File_Restore_Success			   =  0x00000021,    ///< ���ļ��Ѿ����ָ�
} EM_KCLD_THREAT_PROCESS_RESULT;

/**
* @brief   �����Ĳ�ѯ����
*/
typedef enum _EM_KCLD_THREAT_CHECKING_TYPE
{
	em_KCLD_ThreatCheckedByFileEngine,				///< �ļ����汨��
	em_KCLD_ThreatCheckedByCloud,					///< �Ʋ�ɱ����
} EM_KCLD_THREAT_CHECKING_TYPE;

/**
* @brief   ѹ��,�ѿ��ļ����ݽṹ
*/
typedef struct _KCLD_ARCHIVE_THREAT
{
	const wchar_t*					pszFileName;			///< ѹ��,�ļ���
	const wchar_t*					pszFullPath;			///< ����ȫ·��
	const wchar_t*					pszThreatName;			///< ��в����
	EM_KCLD_THREAT_PROCESS_RESULT	eResult;				///< ������
	DWORD							dwThreatType;			///< ��������
	EM_KCLD_THREAT_CHECKING_TYPE	eThreatCheckingType;	///< ��������
} KCLD_ARCHIVE_THREAT;

typedef struct _KCLD_FILEVIRUS_THREAT
{
	DWORD							dwFoundThreatIndex;		///< ��ʾ�˻����Ϸ��ֵ�һ������
	DWORD							dwThreatID;				///< ��IDΪ��в���ڴ��ڵ�ID
	bool							bFileInWrapper;			///< �Ƿ���ѹ�����е��ļ�(������RTF)
	const wchar_t*					pszFileFullPath;		///< �����ļ���ȫ·��
	const wchar_t*					pszVirusDescription;	///< ��������
	EM_KCLD_THREAT_PROCESS_RESULT	eResult;                ///< ������
	HRESULT							hErrCode;               ///< ������
	DWORD							dwThreatType;			///< ��������
	EM_KCLD_THREAT_CHECKING_TYPE	eThreatCheckingType;    ///< ��������
	DWORD							dwVirtualFileCount;		///< ѹ��,�ѿ��ļ��б���
	KCLD_ARCHIVE_THREAT**			ppVirtualFiles;			///< ѹ��,�ѿ��ļ��б�
}KCLD_FILEVIRUS_THREAT;

/**
* @brief ��ѯ���ݵ���ʼ�����Լ���ѯ����
*/
typedef struct _KCLD_QUERY_THREAT
{
	DWORD			dwStartIndex;					///<Ҫ��ѯ��в����ʼ����
	DWORD			dwTotalCount;					///<���β�ѯ��෵�ص�����
}KCLD_QUERY_THREAT;

/**
* @brief ���ڶ�ָ����ScanHandle�����Ӧ����в����
*/
typedef struct _KCLD_PROCESS_SCAN_TARGET
{
	BOOL		bClearAllThread;					///< �Ƿ����������в
	DWORD		dwThreatIndexCount;					///< ��в�б��С
	DWORD*		pdwThreatIndexList;					///< �ύ�����������в�������б���в�����ڲ�ѯ��в�ǻ�ã�
}KCLD_PROCESS_SCAN_TARGET;

//-------------------------------------------------------------------------

/**
 * @brief ScanSession��״̬
 */
typedef enum _EM_KCLD_SCANSESSION_STATUS
{
    em_KCLD_ScanStatus_None          = 0,			///< ��Ч״̬
	em_KCLD_ScanStatus_Ready         = 1,			///< �������,׼������(���ݵ�״̬)
	em_KCLD_ScanStatus_Running       = 2,			///< ������������
	em_KCLD_ScanStatus_Paused        = 3,			///< ������ͣ
	em_KCLD_ScanStatus_Complete      = 4,			///< �������(�п����Ǳ���ֹ���µ����)
	em_KCLD_ScanStatus_NetDetecting  = 5,			///< �ȴ�������
} EM_KCLD_SCANSESSION_STATUS;

/**
* @brief ����ɨ����ͳ����Ϣ
*/
typedef struct _S_KCLD_DISKSCANITEM_INFO
{
	const wchar_t*	pszDriverName;					///< ����������
	DWORD			dwScanItems;					///< �Ѿ�ɨ���������
	DWORD			dwFindThreats;					///< ���ֵĲ�����
    int				nStatus;						///< ��ʾ��ǰ��״̬  �ο�EM_KXE_SCAN_DISK_STATUS
	
} S_KCLD_DISKSCANITEM_INFO;

/**
* @brief ȫ��ɨ���ʱ��״̬��Ϣ�Ĳ�ѯ
*/
typedef struct _S_KCLD_FULL_SCAN_STATUS
{
	S_KCLD_CUSTOM_SCAN_STATUS	scanStatus;
	DWORD						dwScanItemInfoCount;///< ����ɨ����ͳ����Ϣ�б���
	S_KCLD_DISKSCANITEM_INFO**	ppDiskInfo;			///< ����ɨ����ͳ����Ϣ�б�
} S_KCLD_FULL_SCAN_STATUS;

/**
* @brief ��в������״̬
*/
typedef struct _S_KCLD_THREAT_PROCESS_RESULT
{
    DWORD							dwThreadIndex;	///< ��в����ID
    EM_KCLD_THREAT_PROCESS_RESULT	eResult;		///< ������
	DWORD							dwOtherCount;	///< ѹ����,�ѿ��ļ���������Ŀ
    EM_KCLD_THREAT_PROCESS_RESULT**	ppOtherResults;	///< ѹ����,�ѿ��ļ�������
} S_KCLD_THREAT_PROCESS_RESULT;

/**
* @brief ����ɨ������
**/
typedef enum _EM_KCLD_SCAN_PROCESS_TARGET_TYPE
{
	em_KCLD_ScanProcessInvaild	= 0,			///< ��Ч״̬
	em_KCLD_ScanProcessAll		= 1,			///< ɨ�����н���
	em_KCLD_ScanProcessByPid	= 2,			///< ɨ��ָ��pid����
	em_KCLD_ScanProcessByName	= 3,			///< ɨ��ָ��pid����
	em_KCLD_ScanDrivers			= 4				///< ɨ��driversĿ¼�µ�sys�ļ�
}EM_KCLD_SCAN_PROCESS_TARGET_TYPE;

/**
* @brief ����ɨ����
**/
typedef struct _S_KCLD_SCAN_PROCESS_TARGET_ITEM
{
	DWORD								dwSize;		///< �ṹ���С
	EM_KCLD_SCAN_PROCESS_TARGET_TYPE	emScanType; ///< ɨ������
	BOOL								bScanModule;///< �Ƿ�ɨ������µ�ģ��	
	DWORD								dwPid;		///< ����id,��ɨ������Ϊem_KCLD_ScanProcessByPidʱ��Ч
	const wchar_t*						pszName;	///< ������,��ɨ������Ϊem_KCLD_ScanProcessByNameʱ��Ч
}S_KCLD_SCAN_PROCESS_TARGET_ITEM;

/**
* @brief ����ɨ�����
**/
typedef struct _S_KCLD_SCAN_PROCESS_TARGET
{
	DWORD								dwSize;		///< �ṹ���С
	S_KCLD_SCAN_PROCESS_TARGET_ITEM**	ppItems;	///< ɨ����ָ������
	DWORD								dwItemsCnt;	///< ɨ���������С	
}S_KCLD_SCAN_PROCESS_TARGET;