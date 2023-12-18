library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
--use UNISIM.VComponents.all;


entity Top is 
	port (
		CLK 		: in		std_logic;
		Reset		: in		std_logic;
		SoftReset: in		std_logic;
		LED 		: inout 	std_logic_vector (7 downto 0) := "00000001";
		H_sync	: out 	std_logic;
		V_sync	: out 	std_logic;
		RGB		: out   	std_logic_vector(2 downto 0) := "000";
		leftRight: in		std_logic_vector(1 downto 0)
	);
end Top;

architecture Behavioral of Top is
	signal device_clk: std_logic := '0';
	signal VGA_CLK   : std_logic := '0';
	
	signal clk_cnt: std_logic_vector(26 downto 0);
	signal vga_cnt: std_logic_vector( 1 downto 0);
	
	signal Color  : std_logic_vector(2 downto 0) := "000";
	
	constant COUNT_TO		 : integer := 100_000_000/2/8;
	constant VGA_COUNT_TO:  integer := 1;
--	constant COUNT_TO: integer := 10;

	signal x : std_logic_vector (9 downto 0);
	signal y : std_logic_vector (8 downto 0);

	component VGA 
		PORT(
			CLK    : IN   std_logic;
         Reset  : IN   std_logic;
         V_sync : OUT  std_logic;
         H_sync : OUT  std_logic;
         RGB    : OUT  std_logic_vector(2 downto 0);
			Color  : IN   std_logic_vector(2 downto 0);
			x 		 : OUT  STD_LOGIC_VECTOR(9 downto 0);
			y		 : OUT  STD_LOGIC_VECTOR(8 downto 0)
        );
	end component;
	
	
	component Map_controler
		Port ( 
			CLK 	: in  STD_LOGIC;
			Reset : in  STD_LOGIC;
			x 		: in  STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
			sub_x : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			y		: in  STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
			sub_y : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			color : out  STD_LOGIC_VECTOR(2 downto 0);
			leftRight: in STD_LOGIC_VECTOR(1 downto 0)
		);
	end component;
begin
	CLOCK_devider: process (CLK, Reset)
	begin
		if Reset = '0' then
			clk_cnt  <= (others => '0');
			vga_cnt  <= (others => '0');
		elsif rising_edge(CLK) then
			if clk_cnt < COUNT_TO then
				clk_cnt <= clk_cnt + 1;
			else
				device_clk <= not device_clk;
				clk_cnt <= (others => '0');
			end if;
			
			if vga_cnt < VGA_COUNT_TO then
				vga_cnt <= vga_cnt + 1;
			else
				vga_cnt <= (others => '0');
				VGA_CLK <= not VGA_CLK;
			end if;
		end if;
	end process;

	LED_BLINK: process (device_clk, Reset)
	begin
		if Reset = '0' then
			LED <= "00000001";
		elsif rising_edge(device_clk) then
			LED(7 downto 1) <= LED(6 downto 0);
			if LED = "10000000" then
				LED(0) <= '1';
			else
				LED(0) <= '0';
			end if;
			
		end if;
	end process;
	
	vga_port: VGA PORT MAP (
		CLK => VGA_CLK,
		Reset => Reset,
		RGB => RGB,
		Color => Color,
		H_sync => H_sync,
		V_sync => V_sync,
		x => x,
		y => y
	);
	
	drawing: Map_controler PORT MAP (
		CLK 	=> CLK,
		Reset => SoftReset and Reset,
		x 		=> x(9 downto 4) + "0000000",
		sub_x => x(3 downto 0),
		y 		=> y(8 downto 4) +  "000000",
		sub_y => y(3 downto 0),
		Color => Color,
		leftRight => leftRight
	);

end Behavioral;

