library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vgaController is                             -- the vga_controller for 640_480_60Hz
port(
    rst : in std_logic;
    clk : in std_logic;
    colorpix : in std_logic_vector(7 downto 0);     -- 8 colorpixel bits from colorpixSender
    red : out std_logic_vector(2 downto 0);
    grn : out std_logic_vector(2 downto 0);
    blu : out std_logic_vector(1 downto 0);
    HS : out std_logic;                             -- HS = '1' for pixels sync enabled
    VS : out std_logic                              -- VS = '1' for pixels sync enabled
);
end vgaController;

Architecture Behavioral of vgaController is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

-- maximum value for the horizontal pixel counter
constant HMAX  : std_logic_vector(10 downto 0) := "01100100000"; -- 800
-- maximum value for the vertical pixel counter
constant VMAX  : std_logic_vector(10 downto 0) := "01000001101"; -- 525
-- total number of visible columns
constant HLINES: std_logic_vector(10 downto 0) := "01010000000"; -- 640
-- value for the horizontal counter where front porch ends
constant HFP   : std_logic_vector(10 downto 0) := "01010001000"; -- 648
-- value for the horizontal counter where the synch pulse ends
constant HSP   : std_logic_vector(10 downto 0) := "01011101000"; -- 744
-- total number of visible lines
constant VLINES: std_logic_vector(10 downto 0) := "00111100000"; -- 480
-- value for the vertical counter where the front porch ends
constant VFP   : std_logic_vector(10 downto 0) := "00111100010"; -- 482
-- value for the vertical counter where the synch pulse ends
constant VSP   : std_logic_vector(10 downto 0) := "00111100100"; -- 484
-- polarity of the horizontal and vertical synch pulse
-- only one polarity used, because for this resolution they coincide.
constant SPP   : std_logic := '0';


------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------

signal hcounter : std_logic_vector(10 downto 0) := (others => '0');     -- counter for horizontal timing
signal vcounter : std_logic_vector(10 downto 0) := (others => '0');     -- counter for vertical timing
signal pixel_cnt : std_logic_vector(1 downto 0) := "00";

begin
    process(clk)
    begin
      if(rising_edge(clk)) then
            if rst = '1' then                                   --reset all the counters
                hcounter <= "00000000000";
                vcounter <= "00000000000";
                pixel_cnt <= "00";
            end if;

            if pixel_cnt = "11" then                            -- pixel_cnt in 25MHz
                pixel_cnt <= "00";
                -----------------
                -- Main starts --
                -----------------
                if hcounter = HMAX then                         -- increase h_counter
                    hcounter <= "00000000000";                  -- reset h_counter when HMAX
                    if vcounter = VMAX then                     -- increase v_counter 
                        vcounter <= "00000000000";              -- reset v_counter when VMAX
                    else
                        vcounter <= vcounter + 1;
                    end if;
                else
                    hcounter <= hcounter + 1;
                end if;
                
                if hcounter >= HFP and hcounter < HSP then      -- generate and refresh HS signal during display area 
                    HS <= SPP;                                  -- HS <= '0'         
                else
                    HS <= not SPP;                              -- HS <= '1'
                end if;

                if vcounter >= VFP and vcounter < VSP then      -- generate and refresh VS signal during display area 
                    VS <= SPP;                                  -- VS <= '0'                
                else
                    VS <= not SPP;                              -- VS <= '1'
                end if;             
                
                if hcounter < HLINES and vcounter < VLINES then
                    if vcounter < 476 then                      -- send color pixels to vga port within display area
                        red <= colorpix (2 downto 0);
                        grn <= colorpix (5 downto 3);
                        blu <= colorpix (7 downto 6);
                    else
                        red <= "000";
                        grn <= "000";
                        blu <= "00";
                    end if;
                                                           
                else 
                    red <= "000";
                    grn <= "000";
                    blu <= "00";
                end if;         
            else
                pixel_cnt <= pixel_cnt + 1;
           end if;
        end if;
    end process;
end Behavioral;
