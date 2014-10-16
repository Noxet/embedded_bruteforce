

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity bajsd is
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

end bajsd;


architecture EXAMPLE of bajsd is

   -- Total number of input data.
   constant NUMBER_OF_INPUT_WORDS  : natural := 4;

   -- Total number of output data
   constant NUMBER_OF_OUTPUT_WORDS : natural := 2;

   type STATE_TYPE is (Idle, Read_Inputs, cracking, Write_Outputs);

   signal state        : STATE_TYPE;

   -- Accumulator to hold sum of inputs read at any point in time
   --signal sum          : std_logic_vector(0 to 31);

   -- Counters to store the number inputs read & outputs written
   signal nr_of_reads  : natural range 0 to NUMBER_OF_INPUT_WORDS - 1;
   signal nr_of_writes : natural range 0 to NUMBER_OF_OUTPUT_WORDS - 1;
   
   signal s_fsl_data_recv : std_logic;
   signal s_fsl_hash : std_logic_vector(127 downto 0);
   signal s_pw_found : std_logic;
   signal s_passwd : std_logic_vector(47 downto 0);
   signal tmp_passwd : std_logic_vector(47 downto 0);
	signal s_rstn : std_logic;

component brutus_top is
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
end component brutus_top;

begin

	s_rstn <= not FSL_Rst; -- for brutus inverted reset

	-- Brutus instantiation --
	brutus_inst: brutus_top
		port map (
			clk => FSL_Clk,
			rstn => s_rstn, -- active low
			
			i_fsl_data_recv => s_fsl_data_recv,
			i_fsl_hash => s_fsl_hash,
			
			o_pw_found => s_pw_found,
			o_passwd => s_passwd
		);


   FSL_S_Read  <= FSL_S_Exists   when state = Read_Inputs   else '0';
   FSL_M_Write <= not FSL_M_Full when state = Write_Outputs else '0';

   FSL_M_Data <= tmp_passwd(31 downto 0); --s_passwd(31 downto 0);

   The_SW_accelerator : process (FSL_Clk) is
   begin  -- process The_SW_accelerator
    if FSL_Clk'event and FSL_Clk = '1' then     -- Rising clock edge
      if FSL_Rst = '1' then               -- Synchronous reset (active high)
        -- CAUTION: make sure your reset polarity is consistent with the
        -- system reset polarity
        state        <= Idle;
        nr_of_reads  <= 0;
        nr_of_writes <= 0;
        --sum          <= (others => '0');
		  
		  s_fsl_data_recv <= '0'; -- fsl to brutus, signal for data available
		  s_fsl_hash <= (others => '0'); -- fsl to brutus, the has(c)h
		  tmp_passwd <= (others => '0');
      else
        case state is
          when Idle =>
            if (FSL_S_Exists = '1') then
              state       <= Read_Inputs;
              nr_of_reads <= NUMBER_OF_INPUT_WORDS - 1;
				  s_fsl_hash <= (others => '0');
              --sum         <= (others => '0');
            end if;

          when Read_Inputs =>
            if (FSL_S_Exists = '1') then
              -- Coprocessor function (Adding) happens here
              --sum         <= x"12345678"; --std_logic_vector(unsigned(sum) + unsigned(FSL_S_Data));
				  s_fsl_hash <= s_fsl_hash(95 downto 0) & FSL_S_Data; -- shift in the hash 4 times
              if (nr_of_reads = 0) then
                state        <= cracking; -- change this to cracking later
					s_fsl_data_recv <= '1'; 						-- let brutus know it's time to crack
                nr_of_writes <= NUMBER_OF_OUTPUT_WORDS - 1;
              else
                nr_of_reads <= nr_of_reads - 1;
              end if;
            end if;
				
			when cracking =>
				if s_pw_found = '1' then
					state <= Write_Outputs;
					tmp_passwd <= s_passwd;
				end if;

          when Write_Outputs =>
            if (nr_of_writes = 0) then
              state <= Idle;
            else
              if (FSL_M_Full = '0') then
					 tmp_passwd <= x"00000000" & tmp_passwd(47 downto 32);
                nr_of_writes <= nr_of_writes - 1;
              end if;
            end if;
				
			when others => null;
			
        end case;
      end if;
    end if;
   end process The_SW_accelerator;
end architecture EXAMPLE;
