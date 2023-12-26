LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
use ieee.Std_Logic_Arith.all;
 
ENTITY Map_controler_tb IS
END Map_controler_tb;
 
ARCHITECTURE behavior OF Map_controler_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Map_controler
    PORT(
			CLK 	: in  STD_LOGIC;
			Reset : in  STD_LOGIC;
			x 		: in  STD_LOGIC_VECTOR (6 downto 0);
			sub_x : in  STD_LOGIC_VECTOR (3 downto 0);
			y		: in  STD_LOGIC_VECTOR (5 downto 0);
			sub_y : in  STD_LOGIC_VECTOR (3 downto 0);
			color : out  STD_LOGIC_VECTOR(2 downto 0);
			leftRight: in STD_LOGIC_VECTOR(1 downto 0) := "11"
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
	signal Tick: std_logic := '0';
   signal Reset : std_logic := '1';
	
	signal leftRight: std_logic_vector(1 downto 0) := "11";
	
   signal x : std_logic_vector(6 downto 0) := (others => '0');
	signal sub_x: std_logic_vector(3 downto 0) := (others => '0');
	signal y : std_logic_vector(5 downto 0) := (others => '0');
	signal sub_y: std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal color : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Map_controler PORT MAP (
          CLK => CLK,
          Reset => Reset,
			 leftRight => leftRight,
          x => x,
          y => y,
			 sub_x => sub_x,
			 sub_y => sub_y,
          color => color
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
		x <= conv_std_logic_vector(20, 7);
		wait for clk_period;

      wait;
   end process;

	y_loop: process
	begin
		y <= (others => '0');
		for i in 0 to 39 loop
			wait for clk_period;
			y <= y + 1;
		end loop;
	end process;

END;
