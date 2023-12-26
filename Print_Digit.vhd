library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Print_Digit is
	Generic(
		START_DRAW_Y: integer := 10;
		WIDTH			: integer := 40;
		HEIGHT		: integer := 30
	); Port ( 
		CLK 	: in  STD_LOGIC;
      Reset : in  STD_LOGIC;
		x 		: in  STD_LOGIC_VECTOR ( 6 downto 0) := (others => '0');
		y 		: in  STD_LOGIC_VECTOR ( 5 downto 0);
		Data 	: in  STD_LOGIC_VECTOR (12 downto 0);
		Draw	: out STD_LOGIC := '0'
	);
end Print_Digit;

architecture Behavioral of Print_Digit is
	component Digit_to_display
		PORT(
			A 		: in  std_logic_vector(7 downto 0);
			SPO	: out std_logic_vector(7 downto 0)
		);
	end component;
	
	component Natural_to_BCD
		PORT(
			DATA	: in  std_logic_vector(12 downto 0);
			Q		: out std_logic_vector(15 downto 0)
		);
	end component;
	
	signal digits		: std_logic_vector(15 downto 0);
	alias  ones 		is digits( 3 downto  0);
	alias  tens			is digits( 7 downto  4);
	alias  hundreds	is digits(11 downto  8);
	alias  thousands	is digits(15 downto 12);
	
	signal y_to_display			: std_logic_vector(3 downto 0) := (others => '0');

	signal ones_to_display		: std_logic_vector(7 downto 0);
	signal tens_to_display		: std_logic_vector(7 downto 0);
	signal hundreds_to_display	: std_logic_vector(7 downto 0);
	signal thousands_to_display: std_logic_vector(7 downto 0);
	signal x_to_display 			: integer range 0 to 8  := 0;

begin
	N2BCD: Natural_to_BCD
		PORT MAP(
			DATA 	=> Data,
			Q		=> digits
		);
		
	
	Display_ones: Digit_to_display
		PORT MAP(
			A(7 downto 4) => ones,
			A(3 downto 0) => y_to_display,
			SPO			  => ones_to_display
		);
	Display_tens: Digit_to_display
		PORT MAP(
			A(7 downto 4) => tens,
			A(3 downto 0) => y_to_display,
			SPO			  => tens_to_display
		);
	Display_hundreds: Digit_to_display
		PORT MAP(
			A(7 downto 4) => hundreds,
			A(3 downto 0) => y_to_display,
			SPO			  => hundreds_to_display
		);
	Display_thousands: Digit_to_display
		PORT MAP(
			A(7 downto 4) => thousands,
			A(3 downto 0) => y_to_display,
			SPO			  => thousands_to_display
		);
		
		
	
	display_digits: process(CLK, Reset)
	begin
		if Reset = '0' or Data = 0 then
			Draw <= '0';
			x_to_display <= 0;
		elsif rising_edge(CLK) then
			x_to_display <= to_integer(7 - unsigned(x(2 downto 0)));
			
			if x >= 32 then				
				if ones_to_display(x_to_display) = '1' then 
					Draw <= '1';
				else
					Draw <= '0';
				end if;
			elsif x >= 24 then
				if tens_to_display(x_to_display) = '1' then 
					Draw <= '1';
				else
					Draw <= '0';
				end if;
			elsif x >= 16 then
				if hundreds_to_display(x_to_display) = '1' then 
					Draw <= '1';
				else
					Draw <= '0';
				end if;
			elsif x >= 8 then
				if thousands_to_display(x_to_display) = '1' then 
					Draw <= '1';
				else
					Draw <= '0';
				end if;
			end if;
		end if;
	end process;
	
	
	
	y_disp_gen : process (CLK, Reset)
		variable y_tmp 		 : std_logic_vector(5 downto 0) := (others => '0');
	begin
			if Reset = '0' then
				y_tmp := (others => '0');
				y_to_display <= (others => '0');
			elsif rising_edge(CLK) then
				if y >= START_DRAW_Y and y <= START_DRAW_Y + 15 then
					y_tmp := y - START_DRAW_Y;
					y_to_display <= y_tmp(3 downto 0);
				else
					y_tmp := (others => '0');
					y_to_display <= (others => '1');
				end if;
			end if;
	end process;
end Behavioral;

