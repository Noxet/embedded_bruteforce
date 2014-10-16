----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Gabbe
-- 
-- Create Date:    09:40:15 09/17/2014 
-- Design Name: 
-- Module Name:    comp - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comp is
	port(
		clk : in std_logic;
		rstn : in std_logic; -- active low
		i_hash_0, i_hash_1, i_hash_2, i_hash_3 : in unsigned(31 downto 0); -- hash from md5
		i_cmp_hash : in std_logic_vector(127 downto 0); -- hash we are going to crack
		i_start : in std_logic; -- 1 when we should read i_cmp_hash
		
		o_equal : out std_logic -- 1 if we found the matching hash, else 0
		);
end comp;

architecture Behavioral of comp is

	-- the register signals --
	signal cmp_hash_c, cmp_hash_n : std_logic_vector(127 downto 0);

	-- for delaying equal signal, to controller --
	--signal eq_c, eq_n : std_logic;

begin

	-- the only signals which are clocked in this block are the register signals --
	clk_proc: process(clk)
	begin
		if rising_edge(clk) then				
			if rstn = '0' then
				cmp_hash_c <= (others => '0');
				--eq_c <= '0';
			else
				cmp_hash_c <= cmp_hash_n;
				--eq_c <= eq_n;
			end if;
		end if;
	end process;
	
	-- data path --
	data_proc: process(i_start, i_cmp_hash, i_hash_0, i_hash_1, i_hash_2, i_hash_3, cmp_hash_c)--, eq_c)
	
		-- the i_hash_1-3 have to be converted to little endian --
		variable little_endian_0, little_endian_1, little_endian_2, little_endian_3 : unsigned(31 downto 0);
	
	begin
	
		-- defaults --
		--eq_n <= eq_c;
	
		-- converts the md5-hashes to little endian --
 		little_endian_0 := i_hash_0(7 downto 0) & i_hash_0(15 downto 8) & i_hash_0(23 downto 16) & i_hash_0(31 downto 24);
		little_endian_1 := i_hash_1(7 downto 0) & i_hash_1(15 downto 8) & i_hash_1(23 downto 16) & i_hash_1(31 downto 24);
		little_endian_2 := i_hash_2(7 downto 0) & i_hash_2(15 downto 8) & i_hash_2(23 downto 16) & i_hash_2(31 downto 24);
		little_endian_3 := i_hash_3(7 downto 0) & i_hash_3(15 downto 8) & i_hash_3(23 downto 16) & i_hash_3(31 downto 24);
	
		-- sets the register value --
		if i_start = '1' then
			cmp_hash_n <= i_cmp_hash;
		else
			cmp_hash_n <= cmp_hash_c;
		end if;
		
		-- have we found a matching hash or not? --
		if (little_endian_0 & little_endian_1 & little_endian_2 & little_endian_3) = unsigned(cmp_hash_c) then
			--eq_n <= '1';
			o_equal <= '1'; --TEST
		else
			--eq_n <= '0';
			o_equal <= '0'; --TEST
		end if;
	end process;
	
	--o_equal <= eq_c;
		
end Behavioral;

