----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:52:00 04/17/2012 
-- Design Name: 
-- Module Name:    vga_clock - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: devide the original clk(100MHz) by 4, and output a 25MHz vga_clock
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

entity vga_clock is
    Port ( clk : in  STD_LOGIC;
           vga_clk : out  STD_LOGIC);
end vga_clock;

architecture Behavioral of vga_clock is
	-- middle clk is 50MHz
	signal middle_clk: STD_LOGIC;
begin
	process(clk)
	begin
		if clk = '1' and clk'event then
			middle_clk <= not clk;
		end if;
	end process;
	process (middle_clk)
	begin
		if middle_clk = '1' and middle_clk'event then
			vga_clk <= not middle_clk;
		end if;
	end process;
	
end Behavioral;

