-- TestBench Template

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bench is
end bench;

architecture behavior of bench is

    -- Component declaration
    component Microcontroller
        Port(
            clk : in std_logic;

            op : in std_logic_vector(7 downto 0);
            test : in std_logic_vector(2 downto 0);

            PC_code : out std_logic
        );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal op : std_logic_vector(7 downto 0) := "00000000";
    signal test : std_logic_vector(2 downto 0) := "000";

    -- Outputs
    signal PC_code : std_logic;

    -- Clock period definitions
    constant clk_period : time := 1 us;

begin

    -- Component instantiation
    uut: Microcontroller port map (
        clk => clk,
        op => op,
        test => test,
        PC_code => PC_code
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

        op <= "11111111", "01010101" after 1 us;

        test <= "000", "001" after 4 us, "010" after 8 us, "011" after 12 us, "100" after 16 us;

        -- Wait forever, yay!
        wait;
    end process;

end;

