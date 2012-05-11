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
    Port (
            clk,rst : in  STD_LOGIC;
            ca,cb,cc,cd,ce,cf,cg,dp : out  STD_LOGIC;
            an : out  STD_LOGIC_VECTOR (3 downto 0);

            game_started : in std_logic;
            current_instr : in std_logic_vector(3 downto 0);

            game_over : in std_logic;
            active_player : in std_logic_vector(1 downto 0)
         );
end MARCled;

architecture Behavioral of MARCled is
    signal segments : STD_LOGIC_VECTOR (6 downto 0);
    signal counter_r : std_logic_vector(17 downto 0) := (others => '0');

    --alias state is counter_r(17 downto 16);
    alias led_state is counter_r(1 downto 0);
    signal scroll_counter : std_logic_vector(26 downto 0) := (others => '0');
    signal scroll_offset : std_logic_vector(5 downto 0) := (others => '0');
    signal current_char : std_logic_vector(5 downto 0) := (others => '0');

    -- 00   show MARC
    -- 01   show player 1 victory
    -- 10   show player 2 victory
    -- 11   show instruction mnemonic
    signal display_state : std_logic_vector(1 downto 0) := "00";

    signal instr_start : std_logic_vector(5 downto 0) := (others => '0');
    signal instr_char : std_logic_vector(5 downto 0) := (others => '0');

    subtype DataLine is std_logic_vector(6 downto 0);

    type IdData is array (0 to 7) of DataLine;
    signal id : IdData := (
       "0110000", -- M
       "0001000", -- A
       "1111010", -- r
       "0110001", -- C

       -- Blanking period
       "1111111", --
       "1111111", --
       "1111111", --
       "1111111" --
    );

    type PlayerData is array (0 to 42) of DataLine;
    signal player1_victory : PlayerData := (
       "0001000", -- A
       "1110001", -- L
       "1110001", -- L
       "1111111", --
       "1001100", -- Y
       "0000001", -- O
       "1000001", -- U
       "1111010", -- r
       "1111111", --
       "0110001", -- C
       "0000001", -- O
       "1000010", -- d
       "0110000", -- E
       "1111111", --
       "0001000", -- A
       "1111010", -- r
       "0110000", -- E
       "1111111", --
       "1100000", -- b
       "0110000", -- E
       "1110001", -- L
       "0000001", -- O
       "1101010", -- n
       "0100000", -- G
       "1111111", --
       "0111001", -- T
       "0000001", -- O
       "1111111", --
       "1000001", -- U
       "0100100", -- S
       "1111111", --
       "0011000", -- P
       "1110001", -- L
       "0001000", -- A
       "1001100", -- Y
       "0110000", -- E
       "1111010", -- r
       "1111111", --
       "1001111", -- 1
       "1111111", --
       "1111111", --
       "1111111", --
       "1111111" --
    );

    signal player2_victory : PlayerData := (
       "0001000", -- A
       "1110001", -- L
       "1110001", -- L
       "1111111", --
       "1001100", -- Y
       "0000001", -- O
       "1000001", -- U
       "1111010", -- r
       "1111111", --
       "0110001", -- C
       "0000001", -- O
       "1000010", -- d
       "0110000", -- E
       "1111111", --
       "0001000", -- A
       "1111010", -- r
       "0110000", -- E
       "1111111", --
       "1100000", -- b
       "0110000", -- E
       "1110001", -- L
       "0000001", -- O
       "1101010", -- n
       "0100000", -- G
       "1111111", --
       "0111001", -- T
       "0000001", -- O
       "1111111", --
       "1000001", -- U
       "0100100", -- S
       "1111111", --
       "0011000", -- P
       "1110001", -- L
       "0001000", -- A
       "1001100", -- Y
       "0110000", -- E
       "1111010", -- r
       "1111111", --
       "0010010", -- 2
       "1111111", --
       "1111111", --
       "1111111", --
       "1111111" --
    );

    type InstrData is array (0 to 43) of DataLine;
    signal instr : InstrData := (
       "1111111", --
       "1000010", -- d
       "0001000", -- A
       "0111001", -- T

       "1111111", --
       "0110000", -- M (E)
       "0000001", -- O
       "1100011", -- v (u)

       "1111111", --
       "0001000", -- A
       "1000010", -- d
       "1000010", -- d

       "1111111", --
       "0100100", -- S
       "1000001", -- U
       "1100000", -- b

       "1111111", --
       "0000011", -- J
       "0001001", -- m (N)
       "0011000", -- P

       "1111111", --
       "0000011", -- J
       "0001001", -- m (N)
       "0010010", -- Z

       "1111111", --
       "0000011", -- J
       "0001001", -- m (N)
       "1101010", -- n

       "1111111", --
       "0110001", -- C
       "0001001", -- m (N)
       "0011000", -- P

       "1111111", --
       "0100100", -- S
       "1110001", -- L
       "0111001", -- T

       "1111111", --
       "1000010", -- d
       "0000011", -- J
       "1101010", -- n

       "1111111", --
       "0100100", -- S
       "0011000", -- P
       "1110001", -- L

       others => (others => '1')
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

    with display_state select
        segments <= id(conv_integer(current_char(2 downto 0))) when "00",
                    player1_victory(conv_integer(current_char(5 downto 0))) when "01",
                    player2_victory(conv_integer(current_char(5 downto 0))) when "10",
                    instr(conv_integer(instr_char)) when others;

    with current_instr select
        instr_start <=  "000000" when "0000", -- DAT
                        "000100" when "0001", -- MOV
                        "001000" when "0010", -- ADD
                        "001100" when "0011", -- SUB
                        "010000" when "0100", -- JMP
                        "010100" when "0101", -- JMZ
                        "011000" when "0110", -- JMN
                        "011100" when "0111", -- CMP
                        "100000" when "1000", -- SLT
                        "100100" when "1001", -- DJN
                        "101000" when "1010", -- SPL
                        "000000" when others;

    process(clk) begin
        if rising_edge(clk) then

            counter_r <= counter_r + 1;

            -- Update scroll counter
            if rst = '1' then
                scroll_counter <= (others => '0');
            elsif scroll_counter(26) = '1' then
            --elsif scroll_counter(2) = '1' then
                if led_state = "11" then
                    scroll_counter <= (others => '0');

                    -- Artificial max
                    if scroll_offset = "100111" then
                        scroll_offset <= (others => '0');
                    else
                        scroll_offset <= scroll_offset + 1;
                    end if;
                end if;
            -- Check resets...
            elsif (display_state = "00" and (game_started = '1' or game_over = '1')) or
                  ((display_state = "01" or display_state = "10") and game_over = '0') or
                  (display_state = "11" and game_over = '1') then

                scroll_counter <= (others => '0');
                scroll_offset <= (others => '0');
            else
                scroll_counter <= scroll_counter + 1;
            end if;

            current_char <= led_state + scroll_offset;
            instr_char <= led_state + instr_start;

            -- Change of display state
            if rst = '1' then
                display_state <= "00";
            elsif display_state = "00" and game_over = '1' then
                display_state <= active_player;
            elsif display_state = "00" and game_started = '1' then
                display_state <= "11";
            elsif (display_state = "01" or display_state = "10") and game_over = '0' then
                display_state <= "00";
            elsif display_state = "11" and game_over = '1' then
                display_state <= active_player;
            end if;

            -- Set current led display to output
            case led_state is
                when "00" => an <= "0111";
                when "01" => an <= "1011";
                when "10" => an <= "1101";
                when others => an <= "1110";
            end case;
        end if;
    end process;

end Behavioral;

