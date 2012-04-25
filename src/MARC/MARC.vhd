
----------------------------------------------------------------------------------
-- Company: LIU
-- Engineer: Jesper Tingvall
-- 
-- Create Date: 21:47:06 04/21/2012
-- Design Name:
-- Module Name: MARC - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MARC is
    Port (  clk : in std_logic;

            tmp_gpu_data : out STD_LOGIC_VECTOR(7 downto 0);
            buss_controll : in STD_LOGIC_VECTOR(2 downto 0);
            tmp_buss : in STD_LOGIC_VECTOR(12 downto 0);

            memory1_source_address : in STD_LOGIC_VECTOR(1 downto 0);
            memory2_source_address : in STD_LOGIC_VECTOR(1 downto 0);
            memory3_source_address : in STD_LOGIC_VECTOR(1 downto 0);

            memory1_source_data : in STD_LOGIC_VECTOR(1 downto 0);
            memory2_source_data : in STD_LOGIC_VECTOR(1 downto 0);
            memory3_source_data : in STD_LOGIC_VECTOR(1 downto 0);

            memory1_read : in STD_LOGIC;
            memory2_read : in STD_LOGIC;
            memory3_read : in STD_LOGIC;

            memory1_write : in STD_LOGIC;
            memory2_write : in STD_LOGIC;
            memory3_write : in STD_LOGIC;


            alu_operation : in STD_LOGIC_VECTOR(1 downto 0);
            alu1_source : in STD_LOGIC_VECTOR(1 downto 0);
            alu2_source : in STD_LOGIC_VECTOR(1 downto 0);

            active_player : in STD_LOGIC_VECTOR(1 downto 0)
    );
end MARC;

