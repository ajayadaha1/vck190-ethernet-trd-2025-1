--(C) Copyright 2020 - 2021 Xilinx, Inc.
--Copyright (C) 2022 - 2023, Advanced Micro Devices, Inc
--SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/07/2021 07:15:02 PM
-- Design Name: 
-- Module Name: hw_master1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hw_master1 is 
    Port   (
			-- Global Clock Signal.
           s_axis_clk             : in STD_LOGIC;
			-- Global Reset Singal. This Signal is Active Low
           s_axis_resetn          : in STD_LOGIC;
			-- input data from the MCDMA control stream via FIFO
           s_axis_cntrl_tdata     : in STD_LOGIC_VECTOR  (31 downto 0);
		    -- input valid from the MCDMA control stream via FIFO
           s_axis_cntrl_tvalid    : in STD_LOGIC;
		   -- input tlast from the MCDMA control stream via FIFO
           s_axis_cntrl_tlast     : in STD_LOGIC;
		   -- output tready to the MCDMA control stream via FIFO
           s_axis_cntrl_tready    : out STD_LOGIC;
		   -- input tkeep from the MCDMA control stream via FIFO
		   s_axis_cntrl_tkeep     : in STD_LOGIC_VECTOR  (3 downto 0) := (others => '0');
		   -- 80 bit timestamp input 
           tx_timestamp_tod       : in STD_LOGIC_VECTOR  (79 downto 0);
		   -- input valid for timestamp
           tx_timestamp_tod_valid : in STD_LOGIC;
		   -- PTP mode operation input to MRMAC
           tx_ptp_1588op_in       : out STD_LOGIC_VECTOR (1 downto 0);
		   -- interrupt to CIPS
           interrupt              : out STD_LOGIC := '0';
		   -- initialize the address and timestamp write into memory
           init_mem_write         : out STD_LOGIC := '0';
		   -- done signal indicating memory wirte completion
           writes_done	          : in  STD_LOGIC := '0';
		   -- input to the intermediate FIFO
           fifo_input             : out std_logic_vector (159 downto 0);
		   -- Error signal from the AXI memory wite logic 
           error                  : in std_logic;
		   -- input tag from MRMAC
           tx_ptp_tstamp_tag_in   : in std_logic_vector  (15 downto 0);
		   -- tlast signal of the MCDMA MM2S interface
           s_axis_mm2s_tlast      : in std_logic;
		   -- tvalid signal of the MCDMA MM2S interface
           s_axis_mm2s_tvalid     : in std_logic;
		   -- ready signal from the MCDMA S2MM interface
           mrmac_tx_tready        : in std_logic;
		   -- ready signal to the MRMAC input stream
           data_ready             : out std_logic;
		   -- valid signal from the MRMAC input stream
           data_valid             : out std_logic;
           --input data to 1-step fifo
           data_fifo_in           : out std_logic_vector (31 downto 0);
	       -- input Ready from the 1stp helper block
		   m_axis_tready  : in STD_LOGIC :='0';
		   -- output data to the 1stp helper block
           m_axis_tdata   : out STD_LOGIC_VECTOR (31 downto 0);
		   -- output valid to the 1stp helper block
           m_axis_tvalid  : out STD_LOGIC := '0';
		   -- output tlast to the 1stp helper block	   
           m_axis_tlast   : out STD_LOGIC := '0';
		   -- output tkeep to the 1stp helper block
           m_axis_tkeep   : out STD_LOGIC_VECTOR (3 downto 0);
           --32bit TOD data in         
           t2_tdata_in        : in std_logic_vector (63 downto 0);
		   --tlast from cmd fifo
		   cmd_tlast  : in std_logic;
		   -- ready from cmd fifo
		   cmd_tready : in std_logic;
		   -- valid from cmd fifo
		   cmd_tvalid : in std_logic;
		   -- write enable to capture t2 timestamp
		   t2_wr_en: in std_logic
           );
           
