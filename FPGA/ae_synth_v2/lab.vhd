library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab is
    Port ( clk,rst : in  STD_LOGIC;
           ca,cb,cc,cd,ce,cf,cg,dp : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0));
end lab;

architecture Behavioral of lab is
    component leddriver
    Port ( clk,rst : in  STD_LOGIC;
           ca,cb,cc,cd,ce,cf,cg,dp : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           ledvalue : in  STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
  signal ctr : std_logic_vector(15 downto 0) := X"0000";
  signal tickctr : std_logic_vector(19 downto 0) := X"00000";
  signal tick : std_logic := '0';
begin

  process(clk) begin
    if rising_edge(clk) then
       if rst='1' then
         tickctr <= X"00000";
       else
         tickctr <= tickctr + 1;
       end if;
    end if;
  end process;

  tick <= '1' when tickctr=0 else '0';
  
  process(clk) begin
     if rising_edge(clk) then
       if rst='1' then
         ctr <= X"0000";
       elsif tick='1' then
         ctr <= ctr+1;
       end if;
     end if;
  end process;
       
  led: leddriver port map (clk,rst,ca,cb,cc,cd,ce,cf,cg,dp,an, ctr);
end Behavioral;

