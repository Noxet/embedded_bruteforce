--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:12:46 09/15/2014
-- Design Name:   
-- Module Name:   H:/Documents/md5_test/tb_md5.vhd
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_md5 IS
END tb_md5;
 
ARCHITECTURE behavior OF tb_md5 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MD5
    PORT(
         i_clk : IN  std_logic;
         i_rst_n : IN  std_logic;
         i_start : IN  std_logic;
         i_data : IN  unsigned(71 downto 0);
         o_done : OUT  std_logic;
         o_hash_0 : OUT  unsigned(31 downto 0);
			o_hash_1 : OUT  unsigned(31 downto 0);
			o_hash_2 : OUT  unsigned(31 downto 0);
			o_hash_3 : OUT  unsigned(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_rst_n : std_logic := '1';
   signal i_start : std_logic := '0';
   signal i_data : unsigned(71 downto 0) := (others => '0');

 	--Outputs
   signal o_done : std_logic;
   signal o_hash_0, o_hash_1, o_hash_2, o_hash_3 : unsigned(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MD5 PORT MAP (
          i_clk => i_clk,
          i_rst_n => i_rst_n,
          i_start => i_start,
          i_data => i_data,
          o_done => o_done,
          o_hash_0 => o_hash_0,
			 o_hash_1 => o_hash_1,
			 o_hash_2 => o_hash_2,
			 o_hash_3 => o_hash_3
        );

   -- Clock process definitions
   clk_process :process
   begin
		i_clk <= '0';
		wait for clk_period/2;
		i_clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for clk_period/2;
      i_rst_n <= '0';
      wait for clk_period;
		i_rst_n <= '1';
		i_start <= '1';
		i_data <= x"626161616161616180";
		--i_data <= (others => '1');
      wait for clk_period;
      -- insert stimulus here 

      wait;
   end process;

END;
