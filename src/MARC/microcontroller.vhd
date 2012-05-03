
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Microcontroller is
    Port(
        -- Our clock
        clk : in std_logic;

        -- Asynced reset
        reset_a : in std_logic;

        -- Buss input
        buss_in : in std_logic_vector(7 downto 0);

        -- Control codes
        PC_code : out std_logic_vector(1 downto 0);

        buss_code : out std_logic_vector(2 downto 0);

        ALU_code : out std_logic_vector(2 downto 0);
        ALU1_code : out std_logic_vector(1 downto 0);
        ALU2_code : out std_logic;

        memory_addr_code : out std_logic_vector(2 downto 0);

        memory1_write : out std_logic;
        memory2_write : out std_logic;
        memory3_write : out std_logic;

        memory1_read : out std_logic;
        memory2_read : out std_logic;
        memory3_read : out std_logic;

        OP_code : out std_logic;
        M1_code : out std_logic_vector(1 downto 0);
        M2_code : out std_logic_vector(1 downto 0);

        ADR1_code : out std_logic_vector(1 downto 0);
        ADR2_code : out std_logic_vector(1 downto 0);

        -- Status signals
        Z : in std_logic;
        new_IN : in std_logic;
        game_started : in std_logic
    );
end Microcontroller;

architecture Behavioral of Microcontroller is

    -- Microcode lives here
    subtype DataLine is std_logic_vector(42 downto 0);
    type Data is array (0 to 255) of DataLine;

    -- IR ADR1 ADR2 OP M1 M2 mem1 mem2 mem3 mem_addr ALU1 ALU2 ALU buss PC uCount uPC  uPC_addr
    -- 0   00  00   0  00 00  00   00   00    000     00   0   000 000  00   0    0000 00000000

    signal mem : Data := (
        --  Fetch instruction
        "0000000000000000000000000000001000000000000", -- PC -> mem_addr, uCount = 0
        "0000000000010101000000000000000000000000000", -- mem -> OP, mem -> M1, mem -> M2
        "1000000000000000000000000001000000000000000", -- OP -> buss, buss -> IR

        --  Calculate adress
        "0000000000000000000000000000000100000100000", -- jmpAimm BMOD(14)
        "0000001000000000000000000000000000000000000", -- M1 -> ALU1
        "0000000000000000000010010000000000000000000", -- ALU1 += PC
        "0000000000000000000000000000000000000000000", -- ALU1 -> M1
        "0000000000000000000000000000000100100100000", -- jmpAdir BMOD(14)
        "0000000000000001001000000010000000000000000", -- M1 -> buss, buss -> mem_addr, mem -> M2
        "0000000100000000000000000011000000000000000", -- M2 -> buss, buss -> M1
        "0000000000000000000000000000000101000010101", -- jmpApre APRE(0f)
        "0000001000000000000000000000000000000000000", -- M1 -> ALU1
        "0000000000000000000010010000000000000000000", -- ALU1 += PC
        "0000000000000000000000000000000000000000000", -- ALU1 -> M1
        "0000000000000000000000000000000001000100000", -- jmp BMOD(14)

        "0000001000000000000000000000000000000000000", -- M1 -> ALU1
        "0000000000000000000000101000000000000000000", -- ALU--
        "0000000000000000000100000000000000000000000", -- ALU1 -> M1, ALU1 -> M2
        "0000000000000010000000000000000000000000000", -- M2 -> mem
        "0000000000000000000000000000000001000000011", -- jmp AOFF(0b)

        "0000000000000000000000000000000101100100001", -- jmpBimm END(15)

        "0000000000000000000000000000100111100000000", -- PC++, uPC = 0

        others => (others => '0')
    );

    -- Synced reset
    signal reset : std_logic;

    -- Current microcode line to process
    signal signals : DataLine;

    -- Controll the behavior of next uPC value
    signal uPC_addr : std_logic_vector(7 downto 0) := "XXXXXXXX";
    signal uPC_code : std_logic_vector(3 downto 0);

    signal IR_code : std_logic;

    -- TODO
    -- when in delay must output zero signals
    signal uCounter : std_logic_vector(7 downto 0) := "00000000";
    signal uCount_limit : std_logic_vector(7 downto 0) := "00000000";
    signal uCount_code : std_logic := '0';

    -- Registers
    signal IR : std_logic_vector(7 downto 0);
    signal uPC : std_logic_vector(7 downto 0) := "00000000";

    -- Split up IR
    alias OP_field is IR(7 downto 4);
    alias A_field is IR(3 downto 2);
    alias B_field is IR(1 downto 0);

    -- Instruction code decodings
    signal op_addr : std_logic_vector(7 downto 0);
    signal A_imm : std_logic;
    signal A_dir : std_logic;
    signal A_pre : std_logic;
    signal B_imm : std_logic;
    signal B_dir : std_logic;
    signal B_pre : std_logic;
