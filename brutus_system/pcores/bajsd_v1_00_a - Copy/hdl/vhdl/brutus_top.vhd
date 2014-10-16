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

entity brutus_top is
    generic (
        M : integer := 1
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
            o_demux_sel : out std_logic_vector(M-1 downto 0); 		--
            o_mux_sel : out std_logic_vector(M-1 downto 0)	 		-- select signals to DEMUX/MUX
            );
    end component;
    
    signal s_len_sg_pp : std_logic_vector(2 downto 0); 	 -- length sg->pp
    signal s_len_pp_md5 : std_logic_vector(7 downto 0);	 -- length pp->md5
    
    signal s_string_sg_pp : std_logic_vector(47 downto 0);
    
    signal s_string1_pp_md5 : unsigned(31 downto 0);
    signal s_string2_pp_md5 : unsigned(31 downto 0);
    
    signal h0, h1, h2, h3 : unsigned(31 downto 0); 			-- hashes from md5 to comparator
    
    signal comp_ctrl_eq, sg_ctrl_done, md5_ctrl_done : std_logic;
    signal sg_ctrl_string : std_logic_vector(47 downto 0);
    signal ctrl_comp_hash : std_logic_vector(127 downto 0);
    signal ctrl_sg_comp_start : std_logic;						-- start signal to sg and comp
    signal ctrl_md5_start : std_logic;							-- start signal to MD5 cores
    signal ctrl_sg_halt : std_logic;								-- halt signal to sg
    signal ctrl_demux_sel, ctrl_mux_sel : std_logic_vector(M-1 downto 0);	-- mux/demux selectors

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
            o_start_md5 => ctrl_md5_start,
            o_halt_sg => ctrl_sg_halt,
            o_demux_sel => open,
            o_mux_sel => open
            );

    comp_inst: comp
	port map (
            clk => clk,
            rstn => rstn,
            i_cmp_hash => i_fsl_hash,
            i_hash_0 => h0,
            i_hash_1 => h1,
            i_hash_2 => h2,
            i_hash_3 => h3,
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
            o_data_0 => s_string1_pp_md5,
            o_data_1 => s_string2_pp_md5,
            o_length => s_len_pp_md5
            );
    
    MD5_inst: MD5
	port map (
            clk => clk,
            rstn => rstn,
            i_start => ctrl_md5_start,
            i_data_0 => s_string1_pp_md5,
            i_data_1 => s_string2_pp_md5,
            i_length => s_len_pp_md5,
            o_done => md5_ctrl_done,
            o_hash_0 => h0, --o_hash(31 downto 0),
            o_hash_1 => h1, --o_hash(63 downto 32),
            o_hash_2 => h2, --o_hash(95 downto 64),
            o_hash_3 => h3 --o_hash(127 downto 96)
            );


end Behavioral;

