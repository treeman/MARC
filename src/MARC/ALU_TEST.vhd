--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:41:33 04/26/2012
-- Design Name:   
-- Module Name:   C:/Users/J3X/Documents/Digital-konstruktion/src/MARC/ALU_TEST.vhd
-- Project Name:  MARC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALU_TEST IS
END ALU_TEST;
 
ARCHITECTURE behavior OF ALU_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         clk : IN  std_logic;
         alu_operation : IN  std_logic_vector(1 downto 0);
         alu1_zeroFlag : OUT  std_logic;
         alu1_operand : IN  std_logic_vector(12 downto 0);
         alu2_operand : IN  std_logic_vector(12 downto 0);
         alu1_out : OUT  std_logic_vector(12 downto 0);
         alu2_out : OUT  std_logic_vector(12 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal alu_operation : std_logic_vector(1 downto 0) := (others => '0');
   signal alu1_operand : std_logic_vector(12 downto 0) := (others => '0');
   signal alu2_operand : std_logic_vector(12 downto 0) := (others => '0');

 	--Outputs
   signal alu1_zeroFlag : std_logic;
   signal alu1_out : std_logic_vector(12 downto 0);
   signal alu2_out : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          clk => clk,
          alu_operation => alu_operation,
          alu1_zeroFlag => alu1_zeroFlag,
          alu1_operand => alu1_operand,
          alu2_operand => alu2_operand,
          alu1_out => alu1_out,
          alu2_out => alu2_out
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
      
      alu1_operand <= "0000000000010";   -- 2
      alu_operation <= "01";
      
      wait for 10 ns;
      
      alu1_operand <= "1111111111110";    -- -2
      alu_operation <= "10";
      
      -- This will be 2 + -2 = 0
      wait for 10 ns;
      
      alu1_operand <= "0000000000100";   -- 4
      alu_operation <= "01";
      
      wait for 10 ns;
      
      alu1_operand <= "1111111111100";    -- -4
      alu_operation <= "11";
      
      -- This will be 4 + -4 = 8
      
      --wait for 10 ns;
      
      --alu1_operand <= "0000000000001";
      --alu_operation <= "11";
      
      

      -- insert stimulus here 

      wait;
   end process;

END;
