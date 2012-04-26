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
            alu_operation : in STD_LOGIC_VECTOR(1 downto 0);
            -- 00 hold
            -- 01 load main buss
            -- 10 +
            -- xx -

            alu1_zeroFlag : out STD_LOGIC;
				
				alu1_operand : in STD_LOGIC_VECTOR(12 downto 0);
				alu2_operand : in STD_LOGIC_VECTOR(12 downto 0);

            

            alu1_out : out STD_LOGIC_VECTOR (12 downto 0);
            alu2_out : out STD_LOGIC_VECTOR (12 downto 0)
        );
end ALU;

architecture Behavioral of ALU is

    signal alu1_register : STD_LOGIC_VECTOR (12 downto 0);
    signal alu2_register : STD_LOGIC_VECTOR (12 downto 0);

   

begin

   
    -- Insert constants here!


    alu1_out <= alu1_register;
    alu2_out <= alu2_register;

    process(clk)
        variable z: std_logic := '0';
    begin
        if rising_edge(clk) then

            if alu_operation="00" then
                alu1_register <= alu1_register; -- ALU1 = ALU1
            elsif alu_operation="01" then
                alu1_register <= alu1_operand; -- ALU1 = OP1
            elsif alu_operation="10" then
                alu1_register <= alu1_register+alu1_operand; -- ALU1 += OP1
            else
                alu1_register <= alu1_register-alu1_operand; -- ALU1 -= OP1

                for i in 12 downto 0 loop
                    z := z or alu1_register(i);
                end loop;
                    alu1_zeroFlag <= z; -- Set zero flag (invert this?)

            end if;


            if alu_operation="00" then
                alu2_register <= alu2_register; -- ALU2 = ALU2
            elsif alu_operation="01" then
                alu2_register <= alu2_operand; -- ALU1 = OP1
            elsif alu_operation="10" then
                alu2_register <= alu2_register+alu2_operand; -- ALU2 += OP2
            else
                alu2_register <= alu2_register-alu2_operand; -- ALU2 -= OP2
            end if;

        end if;
    end process;

end Behavioral;

