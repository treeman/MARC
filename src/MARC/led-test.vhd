library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_test is
end led_test;

architecture behavior of led_test is

    component MARCled is
        Port(
            clk,rst : in  STD_LOGIC;
            ca,cb,cc,cd,ce,cf,cg,dp : out  STD_LOGIC;
            an : out  STD_LOGIC_VECTOR (3 downto 0);

            game_started : in std_logic;
            current_instr : in std_logic_vector(3 downto 0);

            game_over : in std_logic;
            active_player : in std_logic_vector(1 downto 0)
        );
    end component;

    component tb_print7seg is
        port (
            clk : in std_logic;
            ca,cb,cc,cd,ce,cf,cg,dp : in std_logic;
            an : in std_logic_vector(3 downto 0)
        );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal game_started : std_logic := '0';
    signal current_instr : std_logic_vector(3 downto 0) := (others => '0');
    signal game_over : std_logic := '0';
    signal active_player : std_logic_vector(1 downto 0) := "00";

    -- Outputs
    signal ca,cb,cc,cd,ce,cf,cg,dp : std_logic;
    signal an : std_logic_vector(3 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

   -- init Unit Under Test
    uut: MARCled Port map (
        clk => clk,
        rst => rst,
        ca => ca,
        cb => cb,
        cc => cc,
        cd => cd,
        ce => ce,
        cf => cf,
        cg => cg,
        dp => dp,
        an => an,
        game_started => game_started,
        current_instr => current_instr,
        game_over => game_over,
        active_player => active_player
    );

    print: tb_print7seg Port map (
        clk => clk,
        ca => ca,
        cb => cb,
        cc => cc,
        cd => cd,
        ce => ce,
        cf => cf,
        cg => cg,
        dp => dp,
        an => an
    );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    stim_proc: process
    begin
        wait for 0.45 ns; -- wait until global set/reset completes

        rst <= '0', '1' after 10 ns, '0' after 20 ns;

        --game_over <= '0', '1' after 900 ns, '0' after 3940 ns, '1' after 4 us;
        --active_player <= "00", "01" after 900 ns, "10" after 4 us;

        game_started <= '0', '1' after 100 ns;
        current_instr <= "0000",
                         "0001" after 200 ns,
                         "0010" after 300 ns,
                         "0011" after 400 ns,
                         "0100" after 500 ns,
                         "0101" after 600 ns,
                         "0110" after 700 ns,
                         "0111" after 800 ns,
                         "1000" after 900 ns,
                         "1001" after 1000 ns,
                         "1010" after 1100 ns;

        wait;
    end process;
end;

