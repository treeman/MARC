----------------------------------------------------------------------------------
-- Course:      TSEA43
-- Student:     Jesper Tingvall
-- Design Name: MARC
-- Module Name: Memory Cell Dual Port
-- Description: This will behave like a 8192 x 8 bit memory for our OP + addressing modes. It will automagickally calculate some pretty colors for our code. Since this is a dual port memory can our GPU ask it whenever it wants what colors a address holds.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Memory_Cell_DualPort is
    Port ( clk              : in  STD_LOGIC;
           read             : in  STD_LOGIC;
           write            : in  STD_LOGIC;
           active_player    : in  STD_LOGIC_VECTOR(1 downto 0);  -- So we can color our code in pretty colors!
           address_in       : in  STD_LOGIC_VECTOR(12 downto 0);
           address_out      : out STD_LOGIC_VECTOR(12 downto 0);  -- Connect address_in to address_out via a multiplexer
           data_in          : in  STD_LOGIC_VECTOR(7 downto 0);
           data_out         : out STD_LOGIC_VECTOR(7 downto 0); -- Connect data_in to data_out via a multiplexer
           address_gpu      : in  STD_LOGIC_VECTOR(12 downto 0); -- This is not delayed
           data_gpu         : out STD_LOGIC_VECTOR(7 downto 0); -- This is not delayed
           read_gpu         : in  STD_LOGIC);  
end Memory_Cell_DualPort;

architecture Behavioral of Memory_Cell_DualPort is
    signal address_sync         : STD_LOGIC_VECTOR (12 downto 0);
    signal data_sync            : STD_LOGIC_VECTOR (7 downto 0);

    signal calculated_color : STD_LOGIC_VECTOR (7 downto 0);

    type ram_block_type is array (0 to 1023) of std_logic_vector(15 downto 0);

    

	
    signal ram_block_0 : ram_block_type := (others => (others => '0'));
    signal ram_block_1 : ram_block_type := (others => (others => '0'));
    signal ram_block_2 : ram_block_type := (others => (others => '0'));
    signal ram_block_3 : ram_block_type := (others => (others => '0'));
    signal ram_block_4 : ram_block_type := (others => (others => '0'));
    signal ram_block_5 : ram_block_type := (others => (others => '0'));
    signal ram_block_6 : ram_block_type := (others => (others => '0'));
    signal ram_block_7 : ram_block_type := (others => (others => '0'));

