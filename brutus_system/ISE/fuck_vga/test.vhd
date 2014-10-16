----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:45 10/15/2014 
-- Design Name: 
-- Module Name:    test - Behavioral 
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

entity test is
	port (
		clk : in std_logic;
		rst : in std_logic;
		o : out std_logic_vector(9 downto 0)
	);
end test;

architecture Behavioral of test is

	signal c, n : unsigned(9 downto 0);

begin

	clk_proc: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				c <= (others => '0');
			else
				c <= n;
			end if;
		end if;
	end process;
	
	n <= c + 1;
	o <= std_logic_vector(c);

end Behavioral;

