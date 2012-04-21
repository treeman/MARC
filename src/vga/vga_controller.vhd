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
-- == vga controller with resolution 800x600, 60Hz; screen: Sumsang SyncMaster 710N
-- card version: xc6slx16-3csg324
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

entity vga_controller is
    Port ( colorpix : in  STD_LOGIC_VECTOR (7 downto 0);
           rst : in  STD_LOGIC;
           vhdl_clk : in  STD_LOGIC;
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
           hcount : out  STD_LOGIC;
           vcount : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           red : out  STD_LOGIC_VECTOR (2 downto 0);
           grn : out  STD_LOGIC_VECTOR (2 downto 0);
           blu : out  STD_LOGIC_VECTOR (1 downto 0));
end vga_controller;

architecture Behavioral of vga_controller is

--------------------------------------------------------------------------------
-- ==CONSTANTS==
--------------------------------------------------------------------------------
-- constants pixel clk for vga timing (800x600)

-- maximum value for the horizontal pixel counter
constant HMAX : std_logic_vector(10 downto 0) := "10000100000"; -- 1056
-- maximum value for the vertical pixel counter
constant VMAX : std_logic_vector(10 downto 0) := "01001110100"; -- 628
--total number of visible columns
constant HLINES : std_logic_vector(10 downto 0) := "01100100000"; -- 800
--value for the horizontal counter where front porch ends
constant HFP : std_logic_vector(10 downto 0) := "01101001000"; -- 840
-- value for the horizontal counter where the synch pulse ends
constant HSP : std_logic_vector(10 downto 0) := "01111001000"; -- 968
-- total number of visible lines
constant VLINES : std_logic_vector(10 downto 0) := "01001011000"; -- 600
-- value for the vertical counter where the front porch ends
constant VFP : std_logic_vector(10 downto 0) := "01001011001"; -- 601
-- value for the vertical counter where the synch pulse ends
constant VSP : std_logic_vector(10 downto 0) := "01001011101"; -- 605
-- polarity of the horizontal and vertical synch pulse
-- only one polarity used, because for this resultion they conicide
constant SPP : std_logic := '1';
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- ==SIGNALS==
--------------------------------------------------------------------------------
signal middle_clk: std_logic;  --50MHz 
signal pixel_clk: std_logic;  -- 25MHz

-- horizontal/vertical counters
signal hcounter : std_logic_vector(10 downto 0) := (other => '0');
signal vcounter : std_logic_vector(10 downto 0) := (other => '0');

-- active when inside visible screen area
signal video_enable : std_logic;
--------------------------------------------------------------------------------


begin

	----------------------------------------------------------
	-- divide vhdl clk by 4; 100MHz -> output pixel_clk 25MHz.
	----------------------------------------------------------
	-- or comment this if we can get a pixel_clk without doing this dividing
	----------------------------------------------------------
	process(vhdl_clk)
	begin
		if rising_edge (vhdl_clk) then
			middle_clk <= not vhdl_clk;
		end if;
	end process;
	process(middle_clk)
	begin
		if rising_edge (middle_clk) then
			pixel_clk <= not middle_clk;
		end if;
	end process;
	----------------------------------------------------------
	
	-- output horizontal and vertical counters
	hcount <= hcounter;
	vcount <= vcounter;
	
	
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
	blank <= not video_endable when rising_edge(pixel_clk);
	---------------------------------------------------------------------
	-- or we just output '0' to red, grn and blu 
	-- Uncomment following if so
	-- b_color: process(pixel_clk)
	-- begin
	-- 	if rising_edge(pixel_clk) then
	-- 		red <= "000";
	-- 		grn <= "000";
	-- 		blu <= "00";
	-- 	end if;
	-- end process b_color;
	---------------------------------------------------------------------
	
	
	---------------------------------------------------------------------
	-- COUNTERS --
	---------------------------------------------------------------------
	-- horizontal counter
	h_count: process(pixel_clk)
	begin
		if(rising_edge(pixel_clk)) then
			-- if rst signal comes, then reset the horizontal counter to 0
			if(rst = '1') then
				hcounter <= (others => '0');
			-- if horizontal counter reaches the maximum range(1056) 
			-- then reset the horizontal counter.
			elsif(hcounter = HMAX) then 
				hcounter <= (others => '0');
			-- else, increase the horizontal counter by 1.
			else
				hcounter <= hcounter + 1;
			end if;
		end if;
	end process h_count;

	-- vertical counter
	v_count: process(pixel_clk)
	begin
		if(rising_edge(pixel_clk)) then
			-- if rst signal comes, then reset the vertical counter to 0
			if(rst = '1') then
				vcounter <= (others => '0');
			-- if the horizontal counter reaches the maximum range(1056) 
			elsif(hcounter = HMAX) then
				-- if the vertical counter also reaches the maximun range(628)
				-- then reset the vertical counter
				if(vcounter = VMAX) then
					vcounter <= (others => '0');
				else
					-- otherwise, keep counting the vertical counter
					vcounter  <= vcounter + 1;
				end if;
			end if;
		end if;	
	end process v_count;
	---------------------------------------------------------------------

	---------------------------------------------------------------------
	-- GENERATE SYNC PULSE
	---------------------------------------------------------------------
	-- generate horizontal synch pulse
	-- when horizontal counter is between where the front porch ends and 
	-- the synch pulse ends.
	-- The HS is active (with polarity SPP=1) for a total of 128 pixels.
	do_hs: process(pixel_clk)
	begin
		if(rising_edge(pixel_clk)) then
			if(hcounter >= HFP and hcounter < HSP) then
				HS <= SPP;
				-- test output colors
				red <= "011";
				grn <= "011";
				blu <= "01";
			else
				HS <= not SPP;
				-- reset the colors to '0'
				red <= "000";
				grn <= "000";
				blu <= "00";
			end if;
		end if;
	end process do_hs;

	-- generate vertical synch pulse
	-- when vertical counter is between where the front porch ends and the
	-- synch pulse ends.
	-- The VS is active (with polarity SPP=1) for a total of 4 video lines
	-- = 4*HMAX = 4224 pixels.
	do_vs: process(pixel_clk)
	begin
		if(rising_edge(pixel_clk)) then
			if(vcounter >= VFP and vcounter < VSP) then
				VS <= SPP;
				-- test output colors
				red <= "011";
				grn <= "011";
				blu <= "01";
			else
				VS <= not SPP;
				-- reset the colors to '0'
				red <= "000";
				grn <= "000";
				blu <= "00";
			end if;
		end if;
	end process do_vs;
	---------------------------------------------------------------------
	
	
	-- enable video output when pixel is in visiable area
	video_enable <= '1' when (hcounter < HLINES and vcounter < VLINES) else '0';

	---------------------------------------------------------------------
	-- UPDATE COLORS WITH INPUTS' VECTORS
	---------------------------------------------------------------------
	-- 8 bits input, 8 bits output
	---------------------------------------------------------------------
end Behavioral;

