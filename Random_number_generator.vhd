library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Random_number_generator is
	Port (
		CLK : in   STD_LOGIC;
		Data: out  STD_LOGIC_VECTOR (12 downto 0)
	);
end Random_number_generator;

architecture Behavioral of Random_number_generator is
	signal Q: std_logic_vector(15 downto 0) := (others => '0');
begin

	generator: process(CLK)
	begin
		if rising_edge(CLK) then
			Q (15 downto 1) <= Q (14 downto 0);
			Q (0) <= not (Q(4) xor (Q(13) xor (Q(14) xor Q(15))));
		end if;
	end process;
	Data <= Q(12 downto 0);


end Behavioral;

