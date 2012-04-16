-- TestBench Template

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bench is
end bench;

architecture behavior of bench is

    -- Component declaration
    component test
        Port(
            clk : in std_logic;

            a : in std_logic;
            b : in std_logic;

            res : out std_logic
        );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal a : std_logic := '0';
    signal b : std_logic := '0';

    -- Outputs
    signal res : std_logic;

    -- Clock period definitions
    constant clk_period : time := 1ms;

begin

    -- Component instantiation
    uut: test port map (
        clk => clk,
        a => a,
        b => b,
        res => res
    );

    -- Our clock
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Our tests
    stim_proc : process
    begin
        wait for 100ns; -- wait until global set/reset completes

        -- Add user defined stimulus here;

        a <= '0', '1' after 1 ms, '0' after 2 ms;
        b <= '1', '0' after 2 ms, '1' after 3 ms;

        -- Wait forever, yay!
        wait;
    end process;

end;

