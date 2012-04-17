----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:44:09 04/16/2012 
-- Design Name: 
-- Module Name:    ram-test - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_test is
	port (clk : in std_logic;
	address : in integer;
	we : in std_logic;
	data_i : in std_logic_vector(7 downto 0);
	data_o : out std_logic_vector(7 downto 0)
	);
end ram_test;




architecture Behavioral of ram_test is
		type ram_t is array (0 to 255) of std_logic_vector(7 downto 0);
			signal ram : ram_t := (others => (others => '0'));
			
		signal address_sync is 
	begin
	--process for read and write operation.
	PROCESS(clk)
	BEGIN
		if(rising_edge(clk)) then
		if(we='1') then
		ram(address) <= data_i;
		end if;
		data_o <= ram(address);
		end if; 
	END PROCESS;
end Behavioral;