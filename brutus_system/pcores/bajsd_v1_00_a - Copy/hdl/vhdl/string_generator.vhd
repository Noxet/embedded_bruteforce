----------------------------------------------------------------------------------
-- Engineer: Noxet
--
-- Module Name:    string_generator - Behavioral 
-- Description: 
--      A state machine to generate potential passwords
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity string_generator is
    port (
        clk : in std_logic;
        rstn : in std_logic;	-- active low reset ofc
        i_start : in std_logic;
        i_halt : in std_logic;
        
        o_md5_start : out std_logic; -- when we write a string to md5 we also start them
        o_done : out std_logic;
        o_length : out std_logic_vector(2 downto 0); -- max 6 chars
        o_string : out std_logic_vector(47 downto 0) -- 6 char string
	);
end string_generator;

architecture Behavioral of string_generator is

    type states is (init, c0, c1, c2, c3, c4, c5);
    signal state_c, state_n : states;
    
    constant low_chr : unsigned(7 downto 0) := x"61";  -- First character (a)
    constant high_chr : unsigned(7 downto 0) := x"7A";  -- Last character generated (z) 
    
    signal chr0_c, chr1_c, chr2_c, chr3_c, chr4_c, chr5_c : unsigned(7 downto 0);
    signal chr0_n, chr1_n, chr2_n, chr3_n, chr4_n, chr5_n : unsigned(7 downto 0);
    
    signal len_c, len_n : unsigned(2 downto 0);

begin

    clk_proc: process(clk)
    begin
      	if rising_edge(clk) then
            if rstn = '0' then
                state_c <= init;
                chr0_c <= (others => '0');
                chr1_c <= (others => '0');
                chr2_c <= (others => '0');
                chr3_c <= (others => '0');
                chr4_c <= (others => '0');
                chr5_c <= (others => '0');
                len_c <= (others => '0');
            else
                --if i_halt = '0' then	-- only update when not halted
                state_c <= state_n;
                chr0_c <= chr0_n;
                chr1_c <= chr1_n;
                chr2_c <= chr2_n;
                chr3_c <= chr3_n;
                chr4_c <= chr4_n;
                chr5_c <= chr5_n;
                len_c <= len_n;
                --end if;
            end if;
        end if;
    end process clk_proc;

    fsm_proc: process (i_start, state_c, chr0_c, chr1_c, chr2_c, chr3_c, chr4_c, chr5_c, len_c, i_halt)
    begin
        -- defaults
        state_n <= state_c;
        chr0_n <= chr0_c;
        chr1_n <= chr1_c;
        chr2_n <= chr2_c;
        chr3_n <= chr3_c;
        chr4_n <= chr4_c;
        chr5_n <= chr5_c;
        len_n <= len_c;
        o_done <= '0';
        o_md5_start <= '0';
                       
        if i_halt = '0' then
            
            case state_c is
                when init =>
                    chr0_n <= (others => '0');
                    chr1_n <= (others => '0');
                    chr2_n <= (others => '0');
                    chr3_n <= (others => '0');
                    chr4_n <= (others => '0');
                    chr5_n <= (others => '0');
                    len_n <= (others => '0');
                    o_md5_start <= '0'; -- don't run the md5 in init
                    
                    if i_start = '1' then
                        state_n <= c0;
                    end if;

                when c0 =>
                    chr0_n <= chr0_c + 1;
                    o_md5_start <= '1'; -- we are not halting so we have to start the next md5

                    if chr0_c = 0 then
                        chr0_n <= low_chr;	-- set 'a' as the first character
                        len_n <= len_c + 1; -- string size grows by 1 when we use a new character
                    end if;
                    
                    if chr0_c = high_chr then
                        chr0_n <= low_chr;
                        state_n <= c1;
                    end if;

                when c1 =>
                    chr1_n <= chr1_c + 1;
                    state_n <= c0;
                    o_md5_start <= '1';
                    
                    if chr1_c = 0 then
                        chr1_n <= low_chr;
                        len_n <= len_c + 1;
                    end if;
                    
                    if chr1_c = high_chr then
                        chr1_n <= low_chr;
                        state_n <= c2;
                    end if;

                when c2 =>
                    chr2_n <= chr2_c + 1;
                    state_n <= c0;
                    o_md5_start <= '1';

                    if chr2_c = 0 then
                        chr2_n <= low_chr;
                        len_n <= len_c + 1;
                    end if;
                    
                    if chr2_c = high_chr then
                        chr2_n <= low_chr;
                        state_n <= c3;
                    end if;

                when c3 =>
                    chr3_n <= chr3_c + 1;
                    state_n <= c0;
                    o_md5_start <= '1';

                    if chr3_c = 0 then
                        chr3_n <= low_chr;
                        len_n <= len_c + 1;
                    end if;
                    
                    if chr3_c = high_chr then
                        chr3_n <= low_chr;
                        state_n <= c4;
                    end if;

                when c4 =>
                    chr4_n <= chr4_c + 1;
					state_n <= c0;
                    o_md5_start <= '1';

                    if chr4_c = 0 then
                        chr4_n <= low_chr;
                        len_n <= len_c + 1;
                    end if;
                    
                    if chr4_c = high_chr then
                        chr4_n <= low_chr;
                        state_n <= c5;
                    end if;

                when c5 =>
                    chr5_n <= chr5_c + 1;
                    state_n <= c0;
                    o_md5_start <= '1';

                    if chr5_c = 0 then
                        chr5_n <= low_chr;
                        len_n <= len_c + 1;
                    end if;
                    
                    if chr5_c = high_chr then
                        chr5_n <= low_chr;
                        state_n <= init;
                        o_done <= '1';      -- We have now generated all possible passwords
                    end if;
                    
                when others => null;
                               
            end case;
                
        end if;
    end process;

    -- Output logic
    o_string <= std_logic_vector(chr5_c & chr4_c & chr3_c & chr2_c & chr1_c & chr0_c);
    o_length <= std_logic_vector(len_c);

end Behavioral;

