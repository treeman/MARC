--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:27:19 04/21/2012
-- Design Name:   
-- Module Name:   C:/Users/Ingram/Documents/TSEA43/gpu/tsb.vhd
-- Project Name:  gpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vga_controller
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tsb IS
END tsb;
 
ARCHITECTURE behavior OF tsb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vga_controller
    PORT(
         colorpix : IN  std_logic_vector(7 downto 0);
         rst : IN  std_logic;
         pixel_clk : IN  std_logic;
         HS : OUT  std_logic;
         VS : OUT  std_logic;
         red : OUT  std_logic_vector(2 downto 0);
         grn : OUT  std_logic_vector(2 downto 0);
         blu : OUT  std_logic_vector(1 downto 0);
         row : OUT  std_logic_vector(9 downto 0);
         column : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal colorpix : std_logic_vector(7 downto 0) := (others => '0');
   signal rst : std_logic := '0';
   signal pixel_clk : std_logic := '0';

 	--Outputs
   signal HS : std_logic;
   signal VS : std_logic;
   signal red : std_logic_vector(2 downto 0);
   signal grn : std_logic_vector(2 downto 0);
   signal blu : std_logic_vector(1 downto 0);
   signal row : std_logic_vector(9 downto 0);
   signal column : std_logic_vector(9 downto 0);

   -- Clock period definitions (25 MHz)
   constant pixel_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vga_controller PORT MAP (
          colorpix => colorpix,
          rst => rst,
          pixel_clk => pixel_clk,
          HS => HS,
          VS => VS,
          red => red,
          grn => grn,
          blu => blu,
          row => row,
          column => column
        );

   -- Clock process definitions
   pixel_clk_process :process
   begin
		pixel_clk <= '0';
		wait for pixel_clk_period/2;
		pixel_clk <= '1';
		wait for pixel_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ns.
      wait for 100 ns;

      -- insert stimulus here 
		rst <= '1' after 10 ns, '0' after 20 ns;
		colorpix <= "10101010" after 10 ns, "01010101" after 8000 ns;
      wait;
   end process;

END;
