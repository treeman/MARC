
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MARC is
    Port (  clk : in std_logic;
            reset_a : in std_logic;

            uCount_limit : in std_logic_vector(7 downto 0);
            fbart_in : in std_logic;

            -- Test upstart load without fbart
            --tmp_has_next_data : in std_logic;
            --tmp_IN : in std_logic_vector(12 downto 0);
            --tmp_request_next_data : out std_logic;

            -- VGA output
            red : out std_logic_vector(2 downto 0);
            grn : out std_logic_vector(2 downto 0);
            blu : out std_logic_vector(1 downto 0);
            HS : out std_logic;
            VS : out std_logic;

            -- Output flags etc
            reset_out : out std_logic;
            game_started_out : out std_logic;
            active_player_out : out std_logic_vector(1 downto 0);
            pad_error : out STD_LOGIC_VECTOR(2 downto 0);
            game_over_out : out std_logic;
            alu1_o : out stD_LOGIC_VECTOR(7 downto 0);
	    player_victory_out : out std_logic_vector(1 downto 0)
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

                uCount_limit : in std_logic_vector(7 downto 0);

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

                Z : in std_logic;
                N : in std_logic;
                both_Z : in std_logic;

                new_IN : in std_logic;
                game_started : in std_logic;
                shall_load : in std_logic;
                game_over : in std_logic
        );
    end component;

    component ALU
        Port (  clk : in std_logic;

                alu_operation : in std_logic_vector(1 downto 0);
                alu1_zeroFlag_out : out std_logic;
                alu1_negFlag : out std_logic;
                alu_zeroFlag : out std_logic;

                alu1_operand : in STD_LOGIC_VECTOR(12 downto 0);
                alu2_operand : in STD_LOGIC_VECTOR(12 downto 0);

                alu1_out : out std_logic_vector(12 downto 0);
                alu2_out : out std_logic_vector(12 downto 0)
        );
    end component;

    component Memory_Cell
        Port (  clk : in std_logic;
                read : in std_logic;
                write : in std_logic;

                reset : in std_logic;

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

    component FBARTController
        Port (  request_next_data : in  STD_LOGIC;
                reset : in  STD_LOGIC;
                clk : in  STD_LOGIC;
                control_signals : out  STD_LOGIC_VECTOR (2 downto 0);
                buss_out : out  STD_LOGIC_VECTOR (12 downto 0);
                has_next_data : out  STD_LOGIC;
                rxd : in std_logic;
                padding_error_out : out STD_LOGIC_VECTOR(2 downto 0)
            );
     end component;

     component PlayerFIFO is
         Port ( current_pc_in : in  STD_LOGIC_VECTOR (12 downto 0);
                current_pc_out : out  STD_LOGIC_VECTOR (12 downto 0);
                current_player_out : out STD_LOGIC;
                game_over_out : out STD_LOGIC;
                next_pc : in  STD_LOGIC;
                write_pc : in STD_LOGIC;
                change_player : in STD_LOGIC;
                clk : in std_logic;
                reset : in std_logic
            );
     end component;

      component vga is
        Port (  rst : in  STD_LOGIC;
                clk : in  STD_LOGIC;
                data_gpu : in  STD_LOGIC_VECTOR (7 downto 0);
                address_gpu : out  STD_LOGIC_VECTOR (12 downto 0);
                red : out  STD_LOGIC_VECTOR (2 downto 0);
                grn : out  STD_LOGIC_VECTOR (2 downto 0);
                blu : out  STD_LOGIC_VECTOR (1 downto 0);
                HS : out  STD_LOGIC;
                VS : out  STD_LOGIC
             );
        end component;

    -------------------------------------------------------------------------
    -- DATA SIGNALS
    -------------------------------------------------------------------------

    -- Module data signals
    signal ALU_in : std_logic_vector(12 downto 0);
    signal ALU1_out : std_logic_vector(12 downto 0);
    signal ALU2_out : std_logic_vector(12 downto 0);

    signal ALU_operation : std_logic_vector(1 downto 0);
    -- 00 hold
    -- 01 load main buss
    -- 10 +
    -- 11 -

    signal memory1_data_in : std_logic_vector(7 downto 0);
    signal memory2_data_in : std_logic_vector(12 downto 0);
    signal memory3_data_in : std_logic_vector(12 downto 0);

    -- Combined to one for now
    signal memory_address_in : std_logic_vector(12 downto 0);
    signal memory_address : std_logic_vector(12 downto 0);


    -------------------------------------------------------------------------
    -- FLOW CONTROL
    -------------------------------------------------------------------------

    -- Flow control signals
    signal main_buss : std_logic_vector(12 downto 0) := "1X1X1X1X1X1X1";

    -- Registers
    signal PC : std_logic_vector(12 downto 0);
    signal ADR1 : std_logic_vector(12 downto 0);
    signal ADR2 : std_logic_vector(12 downto 0);

    -- Memory outputs register values
    signal OP : std_logic_vector(7 downto 0);
    signal M1 : std_logic_vector(12 downto 0);
    signal M2 : std_logic_vector(12 downto 0);

    signal IN_reg : std_logic_vector(12 downto 0);

    -------------------------------------------------------------------------
    -- CONTROL SIGNALS
    -------------------------------------------------------------------------

    signal PC_code : std_logic_vector(1 downto 0);

    signal buss_code : std_logic_vector(2 downto 0);

    signal ALU_code : std_logic_vector(2 downto 0);
    signal ALU1_code : std_logic_vector(1 downto 0);
    signal ALU2_code : std_logic;

    signal alu1_operand : std_logic_vector(12 downto 0);
    signal alu2_operand : std_logic_vector(12 downto 0);

    signal memory_addr_code : std_logic_vector(2 downto 0);

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

    signal FIFO_code : std_logic_vector(1 downto 0);

    signal game_code : std_logic_vector(1 downto 0);

    -------------------------------------------------------------------------
    -- STATUS SIGNALS
    -------------------------------------------------------------------------

    signal Z : std_logic := '0';
    signal N : std_logic := '0';
    signal both_Z : std_logic := '0';

    signal active_player : std_logic_vector(1 downto 0);
    -- Are we executing code as playing?
    signal game_started : std_logic := '0';
    -- Sould we load?
    signal load : std_logic := '0';
    -- Did the play stop? (Will not be game over after reset)
    signal game_over : std_logic := '0';

    signal new_IN : std_logic := '0';
    signal reset : std_logic := '0';

    -------------------------------------------------------------------------
    -- FBART SIGNALS
    -------------------------------------------------------------------------
    signal fbart_request_next_data :  STD_LOGIC := '0';         -- Generate this when we read from FBART into BUSS
    signal fbart_control_signals :   STD_LOGIC_VECTOR (2 downto 0);
    signal rxd : std_logic := '1';

    -------------------------------------------------------------------------
    -- FIFO SIGNALS
    -------------------------------------------------------------------------
    signal fifo_out : std_logic_vector(12 downto 0) := "0010XXXXXXXXX";

    signal fifo_current_player : STD_LOGIC;
    signal fifo_game_over :std_logic;

    signal fifo_next_pc : std_logic := '0';
    signal fifo_write_pc : std_logic := '0';
    signal fifo_change_player : std_logic := '0';

     -------------------------------------------------------------------------
    -- VGA SIGNALS
    -------------------------------------------------------------------------

    signal data_gpu : std_logic_vector (7 downto 0);
    signal data_gpu_out : std_logic_vector (7 downto 0);
    signal address_gpu : std_logic_vector (12 downto 0);
    
begin

    -------------------------------------------------------------------------
    -- TEST SIGNALS
    -------------------------------------------------------------------------

    active_player_out <= active_player;
    reset_out <= reset;
    game_started_out <= game_started;
    game_over_out <= game_over;
    alu1_o <= ALU1_out(12 downto 5);

    -------------------------------------------------------------------------
    -- TEMP AND TESTING
    -------------------------------------------------------------------------

    --new_IN <= tmp_has_next_data;
    --IN_reg <= tmp_IN;
    --tmp_request_next_data <= fbart_request_next_data;

    -------------------------------------------------------------------------
    -- COMPONENT INITIATION
    -------------------------------------------------------------------------

    micro: Microcontroller
        port map (  clk => clk,
                    reset_a => reset_a,
                    buss_in => main_buss(7 downto 0),
                    uCount_limit => uCount_limit,

                    PC_code => PC_code,
                    buss_code => buss_code,

                    ALU_code => ALU_code,
                    ALU1_code => ALU1_code,
                    ALU2_code => ALU2_code,

                    memory_addr_code => memory_addr_code,

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
                    ADR2_code => ADR2_code,

                    FIFO_code => FIFO_code,

                    game_code => game_code,

                    Z => Z,
                    N => N,
                    both_Z => both_Z,
                    new_IN => new_IN,
                    game_started => game_started,
                    shall_load => load,
                    game_over => game_over
        );

    alus: ALU
        port map (  clk => clk,
                    alu_operation => ALU_operation,

                    alu1_zeroFlag_out => Z,
                    alu1_negFlag => N,
                    alu_zeroFlag => both_Z,

                    alu1_operand => alu1_operand,
                    alu2_operand => alu2_operand,
                    alu1_out => ALU1_out,
                    alu2_out => ALU2_out
        );

    memory1: Memory_Cell_DualPort
        port map (  clk => clk,
                    read => memory1_read,
                    address_in => memory_address_in,
                    address_out => memory_address,
                    write => memory1_write,
                    data_in => memory1_data_in,
                    data_out => OP,
                    data_gpu => data_gpu,
                    read_gpu => '1',
                    address_gpu => address_gpu,
                    active_player => active_player
        );

    memory2: Memory_Cell
        port map (  clk => clk,
                    read => memory2_read,
                    address_in => memory_address_in,
                    --address_out => memory2_address_out,
                    write => memory2_write,
                    data_in => memory2_data_in,
                    data_out => M1,
                    reset => reset
        );

    memory3: Memory_Cell
        port map (  clk => clk,
                    read => memory3_read,
                    address_in => memory_address_in,
                    --address_out => memory3_address_out,
                    write => memory3_write,
                    data_in => memory3_data_in,
                    data_out => M2,
                    reset => reset
        );

    fbart: FBARTController
        port map (  clk => clk,
                    request_next_data  => fbart_request_next_data,
                    reset => reset,
                    control_signals => fbart_control_signals,

                    -- Commented when testing
                    buss_out => IN_reg,
                    has_next_data => new_IN,

                    rxd => rxd,
                    padding_error_out => pad_error
        );

    fifo: PlayerFIFO
        port map (  current_pc_in => main_buss,         -- Always connected to main_buss
                    current_pc_out => fifo_out,
                    current_player_out => fifo_current_player,
                    game_over_out => fifo_game_over,
                    next_pc => fifo_next_pc,
                    write_pc => fifo_write_pc,
                    change_player => fifo_change_player,
                    clk => clk,
                    reset => reset
        );

     GPU: vga
            port map (  clk => clk,
                        rst => '0',
                        data_gpu => data_gpu_out,
                        address_gpu => address_gpu,
                        red => red,
                        grn => grn,
                        blu => blu,
                        HS => HS,
                        VS => VS
         );

    -------------------------------------------------------------------------
    -- CLOCK EVENT
    -------------------------------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                rxd <= '1';
            else
                rxd <= fbart_in;
            end if;

	    -- Set victory status
	    if reset = '1' then
		player_victory_out <= "00";
	    elsif game_over = '1' and active_player = "01" then
		player_victory_out <= "10";
	    elsif game_over = '1' and active_player = "10" then
		player_victory_out <= "01";
	    end if;

            -- Set load status
            if reset = '1' then
		load <= '0';
            elsif game_code = "11" then
                load <= '1';
            end if;

            -- Game started, will only set at certain times
            if reset = '1' or game_over = '1' then
                game_started <= '0';
            elsif game_code = "01" then
                game_started <= '1';
            end if;

            -- Game over, will only check at certain times
            if reset = '1' then
                game_over <= '0';
            elsif game_code = "10" then
                game_over <= fifo_game_over;
            end if;

            -- Generating fbart_request_next_data when we read the buss.
--            if buss_code = "110" then
--                fbart_request_next_data <= '1';
--            else
--                fbart_request_next_data <= '0';
--            end if;

            -- Sync reset
            if reset_a = '1' then
                reset <= '1';
            elsif reset = '1' then
                reset <= '0';
            end if;

            -------------------------------------------------------------------------
            -- REGISTRY MULTIPLEXERS
            -------------------------------------------------------------------------

            if reset_a = '1' then
                PC <= "0000000000000";
            elsif PC_code = "01" then
                PC <= main_buss;
            elsif PC_code = "10" then
                PC <= PC + 1;
            elsif PC_code = "11" then
                PC <= (others => '0');
            end if;

            case ADR1_code is
                when "01" => ADR1 <= main_buss;
                when "10" => ADR1 <= M1;
                when "11" => ADR1 <= ALU1_out;
                when others => ADR1 <= ADR1;
            end case;

            case ADR2_code is
                when "01" => ADR2 <= main_buss;
                when "10" => ADR2 <= M2;
                when "11" => ADR2 <= ALU2_out;
                when others => ADR2 <= ADR2;
            end case;

        end if;
    end process;

    -------------------------------------------------------------------------
    -- MEMORY MULTIPLEXERS
    -------------------------------------------------------------------------

    with memory_addr_code select
        memory_address_in <= main_buss when "001",
                             ALU1_out when "010",
                             ALU2_out when "011",
                             ADR1 when "100",
                             ADR2 when "101",
                             PC when "110",
                             memory_address when others;

    with OP_code select
        memory1_data_in <= main_buss(7 downto 0) when '1',
                           OP when others;

    with M1_code select
        memory2_data_in <= main_buss when "01",
                           ALU1_out when "10",
                           ALU2_out when "11",
                           M1 when others;

    with M2_code select
        memory3_data_in <= main_buss when "01",
                           ALU1_out when "10",
                           ALU2_out when "11",
                           M2 when others;

    -------------------------------------------------------------------------
    -- ALU MULTIPLEXERS
    -------------------------------------------------------------------------

    -- This works like follows:
    -- alu operand is the in data to the alu

    -- ALU_code is the control signal which says what the ALU should do

    -- ALU_code has these commands:
    -- 000     nothing
    -- 001     load
    -- 010     add
    -- 011     sub
    -- 100     +1
    -- 101     -1
    -- 110      = 0

    -- ALUx_code states the source
    -- 00      M1
    -- 01      buss
    -- 10      M2
    -- 11      mem_addr

    alu1_operand <= "0000000000000" when ALU_code = "110" else -- = 0
                    "0000000000001" when ALU_code = "100" or ALU_code = "101" else -- +1 or -1
                    M1 when ALU1_code = "00" else
                    M2 when ALU1_code = "10" else
                    memory_address when ALU1_code = "11" else
                    main_buss;

    alu2_operand <= "0000000000000" when ALU_code = "110" else -- = 0
                    "0000000000001" when ALU_code = "100" or ALU_code = "101" else -- +1 or -1
                    M1 when ALU2_code = '0' else
                    M2;

    -- 00 hold
    -- 01 load main buss
    -- 10 +
    -- 11 -
    ALU_operation <= "01" when ALU_code = "001" else -- load
                     "10" when ALU_code = "010" else -- +
                     "11" when ALU_code = "011" else -- -
                     "10" when ALU_code = "100" else -- +1
                     "11" when ALU_code = "101" else -- -1
                     "01" when ALU_code = "110" else
                     "00"; -- hold

    -------------------------------------------------------------------------
    -- FIFO Handling
    -------------------------------------------------------------------------

    fifo_write_pc <= '1' when FIFO_code = "01" else
                     '0';

    fifo_next_pc <= '1' when FIFO_code = "11" else
                    '0';

    fifo_change_player <= '1' when FIFO_code = "10" else
                          '0';

    active_player <= "00" when load = '0' else
                     "01" when fifo_current_player = '0' else
                     "10";

    -------------------------------------------------------------------------
    -- FBARt Handling
    -------------------------------------------------------------------------

    fbart_request_next_data <= '1' when buss_code = "110" else '0';

    -------------------------------------------------------------------------
    -- BUSS MEGA-MULTIPLEXER
    -------------------------------------------------------------------------

    with buss_code select
        main_buss <= PC when "000",
                    "00000" & OP when "001",
                    M1 when "010",
                    M2 when "011",
                    ALU1_out when "100",
                    fifo_out when "101",
                    IN_reg when "110",
                    "0000000000000" when others;
    ---------------------------------------------------------------------------
    -- COLOR HANDLING
    ---------------------------------------------------------------------------

    data_gpu_out <= "10001001" when address_gpu = memory_address and (memory1_read = '1' or memory1_read = '1' or memory1_read = '1') else
		    "11011111" when PC = address_gpu and active_player = "01" else
		    "11111011" when PC = address_gpu and active_player = "10" else
		    data_gpu;
    

    
end Behavioral;

