--------------------------------------------------------------------------------
-- Engineer: Nox
--  
-- Module Name:   /home/noxet/vhdl/string_generator/tb_string_generator.vhd
-- Description:   
--      A testbench for the string_generator module
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_string_generator IS
END tb_string_generator;
 
ARCHITECTURE behavior OF tb_string_generator IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT string_generator
    PORT(
         clk : IN  std_logic;
         rstn : IN  std_logic;
         i_start : IN  std_logic;
		 i_halt : IN std_logic;
         o_done : OUT  std_logic;
         o_string : OUT  std_logic_vector(47 downto 0);
			o_length : OUT std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rstn : std_logic := '0';
   signal i_start : std_logic := '0';
   signal i_halt : std_logic := '0';

 	--Outputs
   signal o_done : std_logic;
	signal o_length : std_logic_vector(2 downto 0);
   signal o_string : std_logic_vector(47 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: string_generator PORT MAP (
          clk => clk,
          rstn => rstn,
          i_start => i_start,
		  i_halt => i_halt,
          o_done => o_done,
          o_string => o_string,
			 o_length => o_length
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
      rstn <= '1';

      wait for clk_period*10;

      i_start <= '1';
      wait for clk_period;
      i_start <= '0';
	  
	  wait for 10*clk_period;
	  i_halt <= '1';
	  wait for 5*clk_period;
	  i_halt <= '0';
	  assert o_string = x"00000000006A" report "FAIL HALT, 'j'"; -- 10th letter = j
	  
	  wait for 16*clk_period;
	  i_halt <= '1';
	  wait for 1*clk_period;
	  i_halt <= '0';
	  assert o_string = x"00000000007A" report "FAIL HALT, 'z'"; -- last letter = z
	  
	  wait for 2*clk_period;
	  assert o_string = x"000000006161" report "FAIL OUTPUT, 'aa'";
	  assert o_length = "010" report "FAIL LENGTH, 2";
	  
	
      wait until o_done = '1';
      wait;
   end process;

END;
