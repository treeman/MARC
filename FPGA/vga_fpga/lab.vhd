library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- the vga_controller_640_480_60Hz

entity lab is
port(
   rst   : in std_logic;
   clk   : in std_logic;
	colorpix : in std_logic_vector(7 downto 0);  -- 8 colorpixel bits
   red : out std_logic_vector(2 downto 0);
   grn : out std_logic_vector(2 downto 0);
   blu : out std_logic_vector(1 downto 0);
   HS          : out std_logic; -- HS = '0' for display enabled
   VS          : out std_logic; -- VS = '0' for display enabled
   hcount      : out std_logic_vector(10 downto 0);
   vcount      : out std_logic_vector(10 downto 0);
	blank : out std_logic
);
end lab;

Architecture Behavioral of lab is

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

-- horizontal and vertical counters
signal hcounter : std_logic_vector(10 downto 0) := (others => '0');
signal vcounter : std_logic_vector(10 downto 0) := (others => '0');
signal pixel_cnt : std_logic_vector(1 downto 0) := "00";
-- active when inside visible screen area.
signal video_enable: std_logic;

begin
    process(clk)
    begin
      if(rising_edge(clk)) then
			--reset everything
			if rst = '1' then
				hcounter <= "00000000000";
				vcounter <= "00000000000";
				pixel_cnt <= "00";
			end if;
			
         --generate pixel_counter
			if pixel_cnt = "11" then
				pixel_cnt <= "00";
				-- do vga
				
				--increase h_counter
				if hcounter = HMAX then
					hcounter <= "00000000000";              
                    --increase v_counter                   
                    if vcounter = VMAX then
						vcounter <= "00000000000";
					else
						vcounter <= vcounter + 1;
                    end if;
				else
					hcounter <= hcounter + 1;
				end if;
				
				-- h_sync
				if hcounter >= HFP and hcounter < HSP then
					HS <= SPP;  -- VS = 0				
				else
					HS <= not SPP;  -- VS = 1
				end if;
				
				-- v_sync
				if vcounter >= VFP and vcounter < VSP then
					VS <= SPP;  -- VS = 0				
				else
					VS <= not SPP;  -- VS = 1
				end if;				
				
                -- output horizontal and vertical counters
                hcount <= hcounter;
                vcount <= vcounter;
                
                if hcounter < HLINES and vcounter < VLINES then
                    video_enable <= '1';
                else 
                    video_enable <= '0';
                end if;
					 
					 -- enable video output when pixel is in visible area
                if video_enable = '1' then
						  -- show the colorpix on the screen
                    red <= colorpix(2 downto 0);
                    grn <= colorpix(5 downto 3);
                    blu <= colorpix(7 downto 6);
						  -- disable the blank signal
						  blank <= '0';
					 else
						  -- enable the blank signal and output black color
						  blank <= '1';
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
