//////////////////////////////////////////////////////////////////////
//
//  @ File		:	TestSever.h
//  @ Version	:	1.0
//  @ Author	:	EasyLogic <liangguangcai@kingsoft.com>
//  @ Datetime	:	[2010-6-5, 17:25:53]
//  @ Brief		:	���Լ��ء�ж�� SP
//
//////////////////////////////////////////////////////////////////////
#pragma once
#include <windows.h>

typedef enum _EM_TEST_TYPE
{
	enum_Test_Quick_Scan	= 0x00000001,	///< ���Կ���
	enum_Test_Custom_Scan	= 0x00000010,	///< ����ȫ�̼��Զ���
	enum_Test_All_Scan		= 0x00000011,	///< ����ȫ����ȫ��&���٣�
} EM_TEST_TYPE;

HRESULT TestServer(EM_TEST_TYPE testType);