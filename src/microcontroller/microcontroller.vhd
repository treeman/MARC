----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    18:17:55 04/15/2012
-- Design Name:
-- Module Name:    test - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Microcontroller is
    Port(
        -- Our clock
        clk : in std_logic;

        -- Buss input
        buss_in : in std_logic_vector(7 downto 0);

        -- Test to control shit
        test : in std_logic_vector(2 downto 0);

        -- Control codes
        PC_code : out std_logic
    );
end Microcontroller;

architecture Behavioral of Microcontroller is

    -- Microcode lives here
    subtype DataLine is std_logic_vector(13 downto 0);
    type Data is array (0 to 255) of DataLine;

    -- uCount PC uPC  uPC adr
    -- |00   |0 |000|00000000|
    signal mem : Data := (
        "00000000000000", -- nothing
        "00100011110000", -- +1 PC
        "01000000001111", -- set Z if uCounter >= limit
        "00010100000110", -- jmpz to line 6
        "11000000000000", -- reset uCounter
        "00011100000000", -- Never gonna happen
        "00011111111111", -- line 6, reset uPC
        others => (others => '0')
    );

    -- Current microcode line to process
    signal signals : DataLine;

    -- Controll the behavior of next uPC value
    signal uPC_code : std_logic_vector(2 downto 0) := "000";
    signal uPC_addr : std_logic_vector(7 downto 0) := "XXXXXXXX";

    signal uCounter : std_logic_vector(7 downto 0) := "00000000";
    signal uCount_limit : std_logic_vector(7 downto 0) := "00000010";
    signal uCount_code : std_logic_vector(1 downto 0) := "00";

    signal IR : std_logic_vector(7 downto 0) := "11110011";
    signal uPC : std_logic_vector(7 downto 0) := "00000000";

    -- OP code decodings
    signal op_addr : std_logic_vector(7 downto 0);
    signal A_addr : std_logic_vector(7 downto 0);
    signal B_addr : std_logic_vector(7 downto 0);

    signal Z : std_logic := '0';
begin
    uPC_addr <= signals(7 downto 0);
    uPC_code <= signals(10 downto 8);
    PC_code <= signals(11);
    uCount_code <= signals(13 downto 12);

    process (clk)
    begin
        if rising_edge(clk) then

            signals <= mem(conv_integer(uPC));

            -- Update uPC
            if uPC_code = "000" then
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
            if uCount_code = "00" then
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

        end if;
    end process;

    -- TODO proper address decodings

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

end Behavioral;

