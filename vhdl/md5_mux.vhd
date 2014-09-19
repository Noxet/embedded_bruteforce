----------------------------------------------------------------------------------
-- Engineer: Noxet
-- 
-- Module Name:    md5_mux - Behavioral 
-- Description: 
--			A mux to select which hash to compare
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- include the hash_array type --
use work.hash_array_pkg.all;

entity md5_mux is
    generic (
        N : integer
    );
    port (
        i_hash : in hash_array(N-1 downto 0);
        i_select : in std_logic_vector(N-1 downto 0);
        
        o_hash : out std_logic_vector(127 downto 0)
    );
end md5_mux;

architecture Behavioral of md5_mux is

begin

    data_proc: process(i_hash, i_select)
    begin
        
        for I in 0 to N-1 loop
            if i_select(I) = '1' then
                o_hash <= i_hash(I);
            end if;
        end loop;
        
    end process;

end Behavioral;

