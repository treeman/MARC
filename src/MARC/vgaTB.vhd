--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:44:43 05/06/2012
-- Design Name:   
-- Module Name:   E:/vga_fpga/vgaTB.vhd
-- Project Name:  vga_fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: VGA
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY vgaTB IS
END vgaTB;
 
ARCHITECTURE behavior OF vgaTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT VGA
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         data_gpu : IN  std_logic_vector(7 downto 0);
         address_gpu : OUT  std_logic_vector(12 downto 0);
         red : OUT  std_logic_vector(2 downto 0);
         grn : OUT  std_logic_vector(2 downto 0);
         blu : OUT  std_logic_vector(1 downto 0);
         HS : OUT  std_logic;
         VS : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal data_gpu : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal address_gpu : std_logic_vector(12 downto 0);
   signal red : std_logic_vector(2 downto 0);
   signal grn : std_logic_vector(2 downto 0);
   signal blu : std_logic_vector(1 downto 0);
   signal HS : std_logic;
   signal VS : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: VGA PORT MAP (
          rst => rst,
          clk => clk,
          data_gpu => data_gpu,
          address_gpu => address_gpu,
          red => red,
          grn => grn,
          blu => blu,
          HS => HS,
          VS => VS
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	

      -- insert stimulus here 
		rst <= '1' after 10 ns, '0' after 20 ns;
		data_gpu <= "11111111" after 50 ns, "00000000" after 250 ns, "11111111" after 450 ns, "00000000" after 650 ns, "11111111" after 850 ns, "00000000" after 1050 ns, "11111111" after 1250 ns;

      wait;
   end process;

END;
