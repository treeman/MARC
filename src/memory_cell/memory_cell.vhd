----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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
    Port ( clk : in std_logic;
           read : in STD_LOGIC;
			  write : in  STD_LOGIC;
           address : in  STD_LOGIC_VECTOR (12 downto 0);
           dataIn : in  STD_LOGIC_VECTOR (12 downto 0);
			  dataOut : out  STD_LOGIC_VECTOR (12 downto 0));
end Memory_Cell;

architecture Behavioral of memory_cell is


	type ram_block_type is array (0 to 1023) of std_logic_vector(12 downto 0);
	--type ram_block_type is array (0 to 900) of std_logic_vector(12 downto 0);
	-- Suck, om man ändå visste hur man skulle göra en array och loopa över den!
	
	signal ram_block_0 : ram_block_type := (others => (others => '0'));
	signal ram_block_1 : ram_block_type := (others => (others => '0'));
	signal ram_block_2 : ram_block_type := (others => (others => '0'));
	signal ram_block_3 : ram_block_type := (others => (others => '0'));
	signal ram_block_4 : ram_block_type := (others => (others => '0'));
	signal ram_block_5 : ram_block_type := (others => (others => '0'));
	signal ram_block_6 : ram_block_type := (others => (others => '0'));
	signal ram_block_7 : ram_block_type := (others => (others => '0'));

--	signal ram_block_0: array (0 to 1023) of std_logic_vector(12 downto 0);
--	signal ram_block_1: array (0 to 1023) of std_logic_vector(12 downto 0);
--	signal ram_block_2: array (0 to 1023) of std_logic_vector(12 downto 0);
--	signal ram_block_3: array (0 to 1023) of std_logic_vector(12 downto 0);
--	signal ram_block_4: array (0 to 1023) of std_logic_vector(12 downto 0);
--	signal ram_block_5: array (0 to 1023) of std_logic_vector(12 downto 0);
--	signal ram_block_6: array (0 to 1023) of std_logic_vector(12 downto 0);
--	signal ram_block_7: array (0 to 1023) of std_logic_vector(12 downto 0);


begin


	PROCESS(clk) begin
		if(rising_edge(clk)) then
		
			if (address(12 downto 10) = "000") then
				if(write='1') then
					ram_block_0(to_integer(unsigned( address(9 downto 0) ))) <= dataIn;
				else
					dataOut <= ram_block_0(to_integer(unsigned(address(9 downto 0))));
				end if;
		
			elsif (address(12 downto 10) = "001") then
				if(write='1') then
					ram_block_1(to_integer(unsigned( address(9 downto 0) ))) <= dataIn;
				else
					dataOut <= ram_block_1(to_integer(unsigned(address(9 downto 0))));
				end if;
			elsif (address(12 downto 10) = "010") then
				if(write='1') then
					ram_block_2(to_integer(unsigned( address(9 downto 0) ))) <= dataIn;
				else
					dataOut <= ram_block_2(to_integer(unsigned(address(9 downto 0))));
				end if;
			elsif (address(12 downto 10) = "011") then
				if(write='1') then
					ram_block_3(to_integer(unsigned( address(9 downto 0) ))) <= dataIn;
				else
					dataOut <= ram_block_3(to_integer(unsigned(address(9 downto 0))));
				end if;
			elsif (address(12 downto 10) = "100") then
				if(write='1') then
					ram_block_4(to_integer(unsigned( address(9 downto 0) ))) <= dataIn;
				else
					dataOut <= ram_block_4(to_integer(unsigned(address(9 downto 0))));
				end if;
			elsif (address(12 downto 10) = "101") then
				if(write='1') then
					ram_block_5(to_integer(unsigned( address(9 downto 0) ))) <= dataIn;
				else
					dataOut <= ram_block_5(to_integer(unsigned(address(9 downto 0))));
				end if;
			elsif (address(12 downto 10) = "110") then
				if(write='1') then
					ram_block_6(to_integer(unsigned( address(9 downto 0) ))) <= dataIn;
				else
					dataOut <= ram_block_6(to_integer(unsigned(address(9 downto 0))));
				end if;
			else
				if(write='1') then
					ram_block_7(to_integer(unsigned( address(9 downto 0) ))) <= dataIn;
				else
					dataOut <= ram_block_7(to_integer(unsigned(address(9 downto 0))));
				end if;
			end if;
			
		end if;
	END PROCESS;



end Behavioral;

