
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

        game_code : out std_logic_vector(1 downto 0);

        -- Status signals
        Z : in std_logic;
        N : in std_logic;
        both_Z : in std_logic;

        new_IN : in std_logic;
        game_started : in std_logic;
        shall_load : in std_logic;
        game_over : in std_logic
    );
end Microcontroller;

architecture Behavioral of Microcontroller is

    -- Microcode lives here
    subtype DataLine is std_logic_vector(46 downto 0);
    type Data is array (0 to 255) of DataLine;

    -- game FIFO IR ADR1 ADR2 OP M1 M2 mem1 mem2 mem3 mem_addr ALU1 ALU2 ALU buss PC  uPC  uPC_addr
    --  00   00  0   00  00   0  00 00  00   00   00    000     00   0   000 000  00 00000 00000000
    signal mem : Data := (
        -- Startup, check if we're in game
        "00000000000000000000000000000000000011000101100", -- jmpS GAME(2c)
        "00000000000000000000000000000000000101000000001", -- jmpO +0(01)

        -- Clear memory contents
        -- ALU = 0                                 ; Load 0
        -- ALU1 -> buss, buss -> OP, buss -> M1, buss -> M2, buss -> PC
        -- :CLRMEM PC -> mem_addr                          ; Look at PC
        -- OP -> mem, M1 -> mem, M2 -> mem         ; Clear it
        -- ALU++                                   ; Incr
        -- ALU1 -> PC, jmpZ $LOADP                 ; If 0 we're done looping
        -- jmp $CLRMEM                             ; Else continue

        "00000000000000000000000000000000000100100000100", -- jmpL POLL(04)
        "00000000000000000000000000000000000001000000010", -- jmp -1(02)

        -- Load in program to memory
        "00000000000000000000000000000110000000000000000", -- IN -> buss

        -- Load program 1
        "00110000000000000000000000110000000000000000000", -- ALU = 0, fifo_next
        "00010000000000000000000000000100010000000000000", -- ALU1 -> buss, buss -> FIFO, buss -> PC

        "00000000000000000000000000000000000010000001001", -- jmpIN F1NUM(09)
        "00000000000000000000000000000000000001000000111", -- jmp -1(07)
        "00000000000000000000000010001110000000000000000", -- IN -> buss, buss -> ALU1
        "00000000000000000000000000000000000010000001100", -- jmpIN F1OP(0c)
        "00000000000000000000000000000000000001000001010", -- jmp -1(0a)
        "00000000010000000000000000000110000000000000000", -- IN -> buss, buss -> OP
        "00000000000000000000000000000000000010000001111", -- jmpIN F1M1(0f)
        "00000000000000000000000000000000000001000001101", -- jmp -1(0d)
        "00000000000100000000000000000110000000000000000", -- IN -> buss, buss -> M1
        "00000000000000000000000000000000000010000010010", -- jmpIN F1M2(12)
        "00000000000000000000000000000000000001000010000", -- jmp -1(10)
        "00000000000001000000110000000110000000000000000", -- IN -> buss, buss -> M2, PC -> mem_addr
        "00000000000000101010000000000000000000000000000", -- OP -> mem, M1 -> mem, M2 -> mem
        "00000000000000000000000000101000100000000000000", -- ALU--, PC++
        "00000000000000000000000000000000000001100010111", -- jmpZ LOAD2(17)
        "00000000000000000000000000000000000001000001010", -- jmp F1ROW(0a)

        -- Load program 2
        "00100000000000000000000000000000000000000000000", -- change_player
        "00000000000000000000000000000000000010000011010", -- jmpIN F2PC(1a)
        "00000000000000000000000000000000000001000011000", -- jmp -1(18)
        "00010000000000000000000000000110010000000000000", -- IN -> buss, buss -> FIFO, buss -> PC
        "00000000000000000000000000000000000010000011101", -- jmpIN F2NUM(1d)
        "00000000000000000000000000000000000001000011011", -- jmp -1(1b)
        "00000000000000000000000010001110000000000000000", -- IN -> buss, buss -> ALU1
        "00000000000000000000000000000000000010000100000", -- jmpIN F2OP(20)
        "00000000000000000000000000000000000001000011110", -- jmp -1(1e)
        "00000000010000000000000000000110000000000000000", -- IN -> buss, buss -> OP
        "00000000000000000000000000000000000010000100011", -- jmpIN F2M1(23)
        "00000000000000000000000000000000000001000100001", -- jmp -1(21)
        "00000000000100000000000000000110000000000000000", -- IN -> buss, buss -> M1
        "00000000000000000000000000000000000010000100110", -- jmpIN F2M2(26)
        "00000000000000000000000000000000000001000100100", -- jmp -1(24)
        "00000000000001000000110000000110000000000000000", -- IN -> buss, buss -> M2, PC -> mem_addr
        "00000000000000101010000000000000000000000000000", -- OP -> mem, M1 -> mem, M2 -> mem
        "00000000000000000000000000101000100000000000000", -- ALU--, PC++
        "00000000000000000000000000000000000001100101011", -- jmpZ LEND(2b)
        "00000000000000000000000000000000000001000011110", -- jmp F2ROW(1e)
        "01000000000000000000000000000000000001100000000", -- game_started, jmpZ 0(00)


        -- Game sequence
        "00100000000000000000000000000000000000000000000", -- change_player
        "00110000000000000000000000000000000000000000000", -- fifo_next
        "00000000000000000000000000000101010000000000000", -- FIFO -> buss, buss -> PC
        "00000000000000000000110000000000000000000000000", -- PC -> mem_addr
        "00000000000000010101000000000000000000000000000", -- mem -> OP, mem -> M1, mem -> M2
        "00001000000000000000000000000001000001000110010", -- OP -> buss, buss -> IR, jmp AMOD(32)

        -- Calculate adress mode for A operand
        "00000000000000000000000000000000001000001000011", -- jmpAimm BMOD(43)
        "00000000000000000000000000001000000000000000000", -- M1 -> ALU1
        "00000000000000000000000010010000000000000000000", -- ALU1 += PC
        "00000000001000000000000000000000000000000000000", -- ALU1 -> M1
        "00000000000000000000000000000000001000101000011", -- jmpAdir BMOD(43)
        "00000000000000000001001000000010000000000000000", -- M1 -> buss, buss -> mem_addr, mem -> M2
        "00000000000100000000000000000011000000000000000", -- M2 -> buss, buss -> M1
        "00000000000000000000000000000000001001000111110", -- jmpApre APRE(3e)
        "00000000000000000000000000001000000000000000000", -- M1 -> ALU1
        "00000000000000000000000110010000000000000000000", -- ALU1 += mem_addr
        "00000000001000000000000000000000000000000000000", -- ALU1 -> M1
        "00000000000000000000000000000000000001001000011", -- jmp BMOD(43)

        "00000000000000000000000000001000000000000000000", -- M1 -> ALU1
        "00000000000000000000000000101000000000000000000", -- ALU--
        "00000000001010000000000000000000000000000000000", -- ALU1 -> M1, ALU1 -> M2
        "00000000000000000010000000000000000000000000000", -- M2 -> mem
        "00000000000000000000000000000000000001000111010", -- jmp AOFF(3a)

        -- Calculate adress mode for B operand
        "00000000000000000000110000000000000000000000000", -- PC -> mem_addr
        "00000000000000000001000000000000000000000000000", -- mem -> M2
        "00000000000000000000000000000000001001101010110", -- jmpBimm INSTR(56)
        "00000000000000000000000100001000000000000000000", -- M2 -> ALU1
        "00000000000000000000000010010000000000000000000", -- ALU1 += PC
        "00000000000010000000000000000000000000000000000", -- ALU1 -> M2
        "00000000000000000000000000000000001010001010110", -- jmpBdir INSTR(56)
        "00000000000000000000001000000011000000000000000", -- M2 -> buss, buss -> mem_addr
        "00000000000000000001000000000000000000000000000", -- mem -> M2
        "00000000000000000000000000000000001010101010001", -- jmpBpre BPRE(51)
        "00000000000000000000000100001000000000000000000", -- M2 -> ALU1
        "00000000000000000000000110010000000000000000000", -- ALU1 += mem_addr
        "00000000000010000000000000000000000000000000000", -- ALU1 -> M2
        "00000000000000000000000000000000000001001010110", -- jmp INSTR(56)

        "00000000000000000000000100001000000000000000000", -- M2 -> ALU1
        "00000000000000000000000000101000000000000000000", -- ALU--
        "00000000000010000000000000000000000000000000000", -- ALU1 -> M2
        "00000000000000000010000000000000000000000000000", -- M2 -> mem
        "00000000000000000000000000000000000001001001101", -- jmp BOFF(4d)


        -- Load up instruction and proceed to instruction decoding
        -- A operand is now in ADR1 and B in ADR2
        -- If immediate ignore these, they're also in M1 and M2

        "00000101000000000000000000000000000000100000000", -- M1 -> ADR1, M2 -> ADR2, op_addr -> uPC


        -- Execute instruction
        --
        -- ADR1 is now the absolute address for the A operand
        -- ADR2 is for the B operand
        -- M1 and M2 holds copies of ADR1 and ADR2 always
        --
        -- If immediate, the data is instead in M1 or M2

        -- DAT  Executing data will eat up the PC
        "00000000000000000000000000000000000001010111101", -- jmp END(bd)

        -- MOV  Move A to B
        "00000000000000000000000000000000001000001011110", -- jmpAimm IMOV(5e)
        "00000000000000000000100000000000000000000000000", -- ADR1 -> mem_addr
        "00000000000000010101000000000000000000000000000", -- mem -> OP, mem -> M1, mem -> M2
        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000101010000000000000000000000000000", -- OP -> mem, M1 -> mem, M2 -> mem
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        -- If A immediate, move A to B op specified by B mem address
        "00000000000001000000101000000010000000000000000", -- ADR2 -> mem_addr, M1 -> buss, buss -> M2
        "00000000000000000010000000000000000000000000000", -- M2 -> mem
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        -- ADD  Add A to B
        "00000000000000000000000000000000001000001101010", -- jmpAimm IADD(6a)
        "00000000000000000000100000000000000000000000000", -- ADR1 -> mem_addr
        "00000000000000000101000000000000000000000000000", -- mem -> M1, mem -> M2
        "00000000000000000000101001001000000000000000000", -- ADR2 -> mem_addr, M1 -> ALU1, M2 -> ALU2
        "00000000000000000101000000000000000000000000000", -- mem -> M1, mem -> M2
        "00000000000000000000000001010000000000000000000", -- ALU1 += M1, ALU2 += M2
        "00000000001011000000000000000000000000000000000", -- ALU1 -> M1, ALU2 -> M2
        "00000000000000001010000000000000000000000000000", -- M1 -> mem, M2 -> mem
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000000001000000001000000000000000000", -- M1 -> ALU1, mem -> M2
        "00000000000000000000000100010000000000000000000", -- ALU1 += M2
        "00000000000010000000000000000000000000000000000", -- ALU1 -> M2
        "00000000000000000010000000000000000000000000000", -- M2 -> mem
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        -- SUB  Sub A from B
        "00000000000000000000000000000000001000001111001", -- jmpAimm ISUB(79)
        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000000101000000000000000000000000000", -- mem -> M1, mem -> M2
        "00000000000000000000100001001000000000000000000", -- ADR1 -> mem_addr, M1 -> ALU1, M2 -> ALU2
        "00000000000000000101000000000000000000000000000", -- mem -> M1, mem -> M2
        "00000000000000000000000001011000000000000000000", -- ALU1 -= M1, ALU2 -= M2
        "00000000001011000000101000000000000000000000000", -- ALU1 -> M1, ALU2 -> M2, ADR2 -> mem_addr
        "00000000000000001010000000000000000000000000000", -- M1 -> mem, M2 -> mem
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000000001000000000000000000000000000", -- mem -> M2
        "00000000000000000000000100001000000000000000000", -- M2 -> ALU1
        "00000000000000000000000000011000000000000000000", -- ALU1 -= M1
        "00000000000010000000000000000000000000000000000", -- ALU1 -> M2
        "00000000000000000010000000000000000000000000000", -- M2 -> mem
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        -- JMP  Jump to A
        "00000000000000000000100000000000000000000000000", -- ADR1 -> mem_addr
        "00000000000000000100000110001000000000000000000", -- mem -> M1, mem_addr -> ALU1
        "00000000000000000000000000010000000000000000000", -- ALU1 += M1
        "00010000000000000000000000000100000001010111101", -- ALU1 -> buss, buss -> FIFO, jmp END(bd)

        -- JMPZ Jump to A if B zero
        "00000000000000000000000000000000001001110000111", -- jmpBimm IJMPZ(87)
        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000000001000000000000000000000000000", -- mem -> M2
        "00000000000000000000000100001000000000000000000", -- M2 -> ALU1
        "00000000000000000000000000000000000001110001010", -- jmpZ DOJMPZ(8a)
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)
        "00000000000000000000000000000000000001010000000", -- jmp JMP(80)

        -- JMPN Jump to A if B non-zero
        "00000000000000000000000000000000001001110001110", -- jmpBimm IJMPN(8e)
        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000000001000000000000000000000000000", -- mem -> M2
        "00000000000000000000000100001000000000000000000", -- M2 -> ALU1
        "00000000000000000000000000000000000001110111011", -- jmpZ ADDPC(bb)
        "00000000000000000000000000000000000001010000000", -- jmp JMP(80)

        -- CMP If A eq B skip next instr
        "00000000000000000000000000000000001000010011110", -- jmpAimm ICMP(9e)
        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000010101000000000000000000000000000", -- mem -> OP, mem -> M1, mem -> M2
        "00000000000000000000100001001000000000000000000", -- ADR1 -> mem_addr, M1 -> ALU1, M2 -> ALU2
        "00000000000000000101000000000000000000000000000", -- mem -> M1, mem -> M2
        "00000000000000000000000001011000000000000000000", -- ALU1 -= M1, ALU2 -= M2
        "00000000000000000000000000000000000100010011001", -- jmpE CMPOP(99)
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        "00000000000000000000000010001001000000000000000", -- OP -> buss, buss -> ALU1
        "00000000000000010000000000000000000000000000000", -- mem -> OP
        "00000000000000000000000010011001000000000000000", -- ALU1 -= OP
        "00000000000000000000000000000000000001110111010", -- jmpZ SKIP(ba)
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000000001000000001000000000000000000", -- mem -> M2, M1 -> ALU1
        "00000000000000000000000100011000000000000000000", -- ALU1 -= M2
        "00000000000000000000000000000000000001110111010", -- jmpZ SKIP(ba)
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        -- SLT if A is less than B skip next instr
        "00000000000000000000000000000000001000010101100", -- jmpAimm ISLT(ac)
        "00000000000000000000100000000000000000000000000", -- ADR1 -> mem_addr
        "00000000000000000001000000000000000000000000000", -- mem -> M2
        "00000000000000000000000100001000000000000000000", -- M2 -> ALU1
        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000000001000000000000000000000000000", -- mem -> M2
        "00000000000000000000000100011000000000000000000", -- ALU1 -= M2
        "00000000000000000000000000000000000011110111010", -- jmpN SKIP(ba)
        "00000000000000000000000000000000000001010111011", -- jmp ADDPC(bb)

        "00000000000000000000000000001000000001010100111", -- M1 -> ALU1, jmp SLTCMP(a7)

        -- DJN Decr B, if not zero jmp to A
        "00000000000000000000000000000000001001110110110", -- jmpBimm IDJN(b6)
        "00000000000000000000101000000000000000000000000", -- ADR2 -> mem_addr
        "00000000000000000001000000000000000000000000000", -- mem -> M2
        "00000000000000000000000100001000000000000000000", -- M2 -> ALU1
        "00000000000000000000000000101000000000000000000", -- ALU--
        "00000000000010000000000000000000000000000000000", -- ALU1 -> M2
        "00000000000000000010000000000000000000000000000", -- M2 -> mem
        "00000000000000000000000000000000000001110111011", -- jmpZ ADDPC(bb)
        "00010000000000000000000000000010000001010111101", -- M1 -> buss, buss -> FIFO, jmp END(bd)

        "00000000000000000000000100001000000001010110100", -- M2 -> ALU1, jmp CMPDJN(b4)

        -- SPL Place A in process queue
        "00000000000000000000000000000000100000000000000", -- PC++
        "00010000000000000000000000000000000000000000000", -- PC -> buss, buss -> FIFO
        "00010000000000000000000000000010000001010111101", -- M1 -> buss, buss -> FIFO, jmp END(bd)


        "00000000000000000000000000000000100001010111011", -- PC++, jmp ADDPC(bb)

        -- Keep the PC for next round
        "00000000000000000000000000000000100000000000000", -- PC++
        "00010000000000000000000000000000000000000000000", -- PC -> buss, buss -> FIFO

        "10000000000000000000000000000000000000000000000", -- check_gameover
        "00000000000000000000000000000000000010100000000", -- jmpC 0(00)
        "00000000000000000000000000000000000001010111110", -- jmp DELAY(be)

        others => (others => '0')
    );

    -- Synced reset
    signal reset : std_logic;

    -- Current microcode line to process
    signal signals : DataLine;

    -- Controll the behavior of next uPC value
    signal uPC_addr : std_logic_vector(7 downto 0);
    signal uPC_code : std_logic_vector(4 downto 0);

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
    uPC_code <= signals(12 downto 8);

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
    FIFO_code <= signals(44 downto 43);

    game_code <= signals(46 downto 45);

    -------------------------------------------------------------------------
    -- ENCODINGS
    -------------------------------------------------------------------------

    -- OP code address decoding
    with OP_field select
        op_addr <=  "01010111" when "0000", -- DAT 57
                    "01011000" when "0001", -- MOV 58
                    "01100001" when "0010", -- ADD 61
                    "01110000" when "0011", -- SUB 70
                    "10000000" when "0100", -- JMP 80
                    "10000100" when "0101", -- JMPZ 84
                    "10001011" when "0110", -- JMPN 8b
                    "10010001" when "0111", -- CMP 91
                    "10100011" when "1000", -- SLT a3
                    "10101101" when "1001", -- DJN ad
                    "10110111" when "1010", -- SPL b7
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

            elsif uPC_code = "00001" then
                uPC <= op_addr;
            elsif uPC_code = "00010" then
                uPC <= uPC_addr;
            elsif uPC_code = "00011" and Z = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "00100" and new_IN = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "00101" and uCounter >= uCount_limit then
                uPC <= uPC_addr;
            elsif uPC_code = "00110" and game_started = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "00111" and N = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "01000" and both_Z = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "01001" and shall_load = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "01010" and game_over = '1' then
                uPC <= uPC_addr;

            elsif uPC_code = "10000" and A_imm = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "10001" and A_dir = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "10010" and A_pre = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "10011" and B_imm = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "10100" and B_dir = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "10101" and B_pre = '1' then
                uPC <= uPC_addr;

            elsif uPC_code = "11111" then
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