begin

    -------------------------------------------------------------------------
    -- RETRIEVE SIGNALS
    -------------------------------------------------------------------------

    uPC_addr <= signals(7 downto 0);
    uPC_code <= signals(11 downto 8);
    uCount_code <= signals(12);

    PC_code <= signals(14 downto 13);
    buss_code <= signals(17 downto 15);

    ALU_code <= signals(20 downto 18);
    ALU2_code <= signals(21);
    ALU1_code <= signals(23 downto 22);

    memory_addr_code <= signals(26 downto 24);

    memory3_read <= signals(27);
    memory3_write <= signals(28);

    memory2_read <= signals(29);
    memory2_write <= signals(30);

    memory1_read <= signals(31);
    memory1_write <= signals(32);

    M2_code <= signals(34 downto 33);
    M1_code <= signals(36 downto 35);
    OP_code <= signals(37);

    ADR2_code <= signals(39 downto 38);
    ADR1_code <= signals(41 downto 40);

    IR_code <= signals(42);

    -------------------------------------------------------------------------
    -- ENCODINGS
    -------------------------------------------------------------------------

    -- TODO proper address encodings

    -- OP code address decoding
    with OP_field select
        op_addr <= "00000000" when "0000",
                   "11001110" when "0101",
                   "11111111" when others;

    A_dir <= '1' when A_field = "00" else '0';
    A_imm <= '1' when A_field = "01" else '0';
    A_pre <= '1' when A_field = "11" else '0';

    B_dir <= '1' when B_field = "00" else '0';
    B_imm <= '1' when B_field = "01" else '0';
    B_pre <= '1' when B_field = "11" else '0';

    -------------------------------------------------------------------------
    -- ON CLOCK EVENT
    -------------------------------------------------------------------------

    process (clk)
    begin
        if rising_edge(clk) then

            if reset_a = '1' then
                reset <= '1';
            elsif reset = '1' then
                reset <= '0';
            end if;

            -------------------------------------------------------------------------
            -- SIGNAL MULTIPLEXERS
            -------------------------------------------------------------------------

            -- Update uPC
            if reset_a = '1' then
                uPC <= "00000000";
            elsif uPC_code = "0000" then
                uPC <= uPC + 1;

            elsif uPC_code = "0001" then
                uPC <= op_addr;
            elsif uPC_code = "0010" then
                uPC <= uPC_addr;
            elsif uPC_code = "0011" and Z = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "0100" and new_IN = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "0101" and uCounter >= uCount_limit then
                uPC <= uPC_addr;
            elsif uPC_code = "0110" and game_started = '1' then
                uPC <= uPC_addr;

            elsif uPC_code = "1000" and A_imm = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1001" and A_dir = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1010" and A_pre = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1011" and B_imm = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1100" and B_dir = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1101" and B_pre = '1' then
                uPC <= uPC_addr;

            elsif uPC_code = "1111" then
                uPC <= "00000000";
            end if;

            -- Update uCounter
            if reset_a = '1' then
                uCounter <= "00000000";
            elsif uCount_code = '0' then
                uCounter <= uCounter + 1;
            elsif uCount_code = '1' then
                uCounter <= "00000000";
            end if;

            if reset = '1' then
                IR <= "00000000";
            elsif IR_code = '1' then
                IR <= buss_in;
            end if;

            signals <= mem(conv_integer(uPC));

        end if;
    end process;

end Behavioral;

