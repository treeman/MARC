-- FBART - Fixed Bitrate Asynchronous Receiver Transmitter
--
-- Anders Nilsson		andersn@isy.liu.se
-- $Rev: 9806 $
-- 29-MAR-2009
--
--	Transmitter module
-- 1 byte buffer, CTS flow control
-- Protocol 8N1
-- System clock must be 16 times that of desired bitrate

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fbart_tx is
  port ( clk 			: in  STD_LOGIC;	-- System clock input
         reset 			: in  STD_LOGIC;	-- System reset input
         txd 			: out STD_LOGIC;	-- Transmit data output
         txrdy 			: out  STD_LOGIC;	-- Transmitter ready input
         wr 			: in  STD_LOGIC;	-- Write transmit data input
         cts 			: in  STD_LOGIC;	-- Clear To Send input
         d 			: in  STD_LOGIC_VECTOR (7 downto 0));	-- Data bus
end fbart_tx;

architecture Behavioral of fbart_tx is
  signal tbg				: std_logic_vector(3 downto 0); -- Transmit Bitrate Generator
  signal tbs				: std_logic_vector(1 downto 0); -- Transmit Bit State
  signal tbc				: std_logic_vector(2 downto 0); -- Transmit Bit Counter
  signal tsr				: std_logic_vector(7 downto 0); -- Transmit Shift Register
  signal tdr				: std_logic_vector(7 downto 0); -- Transmit Data Register
  type tws_state is (IDLE, W_WR, W_TDR); 
  signal tws				: tws_state; -- Transmit Write State
  signal load_tdr		: std_logic;	-- Load signal for TDR
  signal load_tsr		: std_logic;	-- Load signal for TSR
  signal shift_tsr		: std_logic;	-- Shift signal for TSR
  signal tdr_full		: std_logic;	-- Signal indicating TDR full
  signal tsr_empty		: std_logic;	-- Signal indicating TSR empty
begin


  -- Transmit Write State
  process(clk, reset)
  begin
    if reset='0' then
      tws <= IDLE;
    elsif rising_edge(clk) then
      case tws is
        when IDLE =>	-- Wait for wr low (active)
          if (wr='0') then
            tws <= W_WR;
          end if;
        when W_WR =>	-- Wait for wr high (inactive)
          if (wr='1') then
            tws <= W_TDR;
          end if;
        when W_TDR =>	-- Hold if TDR full
          if (tdr_full='0') then
            tws <= IDLE;
          end if;
        when others =>	-- Cover others, like 'U','Z','X', ...
          tws <= IDLE;
      end case;
    end if;
  end process;

  -- Transmitter ready for more data (txrdy), active high
  txrdy <= '1' when (tws=IDLE) else '0';

  load_tdr <= '1' when (tws=IDLE) and (wr='0') else '0';
  
  
  
  -- Transmit Data Register
  process(clk, reset)
  begin
    if (reset='0') then
      tdr <= (others => '0');
    elsif rising_edge(clk) then
      if (load_tdr='1') then
        tdr <= d;
      end if;
    end if;
  end process;


  -- TDR full state
  process(clk, reset)
  begin
    if (reset='0') then
      tdr_full <= '0';	-- TDR initially empty
    elsif rising_edge(clk) then
      case tdr_full is
        when '0' =>
          if (load_tdr='1') then
            tdr_full <= '1';
          end if;
        when '1' =>
          if (load_tsr='1') then
            tdr_full <= '0';
          end if;
        when others =>
          tdr_full <= '0';
      end case;
    end if;
  end process;

  
  -- Transmit Shift Register
  process(clk, reset)
  begin
    if (reset='0') then
      tsr <= "00000000";
    elsif rising_edge(clk) then
      if (load_tsr='1' and tsr_empty='1') then
        tsr <= tdr;
      elsif (shift_tsr='1') then
        tsr <= '0' & tsr(7 downto 1);
      end if;
    end if;
  end process;

  load_tsr <= '1' when (tws=W_TDR) and (tsr_empty='1') else '0';
  shift_tsr <= '1' when (tbs="10" and tbg="1111") else '0';	


  -- TSR empty state
  process(clk, reset)
  begin
    if (reset='0') then
      tsr_empty <= '1';									-- TSR initially empty
    elsif rising_edge(clk) then
      case tsr_empty is
        when '0' =>
          if (tbs="11" and tbg="1111") then	-- Wait until end of stop bit
            tsr_empty <= '1';						-- before signalling TSR empty
          end if;
        when '1' =>
          if (load_tsr='1') then					-- when TSR loaded then signal
            tsr_empty <= '0';						-- TSR not empty
          end if;					
        when others =>
          tsr_empty <= '0';
      end case;
    end if;
  end process;
  

  -- Transmit Bitrate Generator
  -- Generate bit length as 16 clock cycles
  process(clk, reset)
  begin
    if (reset='0') then
      tbg <= (others => '0');
    elsif rising_edge(clk) then
      if (tbs/="00") then
        tbg <= tbg + 1;
      end if;
    end if;
  end process;
  

  -- Transmit Bit Counter
  -- Count 8 data bits
  process(clk, reset)
  begin
    if (reset='0') then
      tbc <= (others => '0');
    elsif rising_edge(clk) then
      if (tbg="1111" and tbs="10") then
        tbc <= tbc + 1;
      end if;
    end if;
  end process;
  

  -- Transmit Bit State
  process(clk, reset)
  begin
    if (reset='0') then
      tbs <= "00";
    elsif rising_edge(clk) then
      case tbs is
        when "00" =>		-- Wait for TSR contents and CTS
          if (tsr_empty='0' and cts='0') then
            tbs <= "01";
          end if;
        when "01" =>		-- Start Bit cycle
          if (tbg="1111") then
            tbs <= "10";
          end if;
        when "10" =>		-- Data Bit cycles
          if (tbg="1111" and tbc=7) then
            tbs <= "11";
          end if;
        when "11" =>		-- Stop Bit cycle
          if (tbg="1111") then
            tbs <= "00";
          end if;
        when others =>
          tbs <= "00";
      end case;
    end if;
  end process;

  txd <= '0' when (tbs="01") else					-- Start bit
         tsr(0) when (tbs="10") else				-- Data bits
         '1';												-- Stop bit(s)
  

end Behavioral;

