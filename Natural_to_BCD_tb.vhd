LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all; 
USE ieee.numeric_std.ALL;
USE IEEE.STD_logic_arith.all;
 
ENTITY Natural_to_BCD_tb IS
END Natural_to_BCD_tb;
 
ARCHITECTURE behavior OF Natural_to_BCD_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Natural_to_BCD
    PORT(
--         CLK : IN  std_logic;
         data : IN  std_logic_vector(12 downto 0);
         q : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal data : std_logic_vector(12 downto 0) := (others => '0');

 	--Outputs
   signal q : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Natural_to_BCD PORT MAP (
--          CLK => CLK,
          data => data,
          q => q
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		for i in 0 to 15 loop
			wait for CLK_period;
			data <= data + 1;
		end loop;
		
		data <= conv_std_logic_vector(4321, 13);

   end process;

END;
