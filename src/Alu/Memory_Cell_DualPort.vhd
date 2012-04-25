----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    11:38:38 04/18/2012
-- Design Name:
-- Module Name:    Memory_Cell_DualPort - Behavioral
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

entity Memory_Cell_DualPort is
    Port ( clk              : in  STD_LOGIC;
           read                 : in  STD_LOGIC;
           write                : in  STD_LOGIC;
              active_player : in STD_LOGIC_VECTOR(1 downto 0);
           address_in   : in  STD_LOGIC_VECTOR (12 downto 0);
              address_out   : out  STD_LOGIC_VECTOR (12 downto 0);
              data_in           : in  STD_LOGIC_VECTOR (7 downto 0);
              data_out          : out  STD_LOGIC_VECTOR (7 downto 0);
           address_gpu      : in  STD_LOGIC_VECTOR (12 downto 0);
           data_gpu             : out  STD_LOGIC_VECTOR (7 downto 0);
           read_gpu             : in  STD_LOGIC);
end Memory_Cell_DualPort;

architecture Behavioral of Memory_Cell_DualPort is
    signal address_sync         : STD_LOGIC_VECTOR (12 downto 0);
    signal data_sync            : STD_LOGIC_VECTOR (7 downto 0);
    -- signal address_gpu_sync : STD_LOGIC_VECTOR (12 downto 0);

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

    -- This determines the color depending on what player put what there and what kind of OP code it is (data / non data)
    calculated_color <=     "00000000" when active_player = "00" else                                               -- Black when no player
                                "11000000" when active_player = "10" and data_sync(7 downto 4) = "0000" else        -- Weak red when player 1 and data
                                "00001000" when active_player = "01" and data_sync(7 downto 4) = "0000" else        -- Weak blue when player 2 and data
                                "11100000" when active_player = "10" else                                               -- Red when player 1 and code
                                "00011000";                                                                                     -- Blue when player 2 and code

    PROCESS(clk) begin
        if(rising_edge(clk)) then

            address_sync <= address_in;
            data_sync <= data_in;
            -- address_gpu_sync <= address_gpu;

            if (address_sync(12 downto 10) = "000") then
                if(write='1') then
                    ram_block_0(to_integer(unsigned( address_sync(9 downto 0) ))) <= data_sync & calculated_color;
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


            -- GPU ADDRESS
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

