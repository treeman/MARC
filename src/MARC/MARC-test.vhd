library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MARC_test is
end MARC_test;

architecture behavior of MARC_test is

    component MARC
        Port(
            clk : in std_logic;
            reset_a : in std_logic;

            uCount_limit : in std_logic_vector(7 downto 0);
            fbart_in : in std_logic;

            tmp_buss : in std_logic_vector(12 downto 0);
            tmp_gpu_adr : in std_logic_vector(12 downto 0);
            tmp_gpu_data : out std_logic_vector(7 downto 0);

            tmp_has_next_data : in std_logic;
            tmp_IN : in std_logic_vector(12 downto 0);
            tmp_request_next_data : out std_logic
        );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal reset_a : std_logic := '0';
    signal uCount_limit : std_logic_vector(7 downto 0) := "00000000";
    signal fbart_in : std_logic := '0';

    signal tmp_buss : std_logic_vector(12 downto 0);
    signal tmp_gpu_adr : std_logic_vector(12 downto 0);

    signal tmp_has_next_data : std_logic := '0';
    signal tmp_IN : std_logic_vector(12 downto 0) := "0000000000000";

    -- Outputs
    signal tmp_gpu_data : std_logic_vector(7 downto 0);
    signal tmp_request_next_data : std_logic;

    -- Clock period definitions
    constant clk_period : time := 1 us;

    subtype DataLine is std_logic_vector(38 downto 0);
    type Data is array (0 to 32) of DataLine;

    signal PC : std_logic_vector(4 downto 0) := "00000";
    signal turn : std_logic := '0';

    -- 000 line number
    -- 001 OP
    -- 010 M1
    -- 011 M2
    -- 100 Send PC2
    signal row_status : std_logic_vector(2 downto 0) := "000";

    signal last_request : std_logic := '0';

    signal prog1 : Data := (
        "XXXXX0001111100000111100001000011001100",
        --"XXXXX  1111 1111  0 0000 1111 0000  1 0000 1100 1100", ff 00f0  10cc
        "XXXXX0010000011111111100001000011101110",

        others => (others => '0')
    );
    signal prog1_lines : std_logic_vector(4 downto 0) := "00010";
    signal prog1_row : DataLine;

    signal prog2 : Data := (
        "XXXXX1010101010101101001111011011011100",

        others => (others => '0')
    );
    signal prog2_lines : std_logic_vector(4 downto 0) := "00001";
    signal prog2_row : DataLine;

    signal PC2_start : std_logic_vector(12 downto 0) := "1000011110000";

begin

    -- init Unit Under Test
    uut: MARC Port map (
        clk => clk,
        reset_a => reset_a,
        uCount_limit => uCount_limit,
        fbart_in => fbart_in,

        tmp_buss => tmp_buss,
        tmp_gpu_adr => tmp_gpu_adr,
        tmp_gpu_data => tmp_gpu_data,

        tmp_has_next_data => tmp_has_next_data,
        tmp_IN => tmp_IN,
        tmp_request_next_data => tmp_request_next_data
    );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    prog1_row <= prog1(conv_integer(PC));
    prog2_row <= prog2(conv_integer(PC));

    -- Simulate input
    process
    begin
        wait until tmp_request_next_data = '1';

        tmp_has_next_data <= '0';
        tmp_IN <= "XXXXXXXXXXXXX";

        wait for 5 us;

        tmp_has_next_data <= '1';

        if turn = '0' then
            if row_status = "000" then
                tmp_IN <= "00000000" & prog1_lines;
                row_status <= "001";
            elsif row_status = "001" then
                tmp_IN <= prog1_row(38 downto 26);
                row_status <= "010";
            elsif row_status = "010" then
                tmp_IN <= prog1_row(25 downto 13);
                row_status <= "011";
            else
                tmp_IN <= prog1_row(12 downto 0);

                if prog1_lines = PC + 1 then
                    row_status <= "100";
                    turn <= not turn;
                    PC <= "00000";
                else
                    row_status <= "001";
                    PC <= PC + 1;
                end if;
            end if;
        else
            if row_status = "100" then
                tmp_IN <= PC2_start;
                row_status <= "000";
            elsif row_status = "000" then
                tmp_IN <= "00000000" & prog2_lines;
                row_status <= "001";
            elsif row_status = "001" then
                tmp_IN <= prog2_row(38 downto 26);
                row_status <= "010";
            elsif row_status = "010" then
                tmp_IN <= prog2_row(25 downto 13);
                row_status <= "011";
            else
                tmp_IN <= prog2_row(12 downto 0);

                if prog2_lines = PC + 1 then
                    row_status <= "000";
                    turn <= not turn;
                    PC <= "00000";
                else
                    row_status <= "001";
                    PC <= PC + 1;
                end if;
            end if;
        end if;
    end process;

    stim_proc: process
    begin
        wait for 100 ns; -- wait until global set/reset completes

        -- Test async reset
        reset_a <= '0', '1' after 50 ns, '0' after 70 ns, '1' after 1 us, '0' after 2 us;

        tmp_gpu_adr <= "0000000000000";

        tmp_buss <= "0000000000000";

        wait;
    end process;
end;

