library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Std_Logic_Arith.all;


entity Natural_to_BCD is
	Port ( 
		data 	: in  STD_LOGIC_VECTOR (12 downto 0) := (others => '0');
		q 		: out STD_LOGIC_VECTOR (15 downto 0)
	);
end Natural_to_BCD;

architecture Behavioral of Natural_to_BCD is
begin
		q(4*1-1 downto 4*0) <= conv_std_logic_vector((conv_integer(data)/1) mod 10, 4);
		q(4*2-1 downto 4*1) <= conv_std_logic_vector((conv_integer(data)/10) mod 10, 4);
		q(4*3-1 downto 4*2) <= conv_std_logic_vector((conv_integer(data)/100) mod 10, 4);
		q(4*4-1 downto 4*3) <= conv_std_logic_vector((conv_integer(data)/1000) mod 10, 4);
end Behavioral;

