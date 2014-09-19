--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:29:11 09/18/2014
-- Design Name:   
-- Module Name:   H:/embedded_labs/hash_ctrl/tb_hash_ctrl.vhd
-- Project Name:  hash_ctrl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hash_ctrl
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
 
ENTITY tb_hash_ctrl IS
	
END tb_hash_ctrl;
 
ARCHITECTURE behavior OF tb_hash_ctrl IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT hash_ctrl
	 GENERIC( N : integer := 3);
    PORT(
         clk : IN  std_logic;
         rstn : IN  std_logic;
         i_string_done : IN  std_logic;
         i_md5_done : IN  std_logic;
         i_hash : IN  std_logic_vector(127 downto 0);
         i_start : IN  std_logic;
         o_md5_select : OUT  std_logic_vector(2 downto 0);
         o_start : OUT  std_logic;
         o_string_halt : OUT  std_logic;
         o_cmp_hash : OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rstn : std_logic := '0';
   signal i_string_done : std_logic := '0';
   signal i_md5_done : std_logic := '0';
   signal i_hash : std_logic_vector(127 downto 0) := (others => '0');
   signal i_start : std_logic := '0';

 	--Outputs
   signal o_md5_select : std_logic_vector(2 downto 0);
   signal o_start : std_logic;
   signal o_string_halt : std_logic;
   signal o_cmp_hash : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: hash_ctrl PORT MAP (
          clk => clk,
          rstn => rstn,
          i_string_done => i_string_done,
          i_md5_done => i_md5_done,
          i_hash => i_hash,
          i_start => i_start,
          o_md5_select => o_md5_select,
          o_start => o_start,
          o_string_halt => o_string_halt,
          o_cmp_hash => o_cmp_hash
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
      wait for	clk_period;
		rstn <= '0';
		wait for clk_period;
		rstn <= '1';
		i_hash <= x"10203040102030401020304010203040";
		wait for clk_period;
		i_start <= '1';
		wait for clk_period;
		i_start <= '0';
		assert o_start = '1' report "ctrl is started but not the other components";
		assert o_cmp_hash = x"10203040102030401020304010203040" report "the cmp_hash was not forwarded";
		wait for clk_period*3;
		assert o_string_halt = '1' report "not halting while in counting";
		i_md5_done <= '1';
		wait for clk_period;
		i_md5_done <= '0';
		wait for clk_period*4;
		i_string_done <= '1';
		
		wait;
   end process;

END;
