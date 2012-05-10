library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           data_gpu : in  STD_LOGIC_VECTOR (7 downto 0);
           address_gpu : out  STD_LOGIC_VECTOR (12 downto 0);
	   border_color : in std_logic_vector (7 downto 0);
           red : out  STD_LOGIC_VECTOR (2 downto 0);
           grn : out  STD_LOGIC_VECTOR (2 downto 0);
           blu : out  STD_LOGIC_VECTOR (1 downto 0);
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC);
end vga;

architecture Behavioral of vga is
	component colorpixSender
	Port ( 
			rst : in std_logic;
			clk : in std_logic;
			indata : in  STD_LOGIC_VECTOR (7 downto 0);
			border_color : in std_logic_vector (7 downto 0);
			colorpix : out  STD_LOGIC_VECTOR (7 downto 0);
			address : out  STD_LOGIC_VECTOR (12 downto 0));
	end component;
	
	component vgaController
	Port (
			rst : in std_logic;
			clk : in std_logic;
			colorpix : in std_logic_vector (7 downto 0);
			red : out  STD_LOGIC_VECTOR (2 downto 0);
			grn : out  STD_LOGIC_VECTOR (2 downto 0);
			blu : out  STD_LOGIC_VECTOR (1 downto 0);
			HS : out  STD_LOGIC;
			VS : out  STD_LOGIC );
	end  component;
------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------
signal colorpix: std_logic_vector (7 downto 0);

	
begin
	colordata: colorpixSender
	port map ( 	clk => clk,
					rst => rst,
					indata => data_gpu,
					colorpix => colorpix,
					border_color => border_color,
					address => address_gpu
	);
	
	vga_con: vgaController
	port map ( 	clk => clk,
					rst => rst,
					colorpix => colorpix,
					red => red,
					grn => grn,
					blu => blu,
					HS => HS,
					VS => VS
	);
	

end Behavioral;

