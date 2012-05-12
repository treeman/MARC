library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity colorpixSender is
    Port ( 
      rst : in std_logic;                               -- reset signal
      clk : in std_logic;                               -- Universal clock: 100MHz
      indata : in  STD_LOGIC_VECTOR (7 downto 0);       -- data read from memory_dual_port
      colorpix : out  STD_LOGIC_VECTOR (7 downto 0);    -- color data to vga-port
      border_color : in std_logic_vector (7 downto 0);  -- color for non-data area
      address : out  STD_LOGIC_VECTOR (12 downto 0));   -- memory address to memory_dual_port
end colorpixSender;

architecture Behavioral of colorpixSender is

signal row_cnt : std_logic_vector (3 downto 0) := (others => '0');      -- counter for repeating same row 7 times, to have 7 pixels height for each data.
signal column_cnt : std_logic_vector (10 downto 0) := (others => '0');  -- counter for row timing
signal unit_cnt : std_logic_vector (2 downto 0) := (others => '0');     -- counter for repeating same data 5 times, to have 5 pixels width
signal height : std_logic_vector (11 downto 0) := (others => '0');      -- counter for column timing
signal address_mem : STD_LOGIC_VECTOR (12 downto 0) := (others => '0'); -- temp_address signal
signal pixel_cnt : std_logic_vector(1 downto 0) := "00";                -- counter for colorpixSender to use 25MHz clk

