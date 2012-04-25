
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

    -- Include all components
    component Microcontroller
        Port (  clk : in std_logic;
                buss_in : in std_logic_vector(7 downto 0);
                PC_code : out std_logic_vector(1 downto 0);
                test : in std_logic_vector(2 downto 0)
        );
    end component;

    component ALU
        Port (  clk : in std_logic;
                main_buss_in : in std_logic_vector(12 downto 0);    -- TODO need dual input, one for each ALU
                alu_operation : in std_logic_vector(1 downto 0);
                alu1_zeroFlag : out std_logic;
                alu1_source : in std_logic_vector(1 downto 0);      -- TODO only 1 bit. Update/don't update
                alu2_source : in std_logic_vector(1 downto 0);      -- TODO only 1 bit. Update/don't update
                alu1_out : out std_logic_vector(12 downto 0);
                alu2_out : out std_logic_vector(12 downto 0)
        );
    end component;

    component Memory_Cell
        Port (  clk : in std_logic;
                read : in std_logic;
                write : in std_logic;
                address_in : in std_logic_vector(12 downto 0);
                address_out : out std_logic_vector(12 downto 0);    -- What does this do?
                data_in : in std_logic_vector(12 downto 0);
                data_out : out std_logic_vector(12 downto 0)
        );
    end component;

    component Memory_Cell_DualPort  -- How to write gpu data?
        Port (  clk : in std_logic;
                read : in std_logic;
                write : in std_logic;
                active_player : in std_logic_vector(1 downto 0);
                address_in : in std_logic_vector(12 downto 0);
                address_out : out std_logic_vector (12 downto 0);   -- What does this do?
                data_in : in std_logic_vector(7 downto 0);
                data_out : out std_logic_vector(7 downto 0);
                address_gpu : in std_logic_vector(12 downto 0);
                data_gpu : out std_logic_vector(7 downto 0);
                read_gpu : in std_logic
        );
    end component;


    -- Module data signals
    signal microcontroller_in : std_logic_vector(7 downto 0);

    signal ALU_in : std_logic_vector(12 downto 0);
    signal ALU1_out : std_logic_vector(12 downto 0);
    signal ALU2_out : std_logic_vector(12 downto 0);

    signal ALU_src : std_logic_vector(1 downto 0);      -- TODO should only need 1 bit
    signal ALU_operation : std_logic_vector(1 downto 0);

    signal memory1_data_in : std_logic_vector(7 downto 0);
    signal memory2_data_in : std_logic_vector(12 downto 0);
    signal memory3_data_in : std_logic_vector(12 downto 0);

    signal memory1_data_out : std_logic_vector(7 downto 0);
    signal memory2_data_out : std_logic_vector(12 downto 0);
    signal memory3_data_out : std_logic_vector(12 downto 0);

    signal memory1_address_in : std_logic_vector(12 downto 0);
    signal memory2_address_in : std_logic_vector(12 downto 0);
    signal memory3_address_in : std_logic_vector(12 downto 0);

    -- What do these do? Shouldn't we simply set memory address nad data in and do write? Address shouldn't come out, or..?
    -- or are we treating it as a register? How do we know when we want to update the register?
    signal memory1_address_out : std_logic_vector(12 downto 0);
    signal memory2_address_out : std_logic_vector(12 downto 0);
    signal memory3_address_out : std_logic_vector(12 downto 0);

    -- TODO need a way to write gpu data
    signal memory1_address_gpu : std_logic_vector(12 downto 0); -- Unsynced!
    signal memory1_data_gpu : std_logic_vector(7 downto 0); -- Unsynced!

    signal memory1_read_gpu : std_logic;

    -- Flow control signals
    signal buss : std_logic_vector(7 downto 0);

    -- Registers
    signal PC : std_logic_vector(12 downto 0);

    -- ADR for mem 1,2,3?
    -- data registers? Or are they inside the memories?

    -- Control signals from microcontroller
    signal PC_code : std_logic_vector(1 downto 0);
    signal IR_code : std_logic;

    signal ALU_code : std_logic_vector(2 downto 0);
    signal ALU1_src_code : std_logic_vector(1 downto 0);
    signal ALU2_src_code : std_logic;

    signal memory1_code : std_logic_vector(1 downto 0);
    signal memory2_code : std_logic_vector(1 downto 0);
    signal memory3_code : std_logic_vector(1 downto 0);

    signal OP_code : std_logic;
    signal M1_code : std_logic_vector(1 downto 0);
    signal M2_code : std_logic_vector(1 downto 0);

    -- Status signals
    signal Z : std_logic := '0';

    -- Other stuff
    signal reset : std_logic := '0';

    -- Temporary/Undecided
    signal memory1_write : std_logic;
    signal memory2_write : std_logic;
    signal memory3_write : std_logic;

    signal memory1_read : std_logic;
    signal memory2_read : std_logic;
    signal memory3_read : std_logic;

    signal active_player : std_logic_vector(1 downto 0);

