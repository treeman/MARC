--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:20:49 04/21/2012
-- Design Name:   
-- Module Name:   /edu/liji050/vga_controller_800x600/TBench_800x600_vga_controller.vhd
-- Project Name:  vga_controller_800x600
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TBench_800x600_vga_controller IS
END TBench_800x600_vga_controller;
 
ARCHITECTURE behavior OF TBench_800x600_vga_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vga_controller
    PORT(
         colorpix : IN  std_logic_vector(7 downto 0);
         rst : IN  std_logic;
         vhdl_clk : IN  std_logic;
         HS : OUT  std_logic;
         VS : OUT  std_logic;
         hcount : OUT  std_logic;
         vcount : OUT  std_logic;
         blank : OUT  std_logic;
         red : OUT  std_logic_vector(2 downto 0);
         grn : OUT  std_logic_vector(2 downto 0);
         blu : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal colorpix : std_logic_vector(7 downto 0) := (others => '0');
   signal rst : std_logic := '0';
   signal vhdl_clk : std_logic := '0';

 	--Outputs
   signal HS : std_logic;
   signal VS : std_logic;
   signal hcount : std_logic;
   signal vcount : std_logic;
   signal blank : std_logic;
   signal red : std_logic_vector(2 downto 0);
   signal grn : std_logic_vector(2 downto 0);
   signal blu : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant vhdl_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vga_controller PORT MAP (
          colorpix => colorpix,
          rst => rst,
          vhdl_clk => vhdl_clk,
          HS => HS,
          VS => VS,
          hcount => hcount,
          vcount => vcount,
          blank => blank,
          red => red,
          grn => grn,
          blu => blu
        );

   -- Clock process definitions
   vhdl_clk_process :process
   begin
		vhdl_clk <= '0';
		wait for vhdl_clk_period/2;
		vhdl_clk <= '1';
		wait for vhdl_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for vhdl_clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
