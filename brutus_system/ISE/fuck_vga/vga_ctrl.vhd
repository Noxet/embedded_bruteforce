----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:29:32 10/15/2014 
-- Design Name: 
-- Module Name:    vga_ctrl - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;


entity vga_ctrl is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		hsync : out std_logic;
		vsync : out std_logic;
		gr : out std_logic_vector(2 downto 0);
		re : out std_logic_vector(2 downto 0);
		bl : out std_logic_vector(1 downto 0)
	);
end vga_ctrl;

architecture Behavioral of vga_ctrl is

	constant HD : integer := 640; -- h display
	constant HF : integer := 16;	-- h front porch
	constant HB : integer := 48;	-- h back porch
	constant HR : integer := 96;	-- h retrace
	constant HT : integer := 799; -- h total
	
	constant VD : integer := 480; -- v display
	constant VF : integer := 11;	-- v front porch
	constant VB : integer := 31;	-- v back porch
	constant VR : integer := 2;	-- v retrace
	constant VT : integer := 524;	-- v total
	
	signal clk_div_c, clk_div_n : unsigned(1 downto 0); -- mod 4
	signal h_count_c, h_count_n, v_count_c, v_count_n : unsigned(9 downto 0);

begin

	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				clk_div_c <= (others => '0');
				h_count_c <= (others => '0');
				v_count_c <= (others => '0');
			else
				clk_div_c <= clk_div_n;
				h_count_c <= h_count_n;
				v_count_c <= v_count_n;
			end if;
		end if;
	end process;
	
	clk_div_n <= clk_div_c + 1;
	
	h_proc: process(clk_div_c, h_count_c)
	begin
	
		h_count_n <= h_count_c;
		
		if (clk_div_c = "11") then
			h_count_n <= h_count_c + 1;
			if h_count_c = HT then
				h_count_n <= (others => '0');
			end if;
		end if;
	end process;
	
	v_proc: process(clk_div_c, h_count_c, v_count_c)
	begin
		
		v_count_n <= v_count_c;
		
		if (clk_div_c = "11" and h_count_c = HT) then
			v_count_n <= v_count_c + 1;
			if v_count_c = VT then
				v_count_n <= (others => '0');
			end if;
		end if;
	end process;
--   
end Behavioral;