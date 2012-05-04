----------------------------------------------------------------------------------
-- Company: LIU
-- Engineer: Jesper Tingvall
--
-- Create Date: 11:56:42 04/17/2012
-- Design Name:
-- Module Name: ALU - Behavioral
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
    Port (  clk : in std_logic;

            -- ALU Control
            alu_operation : in STD_LOGIC_VECTOR(2 downto 0);
            -- 000 hold
            -- 001 load main buss
            -- 010 +
            -- 011 -
            -- 100 <

            alu1_zeroFlag : out STD_LOGIC;
            alu2_zeroFlag : out STD_LOGIC;

            alu1_operand : in STD_LOGIC_VECTOR(12 downto 0);
            alu2_operand : in STD_LOGIC_VECTOR(12 downto 0);

            alu1_out : out STD_LOGIC_VECTOR (12 downto 0);
            alu2_out : out STD_LOGIC_VECTOR (12 downto 0)
        );
end ALU;

architecture Behavioral of ALU is

    signal alu1_register : STD_LOGIC_VECTOR (12 downto 0);
    signal alu2_register : STD_LOGIC_VECTOR (12 downto 0);

    -- 2 complements comparison of alu1_register < alu2_register
    signal comp : STD_LOGIC;

begin

    -- Compare 2-complement
    comp <= '1' when alu1_register(12) = alu1_operand(12)
                     and conv_integer(alu1_register) < conv_integer(alu1_operand) else
            '1' when alu1_register(12) = '1' and alu1_operand(12) = '0' else
            '0';

    alu1_zeroFlag <= comp when alu_operation = "100" else
                     '1' when alu1_register = "0000000000000" else
                     '0';

    alu2_zeroFlag <= '1' when alu2_register = "0000000000000" else
                     '0';

    alu1_out <= alu1_register;
    alu2_out <= alu2_register;

    process(clk)
    begin
        if rising_edge(clk) then

            if alu_operation="000" then
                alu1_register <= alu1_register; -- ALU1 = ALU1
                alu2_register <= alu2_register; -- ALU2 = ALU2
            elsif alu_operation="001" then
                alu1_register <= alu1_operand; -- ALU1 = OP1
                alu2_register <= alu2_operand; -- ALU1 = OP1
            elsif alu_operation="010" then
                alu1_register <= alu1_register+alu1_operand; -- ALU1 += OP1
                alu2_register <= alu2_register+alu2_operand; -- ALU2 += OP2
            elsif alu_operation="011" then
                alu1_register <= alu1_register-alu1_operand; -- ALU1 -= OP1
                alu2_register <= alu2_register-alu2_operand; -- ALU2 -= OP2
            end if;

        end if;
    end process;

end Behavioral;

