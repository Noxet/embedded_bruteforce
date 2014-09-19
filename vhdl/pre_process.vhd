----------------------------------------------------------------------------------
-- Company: 
-- Engineer:		 Niklas Aldén
-- 
-- Create Date:    14:02:44 09/16/2014 
-- Design Name: 
-- Module Name:    pre_process - Behavioral 
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

entity pre_process is
    Port ( i_data : in  STD_LOGIC_VECTOR (47 downto 0);
			  i_length : in  STD_LOGIC_VECTOR (2 downto 0);
	        o_data_0 : out  unsigned (31 downto 0);
           o_data_1 : out  unsigned (31 downto 0);
           o_length : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end pre_process;

architecture Behavioral of pre_process is

begin
	data_path : process(i_length, i_data)
		begin
			
			if i_length = "001" then 	--1
				o_data_0 <= x"000080" & unsigned(i_data(7 downto 0));
				o_data_1 <= (others => '0');
				o_length <= x"08";
				
			elsif i_length = "010" then --2
				o_data_0 <= x"0080" & unsigned(i_data(15 downto 0));
				o_data_1 <= (others => '0');
				o_length <= x"10";
			
			elsif i_length = "011" then --3
				o_data_0 <= x"80" & unsigned(i_data(23 downto 0));
				o_data_1 <= (others => '0');
				o_length <= x"18";
			
			elsif i_length = "100" then --4
				o_data_0 <= unsigned(i_data(31 downto 0));
				o_data_1 <= x"00000080";
				o_length <= x"20";
			
			elsif i_length = "101" then --5
				o_data_0 <= unsigned(i_data(31 downto 0));
				o_data_1 <= x"000080" & unsigned(i_data(39 downto 32));
				o_length <= x"28";
			
			elsif i_length = "110" then --6
				o_data_0 <= unsigned(i_data(31 downto 0));
				o_data_1 <= x"0080" & unsigned(i_data(47 downto 32));
				o_length <= x"30";
			
			else								--0
				o_data_0 <= x"00000080";
				o_data_1 <= (others => '0');
				o_length <= x"00";
			end if;
		
	end process;
end Behavioral;

