----------------------------------------------------------------------------------
-- Course:      TSEA43
-- Student:     Jesper Tingvall
-- Design Name: MARC
-- Module Name: Memory Cell
-- Description: This will behave like a 8192 x 13 bit memory.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Memory_Cell is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            read        : in STD_LOGIC;
            write       : in  STD_LOGIC;
            address_in  : in  STD_LOGIC_VECTOR (12 downto 0);
            address_out : out  STD_LOGIC_VECTOR (12 downto 0);
            data_in     : in  STD_LOGIC_VECTOR (12 downto 0);
            data_out    : out  STD_LOGIC_VECTOR (12 downto 0));
end Memory_Cell;

architecture Behavioral of memory_cell is
    signal address_sync     : STD_LOGIC_VECTOR (12 downto 0);
    signal data_sync        : STD_LOGIC_VECTOR (12 downto 0);

    type ram_block_type is array (0 to 1023) of std_logic_vector(12 downto 0);

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

    -- Write or read data to the correct memory block.
    PROCESS(clk) begin
        if(rising_edge(clk)) then
      
                address_sync <= address_in;
                data_sync <= data_in;

                if (address_sync(12 downto 10) = "000") then
                     if(write='1') then
                          ram_block_0(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync;
                     end if;
                     if (read='1') then
                          data_sync <= ram_block_0(to_integer(unsigned(address_sync(9 downto 0))));
                     end if;

                elsif (address_sync(12 downto 10) = "001") then
                     if(write='1') then
                          ram_block_1(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync;
                     end if;
                     if (read='1') then
                          data_sync <= ram_block_1(to_integer(unsigned(address_sync(9 downto 0))));
                     end if;

                elsif (address_sync(12 downto 10) = "010") then
                     if(write='1') then
                          ram_block_2(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync;
                     end if;
                     if (read='1') then
                          data_sync <= ram_block_2(to_integer(unsigned(address_sync(9 downto 0))));
                     end if;

                elsif (address_sync(12 downto 10) = "011") then
                     if(write='1') then
                          ram_block_3(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync;
                     end if;
                     if (read='1') then
                          data_sync <= ram_block_3(to_integer(unsigned(address_sync(9 downto 0))));
                     end if;

                elsif (address_sync(12 downto 10) = "100") then
                     if(write='1') then
                          ram_block_4(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync;
                     end if;
                     if (read='1') then
                          data_sync <= ram_block_4(to_integer(unsigned(address_sync(9 downto 0))));
                     end if;

                elsif (address_sync(12 downto 10) = "101") then
                     if(write='1') then
                          ram_block_5(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync;
                     end if;
                     if (read='1') then
                          data_sync <= ram_block_5(to_integer(unsigned(address_sync(9 downto 0))));
                     end if;

                elsif (address_sync(12 downto 10) = "110") then
                     if(write='1') then
                          ram_block_6(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync;
                     end if;
                     if (read='1') then
                          data_sync <= ram_block_6(to_integer(unsigned(address_sync(9 downto 0))));
                     end if;

                else
                     if(write='1') then
                          ram_block_7(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync;
                     end if;
                     if (read='1') then
                          data_sync <= ram_block_7(to_integer(unsigned(address_sync(9 downto 0))));
                     end if;
                end if;
        end if;
    END PROCESS;

end Behavioral;

