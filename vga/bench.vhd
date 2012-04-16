--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   13:53:36 04/16/2012
-- Design Name:
-- Module Name:   E:/vhdl/vga/bench.vhd
-- Project Name:  vga
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY bench IS
END bench;

ARCHITECTURE behavior OF bench IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT VGA
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         hsync : OUT  std_logic;
         vsync : OUT  std_logic;
         red : OUT  std_logic;
         green : OUT  std_logic;
         blue : OUT  std_logic;
         row : OUT  std_logic_vector(9 downto 0);
         column : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;


   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';

    --Outputs
   signal hsync : std_logic;
   signal vsync : std_logic;
   signal red : std_logic;
   signal green : std_logic;
   signal blue : std_logic;
   signal row : std_logic_vector(9 downto 0);
   signal column : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 1us;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: VGA PORT MAP (
          clk => clk,
          reset => reset,
          hsync => hsync,
          vsync => vsync,
          red => red,
          green => green,
          blue => blue,
          row => row,
          column => column
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
      wait for 100ns;

      reset <= '1', '0' after 1 us;

      -- insert stimulus here

      wait;
   end process;

END;