end hw_master1;

architecture Behavioral of hw_master1 is 

type states is (idle,first_word,second_word,third_word,fourth_word,flag_detect,wait_for_valid_ts,ts_mem_write,wait_for_tlast);
		   -- idle: this state is responsible to assign default values to all signals  
		   -- first_word: This state is responsible to extract the APP0 from cntrl data stream of AXI MCDMA 
		   --second word: This state is responsible to extract the APP1 from cntrl data stream of AXI MCDMA 
		   -- third_word: This state is responsible to extract the APP2 from cntrl data stream of AXI MCDMA
		   -- flag_detect: This state is responsible to check for the ptp mode bits from APP0 of MCDMA 
		   --wait_for_valid_ts: This state will wait for valid timestamp from MRMAC 
		   -- ts_mem_write: This state is responsible to initiate a write into the memory
		   --wait_for_tlast: This state is responsible to start next transaction base don tlast of data stream   
           signal curr_state, nxt_state    : states;
		   -- lower 32 bit address from MCDMA USER APP fields
           signal addr_1        		   : std_logic_vector (31 downto 0) := (others =>'0');
		   -- upper 32 bit address from MCDMA USER APP fields
           signal addr_2        		   : std_logic_vector (31 downto 0) := (others =>'0');
		   -- tag from MCDMA USER APP fields
           signal addr_3        		   : std_logic_vector (31 downto 0) := (others =>'0');
		   -- lower 2 bits from MCDMA USER APP fields to check the for PTP mode
           signal ptp_flag      		   : std_logic_vector (1 downto 0)  := (others =>'0');
		   -- signal to compre input and output tag
           signal ts3           		   : std_logic_vector (31 downto 0) := (others =>'0');
		   -- 15 bits reserved field
           signal reserved      		   : std_logic_vector (14 downto 0) := (others =>'0');
		   -- signal to capture tlast from MCDMA control stream
           signal tlast         		   : std_logic := '0';
		   -- ready signal to MCDMA control stream via FIFO
           signal s_axis_tready 		   : std_logic := '0';
		   -- signal to count the number of USER APP fields form MCDMA control stream
		   signal cnt_ctrl_data            : std_logic_vector (2 downto 0)   := (others =>'0');
		   -- signal to capture the timestamp valid 
	       signal ts_valid_flag            : std_logic := '0';
		   -- final 64 bit memory write address
	       signal addr                     : std_logic_vector  (63 downto 0);
		   -- final 80 bit timestamp
	       signal ts_to_mem                : std_logic_vector  (95 downto 0);
		   -- signal to capture the current tag from the MCDMA USER-APP fields
	       signal curr_ts_tag              : std_logic_vector  (15 downto 0);
		   -- signal to capture tlast of the MCDMA MM2S interface
           signal tlast_int                : std_logic;
           --signal to check if checksum needs to be captured
           signal csum_flag                : std_logic_vector (3 downto 0) := (others =>'0');
           --signal to capture checksum
           signal csum_data                : std_logic_vector (31 downto 0) := (others =>'0');
           --signal to count 1-step fifo write
           signal e2e_cnt_fifo_wr              : std_logic_vector (2 downto 0) := ("000");
          --signal to fill the reserved bits
          signal reserved_1                : std_logic_vector (11 downto 0) := (others =>'0');
          --signal to fill the 32 bit zeros
          signal reserved_2                : std_logic_vector (31 downto 0) := (others =>'0');
          --signal to send e2e data to fifo
          signal e2e_data_fifo_in           : std_logic_vector (31 downto 0);
           --lower 32bit TOD data in
          signal t2_low_data_in         :   std_logic_vector (31 downto 0);
           --higher 32bit TOD data in
           signal t2_high_data_in         : std_logic_vector (31 downto 0);
           -- signal to enable reading of t2
           signal t2_read_enable: std_logic; 
		   -- signal to check reception of user app field
           signal app_field_rcv : std_logic;  
		   -- signal to check end of transaction based on tlast
           signal onestep_block_tlast: std_logic;
		   -- signal to output t2 timestamp data
           signal t2_tdata_out : std_logic_vector (63 downto 0);
           --signal to register tod valid from timer syncer
           signal timestamp_valid : std_logic;
           
            -- Edited to clean up latch
           signal tx_ptp_1588op_in_temp    : STD_LOGIC_VECTOR  (1 downto 0);
           signal init_mem_write_temp      : STD_LOGIC;
           signal fifo_input_temp          : std_logic_vector (159 downto 0);
           signal data_ready_temp          : std_logic;
           signal data_valid_temp          : std_logic;

        

