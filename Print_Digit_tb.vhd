LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all; 
USE ieee.numeric_std.ALL;
use ieee.std_logic_arith.all;
 
ENTITY Print_Digit_tb IS
END Print_Digit_tb;
 
ARCHITECTURE behavior OF Print_Digit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	COMPONENT Print_Digit
--	Generic(
--		START_DRAW_Y: integer
--		WIDTH			: integer;
--		HEIGHT		: integer
--	);
	PORT(
		CLK 			: IN  std_logic;
		Reset 		: IN  std_logic;
		x 				: IN  std_logic_vector(6 downto 0);
		y 				: IN  std_logic_vector(5 downto 0);
		Data 			: IN  std_logic_vector(12 downto 0);
		RGB 			: OUT  std_logic_vector(2 downto 0)
	);
	END COMPONENT;
    

   --Inputs
   signal CLK 		: std_logic := '1';
   signal Reset 	: std_logic := '1';
   signal x 		: std_logic_vector(6 downto 0) := (others => '0');
   signal y 		: std_logic_vector(5 downto 0) := (others => '0');
   signal Data 	: std_logic_vector(12 downto 0) := (others => '0');

 	--Outputs
   signal RGB : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Print_Digit 
--		GENERIC MAP(
--			START_DRAW_Y => 0
--		) 
		PORT MAP (
			CLK 		=> CLK,
			Reset 	=> Reset,
			x 		=> x,
			y			=> y,
			Data 	=> Data,
			RGB 		=> RGB
		);

   -- Clock process definitions
   CLK_process :process
   begin
		wait for CLK_period/2;
		CLK <= not CLK;
	end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		data <= conv_std_logic_vector(1, 13);
      wait;
   end process;

	coordinate_loop: process
	begin
		y <= conv_std_logic_vector(10, y'LENGTH);
		--for i in 0 to 30 loop
			x <= (others => '0');
			for j in 0 to 40 loop 
				wait for clk_period;
				x <= x + 1;
			end loop;
			--wait for clk_period;
			--y <= y + 1;
		--end loop;
	end process;

END;
