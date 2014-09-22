----------------------------------------------------------------------------------
-- Engineer: Noxet
-- 
-- Module Name:    md5_mux - Behavioral 
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
			i_select : in std_logic_vector(N-1 downto 0); -- should be ceil(log2(N-1))
        
			o_md5_indata : out md5_indata_t_array(N-1 downto 0)
    );
end md5_demux;

architecture Behavioral of md5_demux is

begin

	o_md5_indata(to_integer(unsigned(i_select))) <= i_md5_indata;

end Behavioral;

