----------------------------------------------------------------------------------
-- Engineer: Noxet
--
-- Module Name:    sg_pp_md_top - Structural 
-- Description: 
--      A top module for string_generator, pre_processing and md5 modules
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sg_pp_md_top is
    port (
        clk : in std_logic;
        rstn : in std_logic;
        
        i_start_sg : in std_logic;
        i_halt_sg : in std_logic;
        i_start_md5 : in std_logic;
        
        o_hash : out unsigned(127 downto 0);
        o_done_md5 : out std_logic
	);
end sg_pp_md_top;

architecture Structural of sg_pp_md_top is

    
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
    
    signal s_len_sg_pp : std_logic_vector(2 downto 0);  -- length sg->pp
    signal s_len_pp_md5 : std_logic_vector(7 downto 0); -- length pp->md5
    
    signal s_string_sg_pp : std_logic_vector(47 downto 0);
    
    signal s_string1_pp_md5 : unsigned(31 downto 0);
    signal s_string2_pp_md5 : unsigned(31 downto 0);
    


begin

    sg_inst: string_generator 
	port map (
            clk => clk,
            rstn => rstn,
            i_start => i_start_sg,
            i_halt => i_halt_sg,
            o_done => open,
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
            i_start => i_start_md5,
            i_data_0 => s_string1_pp_md5,
            i_data_1 => s_string2_pp_md5,
            i_length => s_len_pp_md5,
            o_done => o_done_md5,
            o_hash_0 => o_hash(31 downto 0),
            o_hash_1 => o_hash(63 downto 32),
            o_hash_2 => o_hash(95 downto 64),
            o_hash_3 => o_hash(127 downto 96)
            );

end Structural;

