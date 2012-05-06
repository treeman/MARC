
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

        uCount_limit : in std_logic_vector(7 downto 0);

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

        FIFO_code : out std_logic_vector(1 downto 0);

        -- Status signals
        Z : in std_logic;
        N : in std_logic;
        both_Z : in std_logic;

        new_IN : in std_logic;
        game_started : in std_logic
    );
end Microcontroller;

architecture Behavioral of Microcontroller is

    -- Microcode lives here
    subtype DataLine is std_logic_vector(43 downto 0);
    type Data is array (0 to 255) of DataLine;

    -- FIFO IR ADR1 ADR2 OP M1 M2 mem1 mem2 mem3 mem_addr ALU1 ALU2 ALU buss PC uPC  uPC_addr
    --  00  0   00  00   0  00 00  00   00   00    000     00   0   000 000  00 0000 00000000

    signal mem : Data := (
        -- Fetch instruction
        "00000000000000000000000000000000011000101000", -- jmpS GAME(28)

        -- Startup sequence
        "00000000000000000000000000011000000000000000", -- IN -> buss
        "11000000000000000000000011000000000000000000", -- ALU = 0, fifo_next
        "01000000000000000000000000010001000000000000", -- ALU1 -> buss, buss -> FIFO, buss -> PC
        "10000000000000000000000000000000000000000000", -- change_player
        "00000000000000000000000000000000010000000111", -- jmpIN F1NUM(07)
        "00000000000000000000000000000000001000000101", -- jmp -1(05)

        "00000000000000000000001000111000000000000000", -- IN -> buss, buss -> ALU1
        "00000000000000000000000000000000010000001010", -- jmpIN F1OP(0a)
        "00000000000000000000000000000000001000001000", -- jmp -1(08)
        "00000001000000000000000000011000000000000000", -- IN -> buss, buss -> OP
        "00000000000000000000000000000000010000001101", -- jmpIN F1M1(0d)
        "00000000000000000000000000000000001000001011", -- jmp -1(0b)
        "00000000010000000000000000011000000000000000", -- IN -> buss, buss -> M1
        "00000000000000000000000000000000010000010000", -- jmpIN F1M2(10)
        "00000000000000000000000000000000001000001110", -- jmp -1(0e)
        "00000000000100000011000000011000000000000000", -- IN -> buss, buss -> M2, PC -> mem_addr
        "00000000000010101000000000000000000000000000", -- OP -> mem, M1 -> mem, M2 -> mem
        "00000000000000000000000010100010000000000000", -- ALU--, PC++
        "00000000000000000000000000000000001100010101", -- jmpZ LOAD2(15)
        "00000000000000000000000000000000001000001000", -- jmp F1ROW(08)

        "00000000000000000000000000000000010000010111", -- jmpIN F2PC(17)
        "00000000000000000000000000000000001000010101", -- jmp -1(15)
        "01000000000000000000000000011001000000000000", -- IN -> buss, buss -> FIFO, buss -> PC
        "00000000000000000000000000000000010000011010", -- jmpIN F2NUM(1a)
        "00000000000000000000000000000000001000011000", -- jmp -1(18)
        "00000000000000000000001000111000000000000000", -- IN -> buss, buss -> ALU1
        "00000000000000000000000000000000010000011101", -- jmpIN F2OP(1d)
        "00000000000000000000000000000000001000011011", -- jmp -1(1b)
        "00000001000000000000000000011000000000000000", -- IN -> buss, buss -> OP
        "00000000000000000000000000000000010000100000", -- jmpIN F2M1(20)
        "00000000000000000000000000000000001000011110", -- jmp -1(1e)
        "00000000010000000000000000011000000000000000", -- IN -> buss, buss -> M1
        "00000000000000000000000000000000010000100011", -- jmpIN F2M2(23)
        "00000000000000000000000000000000001000100001", -- jmp -1(21)
        "00000000000100000011000000011000000000000000", -- IN -> buss, buss -> M2, PC -> mem_addr
        "00000000000010101000000000000000000000000000", -- OP -> mem, M1 -> mem, M2 -> mem
        "00000000000000000000000010100010000000000000", -- ALU--, PC++
        "00000000000000000000000000000000001100000000", -- jmpZ 0(00)
        "00000000000000000000000000000000001000011011", -- jmp F2ROW(1b)

        -- Game sequence
        "10000000000000000000000000000000000000000000", -- change_player
        "11000000000000000000000000000000000000000000", -- fifo_next
        "00000000000000000000000000010101000000000000", -- FIFO -> buss, buss -> PC
        "00000000000000000011000000000000000000000000", -- PC -> mem_addr
        "00000000000001010100000000000000000000000000", -- mem -> OP, mem -> M1, mem -> M2
        "00100000000000000000000000000100001000101110", -- OP -> buss, buss -> IR, jmp AMOD(2e)

        others => (others => '0')
    );

    -- Synced reset
    signal reset : std_logic;

    -- Current microcode line to process
    signal signals : DataLine;

    -- Controll the behavior of next uPC value
    signal uPC_addr : std_logic_vector(7 downto 0);
    signal uPC_code : std_logic_vector(3 downto 0);

    signal IR_code : std_logic;

    signal uCounter : std_logic_vector(7 downto 0);

    -- Registers
    signal IR : std_logic_vector(7 downto 0);
    signal uPC : std_logic_vector(7 downto 0);

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

    signals <= mem(conv_integer(uPC));

    uPC_addr <= signals(7 downto 0);
    uPC_code <= signals(11 downto 8);

    PC_code <= signals(13 downto 12);
    buss_code <= signals(16 downto 14);

    ALU_code <= signals(19 downto 17);
    ALU2_code <= signals(20);
    ALU1_code <= signals(22 downto 21);

    memory_addr_code <= signals(25 downto 23);

    memory3_read <= signals(26);
    memory3_write <= signals(27);

    memory2_read <= signals(28);
    memory2_write <= signals(29);

    memory1_read <= signals(30);
    memory1_write <= signals(31);

    M2_code <= signals(33 downto 32);
    M1_code <= signals(35 downto 34);
    OP_code <= signals(36);

    ADR2_code <= signals(38 downto 37);
    ADR1_code <= signals(40 downto 39);

    IR_code <= signals(41);
    FIFO_code <= signals(43 downto 42);

    -------------------------------------------------------------------------
    -- ENCODINGS
    -------------------------------------------------------------------------

    -- OP code address decoding
    with OP_field select
        op_addr <=  "00110011" when "0000", -- DAT 33
                    "00110100" when "0001", -- MOV 34
                    "00111101" when "0010", -- ADD 3d
                    "01001100" when "0011", -- SUB 4c
                    "01011100" when "0100", -- JMP 5c
                    "01100000" when "0101", -- JMPZ 60
                    "01100111" when "0110", -- JMPN 67
                    "01101101" when "0111", -- CMP 6d
                    "01111111" when "1000", -- SLT 7f
                    "10001001" when "1001", -- DJN 89
                    "10010011" when "1010", -- SPL 93
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
            elsif uPC_code = "0111" and N = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1000" and both_Z = '1' then
                uPC <= uPC_addr;

            elsif uPC_code = "1001" and A_imm = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1010" and A_dir = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1011" and A_pre = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1100" and B_imm = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1101" and B_dir = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "1110" and B_pre = '1' then
                uPC <= uPC_addr;

            elsif uPC_code = "1111" then
                uPC <= "00000000";
            else
                uPC <= uPC + 1;
            end if;

            -- Update uCounter
            if reset_a = '1' then
                uCounter <= "00000000";
            elsif uPC = "00000000" then
                uCounter <= "00000000";
            else
                uCounter <= uCounter + 1;
            end if;

            if reset = '1' then
                IR <= "00000000";
            elsif IR_code = '1' then
                IR <= buss_in;
            end if;

        end if;
    end process;

end Behavioral;

