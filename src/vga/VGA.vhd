----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    13:24:55 04/16/2012
-- Design Name:
-- Module Name:    VGA - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
    Port(
        -- VGA timing counter
        clk : in std_logic;

        -- Reset
        reset : in std_logic;

        -- VGA output
        hsync,
        vsync,
        red,
        green,
        blue : out std_logic;

        -- Sync counters
        row,
        column : out std_logic_vector(9 downto 0)
    );
end VGA;

-- Resolution: 640x480 pixels (307,200 total pixels)
-- Field Refresh Rate: 60 Hz
-- Line Refresh Rate: 31,476 Hz

-- Vertical timing: 60 Hz = Screen refreshed once every 16.66 ms
-- Horizontal timing: ~ 31.47 Hz = Horizontal line every 31.77 us

architecture Behavioral of VGA is

    -- Sync signals
    signal h_sync, v_sync : std_logic;

    -- Video enables
    signal video_en,
        horisontal_en,
        vertical_en : std_logic;

    -- Sync counters
    signal h_cnt, v_cnt : std_logic_vector(9 downto 0);
begin

    video_en <= horisontal_en and vertical_en;

    process (clk)
    begin
        if rising_edge(clk) then

            if (reset = '1') then
                h_cnt <= "0000000000";
                v_cnt <= "0000000000";
                column <= "0000000000";
                row <= "0000000000";
            end if;

            -- Reset horisontal counter
            if (h_cnt = 799) then	-- 799*clk = h_timing
                h_cnt <= "0000000000";
            else
                h_cnt <= h_cnt + 1;
            end if;

            -- Generate horizontal sync
            if (h_cnt <= 755) and (h_cnt >= 699) then 
				-- disable sync during blaking time 
                h_sync <= '0';
            else
				-- within display time
                h_sync <= '1';
            end if;

            -- Reset vertical counter
            if (v_cnt >= 524) and (h_cnt >= 699) then
				-- reset the vertical counter when at max vertical timing (524*clk)
				-- and horizontal orientation is out of display time part.
                v_cnt <= "0000000000";
            elsif (h_cnt = 699) then
				-- increase vertical count after each horizontal display (within display time) is done.
                v_cnt <= v_cnt + 1;
            end if;

            -- Generate vertical sync
            if (v_cnt <= 494) and (v_cnt >= 493) then
				-- same with horizontal sync.
                v_sync <= '0';
            else
                v_sync <= '1';
            end if;

            -- Generate horizontal data
            if (h_cnt <= 639) then
				-- 640 data
                horisontal_en <= '1';
                column <= h_cnt;
            else
                horisontal_en <= '0';
            end if;

            -- Generate vertical data
            if (v_cnt <= 479) then
				-- 480 data
                vertical_en <= '1';
                row <= v_cnt;
            else
                vertical_en <= '0';
            end if;

            -- Assign physical signals to VGA
            hsync <= h_sync;
            vsync <= v_sync;

            -- Output red, black if we're blanking
            red <= '1' and video_en;
            green <= '0' and video_en;
            blue <= '0' and video_en;

        end if;
    end process;

end Behavioral;

