----------------------------------------------------------------------------------
-- Company:        LIU
-- Engineer:       Jesper Tingvall
--
-- Create Date:    15:08:02 04/16/2012
-- Design Name:
-- Module Name:    memory_cell - Behavioral
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory_Cell is
    Port (  clk             	: in std_logic;
				reset					: in std_logic;
				read            	: in STD_LOGIC;			-- This does nothing! :<
				write       		: in  STD_LOGIC;
				address_in  		: in  STD_LOGIC_VECTOR (12 downto 0);
				address_out 		: out  STD_LOGIC_VECTOR (12 downto 0);
				data_in         	: in  STD_LOGIC_VECTOR (12 downto 0);
				data_out    		: out  STD_LOGIC_VECTOR (12 downto 0));
				--dataOut : out  STD_LOGIC_VECTOR (12 downto 0));
end Memory_Cell;

architecture Behavioral of memory_cell is
    signal address_sync     : STD_LOGIC_VECTOR (12 downto 0);

    signal data_sync        : STD_LOGIC_VECTOR (12 downto 0);

    type ram_block_type is array (0 to 1023) of std_logic_vector(12 downto 0);

    --signal ram_block_0 : ram_block_type := (others => (others => '0'));

    -- Testing purposes!
    signal ram_block_0 : ram_block_type := (
        --"0000000000000",
        --"0000000000001",
        --"0000000000010",
        --"0000000000011",
        --"0000000000100",
        --"0000000000101",
        --"0000000000110",
        --"0000000001000",
        --"0000000001001",
        --"0000000001010",
        --"0000000001011",
        --"0000000001100",
        --"0000000001101",
        --"0000000001110",
        --"0000000001111",

        others => (others => '0')
    );
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

