--------------------------------------------------------------------------------
-- Company: 
-- Engineer: Gabbe
--
-- Create Date:   12:04:52 09/17/2014
-- Design Name:   
-- Module Name:   H:/embedded_labs/comp/tb_comp.vhd
-- Project Name:  comp
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: comp
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
 
ENTITY tb_comp IS
END tb_comp;
 
ARCHITECTURE behavior OF tb_comp IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT comp
    PORT(
         clk : IN  std_logic;
         rstn : IN  std_logic;
         i_hash_0 : IN  unsigned(31 downto 0);
         i_hash_1 : IN  unsigned(31 downto 0);
         i_hash_2 : IN  unsigned(31 downto 0);
         i_hash_3 : IN  unsigned(31 downto 0);
         i_cmp_hash : IN  std_logic_vector(127 downto 0);
         i_start : IN  std_logic;
         o_equal : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rstn : std_logic := '1';
   signal i_hash_0 : unsigned(31 downto 0) := (others => '0');
   signal i_hash_1 : unsigned(31 downto 0) := (others => '0');
   signal i_hash_2 : unsigned(31 downto 0) := (others => '0');
   signal i_hash_3 : unsigned(31 downto 0) := (others => '0');
   signal i_cmp_hash : std_logic_vector(127 downto 0) := (others => '0');
   signal i_start : std_logic := '0';

 	--Outputs
   signal o_equal : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: comp PORT MAP (
          clk => clk,
          rstn => rstn,
          i_hash_0 => i_hash_0,
          i_hash_1 => i_hash_1,
          i_hash_2 => i_hash_2,
          i_hash_3 => i_hash_3,
          i_cmp_hash => i_cmp_hash,
          i_start => i_start,
          o_equal => o_res
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
      wait for clk_period/2;
		rstn <= '0';
		wait for clk_period;
		rstn <= '1';
		i_cmp_hash <= x"13121110232221203332313043424140";
		i_start <= '1';
		wait for clk_period;
		i_start <= '0';
		i_hash_0 <= x"10111213";
		i_hash_1 <= x"20212223";
		i_hash_2 <= x"30313233";
		i_hash_3 <= x"40414243";
		assert o_equal = '1' report "correct hash compared wrong";
		wait for clk_period*4;
		i_hash_0 <= x"11111111";
		i_hash_1 <= x"11111111";
		i_hash_2 <= x"11111111";
		i_hash_3 <= x"11111111";
		wait for clk_period;
		assert o_equal = '0' report "false hash compared wrong";
      wait;
   end process;

END;
