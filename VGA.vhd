library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity VGA is
   generic ( 
			H_SIZE: integer := 640;
			V_SIZE: integer := 480
    ); port (   
			CLK    : in    STD_LOGIC;
			Reset  : in    STD_LOGIC;
			
			V_sync : out   STD_LOGIC := '0';
			H_sync : out   STD_LOGIC := '0';
			RGB    : out   STD_LOGIC_VECTOR(2 downto 0) := "000";
			Color  : in 	STD_LOGIC_VECTOR(2 downto 0) := "000";
			
			x		 : out	STD_LOGIC_VECTOR(9 downto 0);
			y		 : out	STD_LOGIC_VECTOR(8 downto 0)
	);
end VGA;

architecture Behavioral of VGA is
--	type COLOR_SEL is (
--		BLACK   = "000",
--		RED     = "100",
--		GREEN   = "010",
--		BLUE    = "001",
--		YELLOW  = "110",
--		MAGENTA = "101",
--		CYAN	  = "011",
--		WHITE   = "111"
--	);

	-- Right + Left border on display
	constant H_R_BORDER:   integer := 16;
	constant H_L_BORDER:   integer := 48;
	constant H_BORDER:     integer := H_R_BORDER + H_L_BORDER;
	constant H_RETREACE:   integer := 96;
	
	constant V_T_BORDER:   integer := 10;
	constant V_B_BORDER:   integer := 33;
	constant V_BORDER:     integer := V_T_BORDER + V_B_BORDER;
	constant V_RETREACE: integer := 2;


	constant H_PERIOD:   integer := H_BORDER + H_RETREACE + H_SIZE; -- = 16 + 48 + 96 + 640 = 800	
	constant V_PERIOD:   integer := V_BORDER + V_RETREACE + V_SIZE; -- = 10 + 33 +  2 + 480 = 525
	
	signal 	H_iner_sync: std_logic := '1';
	signal 	V_iner_sync: std_logic := '1';

	signal h_cnt: std_logic_vector(9 downto 0) := (others => '0');
	signal v_cnt: std_logic_vector(9 downto 0) := (others => '0');
	
	signal x_cnt: std_logic_vector(9 downto 0) := (others => '0');
	signal y_cnt: std_logic_vector(8 downto 0) := (others => '0');
	
	constant h_offset: std_logic_vector(3 downto 0):= "1110";
	constant v_offset: std_logic_vector(3 downto 0):= "1010";
	
	constant background: STD_LOGIC_VECTOR(2 downto 0) := "010";
	constant white: std_logic_vector(2 downto 0) := "111";
begin
-- Synchronizacja pozioma --
	h_sync_cnt: process(CLK, Reset)
	begin
		if Reset = '0' then
			h_cnt <= (others => '0');
		elsif rising_edge(CLK) then
			if h_cnt < H_PERIOD then
				h_cnt <= h_cnt + 1;
				if h_cnt > H_L_BORDER - 2 and x_cnt <= H_SIZE then
					x_cnt <= x_cnt + 1;
				end if;
			else
				h_cnt <= (others => '0');
				x_cnt <= (others => '0');
			end if;
		end if;
	end process;
	x <= x_cnt;
	
	h_sync_sig: process(CLK, Reset)
	begin
		if Reset = '0' then
			H_sync <= '0';
		elsif rising_edge(CLK) then
			if h_cnt < (H_SIZE + H_BORDER)then
				H_iner_sync <= '1';
				H_sync <= '1';
			else
				H_iner_sync <= '0';
				H_sync <= '0';
			end if;
		end if;
	end process;
	
	
-- Synchronizacja pionowa |	
	v_sync_cnt: process(H_iner_sync, Reset)
	begin
		if Reset = '0' then
			v_cnt <= (others => '0');
		elsif rising_edge(H_iner_sync) then
			if v_cnt < V_PERIOD then
				v_cnt <= v_cnt + 1;
				if v_cnt > V_B_BORDER and y_cnt <= V_SIZE then
					y_cnt <= y_cnt + 1;
				end if;
			else
				v_cnt <= (others => '0');
				y_cnt <= (others => '0');
			end if;
		end if;
	end process;
	y <= y_cnt;
	
	v_sync_sig: process(H_iner_sync, Reset)
	begin
		if Reset = '0' then
			V_sync <= '0';
		elsif rising_edge(H_iner_sync) then
			if v_cnt < (V_SIZE + V_BORDER) then
				V_iner_sync <= '1';
				V_sync <= '1';
			else
				V_iner_sync <= '0';
				V_sync <= '0';
			end if;
		end if;
	end process;
	
-- Nie wyswietlaj jesli sygnal jest blank
	display_enable: process(CLK, Reset)
	begin
		if Reset = '0' then
			RGB <= (others => '0');
		elsif rising_edge(CLK) then
			if H_iner_sync = '0' or V_iner_sync = '0'then
				RGB <= (others => '0');
			elsif x_cnt(3 downto 0) = "0000" or y_cnt(3 downto 0) = "0000" then
				RGB <= white;
			else
				case Color is
					when "000" => RGB <= background;
					when others=> RGB <= Color;
				end case;
			end if;
		end if;
	end process;

end Behavioral;

