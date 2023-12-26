LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bin_to_digit_tb IS
END bin_to_digit_tb;
 
ARCHITECTURE behavior OF bin_to_digit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Digit_to_display
    PORT(
         A 		: IN  std_logic_vector(6 downto 0);
         SPO 	: OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk		: std_logic := '0';
   signal we 		: std_logic_vector(0 downto 0) := (others => '0');
   signal addr 	: std_logic_vector(6 downto 0) := (others => '0');

 	--Outputs
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bin_to_digit PORT MAP (
          clka => clk,
          wea => we,
          addra => addr,
          douta => dout
        );

   -- Clock process definitions
   clka_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		wait for clk_period;
		addr <= addr + 1;
      
   end process;

END;
