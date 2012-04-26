library ieee;
use ieee.std_logic_1164.all;

entity MARC_test is
end MARC_test;

architecture behavior of MARC_test is

    component MARC
        Port(
            clk : in std_logic;
            reset_a : in std_logic;

            tmp_buss : in std_logic_vector(12 downto 0);
            tmp_gpu_adr : in std_logic_vector(12 downto 0);
            tmp_gpu_data : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal reset_a : std_logic := '0';
    signal tst : std_logic := '0';

    -- Outputs
    signal tmp_buss : std_logic_vector(12 downto 0);
    signal tmp_gpu_adr : std_logic_vector(12 downto 0);
    signal tmp_gpu_data : std_logic_vector(7 downto 0);

    -- Clock period definitions
    constant clk_period : time := 1 us;

begin

    -- init Unit Under Test
    uut: MARC Port map (
        clk => clk,
        reset_a => reset_a,
        tmp_buss => tmp_buss,
        tmp_gpu_adr => tmp_gpu_adr,
        tmp_gpu_data => tmp_gpu_data
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

        tmp_gpu_adr <= "0000000000000";

        tmp_buss <= "0000000000000";

        wait;
    end process;
end;

