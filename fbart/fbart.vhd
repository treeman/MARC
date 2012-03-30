-- FBART - Fixed Bitrate Asynchronous Receiver Transmitter
--
-- Anders Nilsson       andersn@isy.liu.se
-- $Rev: 9806 $
-- 29-MAR-2009
--
-- Top module
-- 1 byte buffer, RTS-CTS flow control
-- Protocol 8N1
-- System clock must be 16 times that of desired bitrate


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fbart is
  port( clk         : in std_logic;     -- System clock
        reset       : in std_logic;     -- System reset
        cs          : in std_logic;     -- Chip Select
        txd         : out std_logic;    -- Transmitter output
        txrdy       : out std_logic;    -- Transmitter ready for more data
        rxd         : in std_logic;     -- Receiver input
        rxrdy       : out std_logic;    -- Received data ready for reading
        wr          : in std_logic;     -- Write transmitter data
        rd          : in std_logic;     -- Read received data
        d           : inout std_logic_vector(7 downto 0);   -- Data bus
        cts         : in std_logic;     -- Clear To Send
        rts         : out std_logic);   -- Request To Send
end fbart;

architecture behavioral of fbart is

  component fbart_tx
    port( clk       : in std_logic;
          reset     : in std_logic;
          txd       : out std_logic;
          txrdy     : out std_logic;
          wr        : in std_logic;
          d         : in std_logic_vector(7 downto 0);
          cts       : in std_logic);
  end component;

  component fbart_rx
    port( clk       : in std_logic;
          reset     : in std_logic;
          rxd       : in std_logic;
          rxrdy     : out std_logic;
          rd        : in std_logic;
          d         : out std_logic_vector(7 downto 0);
          rts       : out std_logic);
  end component;

  signal wr_i       : std_logic;
  signal rd_i       : std_logic;
  signal rxd_i      : std_logic;
  signal cts_i      : std_logic;

begin

  -- Synchronize rxd, cts
  process(clk)
  begin
    if rising_edge(clk) then
      rxd_i <= rxd;
      cts_i <= cts;
    end if;
  end process;

  wr_i <= wr when (cs='0') else '1';
  rd_i <= rd when (cs='0') else '1';

  U0: fbart_tx
    port map(clk=>clk,reset=>reset,txd=>txd,txrdy=>txrdy,wr=>wr_i,d=>d,cts=>cts_i);

  U1: fbart_rx
    port map(clk=>clk,reset=>reset,rxd=>rxd_i,rxrdy=>rxrdy,rd=>rd_i,d=>d,rts=>rts);

end behavioral;

