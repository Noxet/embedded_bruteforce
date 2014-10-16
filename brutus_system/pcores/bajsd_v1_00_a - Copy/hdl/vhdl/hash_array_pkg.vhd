
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package hash_array_pkg is

	type hash_array is array(integer range <>) of unsigned(127 downto 0);
	
	type md5_indata_t is
	record
		data_0 : unsigned(31 downto 0);
		data_1 : unsigned(31 downto 0);
		start : std_logic;
		len : std_logic_vector(7 downto 0);
	end record;
	
	type md5_indata_t_array is array(integer range <>) of md5_indata_t;
		
end hash_array_pkg;