begin

    address_out <= address_sync;
    data_out <= data_sync;

    -- Colorifier
    -- COLOR IS LIKE THIS BB GGG RRR
    -- This determines the color depending on what player put what there and what kind of OP code it is (data / non data)
    calculated_color <=     "00000000" when active_player = "00" else                       -- DAT 0 0, black!

                            "00000010" when active_player = "01" and data_sync(7 downto 4) = "0000" else    -- Player 1 data
                            "00000101" when active_player = "01" and (data_sync(7 downto 4) = "0010" or data_sync(7 downto 4) = "0011") else    -- Player 1 aritmetic
                            "00000111" when active_player = "01" and (data_sync(7 downto 4) = "0100" or data_sync(7 downto 4) = "0101" or data_sync(7 downto 4) = "0110" or data_sync(7 downto 4) = "1001")  else    -- Player 1 Jumps
                            --"00000110" when active_player = "01" and (data_sync(7 downto 4) = "0111" or data_sync(7 downto 4) = "1000")  else    -- Player 1 Compares
                 
                            "00000110" when active_player = "01" else    -- Player 1 misc

                            "00010000" when active_player = "10" and data_sync(7 downto 4) = "0000" else    -- Player 2 data
                            "00101000" when active_player = "10" and (data_sync(7 downto 4) = "0010" or data_sync(7 downto 4) = "0011") else    -- Player 2 aritmetic
                            "00111000" when active_player = "10" and (data_sync(7 downto 4) = "0100" or data_sync(7 downto 4) = "0101" or data_sync(7 downto 4) = "0110" or data_sync(7 downto 4) = "1001")  else    -- Player 2 Jumps
                            "00110000" when active_player = "10" else    -- Player 2 misc
                            "11111111";

    -- Use this if we want even prettier colors!
    --calculated_color <= active_player & data_sync(7 downto 4) & "00";

    PROCESS(clk) begin
        if(rising_edge(clk)) then

            address_sync <= address_in;
            data_sync <= data_in;

            -- Write and read OP
			
            if (address_sync(12 downto 10) = "000") then
                if(write='1') then
                    ram_block_0(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color; -- First OP then color!
                end if;
                if (read='1') then
                    data_sync <= ram_block_0(to_integer(unsigned(address_sync(9 downto 0))))(15 downto 8);
                end if;


            elsif (address_sync(12 downto 10) = "001") then
                if(write='1') then
                    ram_block_1(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color;
                end if;
                if (read='1') then
                    data_sync <= ram_block_1(to_integer(unsigned(address_sync(9 downto 0))))(15 downto 8);
                end if;


            elsif (address_sync(12 downto 10) = "010") then
                if(write='1') then
                    ram_block_2(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color;
                end if;
                if (read='1') then
                    data_sync <= ram_block_2(to_integer(unsigned(address_sync(9 downto 0))))(15 downto 8);
                end if;


            elsif (address_sync(12 downto 10) = "011") then
                if(write='1') then
                    ram_block_3(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color;
                end if;
                if (read='1') then
                    data_sync <= ram_block_3(to_integer(unsigned(address_sync(9 downto 0))))(15 downto 8);
                end if;


            elsif (address_sync(12 downto 10) = "100") then
                if(write='1') then
                    ram_block_4(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color;
                end if;
                if (read='1') then
                    data_sync <= ram_block_4(to_integer(unsigned(address_sync(9 downto 0))))(15 downto 8);
                end if;


            elsif (address_sync(12 downto 10) = "101") then
                if(write='1') then
                    ram_block_5(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color;
                end if;
                if (read='1') then
                    data_sync <= ram_block_5(to_integer(unsigned(address_sync(9 downto 0))))(15 downto 8);
                end if;


            elsif (address_sync(12 downto 10) = "110") then
                if(write='1') then
                    ram_block_6(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color;
                end if;
                if (read='1') then
                    data_sync <= ram_block_6(to_integer(unsigned(address_sync(9 downto 0))))(15 downto 8);
                end if;


            else
                if(write='1') then
                    ram_block_7(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color;
                end if;
                if (read='1') then
                    data_sync <= ram_block_7(to_integer(unsigned(address_sync(9 downto 0))))(15 downto 8);
                end if;

            end if;


            -- Read GPU
            if (address_gpu(12 downto 10) = "000") then
                if (read_gpu='1') then
                    data_gpu <= ram_block_0(to_integer(unsigned(address_gpu(9 downto 0))))(7 downto 0);
                end if;

            elsif (address_gpu(12 downto 10) = "001") then
                if (read_gpu='1') then
                    data_gpu <= ram_block_1(to_integer(unsigned(address_gpu(9 downto 0))))(7 downto 0);
                end if;

            elsif (address_gpu(12 downto 10) = "010") then
                if (read_gpu='1') then
                    data_gpu <= ram_block_2(to_integer(unsigned(address_gpu(9 downto 0))))(7 downto 0);
                end if;

            elsif (address_gpu(12 downto 10) = "011") then
                if (read_gpu='1') then
                    data_gpu <= ram_block_3(to_integer(unsigned(address_gpu(9 downto 0))))(7 downto 0);
                end if;

            elsif (address_gpu(12 downto 10) = "100") then
                if (read_gpu='1') then
                    data_gpu <= ram_block_4(to_integer(unsigned(address_gpu(9 downto 0))))(7 downto 0);
                end if;

            elsif (address_gpu(12 downto 10) = "101") then
                if (read_gpu='1') then
                    data_gpu <= ram_block_5(to_integer(unsigned(address_gpu(9 downto 0))))(7 downto 0);
                end if;

            elsif (address_gpu(12 downto 10) = "110") then
                if (read_gpu='1') then
                    data_gpu <= ram_block_6(to_integer(unsigned(address_gpu(9 downto 0))))(7 downto 0);
                end if;

            else
                if (read_gpu='1') then
                    data_gpu <= ram_block_7(to_integer(unsigned(address_gpu(9 downto 0))))(7 downto 0);
                end if;
            end if;

        end if;
    END PROCESS;

end Behavioral;

