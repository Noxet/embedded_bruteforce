----------------------------------------------------------------------------------
-- Engineer: Noxet && Niklas
-- 
-- Create Date:    14:56:58 09/22/2014 
-- Module Name:    controller - Behavioral 
-- Description: 
--		The Brutus system controller
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller is
    generic (
        N : integer := 1
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
        o_demux_sel : out std_logic_vector(N-1 downto 0); 		--
        o_mux_sel : out std_logic_vector(N-1 downto 0)	 		-- select signals to DEMUX/MUX
	);
end controller;

architecture Behavioral of controller is

    type states is (wait_fsl, calc_md5, wait_md5, comp_md5, send_fsl);
    signal state_c, state_n : states;
    
    signal dm_count_c, dm_count_n : unsigned(N-1 downto 0);	-- DEMUX selector counter
    signal m_count_c, m_count_n : unsigned(N-1 downto 0);		-- MUX selector counter
    
    type pw_buff_array is array(N-1 downto 0) of std_logic_vector(47 downto 0);
    signal pw_buff_c, pw_buff_n : pw_buff_array;

begin

    clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            if rstn = '0' then
                state_c <= wait_fsl;
                dm_count_c <= (others => '0');
                m_count_c <= (others => '0');
                pw_buff_c <= (others => (others => '0'));
            else
                state_c <= state_n;
                dm_count_c <= dm_count_n;
                m_count_c <= m_count_n;
                pw_buff_c <= pw_buff_n;
            end if;
        end if;
    end process;
    
    fsm_proc: process(state_c, i_fsl_data_recv, i_comp_eq, i_sg_done, i_md5_done, i_sg_string, pw_buff_c, m_count_c, dm_count_c)
    begin
	
        -- defaults --
        o_start_sg_comp <= '0';
        o_start_md5 <= '0';
        o_halt_sg <= '0';
        dm_count_n <= dm_count_c;
        m_count_n <= m_count_c;
        o_passwd <= (others => '0');
        o_pw_found <= '0';
        pw_buff_n <= pw_buff_c;
        state_n <= state_c;
	
        case state_c is
            
            -- KOLLA IFALL SG ÄR FÄRDIG, ISÅFALL HOPPA TILL /DEV/NULL --
            
            when wait_fsl =>
                dm_count_n <= (others => '0');
                m_count_n <= (others => '0');
                
                if i_fsl_data_recv = '1' then
                    state_n <= calc_md5;
                    o_start_sg_comp <= '1';
                end if;
                
            when calc_md5 =>
                o_start_md5 <= '1';				-- start MD5 cores
                dm_count_n <= dm_count_c + 1;
                pw_buff_n(to_integer(dm_count_c)) <= i_sg_string;	-- buffer the sg passwords
                
                if dm_count_c = N-1 then  -- should be N-1? CHECK THIS, we now
                                        -- halt everything...
                    dm_count_n <= (others => '0');
                    o_halt_sg <= '1';							-- halt the sg while crunching MD5 hashes
                    state_n <= wait_md5;
                end if;
                
                -- wait for the main MD5 core to be finished
            when wait_md5 =>
                o_halt_sg <= '1';				-- halt until done
                if i_md5_done = '1' then
                    state_n <= comp_md5;
                end if;
                
            when comp_md5 => 								-- rename to a better name
               -- o_halt_sg <= '1'; -- TEST
                m_count_n <= m_count_c + 1;

                
                if i_comp_eq = '1' then
                    o_passwd <= pw_buff_c(to_integer(m_count_c));
                    o_pw_found <= '1';
                    state_n <= wait_fsl;			-- back to init state
                elsif m_count_c = N-1 then
                    m_count_n <= (others => '0');
							 state_n <= calc_md5;    -- if pwd not found, calculate next hash
                end if;
                
            when others => null;
        end case;
	
    end process;
    
    -- pass through signal --
    o_passwd_hash <= i_fsl_hash;
    
    o_demux_sel <= std_logic_vector(dm_count_c);
    o_mux_sel <= std_logic_vector(m_count_c);

end Behavioral;

