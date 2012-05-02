-- FBART - Fixed Bitrate Asynchronous Receiver Transmitter
--
-- Anders Nilsson       andersn@isy.liu.se
-- $Rev: 9806 $
-- 29-MAR-2009
--
--  Receiver module
-- 1 byte buffer, RTS flow control
-- Protocol 8N1
-- System clock must be 16 times that of desired bitrate

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fbartrx is
  port(clk              : in std_logic;     -- System clock input
       reset                : in std_logic;     -- System reset input
       rxd              : in std_logic;     -- Receiver data input
       rxrdy                : out std_logic;        -- Receiver ready output
       rd               : in std_logic;     -- Read received data input
       rts              : out std_logic;        -- Request To Send output
       d                : out std_logic_vector(7 downto 0));    -- Data bus
end fbartrx;

architecture Behavioral of fbartrx is
  signal rbg                : std_logic_vector(9 downto 0); -- Receive Bitrate Generator
  signal rbs                : std_logic_vector(1 downto 0); -- Receive Bit State
  signal rbc                : std_logic_vector(2 downto 0); -- Receive Bit Counter
  signal rsr                : std_logic_vector(7 downto 0); -- Receive Shift Register
  signal rdr                : std_logic_vector(7 downto 0); -- Receive Data Register
  signal load_rdr           : std_logic; -- Load Receive Data Register

  type rrs_state is (W_RSR,W_RDL,W_RDH,RDRR);
  signal rrs                : rrs_state; -- Receive Read State

  signal rts_i          : std_logic;    -- RTS internal

begin

  -- Receive Read State
  process(clk, reset, rd)
  begin
    if (reset='0') then
      rrs <= W_RSR;
    elsif rising_edge(clk) then
      case rrs is
        when W_RSR =>               -- Wait until all bits shifted into RSR
          if (rbs="11" and rbc="000") then
            rrs <= W_RDL;
          end if;
        when W_RDL =>               -- Wait for read request (rd=0)
          if (rd='0') then
            rrs <= W_RDH;
          end if;
        when W_RDH =>               -- Wait for read request (rd=1)
          if (rd='1') then
            rrs <= RDRR;
          end if;
        when RDRR =>                -- RDR has been read
          rrs <= W_RSR;
        when others =>
          rrs <= W_RSR;
      end case;
    end if;
  end process;

  -- Received data ready to be read (rxrdy), active high
  rxrdy <= '1' when (rrs=W_RDL) else '0';

  -- Request To Send (rts), active low
  rts_i <= '1' when (rbs="11" and rrs/=W_RSR) else '0';
  rts <= rts_i;

  -- Set data out to RDR at read request (rd='0'), else 'Z'
  d <= rdr when (rrs=W_RDL) and (rd='0') else (others => 'Z');

  -- Receive Bitrate Generator
  process(clk, reset, rxd)
  begin
    if (reset='0') then
      rbg <= "0000000000";
    elsif rising_edge(clk) then
      if rbg = 889 then
	rbg <= "0000000000";
      elsif (rbs="11" and rbc="000") then
        rbg <= "0000000000";
      elsif (rxd='0' and rbs="00") or (rbs/="00") then
        rbg <= rbg + 1;
      end if;
    end if;
  end process;


  -- Receive Bit State
  process(clk, reset, rxd)
  begin
    if (reset='0') then
      rbs <= "00";
    elsif rising_edge(clk) then
      case rbs is
        when "00" => -- Wait Bit
          if (rxd='0') then
            rbs <= "01";
          end if;
        when "01" => -- Start Bit
          if (rbg="0000000000") then
            rbs <= "10";
          end if;
        when "10" => -- Data bits
          if (rbg="0000000000" and rbc=7) then
            rbs <= "11";
          end if;
        when "11" => -- Stop bit
          if (rts_i='0') then
            rbs <= "00";
          end if;
        when others =>
          rbs <= "00";
      end case;
    end if;
  end process;


  -- Receive Bit Counter
  process(clk, reset)
  begin
    if (reset='0') then
      rbc <= "000";
    elsif rising_edge(clk) then
      if (rbs="10" and rbg="0000000000") then
        rbc <= rbc + 1;
      end if;
    end if;
  end process;


  -- Receive Data Register
  load_rdr <= '1' when (rbs="11") and (rbc="000") and (rts_i='0') else '0';
  process(clk)
  begin
    if (reset='0') then
      rdr <= (others => '0');
    elsif rising_edge(clk) then
      if  load_rdr='1' then
        rdr <= rsr;
      end if;
    end if;
  end process;


  -- Receive Shift Register
  process(clk, reset)
  begin
    if (reset='0') then
      rsr <= (others => '0');
    elsif rising_edge(clk) then
      if (rbg=433 and rbs="10") then
        rsr <= rxd & rsr(7 downto 1);
      end if;
    end if;
  end process;



end Behavioral;
