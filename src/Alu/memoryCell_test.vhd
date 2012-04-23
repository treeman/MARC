--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:46:07 04/23/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/Digital-konstruktion/src/Alu/memoryCell_test.vhd
-- Project Name:  Alu
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY memoryCell_test IS
END memoryCell_test;
 
ARCHITECTURE behavior OF memoryCell_test IS 
 
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
      --wait for 100 ns;	

      --wait for clk_period*10;

      -- insert stimulus here 
		
		
		
		wait for 10 ns;
		read <= '0';
		write <= '0';
		
		address_in <= "0000000000000";
		data_in <= "1111111111111";
		
		wait for 10 ns;
		write <= '1';

		wait for 10 ns;
		read <= '1';
		write <= '0';
		
    wait for 10 ns;
		
		read <= '1';
		write <= '0';
		
		wait for 10 ns;
		read <= '0';
		write <= '0';
		
		address_in <= "1111111111111";
		data_in <= "0000000000000";
		
		wait for 10 ns;
		write <= '1';

		wait for 10 ns;
		read <= '1';
		write <= '0';
		
    wait for 10 ns;
		
		read <= '1';
		write <= '0';
		
      wait;
   end process;

END;
