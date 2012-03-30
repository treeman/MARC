-- FBART - Fixed Bitrate Asynchronous Receiver Transmitter
--
-- Anders Nilsson		andersn@isy.liu.se
-- $Rev: 9806 $		
-- 29-MAR-2009
--
--	FBART test bench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY test_fbart_vhd IS
END test_fbart_vhd;

ARCHITECTURE behavior OF test_fbart_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT fbart
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		cs : IN std_logic;
		rxd : IN std_logic;
		wr : IN std_logic;
		rd : IN std_logic;
		cts : IN std_logic;    
		d : INOUT std_logic_vector(7 downto 0);      
		txd : OUT std_logic;
		txrdy : OUT std_logic;
		rxrdy : OUT std_logic;
		rts : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '1';
	SIGNAL reset :  std_logic := '0';
	SIGNAL cs : std_logic := '0';
	SIGNAL rxd :  std_logic := '0';
	SIGNAL wr :  std_logic := '0';
	SIGNAL rd :  std_logic := '0';
	SIGNAL cts :  std_logic := '0';

	--BiDirs
	SIGNAL d :  std_logic_vector(7 downto 0);

	--Outputs
	SIGNAL txd :  std_logic;
	SIGNAL txrdy :  std_logic;
	SIGNAL rxrdy :  std_logic;
	SIGNAL rts :  std_logic;

	--Local
	SIGNAL data : std_logic_vector(7 downto 0);
	SIGNAL bygel : std_logic;


BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: fbart PORT MAP(
		clk => clk,
		reset => reset,
		cs => cs,
		txd => bygel,
		txrdy => txrdy,
		rxd => bygel,
		rxrdy => rxrdy,
		wr => wr,
		rd => rd,
		d => d,
		cts => cts,
		rts => rts
	);


	clk <= not clk after 500 ns;
	reset <= '1', '0' after 2 us, '1' after 4 us;
	
	cs <= '0';
	
	wr <= '1', '0' after 5 us,'1' after 6 us,
              '0' after 15 us,'1' after 16 us;

	data <= "11000011",
	        "00110011" after 10 us;
			  
	d <= data when wr='0' else (others => 'Z');

	cts <= '0';

	rd <= '1','0' after 160 us, '1' after 161 us,
                  '0' after 350 us, '1' after 351 us;	
END;