begin

-- process to switch states
process (s_axis_clk)

begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then 
      curr_state <= idle;
    else
      curr_state <= nxt_state;
    end if;
  end if;  

end process;

process (s_axis_cntrl_tvalid, s_axis_tready, ptp_flag, tlast, curr_state, ts_valid_flag, cnt_ctrl_data,tlast_int,csum_flag) 

begin

  Case curr_state is

    --this state is responsible to assign default values to all signals  
    when idle=>  
      nxt_state <= first_word;
      
    
    --this state is responsible to extract the APP0 from cntrl data stream of AXI MCDMA  
    when first_word =>
    --  if (s_axis_cntrl_tvalid = '1' and s_axis_tready = '1' and cnt_ctrl_data = "001") then
		if (cnt_ctrl_data = "001") then
        nxt_state <= second_word;
    --  elsif (cnt_ctrl_data = "000") then
		else
        nxt_state <= first_word;
     end if;
     
    
    --This state is responsible to extract the APP1 from cntrl data stream of AXI MCDMA  
    when second_word => 
    --  if (s_axis_cntrl_tvalid = '1' and s_axis_tready = '1' and cnt_ctrl_data = "010") then
		if (cnt_ctrl_data = "010") then
        nxt_state <= third_word;
    --  elsif (cnt_ctrl_data = "001" or cnt_ctrl_data = "000") then
		else
        nxt_state <= second_word;
      end if;  
    
    --This state is responsible to extract the APP2 from cntrl data stream of AXI MCDMA 
    when third_word =>
    --   if (s_axis_cntrl_tvalid = '1' and s_axis_tready = '1' and cnt_ctrl_data = "011" and ptp_flag="01") then
		if (cnt_ctrl_data = "011" and ptp_flag="01") then
         nxt_state <= fourth_word;  
    --   elsif (s_axis_cntrl_tvalid = '1' and s_axis_tready = '1' and cnt_ctrl_data = "011" and ptp_flag="10") then
		elsif (cnt_ctrl_data = "011" and ptp_flag="10") then
         nxt_state <= flag_detect;           
		elsif (ptp_flag = "00") then
         nxt_state <= wait_for_tlast;
		else
		 nxt_state <= third_word;
       end if;
          

    --This state is responsible to extract the APP3 from cntrl data stream of AXI MCDMA 
    when fourth_word =>
    --   if (s_axis_cntrl_tvalid = '1' and s_axis_tready = '1' and cnt_ctrl_data = "100") then
		if (cnt_ctrl_data = "100") then
         nxt_state <= flag_detect;  
	--	elsif (cnt_ctrl_data = "011") then
	--	 nxt_state <= third_word;
		else
		 nxt_state <= fourth_word;
	
       end if;          
		
   --This state is responsible to check for the ptp mode bits from APP0 of MCDMA 		
	when flag_detect => 
        if ((ptp_flag= "10")) then
          nxt_state <= wait_for_valid_ts;
        else 
          nxt_state <= wait_for_tlast;
        end if;
        
    --This state will wait for valid timestamp from MRMAC    
    when wait_for_valid_ts =>
      if (ts_valid_flag = '1') then
        nxt_state <= ts_mem_write;
      else
        nxt_state <= wait_for_valid_ts;
      end if;
              
    
    --This state is responsible to initiate a write into the memory  
    when ts_mem_write => 
        nxt_state <= wait_for_tlast; 
                                                                     
	--This state is responsible to start next transaction base don tlast of data stream          
    	when wait_for_tlast => 
    	if (tlast_int= '1') then
          nxt_state <= idle;  
        else
          nxt_state <= wait_for_tlast;
        end if;    
      
    when others => 
      nxt_state <= idle;
    
  end Case;   
          
