--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:20:39 04/30/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/My Dropbox/Studier/Digitalkonstruktion/Digital-konstruktion/src/MARC/fbart_controller_test.vhd
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
 
ENTITY fbart_controller_test IS
END fbart_controller_test;
 
ARCHITECTURE behavior OF fbart_controller_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FBART_Controller
    PORT(
         request_next_data : IN  std_logic;
         reset : IN  std_logic;
         clk : IN  std_logic;
         rxd : IN  std_logic;
         control_signals : OUT  std_logic_vector(2 downto 0);
         buss_out : OUT  std_logic_vector(12 downto 0);
         has_next_data : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal request_next_data : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal rxd : std_logic := '0';

 	--Outputs
   signal control_signals : std_logic_vector(2 downto 0);
   signal buss_out : std_logic_vector(12 downto 0);
   signal has_next_data : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FBART_Controller PORT MAP (
          request_next_data => request_next_data,
          reset => reset,
          clk => clk,
          rxd => rxd,
          control_signals => control_signals,
          buss_out => buss_out,
          has_next_data => has_next_data
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
		reset <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		reset <= '0';
		
		
		
		 rxd <= '1',
            '0' after 10 us,        -- Start bit
             '1' after 26 us,
             '1' after 42 us,
             '0' after 58 us,
             '0' after 74 us,
             '0' after 90 us,
             '0' after 106 us,
             '1' after 122 us,
             '1' after 138 us,
             '1' after 154 us,  -- Stop bit
             '0' after 210 us,  -- Start bit
             '1' after 226 us,
             '0' after 242 us,
             '0' after 258 us,
             '1' after 274 us,
             '0' after 290 us,
             '1' after 306 us,
             '1' after 322 us,
             '0' after 338 us,
             '1' after 354 us,  -- Stop bit
             '0' after 420 us,  -- Start bit
             '1' after 436 us,
             '1' after 452 us,
             '0' after 468 us,
             '0' after 484 us,
             '1' after 500 us,
             '1' after 516 us,
             '0' after 532 us,
             '0' after 548 us,
             '1' after 564 us;  -- Stop bit

    request_next_data <= '0',
            '1' after 250 ns,
            '0' after 260 ns,
            '1' after 13200 ns;
		
		
		
      -- insert stimulus here 

      wait;
   end process;

END;
