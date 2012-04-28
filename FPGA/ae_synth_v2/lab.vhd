----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:01:22 04/21/2012 
-- Design Name: 
-- Module Name:    vga_controller - Behavioral 
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
-- == vga controller with resolution 640x480, 60Hz; screen: Sumsang SyncMaster 710N
-- card version: xc6slx16-3csg324
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_controller is
    Port ( 
			-- input 
			colorpix : in  STD_LOGIC_VECTOR (7 downto 0);
			rst : in  STD_LOGIC;
			--pixel_clk : in std_logic;
			clk : in  STD_LOGIC;
			 
			-- vga output
			HS,
			VS : out  STD_LOGIC;
			red : out  STD_LOGIC_VECTOR (2 downto 0);
			grn : out  STD_LOGIC_VECTOR (2 downto 0);
			blu : out  STD_LOGIC_VECTOR (1 downto 0);
			  
			-- Sync counters
			row,
			column : out STD_LOGIC_VECTOR(9 downto 0)
		);
end vga_controller;

architecture Behavioral of vga_controller is

	--------------------------------------------------------------------------------
	-- ==CONSTANTS==
	--------------------------------------------------------------------------------
	-- constants pixel clk for vga timing (640x480)
	-- maximum value for the horizontal pixel counter: 800
	-- maximum value for the vertical pixel counter: 525
	-- total number of visible columns : 640
	-- value for the horizontal counter where front porch ends: 648
	-- value for the horizontal counter where the synch pulse ends: 744
	-- total number of visible lines: 480
	-- value for the vertical counter where the front porch ends: 482
	-- value for the vertical counter where the synch pulse ends: 484
	--------------------------------------------------------------------------------


	--------------------------------------------------------------------------------
	-- ==SIGNALS==
	--------------------------------------------------------------------------------
	signal pixel_clk: std_logic;  -- 25MHz

	-- horizontal/vertical counters
	signal h_cnt, v_cnt : std_logic_vector(9 downto 0);
	signal pixel_cnt : std_logic_vector(3 downto 0) := "0000";
	-- active when inside visible screen area	
	-- signal video_enable : std_logic;
	--------------------------------------------------------------------------------


begin

	----------------------------------------------------------
	-- divide vhdl clk by 1/4; 100MHz -> output pixel_clk 25MHz.
	----------------------------------------------------------
	-- or comment this if we can get a pixel_clk without doing this dividing
	----------------------------------------------------------
	process(clk)
	begin
		if rising_edge (clk) then
			if (pixel_cnt = 1) then
				pixel_clk <= '1';
				pixel_cnt <= pixel_cnt + 1;
			elsif (pixel_cnt >= 3) then
				pixel_clk <= '0';
				pixel_cnt <= "0000";
			elsif (pixel_cnt = 0) then
				pixel_cnt <= pixel_cnt + 1;
			elsif (pixel_cnt = 2) then
				pixel_cnt <= pixel_cnt + 1;
			end if;
		end if;
	end process;
	----------------------------------------------------------
	
	
	--------------------------------------
	---                      --         --
	---        DISPLAY       --  BLANK  --	
	---                      --         --
	---                      --         --
	---------------------------         --
   ---                                 --
   ---         BLANK                   --
   --------------------------------------	
	-- blanking area is active when outside screen display(visible) area
	-- color output should be blacked (put on 0) when blank is active
	-- blank is delayed one pixel clock period from the video_enable
	-- signal to account for the pixel pipeline delay.
	-- blank: set all the colors to 0.
	-- blank: process(pixel_clk)
	---------------------------------------------------------------------
	
	
	
	process (pixel_clk)
	begin
		if(rising_edge(pixel_clk)) then
			if (rst = '1') then
				h_cnt <= "0000000000";
				v_cnt <= "0000000000";
				column <= "0000000000";
				row <= "0000000000";
			end if;
			---------------------------------------------------------------------
			-- COUNTERS --
			---------------------------------------------------------------------
			-- horizontal counter	
			-- if horizontal counter reaches the maximum range(800) 
			-- then reset the horizontal counter.
			if (h_cnt = 800) then 
				h_cnt <= "0000000000";
				red <= "000";
				grn <= "000";
				blu <= "00";
			-- else, increase the horizontal counter by 1.
			elsif (h_cnt < 800) then
				h_cnt <= h_cnt + 1;
				red <= colorpix(7 downto 5);
				grn <= colorpix(4 downto 2);
				blu <= colorpix(1 downto 0);
			end if;
			
			-- vertical counter	
			-- if the horizontal counter reaches the maximum range(800) 
			if (h_cnt = 800) then
				-- if the vertical counter also reaches the maximun range(525)
				-- then reset the vertical counter
				if(v_cnt = 525) then
					v_cnt <= "0000000000";
					red <= "000";
					grn <= "000";
					blu <= "00";
				elsif (v_cnt < 525) then
					red <= colorpix(7 downto 5);
					grn <= colorpix(4 downto 2);
					blu <= colorpix(1 downto 0);
					-- otherwise, keep counting the vertical counter
					v_cnt <= v_cnt + 1;
				end if;
			end if;
			
			---------------------------------------------------------------------
			-- GENERATE SYNC PULSE
			---------------------------------------------------------------------
			-- generate horizontal synch pulse
			-- when horizontal counter is between where the front porch ends and 
			-- the synch pulse ends.
			-- The HS is active (with polarity SPP=0) for a total of 128 pixels.
			if(h_cnt >= 648) and (h_cnt < 744) then
				HS <= '0';
				-- output pixel color due to input data
			elsif (h_cnt < 648) and (h_cnt >= 744) then
				HS <= '1';
				red <= "000";
				grn <= "000";
				blu <= "00";
			end if;

			-- generate vertical synch pulse
			-- when vertical counter is between where the front porch ends and the
			-- synch pulse ends.
			-- The VS is active (with polarity SPP=0) for a total of 4 video lines
			-- = 4*HMAX = 4224 pixels.
			if(v_cnt >= 482) and (v_cnt < 484) then
				VS <= '0';
				-- output pixel color due to input data
			elsif (v_cnt < 482) and (v_cnt >= 484) then
				VS <= '1';
				red <= "000";
				grn <= "000";
				blu <= "00";
			end if;
			---------------------------------------------------------------------			
			
			---------------------------------------------------------------------
			-- UPDATE ROW&COLUMN COUNTER
			---------------------------------------------------------------------
			if(h_cnt <= 639) then
				column <= h_cnt;
			end if;
			if(v_cnt <= 479) then
				row <= v_cnt;
			end if;
			---------------------------------------------------------------------
		end if;
		
	end process;
	
end Behavioral;

