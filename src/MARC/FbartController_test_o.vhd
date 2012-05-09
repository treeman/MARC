--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:39:37 05/08/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/My Dropbox/Studier/Digital-konstruktion/src/MARC/FbartController_test.vhd
-- Project Name:  MARC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FBARTController
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
 
ENTITY FbartController_test IS
END FbartController_test;
 
ARCHITECTURE behavior OF FbartController_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FBARTController
    PORT(
         request_next_data : IN  std_logic;
         reset : IN  std_logic;
         clk : IN  std_logic;
         rxd : IN  std_logic;
         control_signals : OUT  std_logic_vector(2 downto 0);
         buss_out : OUT  std_logic_vector(12 downto 0);
         has_next_data : OUT  std_logic;
         padding_error_out : OUT  std_logic_vector(2 downto 0)
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
   signal padding_error_out : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	--                                     <----- READ Only the DATA this WAY!
	--signal data : std_logic_vector(0 to 19) := "1 0110 0011 0 1 0111 1110 0"; -- "1 110001101 0 1 01111110 0";
	-- signal data : std_logic_vector(0 to 19) := "1 0110 0010 0 1 0111 1110 0";
	signal data : std_logic_vector(0 to 18) := "1011000100111111000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FBARTController PORT MAP (
          request_next_data => request_next_data,
          reset => reset,
          clk => clk,
          rxd => rxd,
          control_signals => control_signals,
          buss_out => buss_out,
          has_next_data => has_next_data,
          padding_error_out => padding_error_out
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

      wait for clk_period*10;
      
      reset <= '1';
      
      wait for 0.1 us;
      
      reset <= '0';
      request_next_data <= '1';
      
      wait for 10 ns;
      request_next_data <= '0';
      
      wait for 1 us;
		
      -- insert stimulus here 

      wait;
   end process;
   
   --read_data: process
   --begin
    -- if (has_next_data = '1') then
     --  wait for 40 ns;
     --  request_next_data <= '1';
     --  wait for 10 ns;
     --  request_next_data <= '0';
       
    -- end if;
   --end process;
   
   Fbart_data: process
   begin
     wait for 11.2 us;
     for i in 0 to 18 loop
			rxd <= data(i);
			wait for 8.86 us;
		end loop;
		wait;
	end process;

END;
