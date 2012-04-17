----------------------------------------------------------------------------------
-- Company:  LIU
-- Engineer: Jesper Tingvall
-- 
-- Create Date:    11:56:42 04/17/2012 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
    Port (	clk 				: in std_logic;
				main_buss_in	: in  STD_LOGIC_VECTOR (12 downto 0);
				main_buss_out	: out  STD_LOGIC_VECTOR (12 downto 0);
				GPU_address 	: in  STD_LOGIC_VECTOR (12 downto 0);
				
				memory1_read 	: in STD_LOGIC;
				memory2_read 	: in STD_LOGIC;
				memory3_read 	: in STD_LOGIC;
				
				memory1_write	: in STD_LOGIC;
				memory2_write	: in STD_LOGIC;
				memory3_write	: in STD_LOGIC;
				
				
				
				memory1_source	: in STD_LOGIC_VECTOR(1 downto 0);
				memory2_source	: in STD_LOGIC_VECTOR(1 downto 0);
				memory3_source	: in STD_LOGIC_VECTOR(1 downto 0);
				
			--	alu1_source		: in alu_source_type;
				
				memory1_read_gpu: in STD_LOGIC;
				
				alu_operation	: in STD_LOGIC_VECTOR(1 downto 0);
				alu1_zeroFlag	: out STD_LOGIC;
				alu1_source		: in STD_LOGIC_VECTOR(2 downto 0);
				alu2_source		: in STD_LOGIC_VECTOR(2 downto 0);
				
				buss_output		: in STD_LOGIC_VECTOR(2 downto 0)
				);
end ALU;

architecture Behavioral of ALU is

	--type alu_source_type is (memory, buss, alu);

	component Memory_Cell
		Port (	clk 		: in std_logic;
					read 		: in STD_LOGIC;
					write 	: in  STD_LOGIC;
					address 	: in  STD_LOGIC_VECTOR (12 downto 0);
					data		: buffer  STD_LOGIC_VECTOR (12 downto 0));
	end component;
	
	signal memory1_data 		: STD_LOGIC_VECTOR (12 downto 0);
	signal memory2_data	 	: STD_LOGIC_VECTOR (12 downto 0);
	signal memory3_data	 	: STD_LOGIC_VECTOR (12 downto 0);
	
	signal alu1_register		: STD_LOGIC_VECTOR (12 downto 0);
	signal alu2_register		: STD_LOGIC_VECTOR (12 downto 0);
	
	signal memory1_address 	: STD_LOGIC_VECTOR (12 downto 0);
	signal memory2_address 	: STD_LOGIC_VECTOR (12 downto 0);
	signal memory3_address 	: STD_LOGIC_VECTOR (12 downto 0);
	
	signal alu1_operand		: STD_LOGIC_VECTOR (12 downto 0);
	signal alu2_operand		: STD_LOGIC_VECTOR (12 downto 0);
	
	

begin

	alu1_operand <=	memory1_data when alu1_source = "001" else
							main_buss_in when alu1_source = "010" else
							memory1_data;
							
	alu2_operand <=	memory2_data when alu2_source = "001" else
							main_buss_in when alu2_source = "010" else
							memory2_data;
							
	main_buss_out <=	alu1_register when 	buss_output = "001" else
							alu2_register when 	buss_output = "010" else
							memory1_data when 	buss_output = "011" else
							memory2_data when 	buss_output = "100" else
							memory3_data when 	buss_output = "101" else
							main_buss_in;
							
	memory1_address<=	main_buss_in;
	
	memory2_address<=	main_buss_in when 	memory2_source = "00" else
							alu1_register when 	memory2_source = "01" else
							alu2_register when 	memory2_source = "10" else
							main_buss_in;
							
	memory3_address<=	main_buss_in when 	memory3_source = "00" else
							alu1_register when 	memory3_source = "10" else
							main_buss_in;

	process(clk)
		variable z: std_logic := '0';
	begin
		if rising_edge(clk) then
			
			if alu_operation="00" then
				alu1_register <= alu1_register;
			elsif alu_operation="01" then
				alu1_register <= alu1_register+alu1_operand;
			elsif alu_operation="10" then
				alu1_register <= alu1_register-alu1_operand;

				for i in 12 downto 0 loop
					z := z or alu1_register(i);
				end loop;
				alu1_zeroFlag <= z;

			end if;
			
			
			if alu_operation="00" then
				alu2_register <= alu2_register;
			elsif alu_operation="01" then
				alu2_register <= alu2_register+alu2_operand;
			elsif alu_operation="10" then
				alu2_register <= alu2_register-alu2_operand;
			end if;
			
		end if;
	end process;
	
	memory2: Memory_Cell
		port map (clk=>clk, read=>memory2_read, address=>memory2_address, write=>memory2_write, data=>memory2_data);
	memory3: Memory_Cell
		port map (clk=>clk, read=>memory3_read, address=>memory3_address, write=>memory3_write, data=>memory3_data);

end Behavioral;

