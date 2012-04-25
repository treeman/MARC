----------------------------------------------------------------------------------
-- Company:        LIU
-- Engineer:       Jesper Tingvall
--
-- Create Date:    11:56:42 04/17/2012
-- Design Name:
-- Module Name:    ALU - Behavioral
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


entity ALU is
    Port (  clk                 : in std_logic;
                main_buss_in    : in  STD_LOGIC_VECTOR (12 downto 0);
                main_buss_out   : out  STD_LOGIC_VECTOR (12 downto 0);

                -- Connect these to the GPU:
                memory1_address_gpu : in STD_LOGIC_VECTOR (12 downto 0);        -- Unsynced!
                memory1_data_gpu : out  STD_LOGIC_VECTOR (7 downto 0);      -- Unsynced!
                memory1_read_gpu: in STD_LOGIC;

                -- Memory control
                memory1_read    : in STD_LOGIC;
                memory2_read    : in STD_LOGIC;
                memory3_read    : in STD_LOGIC;

                memory1_write   : in STD_LOGIC;
                memory2_write   : in STD_LOGIC;
                memory3_write   : in STD_LOGIC;


                -- Memory Data source control MUX
                memory1_source_data : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 01 main buss
                    -- xx hold

                memory2_source_data : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 01 main buss
                    -- xx hold

                memory3_source_data : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 01 main buss
                    -- xx hold

                -- Memory Address source control MUX
                memory1_source_address  : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 01 Main buss
                    -- 10 Memory 2 data
                    -- 11
                    -- XX hold

                memory2_source_address  : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 00 main buss
                    -- 01 alu1 register
                    -- 10 memory 2
                    -- xx hold

                memory3_source_address  : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 00
                    -- 01 main buss
                    -- 10 alu1 register
                    -- XX hold


                -- ALU Control
                alu_operation   : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 00 hold
                    -- 01 load main buss
                    -- 10 +
                    -- xx -
                alu1_zeroFlag   : out STD_LOGIC;

                -- ALU Control mux
                alu1_source     : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 001 memory 2
                    -- 010 main buss
                    -- xxx memory 3

                alu2_source     : in STD_LOGIC_VECTOR(1 downto 0);
                    -- 001 memory 2
                    -- 010 main buss
                    -- xxx memory 3

                -- Buss output mux (remove this and use global mux controll?)
                buss_output     : in STD_LOGIC_VECTOR(2 downto 0);

                active_player   : in STD_LOGIC_VECTOR(1 downto 0));
end ALU;

architecture Behavioral of ALU is

    --type alu_source_type is (memory, buss, alu);

    component Memory_Cell
        Port (  clk         : in std_logic;
                    read        : in STD_LOGIC;
                    write   : in  STD_LOGIC;
                    address_in  : in  STD_LOGIC_VECTOR (12 downto 0);
                    address_out     :out  STD_LOGIC_VECTOR (12 downto 0);
                    data_in     : in  STD_LOGIC_VECTOR (12 downto 0);
                    data_out : out  STD_LOGIC_VECTOR (12 downto 0));
    end component;


    component Memory_Cell_DualPort
        Port (clk               : in  STD_LOGIC;
           read                 : in  STD_LOGIC;
           write                : in  STD_LOGIC;
              active_player : in STD_LOGIC_VECTOR(1 downto 0);
           address_in   : in  STD_LOGIC_VECTOR (12 downto 0);
              address_out   : out  STD_LOGIC_VECTOR (12 downto 0);
           data_in          : in  STD_LOGIC_VECTOR (7 downto 0);
              data_out          : out  STD_LOGIC_VECTOR (7 downto 0);
           address_gpu      : in  STD_LOGIC_VECTOR (12 downto 0);
           data_gpu             : out  STD_LOGIC_VECTOR (7 downto 0);
           read_gpu             : in  STD_LOGIC);
    end component;

    signal memory1_data_in  : STD_LOGIC_VECTOR (7 downto 0);
    -- signal memory1_data_gpu  : STD_LOGIC_VECTOR (12 downto 0);
    signal memory2_data_in  : STD_LOGIC_VECTOR (12 downto 0);
    signal memory3_data_in  : STD_LOGIC_VECTOR (12 downto 0);

    signal memory1_data_out : STD_LOGIC_VECTOR (7 downto 0);
    signal memory2_data_out : STD_LOGIC_VECTOR (12 downto 0);
    signal memory3_data_out : STD_LOGIC_VECTOR (12 downto 0);

    signal alu1_register        : STD_LOGIC_VECTOR (12 downto 0);
    signal alu2_register        : STD_LOGIC_VECTOR (12 downto 0);


    signal memory1_address_in   : STD_LOGIC_VECTOR (12 downto 0);
    signal memory2_address_in   : STD_LOGIC_VECTOR (12 downto 0);
    signal memory3_address_in   : STD_LOGIC_VECTOR (12 downto 0);

    signal memory1_address_out  : STD_LOGIC_VECTOR (12 downto 0);
    signal memory2_address_out  : STD_LOGIC_VECTOR (12 downto 0);
    signal memory3_address_out  : STD_LOGIC_VECTOR (12 downto 0);

    signal alu1_operand     : STD_LOGIC_VECTOR (12 downto 0);
    signal alu2_operand     : STD_LOGIC_VECTOR (12 downto 0);



