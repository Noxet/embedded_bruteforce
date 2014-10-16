--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:08:22 09/17/2014
-- Design Name:   
-- Module Name:   H:/Documents/md5_test/tb_pre_proc.vhd
-- Project Name:  md5_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pre_process
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
 
ENTITY tb_pre_proc IS
END tb_pre_proc;
 
ARCHITECTURE behavior OF tb_pre_proc IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pre_process
    PORT(
         i_data : IN  std_logic_vector(47 downto 0);
         i_length : IN  std_logic_vector(2 downto 0);
         o_data_0 : OUT  unsigned(31 downto 0);
         o_data_1 : OUT  unsigned(31 downto 0);
         o_length : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
	signal clock : std_logic := '0';
   --Inputs
   signal i_data : std_logic_vector(47 downto 0) := (others => '0');
   signal i_length : std_logic_vector(2 downto 0) := (others => '0');
	
 	--Outputs
   signal o_data_0 : unsigned(31 downto 0);
   signal o_data_1 : unsigned(31 downto 0);
   signal o_length : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pre_process PORT MAP (
          i_data => i_data,
          i_length => i_length,
          o_data_0 => o_data_0,
          o_data_1 => o_data_1,
          o_length => o_length
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      i_data <= x"000000000061";--a
		i_length <= "001";
      wait for clock_period;
		i_data <= x"000000006261";--ab
		i_length <= "010";
      wait for clock_period;
		i_data <= x"000000636261";--abc
		i_length <= "011";
      wait for clock_period;
		i_data <= x"000064636261";--abcd
		i_length <= "100";
      wait for clock_period;
      i_data <= x"006564636261";--abcde
		i_length <= "101";
      wait for clock_period;
		i_data <= x"666564636261";--abcdef
		i_length <= "110";
      wait for clock_period;
		-- insert stimulus here 

      wait;
   end process;

END;
