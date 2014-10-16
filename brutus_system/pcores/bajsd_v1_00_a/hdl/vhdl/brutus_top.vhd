----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:25:29 09/22/2014 
-- Design Name: 
-- Module Name:    brutus_top - Behavioral 
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

use work.hash_array_pkg.all;

entity brutus_top is
    generic (
        M : integer := 2
	);
    port (
        clk : in std_logic;
        rstn : in std_logic;
        
        i_fsl_data_recv : in std_logic;
        i_fsl_hash : in std_logic_vector(127 downto 0);
        
        o_pw_found : out std_logic;
        o_passwd : out std_logic_vector(47 downto 0)
	);
end brutus_top;

architecture Behavioral of brutus_top is

    component string_generator
        port (
            clk : in std_logic;
            rstn : in std_logic;	-- active low reset ofc
            i_start : in std_logic;
            i_halt : in std_logic;
            
            o_done : out std_logic;
            o_length : out std_logic_vector(2 downto 0); -- max 6 chars
            o_string : out std_logic_vector(47 downto 0) -- 6 char string
            );
    end component;
    
    component pre_process
        Port ( i_data : in  STD_LOGIC_VECTOR (47 downto 0);
               i_length : in  STD_LOGIC_VECTOR (2 downto 0);
               o_data_0 : out  unsigned (31 downto 0);
               o_data_1 : out  unsigned (31 downto 0);
               o_length : out  STD_LOGIC_VECTOR (7 downto 0)
               );
    end component;
	 
	 component md5_demux
		generic (
        N : integer
		 );
		 port (
				i_md5_indata : in md5_indata_t;
				i_select : in unsigned(N-1 downto 0); -- should be ceil(log2(N-1))
			  
				o_md5_indata_0 : out md5_indata_t; --_array(N-1 downto 0)
				o_md5_indata_1 : out md5_indata_t --_array(N-1 downto 0)
		 );
		end component;

    component MD5
        port (
            clk   : in  std_logic;
            rstn : in  std_logic;
            i_start : in  std_logic;
            --i_data  : in  unsigned(71 downto 0); -- 8 chars + 1 appended bit
            i_data_0  : in  unsigned(31 downto 0); -- first 4 chars
            i_data_1  : in  unsigned(31 downto 0); -- next 4 chars
            i_length  : in std_logic_vector(7 downto 0); -- nbr of chars
            o_done  : out std_logic;      
            o_hash_0  : out unsigned(31 downto 0);
            o_hash_1  : out unsigned(31 downto 0);
            o_hash_2  : out unsigned(31 downto 0);
            o_hash_3  : out unsigned(31 downto 0)
            );
    end component;
	 
	 component md5_mux
		generic (
        N : integer
		 );
		 port (
				clk   : in  std_logic;
            rstn : in  std_logic;
			  i_hash_0 : in unsigned(127 downto 0); --hash_array(N-1 downto 0);
			  i_hash_1 : in unsigned(127 downto 0); --hash_array(N-1 downto 0);
			  i_select : in unsigned(N-1 downto 0); -- should be ceil(log2(N-1))
			  
			  o_hash_0 : out unsigned(31 downto 0);
			  o_hash_1 : out unsigned(31 downto 0);
			  o_hash_2 : out unsigned(31 downto 0);
			  o_hash_3 : out unsigned(31 downto 0)
		 );
		 end component;
	 
    component comp
        port(
            clk : in std_logic;
            rstn : in std_logic; -- active low
            i_hash_0, i_hash_1, i_hash_2, i_hash_3 : in unsigned(31 downto 0); -- hash from md5
            i_cmp_hash : in std_logic_vector(127 downto 0); -- hash we are going to crack
            i_start : in std_logic; -- 1 when we should read i_cmp_hash
            
            o_equal : out std_logic -- 1 if we found the matching hash, else 0
            );
    end component;
    
    component controller
        generic (
            N : integer
            );
        port (
            clk : in std_logic;
            rstn : in std_logic;
            
            i_fsl_data_recv : in std_logic;
            i_fsl_hash : in std_logic_vector(127 downto 0);
            i_comp_eq : in std_logic; 										-- check if password was found
            i_sg_done : in std_logic; 										-- string generator done signal
            i_sg_string : in std_logic_vector(47 downto 0); 		-- current potential password
            i_md5_done : in std_logic; 									-- done signal from the main MD5 core
            
            o_passwd_hash : out std_logic_vector(127 downto 0); 	-- hash from FSL
            o_pw_found : out std_logic;									-- flag to indicate password found
            -- o_pw_nfound : out ---
            o_passwd : out std_logic_vector(47 downto 0);			-- password string, send to user
            o_start_sg_comp : out std_logic; 							-- start signals to sg and comp
            o_start_md5 : out std_logic; 									-- start signal to MD5 cores
            o_halt_sg : out std_logic; 									-- halt signal to sg
            o_demux_sel : out unsigned(M-1 downto 0); 		--
            o_mux_sel : out unsigned(M-1 downto 0)	 		-- select signals to DEMUX/MUX
            );
    end component;
    
    signal s_len_sg_pp : std_logic_vector(2 downto 0); 	 -- length sg->pp
    signal s_len_pp_demux, s_len_demux_md5_0, s_len_demux_md5_1 : std_logic_vector(7 downto 0);	 -- length pp->md5
    
    signal s_string_sg_pp : std_logic_vector(47 downto 0);
    
    signal s_string1_pp_demux, s_string1_demux_md5_0, s_string1_demux_md5_1 : unsigned(31 downto 0);
    signal s_string2_pp_demux, s_string2_demux_md5_0, s_string2_demux_md5_1 : unsigned(31 downto 0);
    
    signal hm0_0, hm1_0, hm2_0, hm3_0 : unsigned(31 downto 0); 			-- hashes from md5 to mux
    signal hm0_1, hm1_1, hm2_1, hm3_1 : unsigned(31 downto 0); 			-- hashes from md5 to mux
	 signal hc0_0, hc1_0, hc2_0, hc3_0 : unsigned(31 downto 0); 	-- hashes from mux to comp
	 
    signal comp_ctrl_eq, sg_ctrl_done, md5_ctrl_done : std_logic;
    signal sg_ctrl_string : std_logic_vector(47 downto 0);
    signal ctrl_comp_hash : std_logic_vector(127 downto 0);
    signal ctrl_sg_comp_start : std_logic;						-- start signal to sg and comp
    signal ctrl_demux_start, demux_md5_start_0, demux_md5_start_1 : std_logic;							-- start signal to MD5 cores
    signal ctrl_sg_halt : std_logic;								-- halt signal to sg
    --signal ctrl_demux_sel, ctrl_mux_sel : std_logic_vector(M-1 downto 0);	-- mux/demux selectors
	 
	 signal s_ctrl_demux_sel, s_ctrl_mux_sel : unsigned(M-1 downto 0);
	 
	 signal temp_hash_0, temp_hash_1 : unsigned(127 downto 0);

