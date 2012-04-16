--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:58:31 04/16/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/Digital-konstruktion/ALU-mem/memory_cell/memory_cell_test.vhd
-- Project Name:  memory_cell
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
 
ENTITY memory_cell_test IS
END memory_cell_test;
 
ARCHITECTURE behavior OF memory_cell_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Memory_Cell
    PORT(
         clk : IN  std_logic;
         read : in STD_LOGIC;
         write : IN  std_logic;
         address : IN  std_logic_vector(12 downto 0);
         data : INOUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal write : std_logic := '0';
   signal read : std_logic := '1';
   signal address : std_logic_vector(12 downto 0) := (others => '0');

	--BiDirs
   signal data : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Memory_Cell PORT MAP (
          clk => clk,
          read => read,
          write => write,
          address => address,
          data => data
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
		address <= "0000000000000";
		data <= "1111111111111111";
		write <= '1';
		read <= '0';
		
		wait for 10 ns;
		address <= "0000000000001";
		data <= "1111111111110001";
		write <= '0';
		read <= '1';
      wait;
   end process;

END;
