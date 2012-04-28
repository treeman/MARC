-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY batchlab_tb IS
END batchlab_tb;

ARCHITECTURE behavior OF batchlab_tb IS 

  -- Component Declaration
  COMPONENT lab
    PORT(
      clk,rst : IN std_logic;
      ca,cb,cc,cd,ce,cf,cg,dp: OUT std_logic;       
      an : OUT std_logic_vector(3 downto 0)
      );
  END COMPONENT;

  SIGNAL clk : std_logic := '0';
  SIGNAL rst : std_logic := '0';
  SIGNAL ca,cb,cc,cd,ce,cf,cg,dp : std_logic;
  SIGNAL an :  std_logic_vector(3 downto 0);
  signal tb_running : boolean := true;
  
BEGIN

  -- Component Instantiation
  uut: lab PORT MAP(
    clk => clk,
    rst => rst,
    ca => ca,
    cb => cb,     
    cc => cc,  
    cd => cd,
    ce => ce,
    cf => cf,
    cg => cg,
    dp => dp,
    an => an);


  clk_gen : process
  begin
    while tb_running loop
      clk <= '0';
      wait for 20 ns;
      clk <= '1';
      wait for 20 ns;
    end loop;
    wait;
  end process;

  

  stimuli_generator : process
    variable i : integer;
  begin
    -- Aktivera reset ett litet tag.
    rst <= '1';
    wait for 500 ns;

    wait until rising_edge(clk);        -- se till att reset släpps synkront
                                        -- med klockan
    rst <= '0';
    report "Reset released" severity note;


    for i in 0 to 50000000 loop         -- Vänta ett antal klockcykler
      wait until rising_edge(clk);
    end loop;  -- i
    
    tb_running <= false;                -- Stanna klockan (vilket medför att inga
                                        -- nya event genereras vilket stannar
                                        -- simuleringen).
    wait;
  end process;

  -- Exempel på direct instantiation.
  printleds : ENTITY work.tb_print7seg port map (
    ca => ca,
    cb => cb,     
    cc => cc,  
    cd => cd,
    ce => ce,
    cf => cf,
    cg => cg,
    dp => dp,
    an      => an,
    clk     => clk);
    
      
END;
