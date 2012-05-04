----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:	 22:04:04 05/02/2012 
-- Design Name: 
-- Module Name:	 PlayerFIFO - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PlayerFIFO is
	 Port ( current_pc_in : in  STD_LOGIC_VECTOR (12 downto 0);
			  current_pc_out : out  STD_LOGIC_VECTOR (12 downto 0);
			  current_player_out : out STD_LOGIC_VECTOR (1 downto 0);
			  game_over_out : out STD_LOGIC;
			  next_pc : in  STD_LOGIC;
			  write_pc : in STD_LOGIC;
			  change_player : in STD_LOGIC;
			  clk : in std_logic;
			  reset : in std_logic);
end PlayerFIFO;

architecture Behavioral of PlayerFIFO is
	signal p1_head : std_logic_vector(6 downto 0) := "0000000";
	signal p1_tail : std_logic_vector(6 downto 0) := "0000000";
	
	signal p2_head : std_logic_vector(6 downto 0) := "0000000";
	signal p2_tail : std_logic_vector(6 downto 0) := "0000000";
	
	type pc_block_type is array (0 to 127) of std_logic_vector(12 downto 0);
	signal p1_block : pc_block_type := (others => (others => '0'));
	signal p2_block : pc_block_type := (others => (others => '0'));
	
	signal current_player : STD_LOGIC_VECTOR (1 downto 0) := "00";
	
		
--	signal current_pc_in :  STD_LOGIC_VECTOR (12 downto 0);
--	signal current_pc_out :  STD_LOGIC_VECTOR (12 downto 0);
	
	signal p1_head_pc : STD_LOGIC_VECTOR (12 downto 0);
	signal p2_head_pc : STD_LOGIC_VECTOR (12 downto 0);
	
	signal block_to_read : STD_LOGIC := '0';
	
	--signal next_pc : std_logic;
	--signal write_pc : std_logic;
	--signal reset : std_logic;
	
	--signal  game_over : std_logic := '1';
	
--	signal change_player : STD_LOGIC;

begin

  current_player_out <= current_player;
  
	current_pc_out <= 	--"0000000000000" when game_over = '1' else
								p1_head_pc when block_to_read = '0' else
								p2_head_pc when block_to_read = '1';
								
  game_over_out <= '1' when (p1_head = p1_tail) or (p2_head = p2_tail) else
					'0';
		
  process(clk)

	 begin
	 

	 
		  if rising_edge(clk) then
			
		  
		  -- current_pc_in <= current_pc_in_a;
			--next_pc <= next_pc_a;
			--write_pc <= write_pc_a ;
			--reset <= reset_a;
			--change_player <= change_player_a;
			--current_pc_out_a <= current_pc_out;
		  
			  if (reset = '1') then
					current_player <= "00";
					--game_over <= '1';
					
					p1_head <= "0000000";
					p1_tail <= "0000000";
					p2_head <= "0000000";
					p2_tail <= "0000000";
					block_to_read <= '0';
					
					--p1_block(0) <= "0000000000000";
					--p2_block(0) <= "0000000000000";
					
			  else
			  
					
			  
					if next_pc = '1' then
						if (current_player = "01") then
							if (p1_head /= p1_tail) then			-- Read player 1 PC
								p1_head_pc <= p1_block(to_integer(unsigned(p1_head)));
								p1_head <= p1_head + 1;
								block_to_read <= '0';
							end if;
						elsif (current_player = "10") then 
							if (p2_head /= p2_tail) then			-- Read player 2 PC
								p2_head_pc <= p2_block(to_integer(unsigned(p2_head)));
								p2_head <= p2_head + 1;
								block_to_read <= '1';
							end if;
						end if;
						
					elsif (write_pc = '1') then
						if (current_player = "10") then					-- Current player 2
							if (p2_tail + 1 /= p2_head) then
								p2_block(to_integer(unsigned(p2_tail))) <= current_pc_in;	-- Increase tail and write current_pc_in
								p2_tail <= p2_tail + 1;
								
							end if;
						
						elsif (current_player = "01") then				-- Current player 1
							if (p1_tail + 1 /= p1_head) then
								p1_block(to_integer(unsigned(p1_tail))) <= current_pc_in;	-- Increase tail and write current_pc_in
								p1_tail <= p1_tail + 1;
								
							end if;
						end if;
					end if;
					
					if change_player = '1' then
						if current_player = "01" then
							current_player <= "10";
						else
							current_player <= "01";
						end if;
					end if;
					
			  end if;

		  end if;
	 end process;

end Behavioral;

