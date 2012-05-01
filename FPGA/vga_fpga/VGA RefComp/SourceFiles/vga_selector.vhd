------------------------------------------------------------------------
-- vga_selector.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the logic that selects between the output of the
-- vga controllers depending on the resolution used.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- Depending on the input signal resolution, the output signals from
-- the vga controllers are selected and sent to other logic in the
-- design that needs these outputs, or to the monitor.
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- resolution        - input pin, from resolution_swticher
--                   - selects active resolution
-- HS_640_60         - input pin, from vga_controller_640_60
--                   - horizontal synch signal for 640x480
-- VS_640_60         - input pin, from vga_controller_640_60
--                   - vertical synch signal for 640x480
-- HS_800_60         - input pin, from vga_controller_800_60
--                   - horizontal synch signal for 800x600
-- VS_800_60         - input pin, from vga_controller_800_60
--                   - vertical synch signal for 800x600
-- blank_640_60      - input pin, from vga_controller_640_60
--                   - blank signal for 640x480
-- blank_800_60      - input pin, from vga_controller_800_60
--                   - blank signal for 800x600
-- hcount_640_60     - input pin, 11 bits, from vga_controller_640_60
--                   - horizontal pixel counter for 640x480
-- hcount_800_60     - input pin, 11 bits, from vga_controller_800_60
--                   - horizontal pixel counter for 800x600
-- vcount_640_60     - input pin, 11 bits, from vga_controller_640_60
--                   - vertical lines counter for 640x480
-- vcount_800_60     - input pin, 11 bits, from vga_controller_800_60
--                   - vertical lines counter for 800x600
-- hs                - output pin, to monitor
--                   - selected horizontal synch signal
-- vs                - output pin, to monitor
--                   - selected vertical synch signal
-- blank             - output pin, to clients
--                   - selected blank signal
-- hcount            - output pin, 11 bits, to clients
--                   - selected horizontal pixel counter
-- vcount            - output pin, 11 bits, to clients
--                   - selected vertical lines counter
------------------------------------------------------------------------
-- Revision History:
-- 09/18/2006(UlrichZ): created
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- simulation library
library UNISIM;
use UNISIM.VComponents.all;

-- the vga_selector entity declaration
-- read above for behavioral description and port definitions.
entity vga_selector is
port(
   resolution        : in std_logic;

   HS_640_60         : in std_logic;
   VS_640_60         : in std_logic;
   HS_800_60         : in std_logic;
   VS_800_60         : in std_logic;

   blank_640_60      : in std_logic;
   blank_800_60      : in std_logic;

   hcount_640_60     : in std_logic_vector(10 downto 0);
   hcount_800_60     : in std_logic_vector(10 downto 0);

   vcount_640_60     : in std_logic_vector(10 downto 0);
   vcount_800_60     : in std_logic_vector(10 downto 0);

   hs                : out std_logic;
   vs                : out std_logic;

   blank             : out std_logic;

   hcount            : out std_logic_vector(10 downto 0);
   vcount            : out std_logic_vector(10 downto 0)
);
end vga_selector;

architecture Behavioral of vga_selector is

begin

   -- select horizontal synch pulse signal depending on the
   -- resolution used
   hs <= HS_800_60 when resolution = '1' else HS_640_60;

   -- select vertical synch pulse signal depending on the
   -- resolution used
   vs <= VS_800_60 when resolution = '1' else VS_640_60;

   -- select blank signal depending on the resolution used
   blank <= blank_800_60 when resolution = '1' else blank_640_60;

   -- select horizontal counter depending on the resolution used
   hcount <= hcount_800_60 when resolution = '1' else hcount_640_60;

   -- select vertical counter depending on the resolution used
   vcount <= vcount_800_60 when resolution = '1' else vcount_640_60;

end Behavioral;