architecture Behavioral of MARC is

    -------------------------------------------------------------------------
    -- MEMORY COMPONENTS
    -------------------------------------------------------------------------

    component Memory_Cell
        Port (  clk : in std_logic;
                read : in STD_LOGIC;
                write : in STD_LOGIC;
                address_in : in STD_LOGIC_VECTOR (12 downto 0);
                address_out : out STD_LOGIC_VECTOR (12 downto 0);
                data_in : in STD_LOGIC_VECTOR (12 downto 0);
                data_out : out STD_LOGIC_VECTOR (12 downto 0));
    end component;


    component Memory_Cell_DualPort
        Port (  clk : in STD_LOGIC;
                read : in STD_LOGIC;
                write : in STD_LOGIC;
                active_player : in STD_LOGIC_VECTOR(1 downto 0);
                address_in : in STD_LOGIC_VECTOR (12 downto 0);
                address_out : out STD_LOGIC_VECTOR (12 downto 0);
                data_in : in STD_LOGIC_VECTOR (7 downto 0);
                data_out : out STD_LOGIC_VECTOR (7 downto 0);
                address_gpu : in STD_LOGIC_VECTOR (12 downto 0);
                data_gpu : out STD_LOGIC_VECTOR (7 downto 0);
                read_gpu : in STD_LOGIC);
    end component;

    -------------------------------------------------------------------------
    -- MEMORY SOURCE SIGNALS
    -------------------------------------------------------------------------


    signal memory1_data_in : STD_LOGIC_VECTOR (7 downto 0);
    signal memory2_data_in : STD_LOGIC_VECTOR (12 downto 0);
    signal memory3_data_in : STD_LOGIC_VECTOR (12 downto 0);

    signal memory1_data_out : STD_LOGIC_VECTOR (7 downto 0);
    signal memory2_data_out : STD_LOGIC_VECTOR (12 downto 0);
    signal memory3_data_out : STD_LOGIC_VECTOR (12 downto 0);

    signal memory1_address_in : STD_LOGIC_VECTOR (12 downto 0);
    signal memory2_address_in : STD_LOGIC_VECTOR (12 downto 0);
    signal memory3_address_in : STD_LOGIC_VECTOR (12 downto 0);

    signal memory1_address_out : STD_LOGIC_VECTOR (12 downto 0);
    signal memory2_address_out : STD_LOGIC_VECTOR (12 downto 0);
    signal memory3_address_out : STD_LOGIC_VECTOR (12 downto 0);

    -------------------------------------------------------------------------

    -- Connect these to the GPU:
    signal memory1_address_gpu :STD_LOGIC_VECTOR (12 downto 0); -- Unsynced!
    signal memory1_data_gpu : STD_LOGIC_VECTOR (7 downto 0); -- Unsynced!
    signal memory1_read_gpu : STD_LOGIC;

    -- Memory control
    --signal memory1_read : STD_LOGIC;
    --signal memory2_read : STD_LOGIC;
    --signal memory3_read : STD_LOGIC;

    --signal memory1_write : STD_LOGIC;
    --signal memory2_write : STD_LOGIC;
    --signal memory3_write : STD_LOGIC;


    -- Memory Data source control MUX
    --signal memory1_source_data : STD_LOGIC_VECTOR(1 downto 0);
    -- 01 main buss
    -- xx hold

    --signal memory2_source_data : STD_LOGIC_VECTOR(1 downto 0);
    -- 01 main buss
    -- xx hold

    --signal memory3_source_data : STD_LOGIC_VECTOR(1 downto 0);
    -- 01 main buss
    -- xx hold

    -- Memory Address source control MUX
    --signal memory1_source_address : STD_LOGIC_VECTOR(1 downto 0);
    -- 01 Main buss
    -- 10 Memory 2 data
    -- 11
    -- XX hold

    --signal memory2_source_address : STD_LOGIC_VECTOR(1 downto 0);
    -- 01 main buss
    -- 10 alu1 register
    -- 11 memory 2
    -- xx hold

    --signal memory3_source_address : STD_LOGIC_VECTOR(1 downto 0);
    -- 01 main buss
    -- 10 alu1 register
    -- XX hold

    -------------------------------------------------------------------------
    -- ALU COMPONENT
    -------------------------------------------------------------------------

    component ALU
        Port (  clk : in std_logic;
                main_buss_in : in STD_LOGIC_VECTOR (12 downto 0);
                alu1_source : in STD_LOGIC_VECTOR(1 downto 0);
                alu2_source : in STD_LOGIC_VECTOR(1 downto 0);


                alu_operation : in STD_LOGIC_VECTOR(1 downto 0);
                -- alu1_source : in alu_source_type;


                alu1_zeroFlag : out STD_LOGIC;

                alu1_out : out STD_LOGIC_VECTOR (12 downto 0);
                alu2_out : out STD_LOGIC_VECTOR (12 downto 0)

        );
    end component;

    -------------------------------------------------------------------------
    -- ALU SIGNALS
    -------------------------------------------------------------------------
    signal alu1_zeroFlag : STD_LOGIC;
    signal alu1_out : STD_LOGIC_VECTOR (12 downto 0);
    signal alu2_out : STD_LOGIC_VECTOR (12 downto 0);

    -------------------------------------------------------------------------
    -- MARC SIGNALS
    -------------------------------------------------------------------------


    signal main_buss : STD_LOGIC_VECTOR (12 downto 0);

    -------------------------------------------------------------------------
    -- TMP SIGNALS
    -------------------------------------------------------------------------

    signal tmp_gpu_read : STD_LOGIC := '0';
    signal tmp_gpu_adr_sync : STD_LOGIC_VECTOR(12 downto 0) := "0000000000000";
    signal tmp_gpu_data_sync : STD_LOGIC_VECTOR(7 downto 0);

    begin

        -------------------------------------------------------------------------
        -- MEMORY INITIATION
        -------------------------------------------------------------------------

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
                        active_player => active_player);

        memory2: Memory_Cell
            port map (  clk => clk,
                        read => memory2_read,
                        address_in => memory2_address_in,
                        address_out => memory2_address_out,
                        write => memory2_write,
                        data_in => memory2_data_in,
                        data_out => memory2_data_out);

        memory3: Memory_Cell
            port map (  clk => clk,
                        read => memory3_read,
                        address_in => memory3_address_in,
                        address_out => memory3_address_out,
                        write => memory3_write,
                        data_in => memory3_data_in,
                        data_out => memory3_data_out);


        -------------------------------------------------------------------------
        -- MEMORY MULTIPLEXERS
        -------------------------------------------------------------------------

        memory1_address_in<= main_buss when memory1_source_address = "01" else
                                                memory2_data_out when memory1_source_address = "10" else
                                                memory1_address_out;
        -- memory1_address_gpu <= main_buss_in;


        memory2_address_in<= main_buss when memory2_source_address = "01" else
                                                --alu1_register when memory2_source_address = "01" else
                                                memory2_data_out when memory2_source_address = "11" else
                                                memory2_address_out;
                                            -- alu2_register when memory2_source = "10" else
                                            -- main_buss_in;

        memory3_address_in<= main_buss when memory3_source_address = "01" else
                                            --alu1_register when memory3_source_address = "10" else
                                            --alu2_register when memory3_source_address = "11" else
                                            memory3_address_out;


        memory1_data_in<= main_buss(7 downto 0) when memory1_source_data = "01" else -- Change this to the OP part of main_buss!
                                                    memory1_data_out;

        memory2_data_in<= main_buss when memory2_source_data = "01" else
                                                    memory2_data_out;

        memory3_data_in<= main_buss when memory3_source_data = "01" else
                                                    memory3_data_out;

        -------------------------------------------------------------------------
        -- ALU INITIATION
        -------------------------------------------------------------------------

        alu1: ALU
        port map(   clk=>clk,
                    main_buss_in => main_buss,

                    alu_operation => alu_operation,
                    alu1_source => alu1_source,
                    alu2_source => alu2_source,

                    alu1_zeroFlag => alu1_zeroFlag,

                    alu1_out => alu1_out,
                    alu2_out => alu2_out
        );

        -------------------------------------------------------------------------
        -- BUSS MEGA-MULTIPLEXER
        -------------------------------------------------------------------------

        main_buss <=    tmp_buss when buss_controll = "000" else
                        memory1_data_out & "00000" when buss_controll = "001" else
                        memory2_data_out when buss_controll = "010" else
                        memory3_data_out when buss_controll = "011" else
                        alu1_out when buss_controll = "100" else
                        alu2_out when buss_controll = "101" else
                        "000000000000" & alu1_zeroFlag;

        memory1_read_gpu <= tmp_gpu_read;

        process(clk)
        begin
            if rising_edge(clk) then

            -- Temporary GPU emulator
            memory1_address_gpu <= tmp_buss;
            tmp_gpu_data <= memory1_data_gpu;
            tmp_gpu_read <= not tmp_gpu_read;

            end if;
        end process;

end Behavioral;