end process;



--This process waits for the tlast signal from the MCDMA
proc_tlast_capture:process (s_axis_clk)
begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then
      tlast_int <= '0';
      
      else
    
        if (s_axis_mm2s_tlast = '1' and s_axis_mm2s_tvalid = '1' and mrmac_tx_tready = '1') then
          tlast_int <= '1';
		  -- capture the tlast signal when tlast, tvalid and tready are high
        elsif (curr_state = wait_for_tlast and nxt_state = idle) then
          tlast_int <= '0';
		  -- after capturing the tlast, make the signal 0 when going to idle
		else 
          tlast_int <= tlast_int; -- else required
        end if;  
    end if;
  end if;
end process;


-- This process receives the 80 bit timestamp from the CF_to_TOD logic
--and arranges it into 3 32 bit word for memory writes.
--proc_timestamp:process (tx_timestamp_tod_valid, s_axis_resetn) --s_axis_clk

--begin

--    if s_axis_resetn='0' then
--      ts_to_mem <= (others => '0');
--    elsif (tx_timestamp_tod_valid = '1') then
--      ts_to_mem <= "1" & reserved & tx_timestamp_tod;
--	  -- append 80 bit timestamp with reserved and qualifier bit to make it 96 bit for memory write
--    end if;
--end process;

proc_timestamp:process (s_axis_clk) --s_axis_clk
begin

if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then 
      ts_to_mem <= (others => '0');
    else
        if (tx_timestamp_tod_valid = '1') then
            ts_to_mem <= "1" & reserved & tx_timestamp_tod;                                
        else
            ts_to_mem <= ts_to_mem;    -- else required
        end if;
    end if;
end if;
end process;

--This process captures the ToD valid signal and registers it
proc_timestamp_valid:process (s_axis_clk)

begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then
      ts_valid_flag <= '0';
      
      else
      
--       if (tx_timestamp_tod_valid = '1' and curr_state = wait_for_valid_ts and nxt_state= wait_for_valid_ts) then
       if (timestamp_valid = '1' and curr_state = wait_for_valid_ts and nxt_state= wait_for_valid_ts) then
          ts_valid_flag <= '1'; 
		  -- capture the timestamp valid and assign it to a flag
        elsif (curr_state = wait_for_tlast and nxt_state <= idle) then
          ts_valid_flag <= '0';
		else
          ts_valid_flag <= ts_valid_flag;	-- else required
        end if;
    end if;
  end if;
end process; 


-- this is the process to register the timestamp valid from timer syncer
--This process captures the ToD valid signal and registers it
proc_timestamp_valid_reg:process (s_axis_clk)

begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then
      timestamp_valid <= '0';
      
      else
      
       if (tx_timestamp_tod_valid = '1' ) then
          timestamp_valid <= '1'; 
		  -- capture the timestamp valid and assign it to a flag
        else
          timestamp_valid <= '0';
      
        end if;
    end if;
  end if;
end process; 



   
   
--This process controls the ready signal of the cntrl stream going to DMA
proc_rdy: process (s_axis_clk)

begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then 
      s_axis_tready    <= 	'0';	
       
    else
	   
	  if (curr_state = idle and nxt_state = first_word) then
	    s_axis_tready <= '1';
	  elsif (curr_state = first_word and nxt_state = first_word) then
	    s_axis_tready <= '1';
	  elsif (curr_state = first_word and nxt_state = second_word) then
	    s_axis_tready <= '1';
	  elsif (curr_state = second_word and nxt_state = third_word) then
	    s_axis_tready <= '1';
	  elsif (curr_state = third_word and nxt_state = fourth_word) then
	    s_axis_tready <= '1';  
	  elsif (curr_state = third_word and nxt_state = flag_detect) then
	    s_axis_tready <= '1';
	  elsif (curr_state = third_word and nxt_state = wait_for_tlast) then
	    s_axis_tready <= '1';	    
	  elsif (curr_state = fourth_word and nxt_state = flag_detect) then
	    s_axis_tready <= '1';    	    
	  elsif (s_axis_cntrl_tvalid = '1' and s_axis_cntrl_tlast = '1') then
	    s_axis_tready <= '0'; 
	  else					--else required
		s_axis_tready <= s_axis_tready;
	  end if;
	  -- keep the ready signal high until 3 USER-APP fields are received from MCDMA via FIFO
	end if;    
  end if;
end process;


-- This process takes the address of the memory from APP0 and APP1 of 
--USER APP fields of AXI MCDMA and concatenates them to craete a 64 bit address.
-- It also extracts the ptp flag from APP) field.
proc_data_addr_assign: process (s_axis_clk)

begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then 
      addr_1   <=  (others => '0');
      addr_2   <=  (Others => '0');
      addr     <=  (others => '0');	
      ptp_flag       <=  "00";
      tlast          <=  '0';
      
    else
   
      if (curr_state = first_word and nxt_state = second_word) then
	    addr_1 <= s_axis_cntrl_tdata;
	  elsif (curr_state = second_word and nxt_state = third_word) then 
	    addr_2 <= s_axis_cntrl_tdata;
	    ptp_flag <= addr_1(1 downto 0);
		-- capture ptp_flag from lower 2 bits of USER-APP field 0
        tlast <= s_axis_cntrl_tlast;
      elsif (curr_state = third_word and (nxt_state = flag_detect or nxt_state = fourth_word  or nxt_state = wait_for_tlast)) then
        addr <= addr_2 & (addr_1 (31 downto 2)& "00");
		-- convert 2 32 bit addresses into one 64 bit address
	  else 					--else required
        addr <= addr; 
        addr_1 <= addr_1;
        addr_2 <= addr_2;
        ptp_flag <= ptp_flag;
        tlast <= tlast;   
      end if;
	end if;    
  end if;
end process;
  
 
 --This process drives the MRMAC ptp port using the extracted ptp flag value. 
proc_flag: process (s_axis_clk)  

begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then 
      tx_ptp_1588op_in_temp <= "00";
      
    else
    
      if (curr_state = third_word and (nxt_state = flag_detect or nxt_state = fourth_word or nxt_state = wait_for_tlast)) then
        tx_ptp_1588op_in_temp <= ptp_flag;
		--drive the MRMAC with the captured ptp mode from USER-APP fields
	  else
        tx_ptp_1588op_in_temp <= tx_ptp_1588op_in_temp;	--else required
      end if;
	end if;    
  end if;
end process;


--This process is used to count the data from AXI MCDMA cntrl field.
----The first 32 bits is flag and can be ignored.
--proc_count: process (s_axis_clk)

--begin

