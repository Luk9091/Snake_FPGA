LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Apple_generator_tb IS
END Apple_generator_tb;
 
ARCHITECTURE behavior OF Apple_generator_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Apple_generator
    PORT(
         CLK : IN  std_logic;
         Reset : IN  std_logic;
         canDraw : IN  std_logic;
         x : IN  std_logic_vector(6 downto 0);
         y : IN  std_logic_vector(5 downto 0);
         apple : OUT  std_logic;
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '1';
   signal canDraw : std_logic := '0';
   signal x : std_logic_vector(6 downto 0) := (others => '0');
   signal y : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal apple : std_logic;
   signal done : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Apple_generator PORT MAP (
          CLK => CLK,
          Reset => Reset,
          canDraw => canDraw,
          x => x,
          y => y,
          apple => apple,
          done => done
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
		Reset <= '0';
		wait for clk_period;
		Reset <= '1';
		wait for 5*clk_period;
		canDraw <= '1';
		wait until Done = '1';
		wait for 5*clk_period;
		Reset <= '0';
		wait for clk_period;
		Reset <= '1';
		
		wait;
   end process;

	position: process
	begin
		x <= (others => '0');
		for i in 0 to 39 loop
			y <= (others => '0');
			for j in 0 to 29 loop
				wait for clk_period;
				y <= y + 1;
			end loop;
			x <= x + 1;
		end loop;
	end process;
END;
