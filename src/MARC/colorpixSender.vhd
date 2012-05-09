library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity colorpixSender is
    Port ( 
      rst : in std_logic;
      clk : in std_logic;
      indata : in  STD_LOGIC_VECTOR (7 downto 0);
      colorpix : out  STD_LOGIC_VECTOR (7 downto 0);
      address : out  STD_LOGIC_VECTOR (12 downto 0));
end colorpixSender;

architecture Behavioral of colorpixSender is

signal row_cnt : std_logic_vector (3 downto 0) := (others => '0');
signal column_cnt : std_logic_vector (10 downto 0) := (others => '0');
signal unit_cnt : std_logic_vector (2 downto 0) := (others => '0');
signal height : std_logic_vector (11 downto 0) := (others => '0');
signal address_mem : STD_LOGIC_VECTOR (12 downto 0) := (others => '0');

-- use the same clk as vga_controller
signal pixel_cnt : std_logic_vector(1 downto 0) := "00";

signal border_color : std_logic_vector(7 downto 0) := "00100111";

begin
  process(clk)
  begin
    if (rising_edge(clk)) then
      -- reset everything
      if rst = '1' then
        colorpix <= (others => '0');
        row_cnt <= (others => '0');
        column_cnt <= (others => '0');
        unit_cnt <= (others => '0');
        pixel_cnt <= "00";
        address_mem <= "0000000000000";
        height <= "000000000000";
      end if;
      
      if pixel_cnt = "11" then
        pixel_cnt <= "00";

        --------------------------------------------------------------------------------
        -- Main code --
        --------------------------------------------------------------------------------
        -- sync the address
        address <= address_mem;
        -- reset counters when it reaches the max area
        if height = 525 then
          if column_cnt = 800 then
            height <= (others => '0');
            column_cnt <= (others => '0');
            row_cnt <= (others => '0');
            unit_cnt <= (others => '0');
            address_mem <= (others => '0');
          else
            column_cnt <= column_cnt + 1;
          end if;
          
          
          -- within the display area (notice that we only display for 63*7=441 lines
          -- send last 4 bits
        elsif height >= 441 and height < 448 then
          if row_cnt = 6  then
            ------------------
            -- Column6 Start --
            ------------------
            if column_cnt < 801 then
              -- keep sending 64*5 = 320 pixels
              if column_cnt < 320 then -- within the display area
                -- send the same data for 5 times
                if unit_cnt < 5 then
                  if unit_cnt = 4 then 
                    unit_cnt <= (others => '0');
                    column_cnt <= column_cnt + 1; 
                    address_mem <= address_mem + 1; -- move to next address
                  elsif unit_cnt = 1 then
                    colorpix(7 downto 0) <= indata(7 downto 0); -- only change the input at the first cp
                    unit_cnt <= unit_cnt + 1;
                    column_cnt <= column_cnt + 1; 
                  else
                    column_cnt <= column_cnt + 1; -- else time, just increase the column_cnt
                    unit_cnt <= unit_cnt + 1;
                  end if;
                end if;
              elsif column_cnt = 800 then -- reset everything on the last cp of column_cnt
                row_cnt <= (others => '0'); 
                height <= height + 1;
                address_mem <= (others => '0'); --address_mem - 64; -- move to next address
                column_cnt <= (others => '0'); -- reset column_cnt
                unit_cnt <= (others => '0'); -- reset the unit_cnt(not nessessary, but just in case)
              elsif column_cnt >= 320 and column_cnt < 640 then
                column_cnt <= column_cnt + 1;
                colorpix(7 downto 0) <= border_color;
              else
                -- this is the blanking are, just incrase the column_cnt here, output nothing
                column_cnt <= column_cnt + 1;
                colorpix(7 downto 0) <= "00000000";
              end if;
            end if;
            -----------------
            -- Column6 End --
            -----------------
          else
            ------------------
            -- Column Start --
	    ------------------
            if column_cnt < 801 then
              -- keep sending 128*5 = 640 pixels
              if column_cnt < 320 then -- within the display area
                -- send the same data for 5 times
                if unit_cnt < 5 then
                  if unit_cnt = 4 then 
                    unit_cnt <= (others => '0');
                    column_cnt <= column_cnt + 1; 
                    address_mem <= address_mem + 1; -- move to next address
                  elsif unit_cnt = 1 then
                    colorpix(7 downto 0) <= indata(7 downto 0); -- only change the input at the first cp
                    unit_cnt <= unit_cnt + 1;
                    column_cnt <= column_cnt + 1; 
                  else
                    column_cnt <= column_cnt + 1; -- else time, just increase the column_cnt
                    unit_cnt <= unit_cnt + 1;
                  end if;
                end if;
              --elsif column_cnt >= 320 and column_cnt < 640 then
               -- address_mem <= address_mem + 1;
               -- column_cnt <= column_cnt + 1;
               -- colorpix(7 downto 0) <= "00000000";
              elsif column_cnt = 800 then -- reset everything on the last cp of column_cnt
                row_cnt <= row_cnt + 1; -- next row, and height increase by 1 too
                height <= height + 1;
                address_mem <= address_mem - 64; -- decrease the address by 128, back to the beginning
                column_cnt <= (others => '0'); -- reset column_cnt
                unit_cnt <= (others => '0'); -- reset the unit_cnt(not nessessary, but just in case)
              elsif column_cnt >= 320 and column_cnt < 640 then
                column_cnt <= column_cnt + 1;
                colorpix(7 downto 0) <= border_color;
              else
                -- this is the blanking area, just incrase the column_cnt here, output nothing
                column_cnt <= column_cnt + 1;
                colorpix(7 downto 0) <= (others => '0');
              end if;
            end if;
            ----------------
            -- Column End --
            ----------------
          end if;  
        elsif height < 441 then
          if row_cnt = 6 then -- 7 pixels height for each "gpu_data"
            ------------------
            -- Column6 Start --
            ------------------
            if column_cnt < 801 then
              -- keep sending 128*5 = 640 pixels
              if column_cnt < 640 then -- within the display area
                -- send the same data for 5 times
                if unit_cnt < 5 then
                  if unit_cnt = 4 then 
                    unit_cnt <= (others => '0');
                    column_cnt <= column_cnt + 1; 
                    address_mem <= address_mem + 1; -- move to next address
                  elsif unit_cnt = 1 then
                    colorpix(7 downto 0) <= indata(7 downto 0); -- only change the input at the first cp
                    unit_cnt <= unit_cnt + 1;
                    column_cnt <= column_cnt + 1; 
                  else
                    column_cnt <= column_cnt + 1; -- else time, just increase the column_cnt
                    unit_cnt <= unit_cnt + 1;
                  end if;
                end if;
                
              elsif column_cnt = 800 then -- reset everything on the last cp of column_cnt
                row_cnt <= (others => '0'); 
                height <= height + 1;
                address_mem <= address_mem + 1; -- move to next address
                column_cnt <= (others => '0'); -- reset column_cnt
                unit_cnt <= (others => '0'); -- reset the unit_cnt(not nessessary, but just in case)
                
              else
                -- this is the blanking are, just incrase the column_cnt here, output nothing
                column_cnt <= column_cnt + 1;
                colorpix(7 downto 0) <= "00000000";
              end if;
            end if;
            -----------------
            -- Column6 End --
            -----------------
          else
            ------------------
            -- Column Start --
	    ------------------
            if column_cnt < 801 then
              -- keep sending 128*5 = 640 pixels
              if column_cnt < 640 then -- within the display area
                -- send the same data for 5 times
                if unit_cnt < 5 then
                  if unit_cnt = 4 then 
                    unit_cnt <= (others => '0');
                    column_cnt <= column_cnt + 1; 
                    address_mem <= address_mem + 1; -- move to next address
                  elsif unit_cnt = 1 then
                  colorpix(7 downto 0) <= indata(7 downto 0); -- only change the input at the first cp
                  unit_cnt <= unit_cnt + 1;
                  column_cnt <= column_cnt + 1; 
                else
                  column_cnt <= column_cnt + 1; -- else time, just increase the column_cnt
                  unit_cnt <= unit_cnt + 1;
                end if;
              end if;
              
            elsif column_cnt = 800 then -- reset everything on the last cp of column_cnt
              row_cnt <= row_cnt + 1; -- next row, and height increase by 1 too
              height <= height + 1;
              address_mem <= address_mem - 128; -- decrease the address by 128, back to the beginning
              column_cnt <= (others => '0'); -- reset column_cnt
              unit_cnt <= (others => '0'); -- reset the unit_cnt(not nessessary, but just in case)
            else
                                        -- this is the blanking are, just incrase the column_cnt here, output nothing
              column_cnt <= column_cnt + 1;
              colorpix(7 downto 0) <= ("00000000");
            end if;
          end if;
                                        ----------------
                                        -- Column End --
                                        ----------------	
        
        end if;
        
        -- during the blanking zone, just increase the counter.
      else
        if column_cnt = 800 then
          height <= height + 1;
          column_cnt <= (others => '0');
          
        elsif column_cnt < 640 then -- within the display area
          -- send the same data for 5 times
          if unit_cnt < 5 then
            if unit_cnt = 4 then 
              unit_cnt <= (others => '0');
              column_cnt <= column_cnt + 1; 
            elsif unit_cnt = 1 then
              colorpix(7 downto 0) <= border_color;
              unit_cnt <= unit_cnt + 1;
              column_cnt <= column_cnt + 1; 
            else
              column_cnt <= column_cnt + 1; -- else time, just increase the column_cnt
              unit_cnt <= unit_cnt + 1;
            end if;
          end if;
          
        else
          column_cnt <= column_cnt + 1;
          colorpix(7 downto 0) <= "00000000";
        end if;
      end if;   
      --------------------------------------------------------------------------------
    else
      pixel_cnt <= pixel_cnt + 1;
    end if;
  end if;
end process;
end Behavioral;