begin
  process(clk)
  begin
    if (rising_edge(clk)) then
      if rst = '1' then                                             -- reset all the counters, temp signals and output signals
        colorpix <= (others => '0');
        row_cnt <= (others => '0');
        column_cnt <= (others => '0');
        unit_cnt <= (others => '0');
        pixel_cnt <= "00";
        address_mem <= "0000000000000";
        height <= "000000000000";
      end if;
      
      if pixel_cnt = "11" then                                      -- execute the following code each 4 times 100MHz, which is 25MHz
        pixel_cnt <= "00";

        ---------------
        -- Main start--
        ---------------
        address <= address_mem;                                     -- output the tmp address
        
        if height = 525 then                                        -- reset counters and address when it reaches the max area
          if column_cnt = 800 then
            height <= (others => '0');
            column_cnt <= (others => '0');
            row_cnt <= (others => '0');
            unit_cnt <= (others => '0');
            address_mem <= (others => '0');
          else
            column_cnt <= column_cnt + 1;
          end if;
          
        elsif height >= 441 and height < 448 then                   -- within the display area (notice that we only display for 64*7=448 lines)
          if row_cnt = 6  then
            -------------------
            -- Column6 Start --
            -------------------
            if column_cnt < 801 then              
              if column_cnt < 320 then                              -- only display half length, because address will reach max.
                if unit_cnt < 5 then                                -- send the same data for 5 times
                  if unit_cnt = 4 then 
                    unit_cnt <= (others => '0');
                    column_cnt <= column_cnt + 1; 
                    address_mem <= address_mem + 1;                 -- move to next address after each 5 cp
                  elsif unit_cnt = 1 then
                    colorpix(7 downto 0) <= indata(7 downto 0);     
                    unit_cnt <= unit_cnt + 1;
                    column_cnt <= column_cnt + 1; 
                  else
                    column_cnt <= column_cnt + 1;                   -- else time, just increase the column_cnt
                    unit_cnt <= unit_cnt + 1;
                  end if;
                end if;
              elsif column_cnt = 800 then                           -- reset everything on the last cp of column_cnt
                row_cnt <= (others => '0'); 
                height <= height + 1;
                address_mem <= (others => '0');                     -- this is the end of output data. reset the address counter 
                column_cnt <= (others => '0');                      -- reset column_cnt
                unit_cnt <= (others => '0');                        -- reset the unit_cnt(not nessessary, but just in case)
              elsif column_cnt >= 320 and column_cnt < 640 then
                column_cnt <= column_cnt + 1;
                colorpix(7 downto 0) <= "00111111";
              else
                column_cnt <= column_cnt + 1;                       -- this is the blanking area, just incrase the column_cnt here, output nothing
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
              if column_cnt < 320 then 
                if unit_cnt < 5 then
                  if unit_cnt = 4 then 
                    unit_cnt <= (others => '0');
                    column_cnt <= column_cnt + 1; 
                    address_mem <= address_mem + 1; 
                  elsif unit_cnt = 1 then
                    colorpix(7 downto 0) <= indata(7 downto 0); 
                    unit_cnt <= unit_cnt + 1;
                    column_cnt <= column_cnt + 1; 
                  else
                    column_cnt <= column_cnt + 1; 
                    unit_cnt <= unit_cnt + 1;
                  end if;
                end if;
              elsif column_cnt = 800 then 
                row_cnt <= row_cnt + 1; 
                height <= height + 1;
                address_mem <= address_mem - 64;
                column_cnt <= (others => '0'); 
                unit_cnt <= (others => '0'); 
              elsif column_cnt >= 320 and column_cnt < 640 then
                column_cnt <= column_cnt + 1;
                colorpix(7 downto 0) <= "00111111";
              else
                column_cnt <= column_cnt + 1;
                colorpix(7 downto 0) <= (others => '0');
              end if;
            end if;
            ----------------
            -- Column End --
            ----------------
          end if;  
          
        elsif height < 441 then                                     -- this is "normal" displaying area
          if row_cnt = 6 then                                       -- 7 pixels height for each "gpu_data"
            -------------------
            -- Column6 Start --
            -------------------
            if column_cnt < 801 then                                -- as same as the timing in vga_controller (HMAX)
              if column_cnt < 640 then                              -- keep sending 128*5 = 640 pixelswithin the display area
                if unit_cnt < 5 then                                -- send the same data for 5 times
                  if unit_cnt = 4 then 
                    unit_cnt <= (others => '0');
                    column_cnt <= column_cnt + 1; 
                    address_mem <= address_mem + 1;                 -- move to next address
                  elsif unit_cnt = 1 then
                    colorpix(7 downto 0) <= indata(7 downto 0);     -- only change the input at the first cp
                    unit_cnt <= unit_cnt + 1;
                    column_cnt <= column_cnt + 1; 
                  else
                    column_cnt <= column_cnt + 1;                   -- else time, just increase the column_cnt
                    unit_cnt <= unit_cnt + 1;
                  end if;
                end if;
              elsif column_cnt = 800 then                           -- reset all the counters at HMAX
                row_cnt <= (others => '0');                         -- this is the last row of "7 pixels height", reset row_cnt after this row            
                height <= height + 1;                               
                address_mem <= address_mem + 1;                     -- move to next address
                column_cnt <= (others => '0');                      -- reset column_cnt
                unit_cnt <= (others => '0');                        -- reset the unit_cnt(not nessessary, but just in case)

              else
                column_cnt <= column_cnt + 1;                       -- this is the blanking are, just incrase the column_cnt here, output nothing
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
              if column_cnt < 640 then
                if unit_cnt < 5 then
                  if unit_cnt = 4 then 
                    unit_cnt <= (others => '0');
                    column_cnt <= column_cnt + 1; 
                    address_mem <= address_mem + 1;
                  elsif unit_cnt = 1 then
                  colorpix(7 downto 0) <= indata(7 downto 0); 
                  unit_cnt <= unit_cnt + 1;
                  column_cnt <= column_cnt + 1; 
                else
                  column_cnt <= column_cnt + 1; 
                  unit_cnt <= unit_cnt + 1;
                end if;
              end if;
              
            elsif column_cnt = 800 then                             -- reset everything on the last cp of column_cnt
              row_cnt <= row_cnt + 1;                               -- next row, and height increase by 1 too
              height <= height + 1;
              address_mem <= address_mem - 128;                     -- decrease the address by 128, back to the beginning
              column_cnt <= (others => '0');                        -- reset column_cnt
              unit_cnt <= (others => '0');                          -- reset the unit_cnt(not nessessary, but just in case)
            else
              column_cnt <= column_cnt + 1;                         -- this is the blanking are, just incrase the column_cnt here, output nothing
              colorpix(7 downto 0) <= ("00000000");
            end if;
            ----------------
            -- Column End --
            ----------------	
          end if;
        end if;
        
      else
        if column_cnt = 800 then                                    -- during the blanking zone, just increase the counter.
          height <= height + 1;
          column_cnt <= (others => '0');
          
        elsif column_cnt < 640 then                                 -- within the border area
          if unit_cnt < 5 then
            if unit_cnt = 4 then 
              unit_cnt <= (others => '0');
              column_cnt <= column_cnt + 1; 
            elsif unit_cnt = 1 then
              colorpix(7 downto 0) <= border_color;                 -- output the border color only
              unit_cnt <= unit_cnt + 1;
              column_cnt <= column_cnt + 1; 
            else
              column_cnt <= column_cnt + 1;
              unit_cnt <= unit_cnt + 1;
            end if;
          end if;
          
        else
          column_cnt <= column_cnt + 1;
          colorpix(7 downto 0) <= "00000000";
        end if;
      end if;   
      ---------------
      -- Main ends--
      ---------------
    else
      pixel_cnt <= pixel_cnt + 1;
    end if;
  end if;
end process;
end Behavioral;

