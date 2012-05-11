--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:55:11 05/04/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/My Dropbox/Studier/Digital-konstruktion/src/MARC/PlayerFIFO_test.vhd
-- Project Name:  MARC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PlayerFIFO
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
 
ENTITY PlayerFIFO_test IS
END PlayerFIFO_test;
 
ARCHITECTURE behavior OF PlayerFIFO_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PlayerFIFO
    PORT(
         current_pc_in : IN  std_logic_vector(12 downto 0);
         current_pc_out : OUT  std_logic_vector(12 downto 0);
         current_player_out : OUT  std_logic;
         game_over_out : OUT  std_logic;
         next_pc : IN  std_logic;
         write_pc : IN  std_logic;
         change_player : IN  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal current_pc_in : std_logic_vector(12 downto 0) := (others => '0');
   signal next_pc : std_logic := '0';
   signal write_pc : std_logic := '0';
   signal change_player : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

    --Outputs
   signal current_pc_out : std_logic_vector(12 downto 0);
   signal current_player_out : std_logic;
   signal game_over_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: PlayerFIFO PORT MAP (
          current_pc_in => current_pc_in,
          current_pc_out => current_pc_out,
          current_player_out => current_player_out,
          game_over_out => game_over_out,
          next_pc => next_pc,
          write_pc => write_pc,
          change_player => change_player,
          clk => clk,
          reset => reset
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
      wait for clk_period ; 
      
      current_pc_in <= "0000000000001";
      write_pc <= '1';
      --change_player <= '1';
      
      wait for clk_period;
      current_pc_in <= "0000000000010";
      write_pc <= '1';
      --change_player <= '1';
      
      wait for clk_period;
      current_pc_in <= "0000000000011";
      write_pc <= '1';
      --change_player <= '1';
      
      wait for clk_period;
      current_pc_in <= "0000000000100";
      write_pc <= '1';
     -- change_player <= '1';
      
      wait for clk_period ; 
      
      current_pc_in <= "0000000000101";
      write_pc <= '1';
    --  change_player <= '1';
      
      wait for clk_period;
      current_pc_in <= "0000000000110";
      write_pc <= '1';
    --  change_player <= '1';
      
      wait for clk_period;
      current_pc_in <= "0000000000111";
      write_pc <= '1';
    --  change_player <= '1';
      
      wait for clk_period;
      current_pc_in <= "0000000001000";
      write_pc <= '1';
    --  change_player <= '1';
      
      wait for clk_period;
      write_pc <= '0';
     -- change_player <= '0';
      
      wait for clk_period;
      next_pc <= '1';
     -- change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
    --  change_player <= '0';
      
      wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
      wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
       wait for clk_period;
      next_pc <= '1';
      change_player <= '1';
      
      wait for clk_period;
      next_pc <= '0';
      change_player <= '0';
      
      --wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
