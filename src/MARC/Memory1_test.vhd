--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:55:27 04/26/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/My Dropbox/Studier/Digitalkonstruktion/Digital-konstruktion/src/MARC/Memory1_test.vhd
-- Project Name:  MARC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Memory_Cell_DualPort
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY Memory1_test IS
END Memory1_test;
 
ARCHITECTURE behavior OF Memory1_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Memory_Cell_DualPort
    PORT(
         clk : IN  std_logic;
         read : IN  std_logic;
         write : IN  std_logic;
         active_player : IN  std_logic_vector(1 downto 0);
         address_in : IN  std_logic_vector(12 downto 0);
         address_out : OUT  std_logic_vector(12 downto 0);
         data_in : IN  std_logic_vector(7 downto 0);
         data_out : OUT  std_logic_vector(7 downto 0);
         address_gpu : IN  std_logic_vector(12 downto 0);
         data_gpu : OUT  std_logic_vector(7 downto 0);
         read_gpu : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal read : std_logic := '0';
   signal write : std_logic := '0';
   signal active_player : std_logic_vector(1 downto 0) := "01";
   signal address_in : std_logic_vector(12 downto 0) := (others => '0');
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal address_gpu : std_logic_vector(12 downto 0) := (others => '0');
   signal read_gpu : std_logic := '0';

 	--Outputs
   signal address_out : std_logic_vector(12 downto 0);
   signal data_out : std_logic_vector(7 downto 0);
   signal data_gpu : std_logic_vector(7 downto 0);
	
	signal sync_gpu : std_logic_vector(12 downto 0) := "0000000000000";
	
	signal fill_signal : std_logic_vector(12 downto 0) := "0000000000000";

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Memory_Cell_DualPort PORT MAP (
          clk => clk,
          read => read,
          write => write,
          active_player => active_player,
          address_in => address_in,
          address_out => address_out,
          data_in => data_in,
          data_out => data_out,
          address_gpu => address_gpu,
          data_gpu => data_gpu,
          read_gpu => read_gpu
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
		  
		  
		
		  
      wait;
   end process;
	
	-- Requesting random GPU Addresses
   gpu_process :process
   begin
		sync_gpu <= sync_gpu + 1;
		wait for clk_period*4;
		active_player <= not active_player;
		address_gpu <= sync_gpu;
		  read_gpu <= '1';
   end process;
   
   -- Requesting random GPU Addresses
   fill_process :process
   begin
		fill_signal <= fill_signal + 1;
	write <='1';
		--read <= '1';
		data_in <= fill_signal(7 downto 0);
		address_in <= fill_signal;
		wait for clk_period;
  end process;

END;
