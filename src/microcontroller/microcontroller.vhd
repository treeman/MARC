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
        op : in std_logic_vector(7 downto 0);

        -- Test to control shit
        test : in std_logic_vector(2 downto 0);

        -- Control codes
        PC_code : out std_logic
    );
end Microcontroller;

architecture Behavioral of Microcontroller is

    -- Controll the behavior of next uPC value
    signal uPC_code : std_logic_vector(2 downto 0) := "000";
    signal uPC_addr : std_logic_vector(7 downto 0) := "XXXXXXXX";

    signal IR : std_logic_vector(7 downto 0) := "11110011";
    signal uPC : std_logic_vector(7 downto 0) := "00000000";

    -- OP code decodings
    signal op_addr : std_logic_vector(7 downto 0);
    signal A_addr : std_logic_vector(7 downto 0);
    signal B_addr : std_logic_vector(7 downto 0);

    signal Z : std_logic := '0';

    type Memory is array (255 downto 0) of std_logic_vector(2 downto 0);

    signal Mem : Memory;
begin
    Mem(0) <= "000";

    uPC_code <= test;

    process (clk)
    begin
        if rising_edge(clk) then

            -- uPC +1
            if uPC_code = "000" then
                uPC <= uPC + 1;
            -- uPC to OP code
            elsif uPC_code = "001" then
                uPC <= op_addr;
            -- uPC to op A a-mod
            elsif uPC_code = "010" then
                uPC <= A_addr;
            -- uPC to op B a-mod
            elsif uPC_code = "011" then
                uPC <= B_addr;
            -- jmp
            elsif uPC_code = "100" then
                uPC <= uPC_addr;
            -- jmpz
            elsif uPC_code = "101" and Z = '1' then
                uPC <= uPC_addr;
            -- uPC = 0
            elsif uPC_code = "111" then
                uPC <= "00000000";
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

    PC_code <= '1';

end Behavioral;

