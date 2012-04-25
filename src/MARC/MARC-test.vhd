library ieee;
use ieee.std_logic_1164.all;

entity MARC_test is
end MARC_test;

architecture behavior of MARC_test is

    component MARC
        Port(
            clk : in std_logic;
            reset_a : in std_logic;
            tst : in std_logic
        );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal reset_a : std_logic := '0';
    signal tst : std_logic := '0';

    -- Outputs

    -- Clock period definitions
    constant clk_period : time := 1 us;

begin

    -- init Unit Under Test
    uut: MARC Port map (
        clk => clk,
        reset_a => reset_a,
        tst => tst
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
        wait for 100ns; -- wait until global set/reset completes

        -- Test async reset
        reset_a <= '0', '1' after 50 ns, '0' after 70 ns, '1' after 1 us, '0' after 2 us;

        tst <= '0', '1' after 3 us, '0' after 10 us;

        wait;
    end process;
end;

