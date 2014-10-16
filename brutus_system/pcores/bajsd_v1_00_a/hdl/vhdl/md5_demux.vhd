----------------------------------------------------------------------------------
-- Engineer: Noxet
-- 
-- Module Name:    md5_demux - Behavioral 
-- Description: 
--			A demux to select which md5 to use for hashing
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- include the hash_array type --
use work.hash_array_pkg.all;

entity md5_demux is
    generic (
        N : integer
    );
    port (
			i_md5_indata : in md5_indata_t;
			i_select : in unsigned(N-1 downto 0); -- should be ceil(log2(N-1))
        
			o_md5_indata_0 : out md5_indata_t; --_array(N-1 downto 0)
			o_md5_indata_1 : out md5_indata_t --_array(N-1 downto 0)
    );
end md5_demux;

architecture Behavioral of md5_demux is

begin
	comb_proc : process(i_select, i_md5_indata)
	begin
		o_md5_indata_0.data_0 <= (others => '0');
		o_md5_indata_0.data_1 <= (others => '0');
		o_md5_indata_0.start <= '0';
		o_md5_indata_0.len <= (others => '0');
		o_md5_indata_1.data_0 <= (others => '0');
		o_md5_indata_1.data_1 <= (others => '0');
		o_md5_indata_1.start <= '0';
		o_md5_indata_1.len <= (others => '0');
		
	--o_md5_indata(to_integer(unsigned(i_select))) <= i_md5_indata;
		if i_select = 0 then
			o_md5_indata_0 <= i_md5_indata;
		elsif i_select = 1 then
			o_md5_indata_1 <= i_md5_indata;
		end if;
	end process;
end Behavioral;