--  if (s_axis_clk='1' and s_axis_clk' event) then
--    if s_axis_resetn='0' then 
--      cnt_ctrl_data <= "000";
--    else
      
--      if (curr_state = idle and nxt_state = first_word) then
--        cnt_ctrl_data <= "000";
--      elsif (curr_state = first_word and nxt_state = first_word and s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then 
--        cnt_ctrl_data <= (cnt_ctrl_data) + (1);
--      elsif (curr_state = first_word and nxt_state = second_word and s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then
--       cnt_ctrl_data <= (cnt_ctrl_data) + (1);     
--      elsif (curr_state = second_word and nxt_state = third_word and s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then
--       cnt_ctrl_data <= (cnt_ctrl_data) + (1);
--      elsif (curr_state = third_word and nxt_state = fourth_word and s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then
--       cnt_ctrl_data <= (cnt_ctrl_data) + (1);
--      elsif (curr_state = third_word and nxt_state = flag_detect and s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then
--       cnt_ctrl_data <= (cnt_ctrl_data) + (1);
--      elsif (curr_state = third_word and nxt_state = wait_for_tlast and s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then
--       cnt_ctrl_data <= (cnt_ctrl_data) + (1);
--      elsif (curr_state = fourth_word and nxt_state = flag_detect and s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then
--       cnt_ctrl_data <= (cnt_ctrl_data) + (1);          
--		-- increase count each time when a valid transaction is initiated by MCDMA via FIFO
--      elsif (curr_state = third_word and nxt_state = flag_detect) then
--        cnt_ctrl_data <= "000";
--      else
--        cnt_ctrl_data <= cnt_ctrl_data;
--      end if;
--    end if;
--  end if;
--end process;

proc_count: process (s_axis_clk)          -- output logic w.r.t state           

begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then 
      cnt_ctrl_data <= "000";
    else
        if (s_axis_cntrl_tlast = '1' and s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then
            cnt_ctrl_data <= "000";
        else											   
			if (s_axis_cntrl_tvalid ='1' and s_axis_tready = '1') then 
				cnt_ctrl_data <= (cnt_ctrl_data) + (1);
			else
				cnt_ctrl_data <= cnt_ctrl_data;
			end if;
		end if;
	end if;        
  end if;
  end process;


-- This process initializes the memory write of the timestamp.
-- The signal init_mem_write is the start of memory write to 
-- write into the Internal data FIFO 
proc_init_mem_write: process (s_axis_clk)

begin

  if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then
      init_mem_write_temp <= '0';
      
    else
    
      if (curr_state = wait_for_valid_ts and nxt_state = ts_mem_write) then
        init_mem_write_temp <= '1';
		-- once address and timestamp are obtained, initiate the memory write 
      elsif (curr_state = idle and nxt_state = first_word) then
         init_mem_write_temp <= '0';
	  else 
         init_mem_write_temp <= init_mem_write_temp;	--else required
      end if;
    end if;
  end if;
end process;    


-- This process writes the timestamp and 
-- address into the Internal data FIFO 
proc_data_to_fifo: process (s_axis_clk)

begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then        
      fifo_input_temp <= (others => '0'); 
      
    elsif (curr_state = wait_for_valid_ts and nxt_state = ts_mem_write) then
      fifo_input_temp <= ts_to_mem & addr;
	  -- append the timestamp and address for memory write
	else 
      fifo_input_temp <= fifo_input_temp;	--else required
    end if;
  end if;
end process; 
   
   
-- This process extracts the tag from APP2 field, sends it to MMRMAC
-- Compares it with received tag     
proc_tag: process (s_axis_clk)

begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then     
      curr_ts_tag <= (others => '0');
      
    else
    
      if (curr_state = third_word and (nxt_state = wait_for_tlast or nxt_state = flag_detect or nxt_state = fourth_word)) then
        addr_3 <= s_axis_cntrl_tdata; 
		-- capture the tag and assign to addr_3
      end if;
    end if;
  
  curr_ts_tag <= addr_3 (15 downto 0); 
      if (tx_ptp_tstamp_tag_in = curr_ts_tag) then
        ts3(30 downto 30) <= "0";
      else
        ts3(30 downto 30) <= "1";
      end if;
	  --Compare tags and make the 95th bit of timestamp high/low accordingly
 end if;
end process;
 


--This process controls the data stream ready signal
proc_data_rdy_control: process (s_axis_clk)

begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then   
       data_ready_temp <= '0'; 

    else
    
      if (cmd_tlast = '1' and cmd_tready = '1' and cmd_tvalid = '1') then
        data_ready_temp <= '1';
		-- enable the data path ready after capturing the USER-APP fields irrespective of whether it is PTP packet or not
      elsif (s_axis_mm2s_tlast = '1' and s_axis_mm2s_tvalid = '1' and mrmac_tx_tready = '1') then
        data_ready_temp <= '0';
	  else 			--else required
        data_ready_temp <= data_ready_temp;
      end if;
    end if;
  end if;
end process;  
          
 
 
 --This process controls the data stream valid signal
proc_data_vld_control: process (s_axis_clk)

begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then   
       data_valid_temp <= '0'; 

    else
    
        if (cmd_tlast = '1' and cmd_tready = '1' and cmd_tvalid = '1') then
        data_valid_temp <= '1';
		-- enable the data path ready after capturing the USER-APP fields irrespective of whether it is PTP packet or not
		
		elsif (s_axis_mm2s_tlast = '1' and s_axis_mm2s_tvalid = '1' and mrmac_tx_tready = '1') then
        data_valid_temp <= '0';
		else
		data_valid_temp <= data_valid_temp; --else required
      end if;
    end if;
  end if;
end process;         



--This process is the check for capturing checksum during 1-step operation
proc_csum_flag: process (s_axis_clk)

begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then   
       csum_flag <= (others => '0'); 

    else
    
      if (curr_state = third_word and nxt_state = fourth_word) then
        csum_flag <= s_axis_cntrl_tdata (27 downto 24);
      elsif (curr_state = idle and nxt_state = first_word) then
        csum_flag <= (others => '0');  
	  else
		csum_flag <= csum_flag;		--else required
      end if;
    end if;
  end if;
end process;


--This process is to capture checksum during 1-step operation
proc_csum_data: process (s_axis_clk)

begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then   
       csum_data <= (others => '0'); 

    else
    
      if (curr_state = fourth_word and nxt_state = flag_detect and (csum_flag= "0101" or csum_flag= "1101") ) then
        csum_data <= s_axis_cntrl_tdata (31 downto 0);
      elsif (curr_state = idle and nxt_state = first_word) then
        csum_data <= (others => '0');   
	  else 
		csum_data <= csum_data;  --else required
      end if;
    end if;
  end if;
end process;    


--This process will arrange the data to be written to the fifo for 1-step E2E sync packet
proc_1_step_data: process (s_axis_clk)
begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then   
       e2e_data_fifo_in <= (others => '0'); 
       e2e_cnt_fifo_wr <= ("000");

    else
    
      if (app_field_rcv = '1') then
        if (csum_flag= "0101" and m_axis_tready = '1') then
          if (e2e_cnt_fifo_wr= "000" ) then
            m_axis_tvalid <= '1';
            e2e_data_fifo_in <= addr_3 (15 downto 0) & reserved_1 & csum_flag ;
            e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr + 1;
          elsif (e2e_cnt_fifo_wr= "001" ) then
            m_axis_tvalid <= '1';
            e2e_data_fifo_in <= csum_data;
            e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
          elsif (e2e_cnt_fifo_wr= "010" ) then
            m_axis_tvalid <= '1';          
            e2e_data_fifo_in <= reserved_2;
            e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
          elsif (e2e_cnt_fifo_wr= "011" ) then
            m_axis_tvalid <= '1';          
            e2e_data_fifo_in <= reserved_2;
            e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
            onestep_block_tlast <= '1';
        elsif (e2e_cnt_fifo_wr > "011") then
            e2e_cnt_fifo_wr <= "000";   
            m_axis_tvalid <= '0';
            onestep_block_tlast <= '0';              
          else
            m_axis_tvalid <= '0';
            onestep_block_tlast <= '0';   
          end if;
        end if;
        
      if (csum_flag= "0010" and m_axis_tready = '1' ) then
        if (e2e_cnt_fifo_wr= "000" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= addr_3 (15 downto 0) & reserved_1 & csum_flag ;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "001" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= reserved_2;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "010" ) then
          m_axis_tvalid <= '1';          
          e2e_data_fifo_in <= reserved_2;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "011" ) then
          m_axis_tvalid <= '1';
          e2e_data_fifo_in <= reserved_2;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
          onestep_block_tlast <= '1'; 
        elsif (e2e_cnt_fifo_wr > "011") then
            e2e_cnt_fifo_wr <= "000";
             m_axis_tvalid <= '0';
            onestep_block_tlast <= '0';                 
        else
            m_axis_tvalid <= '0';                   
            onestep_block_tlast <= '0';   
        end if;
      end if;
      
      if (csum_flag= "1101" and m_axis_tready = '1' ) then
        if (e2e_cnt_fifo_wr= "000" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= addr_3 (15 downto 0) & reserved_1 & csum_flag ;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "001" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= csum_data;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "010" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= t2_tdata_out (31 downto 0);
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "011" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= t2_tdata_out (63 downto 32);
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
          onestep_block_tlast <= '1'; 
        elsif (e2e_cnt_fifo_wr > "011") then
            e2e_cnt_fifo_wr <= "000";  
            m_axis_tvalid <= '0';
            onestep_block_tlast <= '0';               
        else
            m_axis_tvalid <= '0';
            onestep_block_tlast <= '0';                    
        end if;
      end if; 
      
      if((ptp_flag = "00" or ptp_flag = "10") and m_axis_tready = '1') then
        if (e2e_cnt_fifo_wr= "000" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= addr_1;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "001" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= addr_2;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "010" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= reserved_2;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
        elsif (e2e_cnt_fifo_wr= "011" ) then
          m_axis_tvalid <= '1';        
          e2e_data_fifo_in <= reserved_2;
          e2e_cnt_fifo_wr <= e2e_cnt_fifo_wr+1;
          onestep_block_tlast <= '1'; 
        elsif (e2e_cnt_fifo_wr > "011") then
            e2e_cnt_fifo_wr <= "000";
            m_axis_tvalid <= '0';
            onestep_block_tlast <= '0';    
        else
            m_axis_tvalid <= '0';
            onestep_block_tlast <= '0';                                 
        end if;
      end if; 
    else 
            m_axis_tvalid <= '0';
            e2e_data_fifo_in <= (others => '0');
            onestep_block_tlast <= '0';  
        end if;   
               
      end if;
    end if;                    
end process; 


 -- this process will extract the t2 timestamp 
proc_t2_data:process (s_axis_clk)
begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then
      t2_tdata_out <= (others => '0');
      
    else
    
     if (t2_wr_en = '1') then  
       t2_tdata_out <= t2_tdata_in;
     else
       t2_tdata_out <= t2_tdata_out;
       end if;
    end if;
  end if;  
end process;
 
proc_fifo_cnt_wr:process (s_axis_clk)
begin

 if (s_axis_clk='1' and s_axis_clk' event) then
    if s_axis_resetn='0' then
        app_field_rcv <= ('0');
      
    else
    
      if (curr_state = third_word) then
       app_field_rcv <= ('1');
     elsif (onestep_block_tlast = '1') then
       app_field_rcv <= '0';
     else
       app_field_rcv <= app_field_rcv;
      end if;
    end if;
  end if;  
end process; 



   s_axis_cntrl_tready <= s_axis_tready; 
   m_axis_tdata <= e2e_data_fifo_in;
   m_axis_tlast <= onestep_block_tlast;
   tx_ptp_1588op_in <=  tx_ptp_1588op_in_temp;
   init_mem_write <= init_mem_write_temp;   
   fifo_input <= fifo_input_temp;   
   data_ready <= data_ready_temp;
   data_valid <= data_valid_temp;
   
      
end Behavioral;
