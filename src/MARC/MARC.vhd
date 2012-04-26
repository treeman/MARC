
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MARC is
    Port (  clk : in std_logic;
            reset_a : in std_logic;
            tst : in std_logic
    );
end MARC;


architecture Behavioral of MARC is

    -------------------------------------------------------------------------
    -- COMPONENTS
    -------------------------------------------------------------------------

    component Microcontroller
        Port (  clk : in std_logic;
                reset_a : in std_logic;
                buss_in : in std_logic_vector(7 downto 0);

                PC_code : out std_logic_vector(1 downto 0);
                buss_code : out std_logic_vector(2 downto 0);

                ALU_code : out std_logic_vector(2 downto 0);
                ALU1_src_code : out std_logic_vector(1 downto 0);
                ALU2_src_code : out std_logic;

                memory_address_code : out std_logic_vector(2 downto 0);

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
    end component;

    component ALU
        Port (  clk : in std_logic;
                main_buss_in : in std_logic_vector(12 downto 0);    -- TODO need dual input, one for each ALU

                alu_operation : in std_logic_vector(1 downto 0);
                alu1_zeroFlag : out std_logic;

                alu1_source : in std_logic_vector(1 downto 0);
                alu2_source : in std_logic_vector(1 downto 0);

                alu1_out : out std_logic_vector(12 downto 0);
                alu2_out : out std_logic_vector(12 downto 0)
        );
    end component;

    component Memory_Cell
        Port (  clk : in std_logic;
                read : in std_logic;
                write : in std_logic;

                address_in : in std_logic_vector(12 downto 0);
                address_out : out std_logic_vector(12 downto 0);

                data_in : in std_logic_vector(12 downto 0);
                data_out : out std_logic_vector(12 downto 0)
        );
    end component;

    component Memory_Cell_DualPort
        Port (  clk : in std_logic;
                read : in std_logic;
                write : in std_logic;

                active_player : in std_logic_vector(1 downto 0);

                address_in : in std_logic_vector(12 downto 0);
                address_out : out std_logic_vector (12 downto 0);

                data_in : in std_logic_vector(7 downto 0);
                data_out : out std_logic_vector(7 downto 0);

                address_gpu : in std_logic_vector(12 downto 0);
                data_gpu : out std_logic_vector(7 downto 0);
                read_gpu : in std_logic
        );
    end component;


    -------------------------------------------------------------------------
    -- DATA SIGNALS
    -------------------------------------------------------------------------

    -- Module data signals
    signal microcontroller_in : std_logic_vector(7 downto 0);

    signal ALU_in : std_logic_vector(12 downto 0);
    signal ALU1_out : std_logic_vector(12 downto 0);
    signal ALU2_out : std_logic_vector(12 downto 0);

    signal ALU_src : std_logic_vector(1 downto 0);
    signal ALU_operation : std_logic_vector(1 downto 0);

    signal memory1_data_in : std_logic_vector(7 downto 0);
    signal memory2_data_in : std_logic_vector(12 downto 0);
    signal memory3_data_in : std_logic_vector(12 downto 0);

    signal memory1_data_out : std_logic_vector(7 downto 0);
    signal memory2_data_out : std_logic_vector(12 downto 0);
    signal memory3_data_out : std_logic_vector(12 downto 0);

    -- Combined to one for now
    signal memory_address_in : std_logic_vector(12 downto 0);

    -- Need to reroute back if we want to keep the value
    signal memory1_address_out : std_logic_vector(12 downto 0);
    signal memory2_address_out : std_logic_vector(12 downto 0); -- Not used as of now?! Will everything implode?
    signal memory3_address_out : std_logic_vector(12 downto 0); -- Not used as of now?!

    signal memory1_address_gpu : std_logic_vector(12 downto 0); -- Unsynced!
    signal memory1_data_gpu : std_logic_vector(7 downto 0); -- Unsynced!

    signal memory1_read_gpu : std_logic;


    -------------------------------------------------------------------------
    -- FLOW CONTROL
    -------------------------------------------------------------------------

    -- Flow control signals
    signal main_buss : std_logic_vector(12 downto 0) := "1X1X1X1X1X1X1";

    -- Registers
    signal PC : std_logic_vector(12 downto 0);
    signal ADR1 : std_logic_vector(12 downto 0);
    signal ADR2 : std_logic_vector(12 downto 0);


    -------------------------------------------------------------------------
    -- CONTROL SIGNALS
    -------------------------------------------------------------------------

    signal PC_code : std_logic_vector(1 downto 0);

    signal buss_code : std_logic_vector(2 downto 0);

    signal ALU_code : std_logic_vector(2 downto 0);
    signal ALU1_src_code : std_logic_vector(1 downto 0);
    signal ALU2_src_code : std_logic;

    signal memory_address_code : std_logic_vector(2 downto 0);

    signal memory1_write : std_logic;
    signal memory2_write : std_logic;
    signal memory3_write : std_logic;

    signal memory1_read : std_logic;
    signal memory2_read : std_logic;
    signal memory3_read : std_logic;

    signal OP_code : std_logic;
    signal M1_code : std_logic_vector(1 downto 0);
    signal M2_code : std_logic_vector(1 downto 0);

    signal ADR1_code : std_logic_vector(1 downto 0);
    signal ADR2_code : std_logic_vector(1 downto 0);

    -------------------------------------------------------------------------
    -- MISC JUNK
    -------------------------------------------------------------------------

    -- Status signals
    signal Z : std_logic := '0';
    signal active_player : std_logic_vector(1 downto 0);

    -- Other stuff
    signal reset : std_logic := '0';

    -- TODO connect these modules later
    signal fifo_out : std_logic_vector(12 downto 0) := "0010XXXXXXXXX";
    signal IN_out : std_logic_vector(12 downto 0) := "0001XXXXXXXXX";

begin

    -------------------------------------------------------------------------
    -- COMPONENT INITIATION
    -------------------------------------------------------------------------

    micro: Microcontroller
        port map (  clk => clk,
                    reset_a => reset_a,
                    buss_in => microcontroller_in,

                    PC_code => PC_code,
                    buss_code => buss_code,

                    ALU_code => ALU_code,
                    ALU1_src_code => ALU1_src_code,
                    ALU2_src_code => ALU2_src_code,

                    memory_address_code => memory_address_code,

                    memory1_write => memory1_write,
                    memory2_write => memory2_write,
                    memory3_write => memory3_write,

                    memory1_read => memory1_read,
                    memory2_read => memory2_read,
                    memory3_read => memory3_read,

                    OP_code => OP_code,
                    M1_code => M1_code,
                    M2_code => M2_code,

                    ADR1_code => ADR1_code,
                    ADR2_code => ADR2_code
        );

    alus: ALU
        port map (  clk => clk,
                    main_buss_in => ALU_in,
                    alu_operation => ALU_operation,
                    alu1_zeroFlag => Z,     -- TODO not direct mapped
                    alu1_source => ALU_src,
                    alu2_source => ALU_src,
                    alu1_out => ALU1_out,
                    alu2_out => ALU2_out
        );

    memory1: Memory_Cell_DualPort
        port map (  clk => clk,
                    read => memory1_read,
                    address_in => memory_address_in,
                    address_out => memory1_address_out,
                    write => memory1_write,
                    data_in => memory1_data_in,
                    data_out => memory1_data_out,
                    data_gpu => memory1_data_gpu,
                    read_gpu => memory1_read_gpu,
                    address_gpu => memory1_address_gpu,
                    active_player => active_player
        );

    memory2: Memory_Cell
        port map (  clk => clk,
                    read => memory2_read,
                    address_in => memory_address_in,
                    address_out => memory2_address_out,
                    write => memory2_write,
                    data_in => memory2_data_in,
                    data_out => memory2_data_out
        );

    memory3: Memory_Cell
        port map (  clk => clk,
                    read => memory3_read,
                    address_in => memory_address_in,
                    address_out => memory3_address_out,
                    write => memory3_write,
                    data_in => memory3_data_in,
                    data_out => memory3_data_out
        );

    -------------------------------------------------------------------------
    -- CLOCK EVENT
    -------------------------------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            -- Sync reset
            if reset_a = '1' then
                reset <= '1';
            elsif reset = '1' then
                reset <= '0';
            end if;

        end if;
    end process;


    -------------------------------------------------------------------------
    -- MEMORY MULTIPLEXERS
    -------------------------------------------------------------------------

    with memory_address_code select
        memory_address_in <= main_buss when "001",
                             ALU1_out when "010",
                             ALU2_out when "011",
                             ADR1 when "100",
                             ADR2 when "101",
                             PC when "110",
                             memory1_address_out when others;

    with OP_code select
        memory1_data_in <= main_buss(7 downto 0) when '1',
                           memory1_data_out when others;

    with M1_code select
        memory2_data_in <= main_buss when "01",
                           ALU1_out when "10",
                           ALU2_out when "11",
                           memory2_data_out when others;

    with M2_code select
        memory3_data_in <= main_buss when "01",
                           ALU1_out when "10",
                           ALU2_out when "11",
                           memory3_data_out when others;

    -------------------------------------------------------------------------
    -- REGISTRY MULTIPLEXERS
    -------------------------------------------------------------------------

    PC <= "0000000000000" when reset = '1' else
          main_buss when PC_code = "01" else
          PC + 1 when PC_code = "10" else
          PC;

    with ADR1_code select
        ADR1 <= main_buss when "01",
                memory2_data_out when "10",
                ALU1_out when "11",
                ADR1 when others;

    with ADR2_code select
        ADR2 <= main_buss when "01",
                memory3_data_out when "10",
                ALU2_out when "11",
                ADR2 when others;

    -------------------------------------------------------------------------
    -- BUSS MEGA-MULTIPLEXER
    -------------------------------------------------------------------------

    with buss_code select
        main_buss <= PC when "000",
                    "00000" & memory1_data_out when "001",
                    ALU1_out when "010",
                    fifo_out when "011",
                    IN_out when "100",
                    main_buss when others;

    -- TODO
    -- Handle +1 and -1 differently! Needs fixing :<
    ALU_operation <= ALU_code(1 downto 0);

end Behavioral;