begin

    alu1_operand <= memory2_data_out when alu1_source = "10" else
                            main_buss_in when alu1_source = "01" else
                            memory3_data_out;
                            -- Insert constants here!

    alu2_operand <= memory2_data_out when alu2_source = "10" else
                            main_buss_in when alu2_source = "01" else
                            memory3_data_out;
                            -- Insert constants here!

    main_buss_out <=    alu1_register when  buss_output = "001" else
                            alu2_register when  buss_output = "010" else
                            -- memory1_data & "00000" when  buss_output = "011" else
                            memory2_data_out when   buss_output = "100" else
                            memory3_data_out when   buss_output = "101" else
                            main_buss_in;

    memory1_address_in<= main_buss_in       when memory1_source_address = "01" else
                            memory2_data_out    when memory1_source_address = "10" else
                            memory1_address_out;
    -- memory1_address_gpu <= main_buss_in;


    memory2_address_in<=    main_buss_in        when memory2_source_address = "01" else
                            alu1_register       when memory2_source_address = "01" else
                            memory2_data_out    when memory2_source_address = "11" else
                            memory2_address_out;
                    --      alu2_register when  memory2_source = "10" else
                    --      main_buss_in;

    memory3_address_in<=    main_buss_in when   memory3_source_address = "01" else
                            alu1_register when  memory3_source_address = "10" else
                            alu2_register when  memory3_source_address = "11" else
                            memory3_address_out;


    memory1_data_in<=   main_buss_in(7 downto 0) when memory1_source_data = "01" else
                            memory1_data_out;

    memory2_data_in<=   main_buss_in when memory2_source_data = "01" else
                            memory2_data_out;

    memory3_data_in<=   main_buss_in when memory3_source_data = "01" else
                            memory3_data_out;

    process(clk)
        variable z: std_logic := '0';
    begin
        if rising_edge(clk) then

            if alu_operation="00" then
                alu1_register <= alu1_register;                     -- ALU1 = ALU1
            elsif alu_operation="01" then
                alu1_register <= alu1_operand;                      -- ALU1 = OP1
            elsif alu_operation="10" then
                alu1_register <= alu1_register+alu1_operand;        -- ALU1 += OP1
            else
                alu1_register <= alu1_register-alu1_operand;        -- ALU1 -= OP1

                --for i in 12 downto 0 loop
                --  z := z or alu1_register(i);
                --end loop;
                --alu1_zeroFlag <= z;                                       -- Set zero flag (invert this?)

            end if;


            if alu_operation="00" then
                alu2_register <= alu2_register;                     -- ALU2 = ALU2
            elsif alu_operation="01" then
                alu2_register <= alu2_operand;                      -- ALU1 = OP1
            elsif alu_operation="10" then
                alu2_register <= alu2_register+alu2_operand;        -- ALU2 += OP2
            else
                alu2_register <= alu2_register-alu2_operand;        -- ALU2 -= OP2
            end if;

        end if;
    end process;

    memory1: Memory_Cell_DualPort
        port map (  clk=>clk,
                        read=>memory1_read,
                        address_in=>memory1_address_in,
                        address_out=>memory1_address_out,
                        write=>memory1_write,
                        data_in=>memory1_data_in,
                        data_out=>memory1_data_out,
                        data_gpu=>memory1_data_gpu,
                        read_gpu=>memory1_read_gpu,
                        address_gpu=>memory1_address_gpu,
                        active_player=>active_player);

    memory2: Memory_Cell
        port map (  clk=>clk,
                        read=>memory2_read,
                        address_in=>memory2_address_in,
                        address_out=>memory2_address_out,
                        write=>memory2_write,
                        data_in=>memory2_data_in,
                        data_out=>memory2_data_out);

    memory3: Memory_Cell
        port map (  clk=>clk,
                        read=>memory3_read,
                        address_in=>memory3_address_in,
                        address_out=>memory3_address_out,
                        write=>memory3_write,
                        data_in=>memory3_data_in,
                        data_out=>memory3_data_out);
end Behavioral;
