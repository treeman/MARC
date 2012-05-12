----------------------------------------------------------------------------------
-- Course:      TSEA43
-- Student:     Jesper Tingvall
-- Design Name: MARC
-- Module Name: Player FIFO
-- Description: Two FIFOs we can store our player PC in.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity PlayerFIFO is
     Port ( current_pc_in : in  STD_LOGIC_VECTOR (12 downto 0);
            current_pc_out : out  STD_LOGIC_VECTOR (12 downto 0);
            current_player_out : out STD_LOGIC; -- CUrrent player (0 is player 1, 1 is player 2)
            game_over_out : out STD_LOGIC;  -- One player (or both) is dead
            next_pc : in  STD_LOGIC;      -- Removes the first PC in the current players FIFO and write it to current_pc_out.
            write_pc : in STD_LOGIC;      -- Add current_pc_in last to the current players FIFO, if it's full then this does nothing.
            change_player : in STD_LOGIC; -- Flips current player.
            clk : in std_logic;
            reset : in std_logic);
end PlayerFIFO;

architecture Behavioral of PlayerFIFO is
    signal p1_head : std_logic_vector(6 downto 0) := "0000000";
    signal p1_tail : std_logic_vector(6 downto 0) := "0000000";
    
    signal p2_head : std_logic_vector(6 downto 0) := "0000000";
    signal p2_tail : std_logic_vector(6 downto 0) := "0000000";
    
    type pc_block_type is array (0 to 127) of std_logic_vector(12 downto 0);  -- This will synthetisize to a dual port memory, we only need a single port memory but VHDL doesn't seem to understand that we only use one of the pointers (head and tail) and not both during a cp. This might be solved by some multiplexers and black magick.
    signal p1_block : pc_block_type := (others => (others => '0'));
    signal p2_block : pc_block_type := (others => (others => '0'));
    
    signal current_player : STD_LOGIC;
    
    -- Signals to current_pc_out MUX
    signal p1_head_pc : STD_LOGIC_VECTOR (12 downto 0);
    signal p2_head_pc : STD_LOGIC_VECTOR (12 downto 0);
    
    signal block_to_read : STD_LOGIC := '0';
    

begin
    current_player_out <= current_player;
	
    current_pc_out <=   --"0000000000000" when game_over = '1' else
                        p1_head_pc when block_to_read = '0' else
                        p2_head_pc when block_to_read = '1';
						
    game_over_out <= '1' when (p1_head = p1_tail) or (p2_head = p2_tail) else
                     '0';
        
    process(clk)
    begin
        if rising_edge(clk) then 
   
            if (reset = '1') then
                current_player <= '0'; 
                p1_head <= "0000000";
                p1_tail <= "0000000";
                p2_head <= "0000000";
                p2_tail <= "0000000";
                block_to_read <= '0';

            else
                if next_pc = '1' then
                    if (current_player = '0') then
                        if (p1_head /= p1_tail) then            -- Read player 1 PC
                            p1_head_pc <= p1_block(to_integer(unsigned(p1_head)));   -- Put out the top PC
                            p1_head <= p1_head + 1;                                  -- And increase out head
                            block_to_read <= '0';                                    -- Multplexer signals
                        end if;
                    elsif (current_player = '1') then 
                        if (p2_head /= p2_tail) then            -- Read player 2 PC
                            p2_head_pc <= p2_block(to_integer(unsigned(p2_head)));   -- Put out the top PC
                            p2_head <= p2_head + 1;                                  -- And increase out head
                            block_to_read <= '1';                                    -- Multplexer signals
                        end if;
                    end if;
                        
                elsif (write_pc = '1') then
                    if (current_player = '1') then                  -- Current player 2
                        if (p2_tail + 1 /= p2_head) then            -- This can maybe be done better without needing an extra aritmetic unit
                            p2_block(to_integer(unsigned(p2_tail))) <= current_pc_in;   -- Increase tail and write current_pc_in
                            p2_tail <= p2_tail + 1;
                        end if;
                        
                    elsif (current_player = '0') then               -- Current player 1
                        if (p1_tail + 1 /= p1_head) then           
                            p1_block(to_integer(unsigned(p1_tail))) <= current_pc_in;   -- Increase tail and write current_pc_in
                            p1_tail <= p1_tail + 1;
                        end if;
                    end if;
                end if;

                -- Flip player
                if change_player = '1' then
                    current_player <= not current_player;
                end if;
                    
            end if;

        end if;
    end process;
end Behavioral;

