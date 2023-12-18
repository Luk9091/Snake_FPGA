library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Std_Logic_Arith.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Snake is
	GENERIC (
			COUNT_TO_TICK: integer := 100_000_000/(40*16);
			START_X : 		integer := 40/2;
			START_Y :		integer := 30/2;
			START_DIR:		std_logic_vector(1 downto 0) := "00";
			TRANSIT_BYTE:  integer := 2
	);
	Port ( 
		CLK 			: in   STD_LOGIC;
		Reset 		: in   STD_LOGIC;
		x 				: in   STD_LOGIC_VECTOR(6 downto 0);
		y 				: in   STD_LOGIC_VECTOR(5 downto 0);
		leftRight	: in   STD_LOGIC_VECTOR(1 downto 0);
		Part 			: out  STD_LOGIC_VECTOR(2 downto 0);
		push			: in   STD_LOGIC
	);
end Snake;

architecture Behavioral of Snake is
	subtype Direction_t is std_logic_vector(1 downto 0);
	constant UP 	: Direction_t := "00";
	constant DOWN	: Direction_t := "01";
	constant LEFT	: Direction_t := "10";
	constant RIGHT	: Direction_t := "11";
	
	signal x_head: std_logic_vector(6 downto 0) := conv_std_logic_vector(START_X, 7);
	signal y_head: std_logic_vector(5 downto 0) := conv_std_logic_vector(START_Y, 6);
	
	signal x_tail: std_logic_vector(6 downto 0) := conv_std_logic_vector(START_X, 7);
	signal y_tail: std_logic_vector(5 downto 0) := conv_std_logic_vector((START_Y+1), 6);
	
	signal head_draw:    std_logic := '0';
	signal segment_draw: std_logic := '0';
	signal tail_draw:    std_logic := '0';
	
	signal dir     : Direction_t := START_DIR;
	signal next_dir: Direction_t := START_DIR;
	signal tail_dir: Direction_t := START_DIR;
	signal transit_cnt: std_logic_vector(TRANSIT_BYTE-1 downto 0) := (others => '0');
	
	component Snake_segment_memory 
		PORT(
			ADDRA		: in  std_logic_vector(12 downto 0);
			ADDRB		: in  std_logic_vector(12 downto 0);
			WEA		: in  std_logic_vector(0 downto 0);
			WEB		: in  std_logic_vector(0 downto 0);
			CLKA		: in  std_logic;
			CLKB		: in  std_logic;
			DinA		: in  std_logic_vector(0 downto 0);
			DinB		: in  std_logic_vector(0 downto 0);
			DoutB		: out std_logic_vector(0 downto 0)
		);
	end component;
	
	signal write_address		: std_logic_vector(12 downto 0) := (others => '0');
	signal read_address		: std_logic_vector(12 downto 0) := (others => '0');
	signal write_en_segment : std_logic := '0';
	signal place_segment 	: std_logic := '0';
	
	
	component Head_tail_FIFO
		PORT(
			CLK 			: in  std_logic;
			RST 			: in  std_logic;
			DIN 			: in  std_logic_vector(1 downto 0);
			DOUT			: out std_logic_vector(1 downto 0);
			DATA_COUNT	: out std_logic_vector(9 downto 0);
			RD_EN			: in  std_logic;
			WR_EN			: in  std_logic
		);
	end component;
	
	signal snake_size: std_logic_vector(9 downto 0);
	signal push_snake: std_logic := '0';
	signal push_self : std_logic := '0';
	signal pop_snake : std_logic := '0';
	
	signal Tick : std_logic := '0';

	constant move_head : integer := 1;
	constant move_tail : integer := 2;

