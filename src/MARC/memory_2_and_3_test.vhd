--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:38:41 04/26/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/My Dropbox/Studier/Digitalkonstruktion/Digital-konstruktion/src/MARC/memory_2_and_3_test.vhd
-- Project Name:  MARC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Memory_Cell
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

use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY memory_2_and_3_test IS
END memory_2_and_3_test;
 
ARCHITECTURE behavior OF memory_2_and_3_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Memory_Cell
    PORT(
         clk : IN  std_logic;
         read : IN  std_logic;
         write : IN  std_logic;
         address_in : IN  std_logic_vector(12 downto 0);
         address_out : OUT  std_logic_vector(12 downto 0);
         data_in : IN  std_logic_vector(12 downto 0);
         data_out : OUT  std_logic_vector(12 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal read : std_logic := '0';
   signal write : std_logic := '0';
   signal address_in : std_logic_vector(12 downto 0) := (others => '0');
   signal data_in : std_logic_vector(12 downto 0) := (others => '0');

 	--Outputs
   signal address_out : std_logic_vector(12 downto 0);
   signal data_out : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
   	signal fill_signal : std_logic_vector(12 downto 0) := "0000000000000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Memory_Cell PORT MAP (
          clk => clk,
          read => read,
          write => write,
          address_in => address_in,
          address_out => address_out,
          data_in => data_in,
          data_out => data_out
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

      -- insert stimulus here 

      wait;
   end process;

-- Requesting random GPU Addresses
   fill_process :process
   begin
     if write = '0' then
		  fill_signal <= fill_signal + 1;
	    write <='1';
	    read <='0';
	   data_in <= fill_signal;
		  address_in <= fill_signal;
	   else
	      fill_signal <= fill_signal;
	     write <='0';
	     read <='1';

	     end if;
	     		address_in <= fill_signal;
		--read <= '1';
		
		wait for clk_period;
  end process;


END;
