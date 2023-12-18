library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Apple_generator is
	Generic(
		Width : natural  := 40;
		Height: natural  := 30
	);
	Port ( 
		CLK 		: in  STD_LOGIC;
		Reset 	: in  STD_LOGIC;
		canDraw	: in 	std_logic;
		x			: in 	STD_LOGIC_VECTOR (6 downto 0);
		y			: in 	STD_LOGIC_VECTOR (5 downto 0);
		apple 	: out STD_LOGIC := '0';
		done		: out STD_LOGIC := '0'
	);
end Apple_generator;

architecture Behavioral of Apple_generator is
	component Random_number_generator
		PORT (
			CLK : in   STD_LOGIC;
			Data: out  STD_LOGIC_VECTOR (12 downto 0)
		);
	end component;
	
	signal RN: std_logic_vector(12 downto 0);
	signal x_i: std_logic_vector(6 downto 0) := (others => '1');
	signal y_i: std_logic_vector(5 downto 0) := (others => '1');
	signal done_i: std_logic := '0';
begin
	
	set_position: process(CLK, Reset)
	begin
		if Reset = '0' then
			done_i <= '0';
			x_i <= (others => '1');
			y_i <= (others => '1');
		elsif rising_edge(CLK) then
			if done_i = '0' then
				x_i <= RN(6 downto 0);
				y_i <= RN(12 downto 7);
				
				if (RN(6 downto 0) < WIDTH) and (RN(12 downto 7) < HEIGHT) then
					done_i <= '1';
				end if;
			end if;
		end if;
	end process;


	generate_apple: process (CLK, Reset)
	begin
		if Reset = '0' then
			done <= '0';
			apple <= '0';
		elsif rising_edge(CLK) then
			if done_i = '1' then
				if x_i = x and y_i = y then
					if canDraw = '1' then
						done <= '1';
						apple <= '1';
					else
						done <= '0';
					end if;
				else
					apple <= '0';
				end if;
				
			end if;
		end if;
	end process;
	
	RNG: Random_number_generator
		PORT MAP(
			CLK => CLK,
			Data => RN
		);

end Behavioral;

