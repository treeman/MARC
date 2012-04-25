--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   15:08:17 04/23/2012
-- Design Name:
-- Module Name:   C:/Users/J3X/Documents/Digital-konstruktion/src/Alu/MARC-test.vhd
-- Project Name:  Alu
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: MARC
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

ENTITY MARC_test IS
END MARC_test;

ARCHITECTURE behavior OF MARC_test IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT MARC
    PORT(
         clk : IN  std_logic;
         tmp_gpu_adr : IN  std_logic_vector(12 downto 0);
         tmp_gpu_data : OUT  std_logic_vector(7 downto 0);
         buss_controll : IN  std_logic_vector(2 downto 0);
         tmp_buss : IN  std_logic_vector(12 downto 0);
         memory1_source_address : IN  std_logic_vector(1 downto 0);
         memory2_source_address : IN  std_logic_vector(1 downto 0);
         memory3_source_address : IN  std_logic_vector(1 downto 0);
         memory1_source_data : IN  std_logic_vector(1 downto 0);
         memory2_source_data : IN  std_logic_vector(1 downto 0);
         memory3_source_data : IN  std_logic_vector(1 downto 0);

         memory1_read   : in STD_LOGIC;
                memory2_read    : in STD_LOGIC;
                memory3_read    : in STD_LOGIC;

                memory1_write   : in STD_LOGIC;
                memory2_write   : in STD_LOGIC;
                memory3_write   : in STD_LOGIC;

         alu_operation : IN  std_logic_vector(1 downto 0);
         alu1_source : IN  std_logic_vector(1 downto 0);
         alu2_source : IN  std_logic_vector(1 downto 0);
         active_player : IN  std_logic_vector(1 downto 0);
         alu_buss_controll : IN  std_logic_vector(2 downto 0)
        );
    END COMPONENT;


   --Inputs
   signal clk : std_logic := '0';
   signal tmp_gpu_adr : std_logic_vector(12 downto 0) := (others => '0');
   signal buss_controll : std_logic_vector(2 downto 0) := (others => '0');
   signal tmp_buss : std_logic_vector(12 downto 0) := (others => '0');
   signal memory1_source_address : std_logic_vector(1 downto 0) := (others => '0');
   signal memory2_source_address : std_logic_vector(1 downto 0) := (others => '0');
   signal memory3_source_address : std_logic_vector(1 downto 0) := (others => '0');
   signal memory1_source_data : std_logic_vector(1 downto 0) := (others => '0');
   signal memory2_source_data : std_logic_vector(1 downto 0) := (others => '0');
   signal memory3_source_data : std_logic_vector(1 downto 0) := (others => '0');
   signal alu_operation : std_logic_vector(1 downto 0) := (others => '0');
   signal alu1_source : std_logic_vector(1 downto 0) := (others => '0');
   signal alu2_source : std_logic_vector(1 downto 0) := (others => '0');
   signal active_player : std_logic_vector(1 downto 0) := (others => '0');
   signal alu_buss_controll : std_logic_vector(2 downto 0) := (others => '0');

   signal memory1_read  : STD_LOGIC := '0';
                signal memory2_read     : STD_LOGIC := '0';
                signal memory3_read     : STD_LOGIC := '0';

                signal memory1_write    : STD_LOGIC := '0';
                signal memory2_write    : STD_LOGIC := '0';
                signal memory3_write    : STD_LOGIC := '0';

    --Outputs
   signal tmp_gpu_data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: MARC PORT MAP (
          clk => clk,
          tmp_gpu_adr => tmp_gpu_adr,
          tmp_gpu_data => tmp_gpu_data,
          buss_controll => buss_controll,
          tmp_buss => tmp_buss,
          memory1_source_address => memory1_source_address,
          memory2_source_address => memory2_source_address,
          memory3_source_address => memory3_source_address,
          memory1_source_data => memory1_source_data,
          memory2_source_data => memory2_source_data,
          memory3_source_data => memory3_source_data,

          memory1_read          =>  memory1_read,
                    memory2_read            =>  memory2_read,
                    memory3_read            =>  memory3_read,

                    memory1_write           =>  memory1_write,
                    memory2_write           =>  memory2_write,
                    memory3_write           =>  memory3_write,

          alu_operation => alu_operation,
          alu1_source => alu1_source,
          alu2_source => alu2_source,
          active_player => active_player,
          alu_buss_controll => alu_buss_controll
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
      tmp_buss <= "0000000000000";

      tmp_gpu_adr <= "0000000000000";
      buss_controll <= "000";
      memory1_source_address <= "01";
      memory2_source_address <= "01";
      memory3_source_address <= "01";
      memory1_source_data <= "01";
      memory2_source_data <= "01";
      memory3_source_data <= "01";
      alu_operation <= "01";
      alu1_source <= "01";
      alu2_source <= "01";
      active_player <= "00";
      alu_buss_controll <= "000";

      wait;
   end process;

END;
