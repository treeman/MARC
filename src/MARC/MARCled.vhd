library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MARCled is
    Port ( clk,rst : in  STD_LOGIC;
           ca,cb,cc,cd,ce,cf,cg,dp : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0);

       game_over : in std_logic;
       active_player : in std_logic_vector(1 downto 0)
         );
end MARCled;

architecture Behavioral of MARCled is
    signal segments : STD_LOGIC_VECTOR (6 downto 0);
    signal counter_r :  std_logic_vector(17 downto 0) := "000000000000000000";
    alias state is counter_r(17 downto 16);
    signal scroll_counter : std_logic_vector(26 downto 0) := (others => '0');
    signal scroll_offset : std_logic_vector(2 downto 0) := "000";
    signal current_char : std_logic_vector(2 downto 0) := "000";

    subtype DataLine is std_logic_vector(6 downto 0);

    type IdData is array (0 to 3) of DataLine;
    signal id : IdData := (
       "0110000",
       "0001000",
       "1111010",
       "0110001"
    );

    type PlayerData is array (0 to 1) of DataLine;
    signal player1_victory : PlayerData := (
       "0110000",
       "1111000"
    );
    
begin
    ca <= segments(6);
    cb <= segments(5);
    cc <= segments(4);
    cd <= segments(3);
    ce <= segments(2);
    cf <= segments(1);
    cg <= segments(0);
    dp <= '1';

    process(clk) 
    begin
        if rising_edge(clk) then 
            scroll_counter <= scroll_counter + 1;
            counter_r <= counter_r + 1;

            if scroll_counter(26) = '1' then
                scroll_counter <= (others => '0');
                scroll_offset <= scroll_offset + 1;
            end if;

            current_char <= state + scroll_offset;

            if current_char(2) = '0' then    
                segments <= id(conv_integer(current_char(1 downto 0)));
            else
                segments <= "1111111";
            end if;
      
            case counter_r(17 downto 16) is
                when "00" => an <= "0111";
                when "01" => an <= "1011";
                when "10" => an <= "1101";
                when others => an <= "1110";
            end case;
        end if;
    end process;
end Behavioral;

