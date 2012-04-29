
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
        ADR2_code : out std_logic_vector(1 downto 0)
    );
end Microcontroller;

architecture Behavioral of Microcontroller is

    -- Microcode lives here
    subtype DataLine is std_logic_vector(42 downto 0);
    type Data is array (0 to 255) of DataLine;


    -- IR ADR1 ADR2 OP M1 M2 mem1 mem2 mem3 mem_addr ALU1 ALU2 ALU buss PC uCount uPC  uPC adr
    -- 0   00  00   0  00 00  00   00   00    000     00   0   000 000  00 00     000  00000000

    signal mem : Data := (

        --  Fill memory
        "0000010101000000000000000000000000000000000", -- PC -> buss, buss -> OP, buss -> M1, buss -> M2
        "0000000000101010000000000000000000000000000", -- PC -> mem_addr, OP -> mem, M1 -> mem, M2 -> mem
        "0000000000000000000010001000000000000000000", -- PC -> buss, buss -> ALU1

        --  Increase and erase mem registries
        "0000000000000000000000100000000000000000000", -- ALU++
        "0000010101000000000000000100000000000000000", -- ALU1 -> buss, buss -> OP, buss -> M1, buss -> M2

        --  Read back again, check memory contents
        "0000000000010101000000000000000000000000000", -- PC -> mem_addr, mem -> OP, mem -> M1, mem -> M2

        --  Replace PC and restart
        "0000000000000000000000000100010000000000000", -- ALU1 -> buss, buss -> PC
        "0000000000000000000000000000110000000000000", -- PC = 0
        "0000000000000000000000000000000011100000000", -- uPC = 0

        others => (others => '0')
    );

    -- Synced reset
    signal reset : std_logic;

    -- Current microcode line to process
    signal signals : DataLine;

    -- Controll the behavior of next uPC value
    signal uPC_addr : std_logic_vector(7 downto 0) := "XXXXXXXX";
    signal uPC_code : std_logic_vector(2 downto 0);

    signal IR_code : std_logic;

    -- TODO
    -- when in delay must output zero signals
    signal uCounter : std_logic_vector(7 downto 0) := "00000000";
    signal uCount_limit : std_logic_vector(7 downto 0) := "00000000";
    signal uCount_code : std_logic_vector(1 downto 0) := "00";

    -- Registers
    signal IR : std_logic_vector(7 downto 0);
    signal uPC : std_logic_vector(7 downto 0) := "00000000";

    -- OP code decodings
    signal op_addr : std_logic_vector(7 downto 0);
    signal A_addr : std_logic_vector(7 downto 0);
    signal B_addr : std_logic_vector(7 downto 0);

    -- TODO Z should not lieve here!
    signal Z : std_logic := '0';
begin

    -------------------------------------------------------------------------
    -- RETRIEVE SIGNALS
    -------------------------------------------------------------------------

    uPC_addr <= signals(7 downto 0);
    uPC_code <= signals(10 downto 8);
    uCount_code <= signals(12 downto 11);

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
    with IR(7 downto 4) select
        op_addr <= "00000000" when "0000",
                   "11001110" when "0101",
                   "11111111" when others;

    -- A a-mod address decoding
    with IR(3 downto 2) select
        A_addr <= "00000000" when "00",
                  "00000001" when "01",
                  "00000010" when others;

    -- B a-mod address decoding
    with IR(1 downto 0) select
        B_addr <= "00000011" when "00",
                  "00000100" when "01",
                  "00000101" when others;


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

            -- Update current micro controls
            --if reset_a = '1' then
                --signals <= (others => '0');
            --else
                --signals <= mem(conv_integer(uPC));
            --end if;

            -------------------------------------------------------------------------
            -- SIGNAL MULTIPLEXERS
            -------------------------------------------------------------------------

            -- Update uPC
            if reset_a = '1' then
                uPC <= "00000000";
            elsif uPC_code = "000" then
                uPC <= uPC + 1;
            elsif uPC_code = "001" then
                uPC <= op_addr;
            elsif uPC_code = "010" then
                uPC <= A_addr;
            elsif uPC_code = "011" then
                uPC <= B_addr;
            elsif uPC_code = "100" then
                uPC <= uPC_addr;
            elsif uPC_code = "101" and Z = '1' then
                uPC <= uPC_addr;
            elsif uPC_code = "111" then
                uPC <= "00000000";
            end if;

            -- Update uCounter
            if reset_a = '1' then
                uCounter <= "00000000";
            elsif uCount_code = "00" then
                uCounter <= uCounter + 1;
            elsif uCount_code = "01" then
                if uCount_limit <= uCounter then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
            elsif uCount_code = "11" then
                uCounter <= "00000000";
            end if;

            if reset = '1' then
                IR <= "00000000";
            elsif IR_code = '1' then
                IR <= buss_in;
            end if;

        end if;
    end process;

    signals <= mem(conv_integer(uPC));

end Behavioral;

