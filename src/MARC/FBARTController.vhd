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
-- Description: USE GTKTERM WITH SPEED OF 115200!
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

entity FBARTController is
    Port ( request_next_data : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  rxd              : in std_logic;
           control_signals : out  STD_LOGIC_VECTOR (2 downto 0);
           buss_out : out  STD_LOGIC_VECTOR (12 downto 0);
		     --out_switch : in STD_LOGIC;
		     --out_display : out STD_LOGIC_VECTOR( 7 downto 0);
		   
           has_next_data : out  STD_LOGIC;
           padding_error_out : out STD_LOGIC_VECTOR(2 downto 0));
end FBARTController;

architecture Behavioral of FBARTController is
	component fbartrx
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
        signal padding_error    : STD_LOGIC_VECTOR(2 downto 0) := "000";
	
	--signal request_next_data : STD_LOGIC := '0';
	--signal reset : STD_LOGIC := '0';
	
	--signal clk        : std_logic;     -- System clock input
	--signal reset      : std_logic;     -- System reset input
	--signal rxd        : std_logic;     -- Receiver data input
	signal rxrdy      : std_logic := '0';        -- Receiver ready output
	signal rd         : std_logic := '1';     -- Read received data input
	signal rts        : std_logic := '0';        -- Request To Send output
	signal d          : std_logic_vector(7 downto 0);    -- Data bus
	signal inverted_reset : std_logic := '0';
begin
        padding_error_out <= padding_error;
	buss_out <= register1(4 downto 0) & register2;
	control_signals <= register1(7 downto 5);

        inverted_reset <= not reset;
  --inverted_reset <= not(reset);
  
   -- out_display <=  register1 when out_switch = '1' else register2;

   --control_signals<= state;
  
	process(clk)
	begin
		if rising_edge(clk) then
		
			--request_next_data <= request_next_data_a; -- and not(request_next_data);
			--reset <= reset_a;
		        
		  
			if (reset='1') then
				state <= "000";
				has_next_data <= '0';
				padding_error <= "000";
				register1 <= "00000000";
        			register2 <= "00000000";
				-- Reset FBART here!
			else

					if (register1(7 downto 5) = "000") then
                                            if padding_error = "000" then
		                               padding_error <= "000";
                                            end if;
					else
                                            padding_error <= register1(7 downto 5);
		                        end if;

				--if state = "000" then
				--	inverted_reset <= '0';
				--else
				--	inverted_reset <= '1';
				--end if;
			
				-- Wait for request_next_data request
				if state = "000" then
					if request_next_data = '1' then
						state <= "001";
						rd <= '1';
						has_next_data <= '0';
						--inverted_reset <= '1';
						-- We don't want junk data in out memory, better to have DAT 0 0 as default.
						register1 <= "00000000";
						register2 <= "00000000";
					else
						state <= "000";
						--inverted_reset <= '0';
					end if;
					
				
					
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
				elsif state = "100" then
					rd <= '1';
					register2 <= d;
					state <= "000";
					--buss_out <= '1';
					has_next_data <= '1';
				else

				end if;
				
				
			
			end if;
		end if;
	end process;
	
	
	
	fbart: fbartrx
	  port map (  	clk 	=> clk,			  
						reset => inverted_reset,
						rxd 	=> rxd, 
						rxrdy => rxrdy,
						rd    => rd,
						rts   => rts,
						d 		=> d
	  );
	 

end Behavioral;

