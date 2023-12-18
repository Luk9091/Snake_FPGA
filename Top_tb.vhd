LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Top_tb IS
END Top_tb;
 
ARCHITECTURE behavior OF Top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top
    PORT(
         CLK : IN  std_logic;
         Reset : IN  std_logic;
			SoftReset: IN		std_logic;
         LED : INOUT  std_logic_vector(7 downto 0);
			leftRight : in std_logic_vector(1 downto 0);
         H_sync : OUT  std_logic;
         V_sync : OUT  std_logic;
         RGB : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '1';
	signal SoftReset : std_logic := '1';
	signal leftRight : std_logic_vector(1 downto 0) := "11";
	
	--BiDirs
   signal LED : std_logic_vector(7 downto 0);

 	--Outputs
   signal H_sync : std_logic;
   signal V_sync : std_logic;
   signal RGB : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Top PORT MAP (
          CLK => CLK,
          Reset => Reset,
			 SoftReset => SoftReset,
			 leftRight => leftRight,
          LED => LED,
          H_sync => H_sync,
          V_sync => V_sync,
          RGB => RGB
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
		wait for CLK_period;
		Reset <= '1';

      wait;
   end process;

END;
