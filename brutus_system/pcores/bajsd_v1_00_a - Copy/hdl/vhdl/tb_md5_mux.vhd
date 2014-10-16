--------------------------------------------------------------------------------
-- Engineer: Noxet
--
-- Create Date:   14:47:34 09/17/2014
-- Design Name:   
-- Module Name:   C:/temp/test_string_gen/tb_md5_mux.vhd
-- Project Name:  test_string_gen
-- Description:   
--      Testbench for md5_mux module
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

use work.hash_array_pkg.all;

ENTITY tb_md5_mux IS
END tb_md5_mux;

ARCHITECTURE behavior OF tb_md5_mux IS 
    
    -- Component Declaration for the Unit Under Test (UUT)
    
    COMPONENT md5_mux
        generic (
            N : integer
            );
        PORT(
            i_hash : IN  hash_array(N-1 downto 0);
            i_select : IN  std_logic_vector(N-1 downto 0);
            o_hash : OUT  std_logic_vector(127 downto 0)
            );
    END COMPONENT;
    

    --Inputs
    signal i_hash : hash_array(2 downto 0);
    signal i_select : std_logic_vector(2 downto 0) := (others => '0');

    --Outputs
    signal o_hash : std_logic_vector(127 downto 0);

    
BEGIN
    
    -- Instantiate the Unit Under Test (UUT)
    uut: md5_mux generic map(
        N => 3
	)	PORT MAP (
            i_hash => i_hash,
            i_select => i_select,
            o_hash => o_hash
            );
    

    -- Stimulus process
    stim_proc: process
    begin		
        -- hold reset state for 100 ns.
        wait for 10 ns;	

        i_hash(0) <= x"0cc175b9c0f1b6a831c399e269772661"; -- a
        i_hash(1) <= x"92eb5ffee6ae2fec3ad71c777531578f"; -- b
        i_hash(2) <= x"4a8a08f09d37b73795649038408b5f33"; -- c
        
        wait for 1 ns;
        
        i_select <= "001"; -- select a
        wait for 1 ns;
        assert o_hash = x"0cc175b9c0f1b6a831c399e269772661" report "FAIL A";
        
        i_select <= "010"; -- select b
        wait for 1 ns;
        assert o_hash = x"92eb5ffee6ae2fec3ad71c777531578f" report "FAIL B";
        
        i_select <= "100";
        wait for 1 ns;
        assert o_hash = x"4a8a08f09d37b73795649038408b5f33" report "FAIL C";

        wait;
    end process;

END;