begin


	tick_counter: process(CLK, Reset)
		variable tick_cnt : integer := 0;
	begin
		if Reset = '0' then
			Tick <= '0';
			tick_cnt := 0;
		elsif rising_edge(CLK) then
			if tick_cnt < COUNT_TO_TICK then
				tick_cnt := tick_cnt + 1;
			else
				tick_cnt := 0;
				Tick <= not Tick;
			end if;
		end if;
	end process;

	transit: process (Tick, Reset)
	begin
		if Reset = '0' then
			transit_cnt <= (others => '0');
		elsif rising_edge(Tick) then
			transit_cnt <= transit_cnt + 1;
		end if;
	end process;
	
	pushing: process (Tick, Reset, push)
	begin
		if Reset = '0' then
			push_self <= '0';
		elsif push = '1' then
			push_self <= '1';
		elsif rising_edge(Tick) then
			if transit_cnt = move_tail then
				push_self <= '0';
			end if;
		end if;
	end process;


	head_move: process (Tick, Reset)
	begin
		if Reset = '0' then
			x_head <= conv_std_logic_vector(START_X, 7);
			y_head <= conv_std_logic_vector(START_Y, 6);
			dir <= START_DIR;

			x_tail <= conv_std_logic_vector(START_X, 7);
			y_tail <= conv_std_logic_vector((START_Y+1), 6);
			
			place_segment <= '0';
			write_en_segment <= '0';
			push_snake <= '0';
			pop_snake  <= '0';
		elsif falling_edge(Tick) then
			if transit_cnt = move_head then
				case next_dir is
					when UP    => if y_head >  "00000" then y_head <= y_head - 1; end if;
					when DOWN  => if y_head <  "11101" then y_head <= y_head + 1; end if;
					when LEFT  => if x_head > "000000" then x_head <= x_head - 1; end if;
					when RIGHT => if x_head < "100111" then x_head <= x_head + 1; end if;
					when others => NULL;
				end case;
				dir <= next_dir;
				write_en_segment <= '1';
				place_segment <= '1';
				write_address( 6 downto 0) <= x_head;
				write_address(12 downto 7) <= y_head;
				
				push_snake <= '1';
				pop_snake  <= '0';
			elsif transit_cnt = move_tail then
					push_snake <= '0';
					pop_snake <= '1';
			
					write_en_segment <= '1';
					place_segment <= '0';
					write_address( 6 downto 0) <= x_tail;
					write_address(12 downto 7) <= y_tail;
					
					if push_self = '0' then
					case tail_dir is
						when UP    => if y_tail >  "00000" then y_tail <= y_tail - 1; end if;
						when DOWN  => if y_tail <  "11101" then y_tail <= y_tail + 1; end if;
						when LEFT  => if x_tail > "000000" then x_tail <= x_tail - 1; end if;
						when RIGHT => if x_tail < "100111" then x_tail <= x_tail + 1; end if;
						when others => NULL;
					end case;
					end if;
			else
				push_snake <= '0';
				pop_snake  <= '0';
				write_en_segment <= '0';
			end if;
			
			
			
			
			--if x_head = "101000" then
			--	x_head <= (others => '0');
			--elsif x_head = "111111" then
			--	x_head <= "100111";
			--end if;
			
			--if y_head = "11110" then
			--	y_head <= (others => '0');
			--elsif y_head = "11111" then
			--	y_head <= "11101";
			--end if;
		end if;
	end process;
	
	
	change_dir: process (Tick, Reset)
	begin
		if Reset = '0' then
			next_dir <= UP;
		elsif falling_edge(Tick) then
			case dir is
				when UP => 
					case leftRight is
						when "10" 	=> next_dir <= RIGHT;
						when "01" 	=> next_dir <= LEFT;
						when others => NULL;
					end case;
				when DOWN => 
					case leftRight is
						when "10"   => next_dir <= LEFT;
						when "01"   => next_dir <= RIGHT;
						when "00" 	=> next_dir <= dir;
						when others => NULL;
					end case;
				when LEFT => 
					case leftRight is
						when "10"   => next_dir <= UP;
						when "01"   => next_dir <= DOWN;
						when "00" 	=> next_dir <= dir;
						when others => NULL;
					end case;
				when RIGHT => 
					case leftRight is
						when "10"   => next_dir <= DOWN;
						when "01"   => next_dir <= UP;
						when "00" 	=> next_dir <= dir;
						when others => NULL;
					end case;
				when others => next_dir <= next_dir;
			end case;
		end if;
	end process;
	
	
	head_tail_drawing : process (CLK, Reset)
	begin
		if Reset = '0' then
			head_draw <= '0';
		elsif rising_edge(CLK) then
			if x = x_head and y = y_head then
				head_draw <= '1';
--				case dir is
--					when UP =>
--						if sub_y >= not transit_cnt then
--							head_draw <= '1';
--						end if;
--					when DOWN =>
--						if sub_y <= transit_cnt then
--							head_draw <= '1';
--						end if;
--					when LEFT =>
--						if sub_x >= not transit_cnt then
--							head_draw <= '1';
--						end if;
--					when RIGHT =>
--						if transit_cnt >= sub_x then
--							head_draw <= '1';
--						end if;
--				end case;
			else
				head_draw <= '0';
			end if;
			
			if Reset <= '0' then
				tail_draw <= '0';
			elsif rising_edge(CLK) then
				if x = x_tail and y = y_tail then
					tail_draw <= '1';
				else
					tail_draw <= '0';
				end if;
			end if;
		end if;
	end process;
	
	read_segment: process(Clk, Reset)
		variable reset_memory: boolean := False;
	begin
		if rising_edge(Clk) then
			if Reset = '0' then
				if reset_memory = False then
					reset_memory := True;
					read_address <= (others => '0');
				else
					read_address <= read_address + 1;
				end if;
			else
				reset_memory := False;
				read_address(6) <= '0';
				read_address(12)<= '0';
				read_address( 5 downto 0) <= x(5 downto 0);
				read_address(11 downto 7) <= y(4 downto 0);
			end if;
		end if;
	end process;
	
	
	segment_memory : Snake_segment_memory 
		PORT MAP(
			ADDRA		=> write_address,
			ADDRB		=> read_address,
			WEA(0)	=> write_en_segment,
			WEB(0)	=> not Reset,
			CLKA 		=> clk,
			CLKB 		=> clk,
			DinA(0)	=> place_segment,
			DinB(0) 	=> '0',
			DoutB(0)	=> segment_draw
		);
		

	tail_moving: Head_tail_FIFO
		PORT MAP(
			CLK 			=> Tick,
			RST 			=> not Reset,
			DIN 			=> next_dir,
			DOUT			=> tail_dir,
			DATA_COUNT 	=> snake_size,
			WR_EN 		=> push_snake,
			RD_EN 		=>  pop_snake and not push_self
		);

	Part(0) <= head_draw;
	Part(1) <= segment_draw;
	Part(2) <= tail_draw;


end Behavioral;

