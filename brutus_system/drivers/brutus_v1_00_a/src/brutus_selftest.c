/*****************************************************************************
* Filename:          C:\Users\ael10jso\Xilinx\brutus\drivers/brutus_v1_00_a/src/brutus_selftest.c
* Version:           1.00.a
* Description:       
* Date:              Fri Sep 19 16:15:00 2014 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#include "xparameters.h"
#include "brutus.h"

/* IMPORTANT:
*  In order to run this self test, you need to modify the value of following
*  micros according to the slot ID defined in xparameters.h file. 
*/
#define input_slot_id   XPAR_FSL_BRUTUS_0_INPUT_SLOT_ID
#define output_slot_id  XPAR_FSL_BRUTUS_0_OUTPUT_SLOT_ID

XStatus BRUTUS_SelfTest()
{
	 unsigned int input_0[1];     
	 unsigned int output_0[1];     

	 //Initialize your input data over here: 
	 input_0[0] = 12345;     

	 //Call the macro with instance specific slot IDs
	 brutus(
		 input_slot_id,
		 output_slot_id,
		 input_0,      
		 output_0       
		 );

	 if (output_0[0] != 12345)
		 return XST_FAILURE;
	 if (output_0[0] != 12345)
		 return XST_FAILURE;

	 return XST_SUCCESS;
}
