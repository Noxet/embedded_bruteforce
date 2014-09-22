------------------------------------------------------------------------------
-- brutus - entity/architecture pair
------------------------------------------------------------------------------
--
-- Filename:          brutus
-- Version:           1.00.a
-- Description:       Example FSL core (VHDL).
-- Date:              Fri Sep 19 16:14:59 2014 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------------
--
--
-- Definition of Ports
-- FSL_Clk             : Synchronous clock
-- FSL_Rst           : System reset, should always come from FSL bus
-- FSL_S_Clk       : Slave asynchronous clock
-- FSL_S_Read      : Read signal, requiring next available input to be read
-- FSL_S_Data      : Input data
-- FSL_S_CONTROL   : Control Bit, indicating the input data are control word
-- FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
-- FSL_M_Clk       : Master asynchronous clock
-- FSL_M_Write     : Write signal, enabling writing to output FSL bus
-- FSL_M_Data      : Output data
-- FSL_M_Control   : Control Bit, indicating the output data are contol word
-- FSL_M_Full      : Full Bit, indicating output FSL bus is full
--
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Entity Section
------------------------------------------------------------------------------

entity brutus is
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
      FSL_M_Clk	: in	std_logic;
      FSL_M_Write	: out	std_logic;
      FSL_M_Data	: out	std_logic_vector(0 to 31);
      FSL_M_Control	: out	std_logic;
      FSL_M_Full	: in	std_logic
      -- DO NOT EDIT ABOVE THIS LINE ---------------------
      );

  attribute SIGIS : string; 
  attribute SIGIS of FSL_Clk : signal is "Clk"; 
  attribute SIGIS of FSL_S_Clk : signal is "Clk"; 
  attribute SIGIS of FSL_M_Clk : signal is "Clk"; 

end brutus;


architecture Behavioral of brutus is

  type states is (idle, read_charset, read_hash, write_outputs);
  signal state_c, state_n : states;

  signal h_count_c, h_count_n : unsigned(1 downto 0); -- hash counter, 4 pieces

  signal test : std_logic_vector(31 downto 0);


begin
  -- CAUTION:
  -- The sequence in which data are read in and written out should be
  -- consistent with the sequence they are written and read in the
  -- driver's brutus.c file

  FSL_S_Read  <= FSL_S_Exists   when (state_c = read_charset or state_c = read_hash) else '0';
  FSL_M_Write <= not FSL_M_Full when state_c = Write_Outputs else '0';

  FSL_M_Data <= test;

  clk_proc : process (FSL_Clk) is
  begin  -- process The_SW_accelerator
    if rising_edge(FSL_Clk) then     -- Rising clock edge
      if FSL_Rst = '1' then              -- Synchronous reset (active high)
        state_c <= idle;
        h_count_c <= (others => '0');
        test <= (others => '0');
      else
        state_c <= state_n;
        h_count_c <= h_count_n;
        test <= x"00000042";
      end if;
    end if;
  end process;

  fsm_proc: process(state_c, h_count_c, FSL_S_Exists, FSL_S_Data, FSL_M_Full)
  begin

    -- defaults --
    h_count_n <= h_count_c;
    state_n <= state_c;
    
    case state_c is
      when idle =>
        if (FSL_S_Exists = '1') then
          state_n <= read_charset; -- which characters to include
        end if;

      when read_charset =>
        if FSL_S_Exists = '1' then
          state_n <= read_hash;
        end if;

      when read_hash =>
        if (FSL_S_Exists = '1') then
          h_count_n <= h_count_c + 1;
			 --test <= FSL_S_Data;
          
          if h_count_c = 3 then
            h_count_n <= (others => '0');
            state_n <= write_outputs;
          end if;
        end if;

      when write_outputs =>
        if (0 = 0) then
          state_n <= idle;
        else
          if (FSL_M_Full = '0') then
            --nr_of_writes <= nr_of_writes - 1;
          end if;
        end if;
    end case;
end process;

end architecture Behavioral;
