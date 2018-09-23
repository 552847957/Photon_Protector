/*

  hookzwcreateprocess.H

  Author: <your name>
  Last Updated: 2006-02-12

  This framework is generated by EasySYS 0.3.0
  This template file is copying from QuickSYS 0.3.0 written by Chunhua Liu

*/

#ifndef _HOOKZWCREATEPROCESS_H
#define _HOOKZWCREATEPROCESS_H 1

//
// Define the various device type values.  Note that values used by Microsoft
// Corporation are in the range 0-0x7FFF(32767), and 0x8000(32768)-0xFFFF(65535)
// are reserved for use by customers.
//

#define FILE_DEVICE_HOOKZWCREATEPROCESS	0x8000

//
// Macro definition for defining IOCTL and FSCTL function control codes. Note
// that function codes 0-0x7FF(2047) are reserved for Microsoft Corporation,
// and 0x800(2048)-0xFFF(4095) are reserved for customers.
//

#define HOOKZWCREATEPROCESS_IOCTL_BASE	0x800

//
// The device driver IOCTLs
//

#define CTL_CODE_HOOKZWCREATEPROCESS(i) CTL_CODE(FILE_DEVICE_HOOKZWCREATEPROCESS, HOOKZWCREATEPROCESS_IOCTL_BASE+i, METHOD_BUFFERED, FILE_ANY_ACCESS)

#define IOCTL_HOOKZWCREATEPROCESS_HELLO	CTL_CODE_HOOKZWCREATEPROCESS(0)
#define IOCTL_HOOKZWCREATEPROCESS_TEST	CTL_CODE_HOOKZWCREATEPROCESS(1)

//
// Name that Win32 front end will use to open the hookzwcreateprocess device
//

#define HOOKZWCREATEPROCESS_WIN32_DEVICE_NAME_A	"\\\\.\\PRMonitor"
#define HOOKZWCREATEPROCESS_WIN32_DEVICE_NAME_W	L"\\\\.\\PRMonitor"
#define HOOKZWCREATEPROCESS_DEVICE_NAME_A			"\\Device\\PRMonitor"
#define HOOKZWCREATEPROCESS_DEVICE_NAME_W			L"\\Device\\PRMonitor"
#define HOOKZWCREATEPROCESS_DOS_DEVICE_NAME_A		"\\DosDevices\\PRMONITOR"
#define HOOKZWCREATEPROCESS_DOS_DEVICE_NAME_W		L"\\DosDevices\\PRMONITOR"

#ifdef _UNICODE
#define HOOKZWCREATEPROCESS_WIN32_DEVICE_NAME HOOKZWCREATEPROCESS_WIN32_DEVICE_NAME_W
#define HOOKZWCREATEPROCESS_DEVICE_NAME		HOOKZWCREATEPROCESS_DEVICE_NAME_W
#define HOOKZWCREATEPROCESS_DOS_DEVICE_NAME	HOOKZWCREATEPROCESS_DOS_DEVICE_NAME_W
#else
#define HOOKZWCREATEPROCESS_WIN32_DEVICE_NAME HOOKZWCREATEPROCESS_WIN32_DEVICE_NAME_A
#define HOOKZWCREATEPROCESS_DEVICE_NAME		HOOKZWCREATEPROCESS_DEVICE_NAME_A
#define HOOKZWCREATEPROCESS_DOS_DEVICE_NAME	HOOKZWCREATEPROCESS_DOS_DEVICE_NAME_A
#endif

#endif