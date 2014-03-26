/*-----------------------------------------------------------
"Automatically generated by the EiffelCOM Wizard."
Added Record _TASK_TRIGGER
	cbTriggerSize: USHORT
			-- Structure size.
	Reserved1: USHORT
			-- Reserved. Must be zero.
	wBeginYear: USHORT
			-- Trigger beginning date year.
	wBeginMonth: USHORT
			-- Trigger beginning date month.
	wBeginDay: USHORT
			-- Trigger beginning date day.
	wEndYear: USHORT
			-- Optional trigger ending date year.
	wEndMonth: USHORT
			-- Optional trigger ending date month.
	wEndDay: USHORT
			-- Optional trigger ending date day.
	wStartHour: USHORT
			-- Run bracket start time hour.
	wStartMinute: USHORT
			-- Run bracket start time minute.
	MinutesDuration: ULONG
			-- Duration of run bracket.
	MinutesInterval: ULONG
			-- Run bracket repetition interval.
	rgFlags: ULONG
			-- Trigger flags.
	TriggerType: typedef
			-- Trigger type.
	Type: typedef
			-- Trigger data.
	Reserved2: USHORT
			-- Reserved. Must be zero.
	wRandomMinutesInterval: USHORT
			-- Maximum number of random minutes after start time.
	
-----------------------------------------------------------*/

#ifndef __ECOM_MS_TASKSCHED_LIB__TASK_TRIGGER_H__
#define __ECOM_MS_TASKSCHED_LIB__TASK_TRIGGER_H__


namespace ecom_MS_TaskSched_lib
{
struct tag_TASK_TRIGGER;
typedef struct ecom_MS_TaskSched_lib::tag_TASK_TRIGGER _TASK_TRIGGER;
}


#include "eif_com.h"

#include "eif_eiffel.h"

#include "eif_setup.h"

#include "eif_macros.h"

#include "ecom_MS_TaskSched_lib__TRIGGER_TYPE_UNION.h"



namespace ecom_MS_TaskSched_lib
{
struct tag_TASK_TRIGGER
{	USHORT cbTriggerSize;
	USHORT Reserved1;
	USHORT wBeginYear;
	USHORT wBeginMonth;
	USHORT wBeginDay;
	USHORT wEndYear;
	USHORT wEndMonth;
	USHORT wEndDay;
	USHORT wStartHour;
	USHORT wStartMinute;
	ULONG MinutesDuration;
	ULONG MinutesInterval;
	ULONG rgFlags;
	long TriggerType;
	ecom_MS_TaskSched_lib::_TRIGGER_TYPE_UNION Type;
	USHORT Reserved2;
	USHORT wRandomMinutesInterval;
};
}

#endif