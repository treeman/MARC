--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:29:56 05/01/2012
-- Design Name:   
-- Module Name:   E:/vga_fpga/labtb.vhd
-- Project Name:  vga_fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lab
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
 
ENTITY labtb IS
END labtb;
 
ARCHITECTURE behavior OF labtb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lab
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         colorpix : IN  std_logic_vector(7 downto 0);
         red : OUT  std_logic_vector(2 downto 0);
         grn : OUT  std_logic_vector(2 downto 0);
         blu : OUT  std_logic_vector(1 downto 0);
         HS : OUT  std_logic;
         VS : OUT  std_logic;
         hcount : OUT  std_logic_vector(10 downto 0);
         vcount : OUT  std_logic_vector(10 downto 0);
			blank : out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal colorpix : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal red : std_logic_vector(2 downto 0);
   signal grn : std_logic_vector(2 downto 0);
   signal blu : std_logic_vector(1 downto 0);
   signal HS : std_logic;
   signal VS : std_logic;
   signal hcount : std_logic_vector(10 downto 0);
   signal vcount : std_logic_vector(10 downto 0);
	signal blank : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns; -- 100 MHz default clock
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lab PORT MAP (
          rst => rst,
          clk => clk,
          colorpix => colorpix,
          red => red,
          grn => grn,
          blu => blu,
          HS => HS,
          VS => VS,
          hcount => hcount,
          vcount => vcount,
			 blank => blank
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
      wait for 100 ns;	

      -- insert stimulus here 
		rst <= '1' after 10 ns, '0' after 50 ns;
		colorpix <= "11111111" after 10 ns, "00000000" after 50 ns, "11111111" after 90 ns;
		wait;
   end process;



END;
