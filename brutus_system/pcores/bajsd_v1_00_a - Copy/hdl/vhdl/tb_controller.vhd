--------------------------------------------------------------------------------
-- Company: 
-- Engineer: Noxet && Niklas
--
-- Create Date:   16:17:39 09/22/2014
-- Design Name:   
-- Module Name:   C:/Users/ael10jso/Xilinx/embedded_bruteforce/vhdl/tb_controller.vhd
-- Project Name:  test_sg_top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_controller IS
END tb_controller;
 
ARCHITECTURE behavior OF tb_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controller
    PORT(
         clk : IN  std_logic;
         rstn : IN  std_logic;
         i_fsl_data_recv : IN  std_logic;
         i_fsl_hash : IN  std_logic_vector(127 downto 0);
         i_comp_eq : IN  std_logic;
         i_sg_done : IN  std_logic;
         i_sg_string : IN  std_logic_vector(47 downto 0);
         i_md5_done : IN  std_logic;
         o_passwd_hash : OUT  std_logic_vector(127 downto 0);
         o_pw_found : OUT  std_logic;
         o_passwd : OUT  std_logic_vector(47 downto 0);
         o_start_sg_comp : OUT  std_logic;
         o_start_md5 : OUT  std_logic;
         o_halt_sg : OUT  std_logic;
         o_demux_sel : OUT  std_logic_vector(0 downto 0);
         o_mux_sel : OUT  std_logic_vector(0 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rstn : std_logic := '0';
   signal i_fsl_data_recv : std_logic := '0';
   signal i_fsl_hash : std_logic_vector(127 downto 0) := (others => '0');
   signal i_comp_eq : std_logic := '0';
   signal i_sg_done : std_logic := '0';
   signal i_sg_string : std_logic_vector(47 downto 0) := (others => '0');
   signal i_md5_done : std_logic := '0';

 	--Outputs
   signal o_passwd_hash : std_logic_vector(127 downto 0);
   signal o_pw_found : std_logic;
   signal o_passwd : std_logic_vector(47 downto 0);
   signal o_start_sg_comp : std_logic;
   signal o_start_md5 : std_logic;
   signal o_halt_sg : std_logic;
   signal o_demux_sel : std_logic_vector(0 downto 0);
   signal o_mux_sel : std_logic_vector(0 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controller PORT MAP (
          clk => clk,
          rstn => rstn,
          i_fsl_data_recv => i_fsl_data_recv,
          i_fsl_hash => i_fsl_hash,
          i_comp_eq => i_comp_eq,
          i_sg_done => i_sg_done,
          i_sg_string => i_sg_string,
          i_md5_done => i_md5_done,
          o_passwd_hash => o_passwd_hash,
          o_pw_found => o_pw_found,
          o_passwd => o_passwd,
          o_start_sg_comp => o_start_sg_comp,
          o_start_md5 => o_start_md5,
          o_halt_sg => o_halt_sg,
          o_demux_sel => o_demux_sel,
          o_mux_sel => o_mux_sel
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
      -- hold reset state for 10 ns.
      wait for 10 ns;
		rstn <= '0';

      wait for clk_period*10;
		rstn <= '1';
		
		i_fsl_hash <= x"e2fc714c4727ee9395f324cd2e7f331f";
		i_fsl_data_recv <= '1'; -- catch the data!
		wait for clk_period;
		
		--i_sg_string <= 


      wait;
   end process;

END;
