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

entity test is
    Port(
        -- Our clock
        clk : in std_logic;

        a : in std_logic;
        b : in std_logic;

        res : out std_logic
    );

end test;

architecture Behavioral of test is

begin

    process (clk)
    begin
        if rising_edge(clk) then
            res <= a or b;
        end if;
    end process;

end Behavioral;

