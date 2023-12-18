LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY Snake_tb IS
END Snake_tb;
 
ARCHITECTURE behavior OF Snake_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Snake
	 GENERIC(
		COUNT_TO_TICK: integer;
		START_X : integer;
		START_Y : integer;
		START_DIR: std_logic_vector(1 downto 0);
		TRANSIT_BYTE : integer
	 );
    PORT(
         CLK : IN  std_logic;
         Reset : IN  std_logic;
         x : IN  std_logic_vector(6 downto 0);
         y : IN  std_logic_vector(5 downto 0);
         leftRight : IN  std_logic_vector(1 downto 0);
         Part : OUT  std_logic_vector(2 downto 0);
         push : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '1';
   signal x : std_logic_vector(6 downto 0) := (others => '0');
   signal y : std_logic_vector(5 downto 0) := (others => '0');
   signal leftRight : std_logic_vector(1 downto 0) := (others => '0');
   signal push : std_logic := '0';

 	--Outputs
   signal Part : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Snake 
	GENERIC MAP(
		COUNT_TO_TICK => 2,
		START_X => 1,
		START_Y => 0,
		START_DIR => "11",
		TRANSIT_BYTE => 2
	)PORT MAP (
          CLK => CLK,
          Reset => Reset,
          x => x,
          y => y,
          leftRight => leftRight,
          Part => Part,
          push => push
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
			wait for 105*clk_period;
			push <= '1';
			wait for clk_period;
			push <= '0';
			wait for 200*clk_period;
			Reset <= '0';
			wait for 200*clk_period;
			Reset <= '1';
			wait for 80*clk_period;
			leftRight <= "10";
			wait for 2*clk_period;
			wait;
		end process;

		y_loop: process
		begin
			x <= (others => '0');
			for i in 0 to 39 loop
				wait for clk_period;
				x <= x + 1;
			end loop;
		end process;


END;
