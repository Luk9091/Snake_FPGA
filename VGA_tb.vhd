LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY VGA_tb IS
END VGA_tb;
 
ARCHITECTURE behavior OF VGA_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT VGA
    PORT(
			CLK 	 : IN     std_logic;
         Reset  : IN     std_logic;
         V_sync : INOUT  std_logic;
         H_sync : INOUT  std_logic;
         RGB 	 : OUT    std_logic_vector(2 downto 0);
			Color	 : IN     std_logic_vector(2 downto 0);
			x		 : OUT    std_logic_vector(9 downto 0);
			y		 : OUT    std_logic_vector(8 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '0';
	signal Color : std_logic_vector(2 downto 0) := "000";

	--BiDirs
   signal V_sync : std_logic;
   signal H_sync : std_logic;

 	--Outputs
   signal RGB : std_logic_vector(2 downto 0);
	signal x	  : std_logic_vector(9 downto 0);
	signal y	  : std_logic_vector(8 downto 0);


   -- Clock period definitions
   constant CLK_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: VGA PORT MAP (
			 CLK => CLK,
          Reset => Reset,
          V_sync => V_sync,
          H_sync => H_sync,
          RGB => RGB,
			 Color => Color,
			 x => x,
			 y => y
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
      -- hold reset state for 100 ns.
		Reset <= '1';
      wait for CLK_period;

      -- insert stimulus here 

      wait;
   end process;

END;
