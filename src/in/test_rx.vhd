-- FBART - Fixed Bitrate Asynchronous Receiver Transmitter
--
-- Anders Nilsson       andersn@isy.liu.se
-- $Rev: 5420 $
-- 29-MAR-2009
--
--  Receiver test bench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY test_rx_vhd IS
END test_rx_vhd;

ARCHITECTURE behavior OF test_rx_vhd IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT fbart_rx
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;
        rxd : IN std_logic;
        rd : IN std_logic;
        rxrdy : OUT std_logic;
        rts : out std_logic;
        d : out std_logic_vector(7 downto 0)
        );
    END COMPONENT;

    --Inputs
    SIGNAL clk :  std_logic := '0';
    SIGNAL reset :  std_logic := '1';
    SIGNAL rxd :  std_logic := '0';
    SIGNAL rd : std_logic := '1';
    SIGNAL rxrdy : std_logic := '0';
    SIGNAL rts : std_logic := '0';
    SIGNAL d : std_logic_vector(7 downto 0) := "00000000";

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: fbart_rx PORT MAP(
        clk => clk,
        reset => reset,
        rxd => rxd,
        rd => rd,
        rxrdy => rxrdy,
        rts => rts,
        d => d
    );

    clk <= not clk after 500 ns;
    reset <= '0', '1' after 2 us;
    rxd <= '1',
             '0' after 10 us,   -- Start bit
             '1' after 26 us,
             '1' after 42 us,
             '0' after 58 us,
             '0' after 74 us,
             '0' after 90 us,
             '0' after 106 us,
             '1' after 122 us,
             '1' after 138 us,
             '1' after 154 us,  -- Stop bit
             '0' after 210 us,  -- Start bit
             '1' after 226 us,
             '0' after 242 us,
             '0' after 258 us,
             '1' after 274 us,
             '0' after 290 us,
             '1' after 306 us,
             '1' after 322 us,
             '0' after 338 us,
             '1' after 354 us,  -- Stop bit
             '0' after 420 us,  -- Start bit
             '1' after 436 us,
             '1' after 452 us,
             '0' after 468 us,
             '0' after 484 us,
             '1' after 500 us,
             '1' after 516 us,
             '0' after 532 us,
             '0' after 548 us,
             '1' after 564 us;  -- Stop bit

    rd <= '1',
            '0' after 380 us,
            '1' after 390 us,
            '0' after 590 us,
            '1' after 600 us,
            '0' after 610 us,
            '1' after 620 us;

END;

