
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity myvga is
	port 
	(
		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add or delete. 
		FSL_Clk	: in	std_logic;
		FSL_Rst	: in	std_logic;
		FSL_S_Clk	: in	std_logic;
		FSL_S_Read	: out	std_logic;
		FSL_S_Data	: in	std_logic_vector(0 to 31);
		FSL_S_Control	: in	std_logic;
		FSL_S_Exists	: in	std_logic;
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
		
		hsync : out std_logic;
		vsync : out std_logic;
		gr : out std_logic_vector(2 downto 0);
		re : out std_logic_vector(2 downto 0);
		bl : out std_logic_vector(1 downto 0)
	);

attribute SIGIS : string; 
attribute SIGIS of FSL_Clk : signal is "Clk"; 
attribute SIGIS of FSL_S_Clk : signal is "Clk"; 
end myvga;


architecture EXAMPLE of myvga is

	constant hpixels : unsigned(9 downto 0) := "1100100000"; -- 800
	constant vlines : unsigned(9 downto 0) := "1000001101"; -- 525
	
	constant hbp : unsigned(9 downto 0) := "0010010000"; -- 144 backp h
	constant hfp: unsigned(9 downto 0) := "1100010000"; -- 784 frontp h
	
	constant vbp : unsigned(9 downto 0) := "0000011111"; -- 31 backp v
	constant vfp : unsigned(9 downto 0) := "0111111111"; -- 511 frontp v
	
	signal clk_div_c, clk_div_n : unsigned(1 downto 0); -- mod 4
	
	signal h_count_c, h_count_n, v_count_c, v_count_n : unsigned(9 downto 0);
	signal vsenable : std_logic; -- enable for vertical count
	signal vidon : std_logic;

begin

	FSL_S_Read <= '0';

	clk_proc: process(FSL_Clk) is
	begin
		if FSL_Clk'event and FSL_Clk = '1' then
			if FSL_Rst = '1' then
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
	
	clk_div_proc: process(clk_div_c)
	begin
		clk_div_n <= clk_div_c + 1;
		if clk_div_c = 3 then
			clk_div_n <= (others => '0');
		end if;
	end process;
	
	h_proc: process(clk_div_c, h_count_c)
	begin
		vsenable <= '0';
		h_count_n <= h_count_c;
		
		if (clk_div_c = 3) then
			h_count_n <= h_count_c + 1;
			
			if h_count_c = hpixels - 1 then
				h_count_n <= (others => '0');
				vsenable <= '1';
			end if;
			
		end if;
	end process;
	
	hsync <= '0' when h_count_c < 96 else '1';
	
	v_proc: process(clk_div_c, vsenable, v_count_c)
	begin
		
		v_count_n <= v_count_c;
		
		if (clk_div_c = 3 and vsenable = '1') then
			v_count_n <= v_count_c + 1;
			
			if v_count_c = vlines - 1 then
				v_count_n <= (others => '0');
			end if;
			
		end if;
	end process;
	
	vsync <= '0' when v_count_c < 2 else '1';
	
	vidon <= '1' when (((h_count_c < hfp) and (h_count_c >= hbp)) and ((v_count_c < vfp) and (v_count_c >= vbp))) else '0';
	
	rgb_proc: process(vidon)
	begin
		gr <= (others => '0');
		re <= (others => '0');
		bl <= (others => '0');
		
		if (vidon = '1') then
			re <= "111";
		end if;
	end process;
	
	--hsync <= '0' when (h_count_c >= (HD+HF)) and (h_count_c <= (HD+HF+HR-1)) else '1';
	--vsync <= '0' when (v_count_c >= (VD+VF)) and (h_count_c <= (VD+VF+VR-1)) else '1';
   
	
end architecture EXAMPLE;
