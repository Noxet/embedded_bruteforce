--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:53:59 09/16/2014
-- Design Name:   
-- Module Name:   C:/temp/teeest/tb_big_little_endian.vhd
-- Project Name:  teeest
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: big_little_endian
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
 
ENTITY tb_big_little_endian IS
END tb_big_little_endian;
 
ARCHITECTURE behavior OF tb_big_little_endian IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT big_little_endian
    PORT(
         in_data : IN  std_logic_vector(31 downto 0);
         out_data : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal in_data : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal out_data : std_logic_vector(31 downto 0);

 
BEGIN
 
   uut: big_little_endian PORT MAP (
          in_data => in_data,
          out_data => out_data
        );
 

   -- Stimulus process
   stim_proc: process
   begin
	
		in_data <= x"61626364";
		wait for 10ns;
		assert out_data = x"64636261" report "CONVERSION ERROR!";
		in_data <= x"ab12de45";
		wait for 10ns;
		assert out_data = x"45de12ab" report "CONVERSION ERROR!";

      wait;
   end process;

END;
