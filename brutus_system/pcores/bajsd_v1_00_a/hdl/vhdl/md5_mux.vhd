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
			clk : in std_logic;
			rstn : in std_logic;
        i_hash_0 : in unsigned(127 downto 0); --hash_array(N-1 downto 0);
        i_hash_1 : in unsigned(127 downto 0); --hash_array(N-1 downto 0);
        i_select : in unsigned(N-1 downto 0); -- should be ceil(log2(N-1))
        
        o_hash_0 : out unsigned(31 downto 0);
		  o_hash_1 : out unsigned(31 downto 0);
		  o_hash_2 : out unsigned(31 downto 0);
		  o_hash_3 : out unsigned(31 downto 0)
    );
end md5_mux;

architecture Behavioral of md5_mux is

begin
	clk_proc : process(clk)
	begin
		if rising_edge(clk) then
			if rstn = '0' then 
				o_hash_0 <= (others => '0');
				o_hash_1 <= (others => '0');
				o_hash_2 <= (others => '0');
				o_hash_3 <= (others => '0');
			else
				o_hash_0 <= (others => '0');
				o_hash_1 <= (others => '0');
				o_hash_2 <= (others => '0');
				o_hash_3 <= (others => '0');
			--o_hash <= i_hash(to_integer(unsigned(i_select)));
				if i_select = "00" then
					o_hash_0 <= i_hash_0(127 downto 96);
					o_hash_1 <= i_hash_0(95 downto 64);
					o_hash_2 <= i_hash_0(63 downto 32);
					o_hash_3 <= i_hash_0(31 downto 0);
				elsif i_select = "01" then
					o_hash_0 <= i_hash_1(127 downto 96);
					o_hash_1 <= i_hash_1(95 downto 64);
					o_hash_2 <= i_hash_1(63 downto 32);
					o_hash_3 <= i_hash_1(31 downto 0);
				end if;
			end if;
		end if;
	end process;
end Behavioral;

