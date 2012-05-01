----------------------------------------------------------------------------------
-- Company: Digilent RO
-- Engineer: Mircea Dabacan
-- 
-- Create Date:    14:06:46 03/01/2008 
-- Design Name: 
-- Module Name:    VgaRefComp - Structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: This is the structural VHDL code of the 
--              Digilent VGA Reference Component.
--              It instantiates three components:
--                - vga_selector
--                - vga_controller_640_60
--                - vga_controller_800_60
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity VgaRefComp is
   port ( CLK_25MHz  : in    std_logic; 
          CLK_40MHz  : in    std_logic; 
          RESOLUTION : in    std_logic; 
          RST        : in    std_logic; 
          BLANK      : out   std_logic; 
          HCOUNT     : out   std_logic_vector (10 downto 0); 
          HS         : out   std_logic; 
          VCOUNT     : out   std_logic_vector (10 downto 0); 
          VS         : out   std_logic);
end VgaRefComp;

architecture Structural of VgaRefComp is
   signal bitBlank800_60    : std_logic;
   signal bitHS_800_60    : std_logic;
   signal bitHS_640_60    : std_logic;
   signal bitVS_640_60    : std_logic;
   signal bitBlank640_60    : std_logic;
   signal bitVS_800_60   : std_logic;
   signal vecHcount_640_60   : std_logic_vector (10 downto 0);
   signal vecVcount_640_60   : std_logic_vector (10 downto 0);
   signal bitHcount_800_60   : std_logic_vector (10 downto 0);
   signal vecVcount_800_60   : std_logic_vector (10 downto 0);

   component vga_selector
      port ( hcount_800_60 : in    std_logic_vector (10 downto 0); 
             vcount_800_60 : in    std_logic_vector (10 downto 0); 
             resolution    : in    std_logic; 
             HS_800_60     : in    std_logic; 
             VS_800_60     : in    std_logic; 
             blank_800_60  : in    std_logic; 
             HS_640_60     : in    std_logic; 
             VS_640_60     : in    std_logic; 
             blank_640_60  : in    std_logic; 
             hcount_640_60 : in    std_logic_vector (10 downto 0); 
             vcount_640_60 : in    std_logic_vector (10 downto 0); 
             hs            : out   std_logic; 
             vs            : out   std_logic; 
             blank         : out   std_logic; 
             hcount        : out   std_logic_vector (10 downto 0); 
             vcount        : out   std_logic_vector (10 downto 0));
   end component;
   
   component vga_controller_640_60
      port ( rst       : in    std_logic; 
             pixel_clk : in    std_logic; 
             HS        : out   std_logic; 
             VS        : out   std_logic; 
             blank     : out   std_logic; 
             hcount    : out   std_logic_vector (10 downto 0); 
             vcount    : out   std_logic_vector (10 downto 0));
   end component;
   
   component vga_controller_800_60
      port ( rst       : in    std_logic; 
             HS        : out   std_logic; 
             VS        : out   std_logic; 
             blank     : out   std_logic; 
             pixel_clk : in    std_logic; 
             vcount    : out   std_logic_vector (10 downto 0); 
             hcount    : out   std_logic_vector (10 downto 0));
   end component;
   
begin
   VgaSelectorInst : vga_selector
      port map (blank_640_60=>bitBlank640_60,
                blank_800_60=>bitBlank800_60,
                hcount_640_60(10 downto 0)=>vecHcount_640_60(10 downto 0),
                hcount_800_60(10 downto 0)=>bitHcount_800_60(10 downto 0),
                HS_640_60=>bitHS_640_60,
                HS_800_60=>bitHS_800_60,
                resolution=>RESOLUTION,
                vcount_640_60(10 downto 0)=>vecVcount_640_60(10 downto 0),
                vcount_800_60(10 downto 0)=>vecVcount_800_60(10 downto 0),
                VS_640_60=>bitVS_640_60,
                VS_800_60=>bitVS_800_60,
                blank=>BLANK,
                hcount(10 downto 0)=>HCOUNT(10 downto 0),
                hs=>HS,
                vcount(10 downto 0)=>VCOUNT(10 downto 0),
                vs=>VS);
   
   VgaCtrl640_60 : vga_controller_640_60
      port map (pixel_clk=>CLK_25MHz,
                rst=>RST,
                blank=>bitBlank640_60,
                hcount(10 downto 0)=>vecHcount_640_60(10 downto 0),
                HS=>bitHS_640_60,
                vcount(10 downto 0)=>vecVcount_640_60(10 downto 0),
                VS=>bitVS_640_60);
   
   VgaCtrl800_60 : vga_controller_800_60
      port map (pixel_clk=>CLK_40MHz,
                rst=>RST,
                blank=>bitBlank800_60,
                hcount(10 downto 0)=>bitHcount_800_60(10 downto 0),
                HS=>bitHS_800_60,
                vcount(10 downto 0)=>vecVcount_800_60(10 downto 0),
                VS=>bitVS_800_60);
   
end Structural;
