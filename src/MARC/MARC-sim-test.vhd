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

            -- Test upstart load without fbart
            tmp_has_next_data : in std_logic;
            tmp_IN : in std_logic_vector(12 downto 0);
            tmp_request_next_data : out std_logic;

            -- VGA output
            red : out std_logic_vector(2 downto 0);
            grn : out std_logic_vector(2 downto 0);
            blu : out std_logic_vector(1 downto 0);
            HS : out std_logic;
            VS : out std_logic;

            -- Hex display output
            ca,cb,cc,cd,ce,cf,cg,dp : out  STD_LOGIC;
            an : out  STD_LOGIC_VECTOR (3 downto 0);

            -- Output flags etc
            reset_out : out std_logic;
            game_started_out : out std_logic;
            active_player_out : out std_logic_vector(1 downto 0);
            pad_error : out STD_LOGIC_VECTOR(2 downto 0);
            alu1_o : out stD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal reset_a : std_logic := '0';
    signal uCount_limit : std_logic_vector(7 downto 0) := "00000000";
    signal fbart_in : std_logic := '1';

    signal tmp_has_next_data : std_logic := '0';
    signal tmp_IN : std_logic_vector(12 downto 0) := "0000000000000";

    -- Outputs
    signal tmp_request_next_data : std_logic;

    signal red : std_logic_vector(2 downto 0);
    signal grn : std_logic_vector(2 downto 0);
    signal blu : std_logic_vector(1 downto 0);
    signal HS : std_logic;
    signal VS : std_logic;

    signal reset_out : std_logic;
    signal game_started_out : std_logic;
    signal active_player_out : std_logic_vector(1 downto 0);
    signal pad_error : STD_LOGIC_VECTOR(2 downto 0);

    signal ca,cb,cc,cd,ce,cf,cg,dp : STD_LOGIC;
    signal an : STD_LOGIC_VECTOR (3 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

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
        -- Dwarf
        --"XXXXX0010010000000000001000000000000011", -- ADD # 4(4)  3 (3)
        --"XXXXX0001001000000000000100000000000010", -- MOV  2(2) @ 2(2)
        --"XXXXX0100000011111111111100000000000000", -- JMP  die(-2)  0(0)
        --"XXXXX0000010100000000000000000000000000", -- DAT # 0(0) # 0(0)

        -- Imp
        --"XXXXX0001000000000000000000000000000001", -- MOV 0,1

        -- Bomber
        --"XXXXX0010010000000000000010000000000010", -- add # 1(1)  2(2)
        --"XXXXX0001001000000000000100000000000001", -- mov  2(2) @ 1(1)
        --"XXXXX0100000011111111111100000000000001", -- jmp  -2(-2)  1(1)
        --"XXXXX0000000000000000000000000000000000", -- dat  0(0)  0(0)

        -- Split test
        --"XXXXX0010000000000000000110000000000001", -- add  3(3)  1(1)
        --"XXXXX1010000000000000000100000000000000", -- spl @ 2(2)  0(0)
        --"XXXXX0100000011111111111100000000000000", -- jmp  -2(-2)  0(0)
        --"XXXXX0000000000000000000110000000000011", -- dat  3(3)  3(3)

        -- Signalgun
        --"XXXXX1010000000000000000000000000000000", -- spl  0(0)  0(0)
        --"XXXXX1001001100000000000001111111111110", --  djn  0(0) < -2(-2)

        --"XXXXX0010010011111111111110000000000001", -- add #-1,1
        --"XXXXX0101010011111111111110000000000001", -- jmz -1,1

        -- Split test
        --"XXXXX0010010000000000000010000000000100", -- ; add # 1(1)  4(4)
        --"XXXXX1010000011111111111110000000000000", -- ; spl  -1(-1)  0(0)
        --"XXXXX0000000000000000000000000000000000", -- ; dat  0(0)  0(0)

        -- Imp spawner!
        --"XXXXX0010000000000000001100000000000101", --   ; ADD  STEP(6)  PTR(5)
        --"XXXXX0001001000000000000110000000000100", --   ; MOV  IMP(3) @ PTR(4)
        --"XXXXX1010100000000000000110000000000000", --   ; SPL @ PTR(3)  0(0)
        --"XXXXX0100000011111111111010000000000000", --   ; JMP  START(-3)  0(0)
        --"XXXXX0001000000000000000000000000000001", --   ; MOV  0(0)  1(1)
        --"XXXXX0000000000000001100100000000110010", --   ; DAT  50(50)  50(50)
        --"XXXXX0000000000000001100100000000110010", --   ; DAT  50(50)  50(50)

	-- Dwarf scout!
	"XXXXX0001000000000000110110000000011100",
	"XXXXX0001010000000000010000000000000010",
	"XXXXX0001001100000000110000000000011010",
	"XXXXX1001000111111111111110000000001000",
	"XXXXX0001000000000000101000000000010011",
	"XXXXX1010000000000000011110000000000000",
	"XXXXX0001000000000000101010000000010110",
	"XXXXX0001010000000000010000000000000011",
	"XXXXX0111001100000000100100000000010100",
	"XXXXX0100000000000000000110000000000000",
	"XXXXX1001000111111111111100000000001000",
	"XXXXX0100000011111111110110000000000000",
	"XXXXX0001000000000000100010000000001011",
	"XXXXX0001010000000000000000000000010000",
	"XXXXX0001010001110110101100000000000101",
	"XXXXX0001010000000000111010000000000011",
	"XXXXX0001101000000000011010000000000011",
	"XXXXX0001111100000000011000000000000010",
	"XXXXX1001000111111111111110000000011101",
	"XXXXX1010100000000000000000111011010001",
	"XXXXX0001010000000000010100000000000101",
	"XXXXX0010010000000000000110000000000100",
	"XXXXX0001001000000000000110000000000011",
	"XXXXX0100000011111111111100000000000000",
	"XXXXX0100000011111111111100000000000000",
	"XXXXX0000010100000000000000000000000101",
	"XXXXX0000010100000111011010001111011010",
	"XXXXX0000010111111011000011111101100001",
	"XXXXX0000010100000000000000000000000000",
	"XXXXX0000010000000000000000000000000000",

        others => (others => '0')
    );
    signal prog1_lines : std_logic_vector(4 downto 0) := "11110";
    signal prog1_row : DataLine;

    signal prog2 : Data := (
        --"XXXXX0001000000000000000000000000000001", -- MOV 0,1
        "XXXXX0100000000000000000000000000000000", -- JMP 0,0

        others => (others => '0')
    );
    signal prog2_lines : std_logic_vector(4 downto 0) := "00001";
    signal prog2_row : DataLine;

    signal PC2_start : std_logic_vector(12 downto 0) := "0000000000111";

begin

   -- init Unit Under Test
    uut: MARC Port map (
        clk => clk,
        reset_a => reset_a,
        uCount_limit => uCount_limit,
        fbart_in => fbart_in,

        tmp_has_next_data => tmp_has_next_data,
        tmp_IN => tmp_IN,
        tmp_request_next_data => tmp_request_next_data,

        red => red,
        grn => grn,
        blu => blu,
        HS => HS,
        VS => VS,

	ca => ca,
	cb => cb,
	cc => cc,
	cd => cd,
	ce => ce,
	cf => cf,
	cg => cg,
	dp => dp,
	an => an,

        reset_out => reset_out,
        game_started_out => game_started_out,
        active_player_out => active_player_out,
        pad_error => pad_error
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
       --tmp_IN <= "XXXXXXXXXXXXX";

       wait for 50 ns;

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
        --wait for 0.45 ns; -- wait until global set/reset completes

        -- Test async reset
        reset_a <= '0', '1' after 3 ns, '0' after 15 ns;

        wait;
    end process;
end;

