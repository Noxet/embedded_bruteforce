/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xa0883be4 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/ael10jso/Xilinx/embedded_bruteforce/vhdl/brutus_top.vhd";
extern char *IEEE_P_1242562249;



static void work_a_4047939593_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(212, ng0);

LAB3:    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 8256);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 48U);
    xsi_driver_first_trans_fast(t1);

LAB2:    t7 = (t0 + 8160);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_4047939593_3212880686_p_1(char *t0)
{
    char t4[16];
    char t10[16];
    char t15[16];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned char t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;

LAB0:    xsi_set_current_line(266, ng0);

LAB3:    t1 = (t0 + 3272U);
    t2 = *((char **)t1);
    t1 = (t0 + 3432U);
    t3 = *((char **)t1);
    t5 = ((IEEE_P_1242562249) + 3000);
    t6 = (t0 + 14100U);
    t7 = (t0 + 14100U);
    t1 = xsi_base_array_concat(t1, t4, t5, (char)97, t2, t6, (char)97, t3, t7, (char)101);
    t8 = (t0 + 3592U);
    t9 = *((char **)t8);
    t11 = ((IEEE_P_1242562249) + 3000);
    t12 = (t0 + 14100U);
    t8 = xsi_base_array_concat(t8, t10, t11, (char)97, t1, t4, (char)97, t9, t12, (char)101);
    t13 = (t0 + 3752U);
    t14 = *((char **)t13);
    t16 = ((IEEE_P_1242562249) + 3000);
    t17 = (t0 + 14100U);
    t13 = xsi_base_array_concat(t13, t15, t16, (char)97, t8, t10, (char)97, t14, t17, (char)101);
    t18 = (32U + 32U);
    t19 = (t18 + 32U);
    t20 = (t19 + 32U);
    t21 = (128U != t20);
    if (t21 == 1)
        goto LAB5;

LAB6:    t22 = (t0 + 8320);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    memcpy(t26, t13, 128U);
    xsi_driver_first_trans_fast(t22);

LAB2:    t27 = (t0 + 8176);
    *((int *)t27) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(128U, t20, 0);
    goto LAB6;

}


extern void work_a_4047939593_3212880686_init()
{
	static char *pe[] = {(void *)work_a_4047939593_3212880686_p_0,(void *)work_a_4047939593_3212880686_p_1};
	xsi_register_didat("work_a_4047939593_3212880686", "isim/tb_brutus_isim_beh.exe.sim/work/a_4047939593_3212880686.didat");
	xsi_register_executes(pe);
}
