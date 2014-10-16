--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:48:46 10/15/2014
-- Design Name:   
-- Module Name:   C:/Users/ael10jso/Xilinx/embedded_bruteforce/brutus_system/ISE/controller_sg_pp_md_comp/tb_brutus_dual.vhd
-- Project Name:  controller_sg_pp_md_comp
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: brutus_top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_brutus_dual IS
END tb_brutus_dual;
 
ARCHITECTURE behavior OF tb_brutus_dual IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT brutus_top
    PORT(
         clk : IN  std_logic;
         rstn : IN  std_logic;
         i_fsl_data_recv : IN  std_logic;
         i_fsl_hash : IN  std_logic_vector(127 downto 0);
         o_pw_found : OUT  std_logic;
         o_passwd : OUT  std_logic_vector(47 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rstn : std_logic := '0';
   signal i_fsl_data_recv : std_logic := '0';
   signal i_fsl_hash : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal o_pw_found : std_logic;
   signal o_passwd : std_logic_vector(47 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: brutus_top PORT MAP (
          clk => clk,
          rstn => rstn,
          i_fsl_data_recv => i_fsl_data_recv,
          i_fsl_hash => i_fsl_hash,
          o_pw_found => o_pw_found,
          o_passwd => o_passwd
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
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      rstn <= '0';
		  wait for clk_period*10;
		  rstn <= '1';

		  i_fsl_hash <= x"07159c47ee1b19ae4fb9c40d480856c4";  -- "ba"
		  i_fsl_data_recv <= '1';
		  wait for clk_period;
		  i_fsl_data_recv <= '0';
			  
      wait;
   end process;

END;
