--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:06:02 09/17/2014
-- Design Name:   
-- Module Name:   H:/Documents/md5_test/tb_md5_working.vhd
-- Project Name:  md5_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MD5
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
USE ieee.numeric_std.ALL;
 
ENTITY tb_md5_working IS
END tb_md5_working;
 
ARCHITECTURE behavior OF tb_md5_working IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MD5
    PORT(
         clk : IN  std_logic;
         rstn : IN  std_logic;
         i_start : IN  std_logic;
         i_data_0 : IN  unsigned(31 downto 0);
         i_data_1 : IN  unsigned(31 downto 0);
         i_length : IN  std_logic_vector(7 downto 0);
         o_done : OUT  std_logic;
         o_hash_0 : OUT  unsigned(31 downto 0);
         o_hash_1 : OUT  unsigned(31 downto 0);
         o_hash_2 : OUT  unsigned(31 downto 0);
         o_hash_3 : OUT  unsigned(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rstn : std_logic := '0';
   signal i_start : std_logic := '0';
   signal i_data_0 : unsigned(31 downto 0) := (others => '0');
   signal i_data_1 : unsigned(31 downto 0) := (others => '0');
   signal i_length : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal o_done : std_logic;
   signal o_hash_0 : unsigned(31 downto 0);
   signal o_hash_1 : unsigned(31 downto 0);
   signal o_hash_2 : unsigned(31 downto 0);
   signal o_hash_3 : unsigned(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MD5 PORT MAP (
          clk => clk,
          rstn => rstn,
          i_start => i_start,
          i_data_0 => i_data_0,
          i_data_1 => i_data_1,
          i_length => i_length,
          o_done => o_done,
          o_hash_0 => o_hash_0,
          o_hash_1 => o_hash_1,
          o_hash_2 => o_hash_2,
          o_hash_3 => o_hash_3
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
      wait for clk_period/2;
		rstn <= '0';
      wait for clk_period;
		rstn <= '1';
		i_start <= '1';
      i_data_0 <= x"00008061";
      i_data_1 <= x"00000000";
      i_length <= x"08";
		wait until o_done = '1';
      i_data_0 <= x"80636261";
      i_data_1 <= x"00000000";
      i_length <= x"18";
		wait;
   end process;

END;
