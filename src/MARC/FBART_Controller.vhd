----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:09:45 04/28/2012 
-- Design Name: 
-- Module Name:    FBART_Controller - Behavioral 
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
--
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

entity FBART_Controller is
    Port ( request_next_data : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			     rxd              : in std_logic;
           control_signals : out  STD_LOGIC_VECTOR (2 downto 0);
           buss_out : out  STD_LOGIC_VECTOR (12 downto 0);
           has_next_data : out  STD_LOGIC);
end FBART_Controller;

architecture Behavioral of FBART_Controller is
	component fbart_rx
		port(  clk              : in std_logic;     -- System clock input
				 reset                : in std_logic;     -- System reset input
				 rxd              : in std_logic;     -- Receiver data input
				 rxrdy                : out std_logic;        -- Receiver ready output
				 rd               : in std_logic;     -- Read received data input
				 rts              : out std_logic;        -- Request To Send output
				 d                : out std_logic_vector(7 downto 0));    -- Data bus
	end component;
	
	signal register1 	: STD_LOGIC_VECTOR(7 downto 0);
	signal register2 	: STD_LOGIC_VECTOR(7 downto 0);
	signal state		: STD_LOGIC_VECTOR(2 downto 0);
	
	--signal clk        : std_logic;     -- System clock input
	--signal reset      : std_logic;     -- System reset input
	--signal rxd        : std_logic;     -- Receiver data input
	signal rxrdy      : std_logic := '0';        -- Receiver ready output
	signal rd         : std_logic := '1';     -- Read received data input
	signal rts        : std_logic := '0';        -- Request To Send output
	signal d          : std_logic_vector(7 downto 0);    -- Data bus
	signal inverted_reset : std_logic := '0';
begin

	buss_out <= register1 & register2(4 downto 0);
  inverted_reset <= not reset;
	process(clk)
	begin
		if rising_edge(clk) then
		
		  
			if (reset='1') then
				state <= "000";
				has_next_data <= '0';
				--register1 <= "00000000";
        --register2 <= "00000000";
				-- Reset FBART here!
			else
			
				-- Wait for request_next_data request
				if state = "000" then
					if request_next_data = '1' then
						state <= "001";
						rd <= '1';
						
						-- We don't want junk data in out memory, better to have DAT 0 0 as default.
						register1 <= "00000000";
						register2 <= "00000000";
					else
						state <= "000";
					end if;
					has_next_data <= '0';
					
					--buss_out <= '0';
				
				-- Wait for first 8 bits of data
				elsif state = "001" then
					if rxrdy = '1' then
						state <= "010";
						rd <= '0';			-- Request data read!
					else
						state <= "001";
					end if;
					
				-- Read 1st data
				elsif state = "010" then
					rd <= '1';
					register1 <= d;
					state <= "011";
				
				-- Wait for second 8 bits of data
				elsif state = "011" then
					if rxrdy = '1' then
						state <= "100";
						rd <= '0';			-- Request data read!
					else
						state <= "011";
					end if;
				
				-- Read 2st data
				else
					rd <= '1';
					register2 <= d;
					state <= "000";
					--buss_out <= '1';
					has_next_data <= '1';
					
				end if;
				
				
			
			end if;
		end if;
	end process;
	
	
	
	fbart: fbart_rx
	  port map (  	clk 	=> clk,			  
						reset => inverted_reset,
						rxd 	=> rxd, 
						rxrdy => rxrdy,
						rd    => rd,
						rts   => rts,
						d 		=> d
	  );
	 

end Behavioral;

