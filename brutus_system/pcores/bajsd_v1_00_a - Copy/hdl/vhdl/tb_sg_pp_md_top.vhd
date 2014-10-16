--------------------------------------------------------------------------------
-- Engineer: Noxet
-- Module Name:   C:/temp/test_string_gen/tb_sg_pp_md_top.vhd
-- Description:   
--      A testbench for sg_pp_md top module 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY tb_sg_pp_md_top IS
END tb_sg_pp_md_top;

ARCHITECTURE behavior OF tb_sg_pp_md_top IS 
    
    -- Component Declaration for the Unit Under Test (UUT)
    
    COMPONENT sg_pp_md_top
        PORT(
            clk : IN  std_logic;
            rstn : IN  std_logic;
            i_start_sg : IN  std_logic;
            i_halt_sg : IN  std_logic;
            i_start_md5 : IN  std_logic;
            o_hash : OUT  unsigned(127 downto 0);
            o_done_md5 : OUT  std_logic
            );
    END COMPONENT;
    

    --Inputs
    signal clk : std_logic := '0';
    signal rstn : std_logic := '0';
    signal i_start_sg : std_logic := '0';
    signal i_halt_sg : std_logic := '0';
    signal i_start_md5 : std_logic := '0';

    --Outputs
    signal o_hash : unsigned(127 downto 0);
    signal o_done_md5 : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;
    
BEGIN
    
    -- Instantiate the Unit Under Test (UUT)
    uut: sg_pp_md_top PORT MAP (
        clk => clk,
        rstn => rstn,
        i_start_sg => i_start_sg,
        i_halt_sg => i_halt_sg,
        i_start_md5 => i_start_md5,
        o_hash => o_hash,
        o_done_md5 => o_done_md5
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    

    -- Stimulus process
    stim_proc: process
        variable li : line;
    begin		
        -- hold reset state for 100 ns.
        wait for 10 ns;	
        rstn <= '0';

        wait for clk_period*2;
        rstn <= '1';
        
        i_start_sg <= '1';
        wait for 2*clk_period;
        i_halt_sg <= '1'; -- wait for md5 to start
        
        for I in 0 to 28 loop
            i_start_md5 <= '1';
            wait for clk_period;
            i_start_md5 <= '0';
            
            wait until o_done_md5 = '1';
            if I = 22 then -- 'w'
                write(li, "Testing 'w'");
                writeline(output, li);
                assert o_hash = x"685d0c7ce7f427abceb1d0a5860129f1" report "Fail";
            elsif I = 27 then -- 'aa'
                write(li, "Testing 'aa'");
                writeline(output, li);
                assert o_hash = x"12497a20ba246f087fc235930abc2441"report "Fail";
                --assert o_hash = x"4124bc0a9335c27f086f24ba207a4912";
            end if;
            
            i_halt_sg <= '0';
            wait for clk_period;
            i_halt_sg <= '1';
        end loop;
 
        wait;
    end process;

END;
