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

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_1242562249;
char *WORK_P_0756454274;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_1242562249_init();
    work_p_0756454274_init();
    work_a_3433964637_3212880686_init();
    work_a_3211060057_3212880686_init();
    work_a_2701513869_3212880686_init();
    work_a_3110809199_3212880686_init();
    work_a_0815171785_3212880686_init();
    work_a_4143924007_3212880686_init();
    work_a_2336845708_3212880686_init();
    work_a_4076869200_3212880686_init();
    work_a_0655082905_2372691052_init();


    xsi_register_tops("work_a_0655082905_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    WORK_P_0756454274 = xsi_get_engine_memory("work_p_0756454274");

    return xsi_run_simulation(argc, argv);

}
