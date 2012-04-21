----------------------------------------------------------------------------------
-- Company:        LIU
-- Engineer:       Jesper Tingvall
-- 
-- Create Date:    21:47:06 04/21/2012 
-- Design Name: 
-- Module Name:    MARC - Behavioral 
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

entity MARC is
	Port (clk 				: in std_logic;
			tmp_gpu_adr		: in STD_LOGIC_VECTOR(12 downto 0);
			tmp_gpu_data	: out STD_LOGIC_VECTOR(7 downto 0);
			buss_controll : in STD_LOGIC_VECTOR(2 downto 0);
			tmp_buss			: in STD_LOGIC_VECTOR(12 downto 0);
			
			memory1_source	: in STD_LOGIC_VECTOR(1 downto 0);
			memory2_source	: in STD_LOGIC_VECTOR(1 downto 0);
			memory3_source	: in STD_LOGIC_VECTOR(1 downto 0);
			
			alu_buss_controll : in STD_LOGIC_VECTOR(2 downto 0));
end MARC;

architecture Behavioral of MARC is

	
	component ALU
		Port (clk 				: in std_logic;
				main_buss_in	: in  STD_LOGIC_VECTOR (12 downto 0);
				main_buss_out	: out  STD_LOGIC_VECTOR (12 downto 0);
				
				memory1_address_gpu : in STD_LOGIC_VECTOR (12 downto 0);		-- Unsynced!
				memory1_data_gpu : out  STD_LOGIC_VECTOR (7 downto 0);		-- Unsynced!
				memory1_read_gpu: in STD_LOGIC;										
				
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
				
				
				alu_operation	: in STD_LOGIC_VECTOR(1 downto 0);
				alu1_zeroFlag	: out STD_LOGIC;
				alu1_source		: in STD_LOGIC_VECTOR(2 downto 0);
				alu2_source		: in STD_LOGIC_VECTOR(2 downto 0);
				
				buss_output		: in STD_LOGIC_VECTOR(2 downto 0);
				
				active_player	: in STD_LOGIC_VECTOR(1 downto 0));
	end component;
	
	signal main_buss	: STD_LOGIC_VECTOR (12 downto 0);
	
	
	
	signal alu_buss_out : STD_LOGIC_VECTOR (12 downto 0);
	
	signal tmp_gpu_adr_sync	: STD_LOGIC_VECTOR(12 downto 0);
	signal tmp_gpu_data_sync		: STD_LOGIC_VECTOR(7 downto 0);
	
	 signal	alu1_zeroFlag	: STD_LOGIC;
begin



	alu1: ALU
		port map(clk=>clk,
					main_buss_in 			=> main_buss,
					main_buss_out 			=> alu_buss_out,
					
					memory1_address_gpu	=> tmp_gpu_adr_sync,
					memory1_data_gpu		=> tmp_gpu_data_sync,
					memory1_read_gpu		=>	'1',
					
					memory1_read			=>	'1',
					memory2_read			=>	'0',
					memory3_read			=>	'0',
					
					memory1_write			=>	'1',
					memory2_write			=>	'1',
					memory3_write			=>	'1',
					
					memory1_source			=>	memory1_source,
					memory2_source			=>	memory2_source,
					memory3_source			=>	memory3_source,
					
					alu_operation			=>	"01",
					alu1_source				=>	"010",
					alu2_source				=>	"001",
					
					buss_output				=>	alu_buss_controll,
					
					active_player			=>	"10",
					alu1_zeroFlag			=> alu1_zeroFlag
		);

	process(clk)
	begin
		if rising_edge(clk) then
			-- Temporary GPU emulator
			tmp_gpu_adr_sync <= tmp_gpu_adr;
			tmp_gpu_data  		<= tmp_gpu_data_sync;
			
			-- Here be a big multiplexer for the main buss!
			if buss_controll = "001" then
				main_buss <= alu_buss_out;
			else
				main_buss <= tmp_buss;
			end if;
		end if;
	end process;

end Behavioral;

