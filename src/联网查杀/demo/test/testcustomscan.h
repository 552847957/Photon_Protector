//////////////////////////////////////////////////////////////////////
//
//  @ File		:	testcustomscan.h
//  @ Version	:	1.0
//  @ Author	:	EasyLogic <liangguangcai@kingsoft.com>
//  @ Datetime	:	[2010-6-2, 16:49:50]
//  @ Brief		:	�����Զ���ɨ�蹦��
//
//////////////////////////////////////////////////////////////////////
#pragma once
#include <windows.h>

//-------------------------------------------------------------------------

DWORD WINAPI CustomScanThreadProc(LPVOID lpParameter);
HRESULT TestCustomScan(BOOL bFullScanning);