begin

    controller_inst: controller
        generic map (
            N => M
            )
        port map (
            clk => clk,
            rstn => rstn,
            
            i_fsl_data_recv => i_fsl_data_recv,
            i_fsl_hash => i_fsl_hash,
            i_comp_eq => comp_ctrl_eq,
            i_sg_done => sg_ctrl_done,
            i_sg_string => sg_ctrl_string,
            i_md5_done => md5_ctrl_done,
            
            o_passwd_hash => ctrl_comp_hash,
            o_pw_found => o_pw_found,
            o_passwd => o_passwd,
            o_start_sg_comp => ctrl_sg_comp_start,
            o_start_md5 => ctrl_demux_start,
            o_halt_sg => ctrl_sg_halt,
            o_demux_sel => s_ctrl_demux_sel,
            o_mux_sel => s_ctrl_mux_sel
            );

    comp_inst: comp
	port map (
            clk => clk,
            rstn => rstn,
            i_cmp_hash => i_fsl_hash,
            i_hash_0 => hc0_0,
            i_hash_1 => hc1_0,
            i_hash_2 => hc2_0,
            i_hash_3 => hc3_0,
            i_start => ctrl_sg_comp_start,
            o_equal => comp_ctrl_eq
            );
    
    sg_ctrl_string <= s_string_sg_pp; -- string goes both to pp and controller

    sg_inst: string_generator 
	port map (
            clk => clk,
            rstn => rstn,
            i_start => ctrl_sg_comp_start,
            i_halt => ctrl_sg_halt,
            o_done => sg_ctrl_done,
            o_length => s_len_sg_pp,
            o_string => s_string_sg_pp
            );
    
    pp_inst: pre_process
	port map(
            i_data => s_string_sg_pp,
            i_length => s_len_sg_pp,
            o_data_0 => s_string1_pp_demux,
            o_data_1 => s_string2_pp_demux,
            o_length => s_len_pp_demux
            );
				
	demux_inst: md5_demux
		generic map (
			N => M
		)
		port map (
			i_md5_indata.start => ctrl_demux_start,
			i_md5_indata.data_0 => s_string1_pp_demux,
			i_md5_indata.data_1 => s_string2_pp_demux,
			i_md5_indata.len => s_len_pp_demux,
			i_select => s_ctrl_demux_sel,
			
			o_md5_indata_0.start => demux_md5_start_0,
			o_md5_indata_0.data_0 => s_string1_demux_md5_0,
			o_md5_indata_0.data_1 => s_string2_demux_md5_0,
			o_md5_indata_0.len => s_len_demux_md5_0,
			
			o_md5_indata_1.start => demux_md5_start_1,
			o_md5_indata_1.data_0 => s_string1_demux_md5_1,
			o_md5_indata_1.data_1 => s_string2_demux_md5_1,
			o_md5_indata_1.len => s_len_demux_md5_1
		);
    
    MD5_inst_0: MD5
		port map (
            clk => clk,
            rstn => rstn,
            i_start => demux_md5_start_0,
            i_data_0 => s_string1_demux_md5_0,
            i_data_1 => s_string2_demux_md5_0,
            i_length => s_len_demux_md5_0,
            o_done => md5_ctrl_done,	-- only first md5 connected to controller
            o_hash_0 => hm0_0, --o_hash(31 downto 0),
            o_hash_1 => hm1_0, --o_hash(63 downto 32),
            o_hash_2 => hm2_0, --o_hash(95 downto 64),
            o_hash_3 => hm3_0 --o_hash(127 downto 96)
            );
				
	MD5_inst_1: MD5
		port map (
            clk => clk,
            rstn => rstn,
            i_start => demux_md5_start_1,
            i_data_0 => s_string1_demux_md5_1,
            i_data_1 => s_string2_demux_md5_1,
            i_length => s_len_demux_md5_1,
            o_done => open,
            o_hash_0 => hm0_1, --o_hash(31 downto 0),
            o_hash_1 => hm1_1, --o_hash(63 downto 32),
            o_hash_2 => hm2_1, --o_hash(95 downto 64),
            o_hash_3 => hm3_1 --o_hash(127 downto 96)
            );
		
		temp_hash_0 <= hm0_0 & hm1_0 & hm2_0 & hm3_0;
		temp_hash_1 <= hm0_1 & hm1_1 & hm2_1 & hm3_1;
		
		mux_inst: md5_mux
		generic map (
			N => M
		)
		port map (
			clk => clk,
         rstn => rstn,
			i_hash_0 => temp_hash_0,
			i_hash_1 => temp_hash_1,
			i_select => s_ctrl_mux_sel,
			
			o_hash_0 => hc0_0,
			o_hash_1 => hc1_0,
			o_hash_2 => hc2_0,
			o_hash_3 => hc3_0
		);


end Behavioral;

