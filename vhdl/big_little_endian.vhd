----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		Nox && Gabbe
-- 
-- Create Date:    14:49:40 09/16/2014 
-- Design Name: 
-- Module Name:    big_little_endian - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Converts big endian in-data to little endian out-data
--
-- Dependencies:
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity big_little_endian is
	port (
		in_data : in std_logic_vector(31 downto 0);
		out_data : out std_logic_vector(31 downto 0)
	);
end big_little_endian;

architecture Behavioral of big_little_endian is

begin
	
	out_data <= in_data(7 downto 0) & in_data(15 downto 8) & in_data(23 downto 16) & in_data(31 downto 24);

end Behavioral;

