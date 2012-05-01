--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:25:25 05/01/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/My Dropbox/Studier/Digitalkonstruktion/Digital-konstruktion/src/MARC/fbart_controller_Implimentation_test.vhd
-- Project Name:  MARC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FBART_Controller
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
 
ENTITY fbart_controller_Implimentation_test IS
END fbart_controller_Implimentation_test;
 
ARCHITECTURE behavior OF fbart_controller_Implimentation_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FBART_Controller
    PORT(
         request_next_data_a : IN  std_logic;
         reset_a : IN  std_logic;
         clk : IN  std_logic;
         rxd : IN  std_logic;
         control_signals : OUT  std_logic_vector(2 downto 0);
         buss_out : OUT  std_logic_vector(12 downto 0);
         out_switch : IN  std_logic;
         out_display : OUT  std_logic_vector(7 downto 0);
         has_next_data : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal request_next_data_a : std_logic := '0';
   signal reset_a : std_logic := '0';
   signal clk : std_logic := '0';
   signal rxd : std_logic := '0';
   signal out_switch : std_logic := '0';

 	--Outputs
   signal control_signals : std_logic_vector(2 downto 0);
   signal buss_out : std_logic_vector(12 downto 0);
   signal out_display : std_logic_vector(7 downto 0);
   signal has_next_data : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FBART_Controller PORT MAP (
          request_next_data_a => request_next_data_a,
          reset_a => reset_a,
          clk => clk,
          rxd => rxd,
          control_signals => control_signals,
          buss_out => buss_out,
          out_switch => out_switch,
          out_display => out_display,
          has_next_data => has_next_data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
		
		rxd <= not rxd;
		
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	
      
      reset_a <= '1';
      
      wait for 20 ns;
      
      reset_a <= '0';
      
      wait for 50 ns;
      
      request_next_data_a <= '1';
      
      wait for 30 ns;
      
      request_next_data_a <= '0';
      
      wait for 3000 ns;
      
      request_next_data_a <= '1';
      
      wait for 30 ns;
      
      request_next_data_a <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
