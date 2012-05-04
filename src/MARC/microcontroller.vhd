
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
        "0000000000000000110000000000001000000000000", -- PC -> mem_addr, uCount = 0
        "0000000000010101000000000000000000000000000", -- mem -> OP, mem -> M1, mem -> M2
        "1000000000000000000000000001000001000000011", -- OP -> buss, buss -> IR, jmp AMOD(03)

        --  Calculate adress mode for A operand
        "0000000000000000000000000000000100000010100", -- jmpAimm BMOD(14)
        "0000000000000000000000001000000000000000000", -- M1 -> ALU1
        "0000000000000000000010010000000000000000000", -- ALU1 += PC
        "0000001000000000000000000000000000000000000", -- ALU1 -> M1
        "0000000000000000000000000000000100100010100", -- jmpAdir BMOD(14)
        "0000000000000001001000000010000000000000000", -- M1 -> buss, buss -> mem_addr, mem -> M2
        "0000000100000000000000000011000000000000000", -- M2 -> buss, buss -> M1
        "0000000000000000000000000000000101000001111", -- jmpApre APRE(0f)
        "0000000000000000000000001000000000000000000", -- M1 -> ALU1
        "0000000000000000000110010000000000000000000", -- ALU1 += mem_addr
        "0000001000000000000000000000000000000000000", -- ALU1 -> M1
        "0000000000000000000000000000000001000010100", -- jmp BMOD(14)

        "0000000000000000000000001000000000000000000", -- M1 -> ALU1
        "0000000000000000000000101000000000000000000", -- ALU--
        "0000001010000000000000000000000000000000000", -- ALU1 -> M1, ALU1 -> M2
        "0000000000000010000000000000000000000000000", -- M2 -> mem
        "0000000000000000000000000000000001000001011", -- jmp AOFF(0b)

        --  Calculate adress mode for B operand
        "0000000000000000110000000000000000000000000", -- PC -> mem_addr
        "0000000000000001000000000000000000000000000", -- mem -> M2
        "0000000000000000000000000000000101100100111", -- jmpBimm INSTR(27)
        "0000000000000000000100001000000000000000000", -- M2 -> ALU1
        "0000000000000000000010010000000000000000000", -- ALU1 += PC
        "0000000010000000000000000000000000000000000", -- ALU1 -> M2
        "0000000000000000000000000000000110000100111", -- jmpBdir INSTR(27)
        "0000000000000000001000000011000000000000000", -- M2 -> buss, buss -> mem_addr
        "0000000000000001000000000000000000000000000", -- mem -> M2
        "0000000000000000000000000000000110100100010", -- jmpBpre BPRE(22)
        "0000000000000000000100001000000000000000000", -- M2 -> ALU1
        "0000000000000000000110010000000000000000000", -- ALU1 += mem_addr
        "0000000010000000000000000000000000000000000", -- ALU1 -> M2
        "0000000000000000000000000000000001000100111", -- jmp INSTR(27)

        "0000000000000000000100001000000000000000000", -- M2 -> ALU1
        "0000000000000000000000101000000000000000000", -- ALU--
        "0000000010000000000000000000000000000000000", -- ALU1 -> M2
        "0000000000000010000000000000000000000000000", -- M2 -> mem
        "0000000000000000000000000000000001000011110", -- jmp BOFF(1e)

        --  Load up instruction
        "0101000000000000000000000000000000000000000", -- M1 -> ADR1, M2 -> ADR2
        "0000000000000000000000000000000000100000000", -- op_addr -> uPC


        --  Execute instruction
        -- 
        --  ADR1 is now the absolute address for the A operand
        --  ADR2 is for the B operand
        -- 
        --  If immediate, the data is instead in M1 or M2

        --  DAT  Executing data will eat up the PC
        "0000000000000000000000000000000001001000011", -- jmp END(43)

        --  MOV  Move A to B
        "0000000000000000000000000000000100000110000", -- jmpAimm IMOV(30)
        "0000000000000000100000000000000000000000000", -- ADR1 -> mem_addr
        "0000000000010101000000000000000000000000000", -- mem -> OP, mem -> M1, mem -> M2
        "0000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "0000000000101010000000000000000000000000000", -- OP -> mem, M1 -> mem, M2 -> mem
        "0000000000000000000000000000000001001000010", -- jmp ADDPC(42)

        --  If A immediate, move A to B op specified by B mem address
        "0000000001000000101000000010000000000000000", -- ADR2 -> mem_addr, M1 -> buss, buss -> M2
        "0000000000000010000000000000000000000000000", -- M2 -> mem
        "0000000000000000000000000000000001001000010", -- jmp ADDPC(42)

        --  ADD  Add A to B
        "0000000000000000000000000000000100000111100", -- jmpAimm IADD(3c)
        "0000000000000000100000000000000000000000000", -- ADR1 -> mem_addr
        "0000000000000101000000000000000000000000000", -- mem -> M1, mem -> M2
        "0000000000000000101001001000000000000000000", -- ADR2 -> mem_addr, M1 -> ALU1, M2 -> ALU2
        "0000000000000101000000000000000000000000000", -- mem -> M1, mem -> M2
        "0000000000000000000001010000000000000000000", -- ALU1 += M1, ALU2 += M2
        "0000001011000000000000000000000000000000000", -- ALU1 -> M1, ALU2 -> M2
        "0000000000001010000000000000000000000000000", -- M1 -> mem, M2 -> mem
        "0000000000000000000000000000000001001000010", -- jmp ADDPC(42)

        "0000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "0000000000000001000000001000000000000000000", -- M1 -> ALU1, mem -> M2
        "0000000000000000000100010000000000000000000", -- ALU1 += M2
        "0000000010000000000000000000000000000000000", -- ALU1 -> M2
        "0000000000000010000000000000000000000000000", -- M2 -> mem
        "0000000000000000000000000000000001001000010", -- jmp ADDPC(42)

        --  Keep the PC for next round
        "0000000000000000000000000000100000000000000", -- PC++
        --        PC -> FIFO

        "0000000000000000000000000000000001001000100", -- jmp DELAY(44)
        "0000000000000000000000000000000010100000000", -- jmpC 0
        "0000000000000000000000000000000001001000100", -- jmp DELAY(44)

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

    -- TODO connect or change this for delay
    signal uCount_limit : std_logic_vector(7 downto 0) := "00000000";
    signal uCount_code : std_logic := '0';

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
        op_addr <= "00101001" when "0000", -- DAT 29
                   "00101010" when "0001", -- MOV 2a
                   "00110011" when "0010", -- ADD 33
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
            else
                uPC <= uPC + 1;
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

        end if;
    end process;

end Behavioral;

