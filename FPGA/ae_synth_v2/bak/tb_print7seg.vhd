-------------------------------------------------------------------------------
-- Ett exempel på en testbänk som kan skriva ut saker till terminalen så att
-- man kan se vad som händer i en batchkörning.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.all;

entity tb_print7seg IS
  port (
    clk : in std_logic;
    ca,cb,cc,cd,ce,cf,cg,dp : in std_logic;
    an                             : in std_logic_vector(3 downto 0));
end tb_print7seg;

architecture behavioral of tb_print7seg is
  type oldledarray is array(integer range 0 to 3) of std_logic_vector(7 downto 0);
  signal oldledval : oldledarray;
  signal showleds : boolean := false;
  signal ledsigs : std_logic_vector(7 downto 0);
begin  -- behavioral
  ledsigs(7) <= ca;
  ledsigs(6) <= cb;
  ledsigs(5) <= cc;
  ledsigs(4) <= cd;
  ledsigs(3) <= ce;
  ledsigs(2) <= cf;
  ledsigs(1) <= cg;
  ledsigs(0) <= dp;

  --  ledsigs(7 downto 0): ca cb cc cd ce cf cg dp
  storeoldval : process
    variable i : integer;
    variable ledshaschanged : boolean := false;
  begin
    wait until rising_edge(clk);
    for i in 0 to 3 loop
      if an(i) = '0' then
        if ledsigs /= oldledval(i) then
          oldledval(i) <= ledsigs;
          ledshaschanged := true;
        end if;
      end if;
    end loop;  -- i
    if ledshaschanged and an(0) = '0' then
      showleds <= true;
      ledshaschanged := false;
    else
      showleds <= false;
    end if;
  end process;


  -------------------------------------------------------------------------------
  ---- Testbänken skriver ut värdet på LEDdarna i följande format:
  ----    _    _    _    _  
  ----   /_/  /_/  /_/  /_/ 
  ----  /_/. /_/. /_/. /_/.
  ----
  ---- Notera att du måste titta på utskriften i en monospaced font för att det ska
  ---- se vettigt ut. (Exempelvis, kör du make lab.simc kommer det se bra ut.)
  -----------------------------------------------------------------------------

  
  printleds : process
    variable i : integer;
    variable s : line;
    variable currled7 : std_logic_vector(7 downto 0);
  begin
    wait until rising_edge(clk);
    if showleds then
      -- Print topmost line
      deallocate(s);
      report  "*** LED display was updated" severity note;
      writeline(output,s);

      deallocate(s);
      write(s,string'("  "));

      -- Print top line
      for i in 3 downto 0 loop
        write(s,string'("  "));
        currled7 := oldledval(i);
        if currled7(7) = '0' then
          write(s,string'("_  "));
        else
          write(s,string'("   "));
        end if;
      end loop;  -- i
      writeline(output,s);

      -- Print middle line
      deallocate(s);
      write(s,string'("  "));
      for i in 3 downto 0 loop
        write(s,string'(" "));
        currled7 := oldledval(i);
        if currled7(2) = '0' then
          write(s,string'("/"));
        else
          write(s,string'(" "));
        end if;

        if currled7(1) = '0' then
          write(s,string'("_"));
        else
          write(s,string'(" "));
        end if;

        if currled7(6) = '0' then
          write(s,string'("/ "));
        else
          write(s,string'("  "));
        end if;
      end loop;  -- i
      writeline(output,s);



      -- Print lower line
      deallocate(s);
      write(s,string'("  "));
      for i in 3 downto 0 loop
        write(s,string'(""));
        currled7 := oldledval(i);
        if currled7(3) = '0' then
          write(s,string'("/"));
        else
          write(s,string'(" "));
        end if;

        if currled7(4) = '0' then
          write(s,string'("_"));
        else
          write(s,string'(" "));
        end if;

        if currled7(5) = '0' then
          write(s,string'("/"));
        else
          write(s,string'(" "));
        end if;

        if currled7(0) = '0' then
          write(s,string'(". "));
        else
          write(s,string'("  "));
        end if;
      end loop;  -- i
      writeline(output,s);

      deallocate(s);
      write(s,string'(""));
      writeline(output,s);
      writeline(output,s);
      
    end if;
  end process;
  
end behavioral;