begin

    micro: Microcontroller
        port map (  clk => clk,
                    buss_in => microcontroller_in,
                    PC_code => PC_code,
                    test => "010"
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
                    address_in => memory1_address_in,
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
                    address_in => memory2_address_in,
                    address_out => memory2_address_out,
                    write => memory2_write,
                    data_in => memory2_data_in,
                    data_out => memory2_data_out
        );

    memory3: Memory_Cell
        port map (  clk => clk,
                    read => memory3_read,
                    address_in => memory3_address_in,
                    address_out => memory3_address_out,
                    write => memory3_write,
                    data_in => memory3_data_in,
                    data_out => memory3_data_out
        );

    -- TODO
    -- Handle +1 and -1 differently! Needs fixing :<
    ALU_operation <= ALU_code(1 downto 0);

    process(clk)
    begin
        if rising_edge(clk) then

            -- Sync reset
            if reset_a = '1' then
                reset <= '1';
            elsif reset = '1' then
                reset <= '0';
            end if;

            -- Handle reset
            if reset = '1' then
                -- TODO do something better here
                ALU_code <= "000";
            end if;
        end if;
    end process;


    -------------------------------------------------------------------------
    -- MEMORY MULTIPLEXERS
    -------------------------------------------------------------------------

    --memory1_address_in<= main_buss when memory1_source_address = "01" else
                                            --memory2_data_out when memory1_source_address = "10" else
                                            --memory1_address_out;
    ---- memory1_address_gpu <= main_buss_in;


    --memory2_address_in<= main_buss when memory2_source_address = "01" else
                                            ----alu1_register when memory2_source_address = "01" else
                                            --memory2_data_out when memory2_source_address = "11" else
                                            --memory2_address_out;
                                        ---- alu2_register when memory2_source = "10" else
                                        ---- main_buss_in;

    --memory3_address_in<= main_buss when memory3_source_address = "01" else
                                        ----alu1_register when memory3_source_address = "10" else
                                        ----alu2_register when memory3_source_address = "11" else
                                        --memory3_address_out;


    --memory1_data_in<= main_buss(7 downto 0) when memory1_source_data = "01" else -- Change this to the OP part of main_buss!
                                                --memory1_data_out;

    --memory2_data_in<= main_buss when memory2_source_data = "01" else
                                                --memory2_data_out;

    --memory3_data_in<= main_buss when memory3_source_data = "01" else
                                                --memory3_data_out;

    --main_buss <=    tmp_buss when buss_controll = "000" else
                    --memory1_data_out & "00000" when buss_controll = "001" else
                    --memory2_data_out when buss_controll = "010" else
                    --memory3_data_out when buss_controll = "011" else
                    --alu1_out when buss_controll = "100" else
                    --alu2_out when buss_controll = "101" else
                    --"000000000000" & alu1_zeroFlag;

    --memory1_read_gpu <= tmp_gpu_read;

    --process(clk)
    --begin
        --if rising_edge(clk) then

        ---- Temporary GPU emulator
        --memory1_address_gpu <= tmp_buss;
        --tmp_gpu_data <= memory1_data_gpu;
        --tmp_gpu_read <= not tmp_gpu_read;

        --end if;
    --end process;

end Behavioral;

