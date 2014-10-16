
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name test_vga -dir "C:/Users/ael10jso/Xilinx/embedded_bruteforce/brutus_system/ISE/test_vga/planAhead_run_2" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "vga_ctrl.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../../pcores/myvga_v1_00_a/hdl/vhdl/vga_ctrl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top vga_ctrl $srcset
add_files [list {vga_ctrl.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3
