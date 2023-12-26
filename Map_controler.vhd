library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Map_controler is
		Port ( 
			CLK 		: in  STD_LOGIC;
			Reset 	: in  STD_LOGIC;
			x 			: in  STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
			sub_x 	: in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			y			: in  STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
			sub_y 	: in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			color 	: out STD_LOGIC_VECTOR (2 downto 0);
			leftRight: in  STD_LOGIC_VECTOR (1 downto 0) 	:= "11"
		);
end Map_controler;

architecture Behavioral of Map_controler is
	component Snake 
		Port ( 
			CLK 			: in   STD_LOGIC;
			Reset 		: in   STD_LOGIC;
			x 				: in   STD_LOGIC_VECTOR(6 downto 0);
			y 				: in   STD_LOGIC_VECTOR(5 downto 0);
			leftRight	: in   STD_LOGIC_VECTOR(1 downto 0);
			Part 			: out  STD_LOGIC_VECTOR(2 downto 0);
			push			: in   STD_LOGIC;
			max_size		: out  STD_LOGIC_VECTOR(12 downto 0)
		);
	end component;
	signal drawPart: std_logic_vector (2 downto 0);
	signal max_size: std_logic_vector(12 downto 0);
	
	
	component Apple_generator
		Port ( 
			CLK 		: in  STD_LOGIC;
			Reset 	: in  STD_LOGIC;
			canDraw	: in 	std_logic;
			x			: in 	STD_LOGIC_VECTOR (6 downto 0);
			y			: in 	STD_LOGIC_VECTOR (5 downto 0);
			apple 	: out STD_LOGIC;
			done		: out STD_LOGIC
		);
	end component;
	signal apple : std_logic;
	signal push: std_logic;
	
	
	
	component Print_Digit
		Port ( 
			CLK 	: in  STD_LOGIC;
			Reset : in  STD_LOGIC;
			x 		: in  STD_LOGIC_VECTOR ( 6 downto 0);
			y 		: in  STD_LOGIC_VECTOR ( 5 downto 0);
			Data 	: in  STD_LOGIC_VECTOR (12 downto 0);
			draw	: out STD_LOGIC
		);
	end component;
	signal score_draw: std_logic := '0';
	
begin
	eat_apple: process(CLK, Reset)
	begin
		if Reset = '0' then
			push <= '0';
		elsif rising_edge(CLK) then
			if apple = '1' and drawPart(0) = '1' then
				push <= '1';
			else
				push <= '0';
			end if;
		end if;
	end process;
	

	snake_segments: Snake 
		PORT MAP ( 
			CLK 			=> CLK,
			Reset 		=> Reset,
			x 				=> x,
			y 				=> y,
			leftRight	=> leftRight,
			Part 			=> drawPart,
			push 			=> push,
			max_size		=> max_size
		);

	apple_gen: Apple_generator
		PORT MAP(
			CLK 		=> CLK,
			Reset 	=> Reset and not push,
			canDraw 	=> not (drawPart(0) and drawPart(1) and drawPart(2)),
			x 			=> x,
			y 			=> y,
			apple 	=> apple
		);


	Score : Print_Digit
		PORT MAP (
			CLK 		=> CLK,
			Reset 	=> Reset,
			x 			=> x,
			y			=> y,
			Data 		=> max_size,
			Draw 		=> score_draw
		);



-- Color selector MUX:
	Color <= "000" when Reset       = '0' else
				"111" when score_draw  = '1' else
				"001" when drawPart(0) = '1' else
				"111" when drawPart(2) = '1' else
				"111" when drawPart(1) = '1' else
				"100" when apple       = '1' else
				"000";
end Behavioral;

