-- FBART - Fixed Bitrate Asynchronous Receiver Transmitter
--
-- Anders Nilsson		andersn@isy.liu.se
-- $Rev: 9806 $
-- 29-MAR-2009
--
--	Transmitter test bench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY test_tx_vhd IS
END test_tx_vhd;

ARCHITECTURE behavior OF test_tx_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT fbart_tx
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		wr : IN std_logic;
		cts : IN std_logic;    
		d : IN std_logic_vector(7 downto 0);      
		txd : OUT std_logic;
		txrdy : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '1';
	SIGNAL reset :  std_logic := '0';
	SIGNAL wr :  std_logic := '0';
	SIGNAL cts :  std_logic := '0';

	--BiDirs
	SIGNAL d :  std_logic_vector(7 downto 0);

	--Outputs
	SIGNAL txd :  std_logic;
	SIGNAL txrdy :  std_logic;

	--Local
	SIGNAL data : std_logic_vector(7 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: fbart_tx PORT MAP(
		clk => clk,
		reset => reset,
		txd => txd,
		txrdy => txrdy,
		wr => wr,
		cts => cts,
		d => d
	);

	clk <= not clk after 500 ns;
	reset <= '0', '1' after 2 us;
	wr <= '1', '0' after 5 us, '1' after 8 us,
				  '0' after 15 us, '1' after 18 us,
				  '0' after 240 us, '1' after 243 us;
	data <= "11000011",
			  "00110011" after 10 us,
			  "10010110" after 230 us;
	d <= data when wr='0' else (others => 'Z');


END;
