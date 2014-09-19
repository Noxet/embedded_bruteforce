----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:33 09/17/2014 
-- Design Name: 
-- Module Name:    hash_ctrl - Behavioral 
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

entity hash_ctrl is
	generic(
			N : integer := 1
			 );
	port(
		clk : in std_logic;
		rstn : in std_logic;
		i_string_done : in std_logic; -- from string_generator
		i_md5_done : in std_logic; -- the done signal from the first md5
		i_hash : in std_logic_vector(127 downto 0); -- the hash to crack
		i_start : in std_logic; -- from MB to start cracking
		
		o_md5_select : out std_logic_vector(N-1 downto 0); -- to the dmux which decides which md5 to start
		o_start : out std_logic; -- start signals to string-generator and cmp
		o_string_halt : out std_logic; -- pause the string-generator
		o_cmp_hash : out std_logic_vector(127 downto 0) -- the hash to the cmp
	);
end hash_ctrl;

architecture Behavioral of hash_ctrl is

		-- local signals here --
		signal i_c, i_n : unsigned(N-1 downto 0);
		-- the selection has to be delayed --
		signal md5_sel_c, md5_sel_n : std_logic_vector(N-1 downto 0);
		
		type state is (waiting, init, counting);
		signal state_c, state_n : state;
		
begin
	
		clk_proc: process(clk, rstn)
		begin
			if rising_edge(clk) then
				if rstn = '0' then
					i_c <= (others => '0');
					md5_sel_c <= (others => '0');
					state_c <= waiting;
				else
					i_c <= i_n;
					md5_sel_c <= md5_sel_n;
					state_c <= state_n;
				end if;
			end if;
		end process;
		
		FSM_proc: process(state_c, i_start, i_c, i_string_done)
		begin
			state_n <= state_c;
			case state_c is
				-- waits for a start signal --
				when waiting =>
					if i_start = '1' then
						state_n <= init;
					else
						state_n <= waiting;
					end if;
					
				-- set the hash value to cmp, initialize the string_gen, wait until all md5 have data --
				when init =>
					if i_c = N then
						state_n <= counting;
					else
						state_n <= init;
					end if;
					
				-- waits for a md5 to be done and checks if the hash has been cracked --
				when counting =>
					if i_string_done = '1' then
						state_n <= waiting;
					else
						state_n <= counting;
					end if;
			end case;
		end process;
		
		data_proc: process(md5_sel_c, state_c, i_hash, i_c, i_md5_done)
		begin
			-- halt everything as standard --
			md5_sel_n <= (others => '0');
			o_start <= '0';
			o_string_halt <= '1';
			o_cmp_hash <= (others => '0');
			o_md5_select <= md5_sel_c;
			i_n <= (others => '0');
			case state_c is	
				when init =>
					-- start the string-gen and cmp --
					if i_c = 0 then
						o_start <= '1';
						o_cmp_hash <= i_hash;
					else
						o_start <= '0';
						o_cmp_hash <= (others => '0');
					end if;
					
					-- loop through all the md5's to give them strings and start signals --
					o_string_halt <= '0';
					md5_sel_n <= (others => '0');
					md5_sel_n(to_integer(i_c)) <= '1';
					if i_c /= N then 
						i_n <= i_c + 1;
					else
						i_n <= (others => '0');
					end if;
					
				when counting =>
					if i_md5_done = '1' then
						-- the first md5 is finished, start counting --
						o_string_halt <= '0';
						md5_sel_n <= (others => '0');
						md5_sel_n(to_integer(i_c)) <= '1'; 
						i_n <= i_c + 1;
					else
						if (i_c < N) and (i_c /= 0) then
							-- we haven't started all the md5:s yet --
							o_string_halt <= '0';
							md5_sel_n <= (others => '0');
							md5_sel_n(to_integer(i_c)) <= '1'; 
							i_n <= i_c + 1;
						else
							-- just waiting for the done signal --
							o_string_halt <= '1';
							md5_sel_n <= (others => '0');
							i_n <= (others => '0');
						end if;
					end if;
					
				when others =>
					-- we don't do anything here because the halt signals are set as standard values --
					NULL;
			end case;
		end process;
end Behavioral;

