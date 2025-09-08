--(C) Copyright 2020 - 2021 Xilinx, Inc.
--Copyright (C) 2022- 2023, Advanced Micro Devices, Inc
--SPDX-License-Identifier: Apache-2.0
---------------------------------------------------------------------
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 1.0 
-- Additional Comments: 
--
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity RX_PTP_TS_PREPEND is
   port(
	     rx_axis_clk_in		    : in std_logic;         
		 -- axis clock 390.625 MHz
		 rx_axis_reset_in	    : in std_logic;		 
		 -- axis reset sync with rx_axis_clk_in			 
		 s_axis_tdata 	        : in std_logic_vector(63 downto 0); 
		 -- 64 bit AXI data received 
		 s_axis_tkeep           : in std_logic_vector(7 downto 0);  
		 -- indicates valid bytes 
		 s_axis_tlast           : in std_logic;                     
		 -- indicates last byte of the transaction
		 s_axis_tvalid          : in std_logic;		             
		 -- indicates the data recieved is a valid data
		 s_axis_tready          : out std_logic;                    
         -- asserted when the DUT is ready to accept data		       
		 m_axis_tdata           : out std_logic_vector(63 downto 0);
		 --	64 bit AXI data transmitted	 
         m_axis_tkeep           : out std_logic_vector(7 downto 0); 
		 -- indicates valid bytes 	 
         m_axis_tlast           : out std_logic; 
		 -- indicates last byte of the transaction
		 m_axis_tvalid          : out std_logic; 
		 -- indicates the data recieved is a valid data
		 m_axis_tready          : in std_logic;  
		 -- asserted when the DUT is ready to accept data		                                                             
		 fifo_reset             : out std_logic;
		 -- to reset the FIFOs in the Data Path during initialization,its a one time reset.		 		 
		 rx_timestamp_tod       : in std_logic_vector(79 downto 0);
		 -- 80 bit timestamp from TOD Conversion block stored in TOD FIFO 	  	 
		 
		 TOD_data_count         : in std_logic_vector(9 downto 0) ;
		 -- TOD FIFO data count 		 
		 fifo_full              : in std_logic;
		 -- FIFO Prog_full from AXI Stream FIFO_1 
		 mrmac_last             : in std_logic;
		 -- axis_tlast of MRMAC Rx axis Transcation
		 mrmac_valid            : in std_logic	;
		 -- axis_tvalid of MRMAC Rx axis Transaction 
		 fifo_valid             : out std_logic;
		 -- controls the AXI Stream FIFO valid when FIFO prog_full is asserted 
		 rd_en                  : out std_logic; 
		 -- Read enable to retrieved the data stored in FIFO during PTP detection         
         rd_data                : in std_logic_vector(15 downto 0);
		 -- retrieve the Rx data stored during PTP detection  
		 empty                  : in std_logic ;
		 
		 wr_en_t2_TOD           : out std_logic         
		);
     
end RX_PTP_TS_PREPEND;

architecture Behavioral of RX_PTP_TS_PREPEND is
 
  signal TS_DATA_WORD_0			    : std_logic_vector(63 downto 0):= (others => '0');
  -- stores the [63:0] bits of Timestamp information of corresponding Rx packet
  signal TS_DATA_WORD_1 		    : std_logic_vector(63 downto 0):= (others => '0');
  -- stores the  [79:64] bits of Timestamp info and remaining are reserved  
  signal m_axis_tdata_int           :  std_logic_vector(63 downto 0);
  -- internal m_axis_tdata signal
  signal s_axis_tready_int          : std_logic := '0';
  -- internal s_axis_tready signal
  signal m_axis_tvalid_int          : std_logic := '0';
  -- internal m_axis_tvalid signal
  signal m_axis_tlast_int           : std_logic := '0';    
  -- internal m_axis_tlast signal                         
  signal fifo_reset_int             : std_logic := '1';
  -- AXI Stream FIFOs reset internal signal
  signal fifo_valid_int             : std_logic := '1';
  -- AXI Stream FIFO valid internal signal     
                  
                                 
  type STATE is (WAIT_FOR_MCDMA_READY, WAIT_FOR_NEW_PACKET, START_NEW_PACKET_PROCESSING,
                 SEND_TS_DW_0_TO_MCDMA, SEND_TS_DW_1_TO_MCDMA, ACCEPT_RX_PACKET, PACKET_RX_DONE, PROCESS_NEXT_PACKET  );                 
 
  signal CURRENT_STATE, NEXT_STATE : STATE := WAIT_FOR_MCDMA_READY; 
  -- PTP Packet Detection and Timestamp Prepend State Machine states
  -- WAIT_4_MCDMA_READY     : once the system is out of Reset, wait in this state till MCDMA is ready to accept the data. 
  --                          once MCDMA is ready reset the stream FIFOs in the data path. This state is one time after Power ON 
  -- WAIT_FOR_NEW_PACKET    : wait for New Rx Packet and move to STORE_RX_PACKET_DATA state once tvalid is asserted
  -- START_NEW_PACKET_PROCESSING :
  -- SEND_TS_DW_0_TO_MCDMA  : send first 64 bits of Timestamp to MCDMA - {Timestamp is 80 bits}
  -- SEND_TS_DW_1_TO_MCDMA  : send remaining 16 bits of Timestamp DW[15:0] to MCDMA with Qualifier bit-DW[63] - remaining bits Reserved[62:16]
  -- ACCEPT_RX_PACKET   : send the remaining Datawords in AXI Stream FIFO to MCDMA till TLAST is received and move to PACKET_RX_DONE state
  -- PACKET_RX_DONE         : Reset all the control signals in this state and move to WAIT_FOR_NEW_PACKET for processing new packet  
  
begin
 
   
   

-- process current_state 

proc_state : process (rx_axis_clk_in)
  begin

    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then

      if (rx_axis_reset_in = '0') then
 
        CURRENT_STATE <= WAIT_FOR_MCDMA_READY;
        
	  else
	
	    CURRENT_STATE <= NEXT_STATE;
	    
	  end if;
	  
	end if;
	
  end process;	


-- this process implements the FSM and passes through different states based on Received S_AXIS Transaction and
-- other flags.

proc_nextstate : process (CURRENT_STATE, s_axis_tvalid, s_axis_tdata, m_axis_tready, s_axis_tlast, empty, s_axis_tready_int)
begin


   NEXT_STATE <= CURRENT_STATE;

   case CURRENT_STATE is
   
     when WAIT_FOR_MCDMA_READY =>
   
     -- Wait in this state, till MCDMA is ready to accept data after reset.
     -- The statemachine remains in this state during initilization only.  
       if( m_axis_tready = '1' ) then		 
		  
		 NEXT_STATE  <=  WAIT_FOR_NEW_PACKET;	
	     		  
	   else 
		
		 NEXT_STATE  <=  WAIT_FOR_MCDMA_READY;
		  
	   end if;	  
   
      
	when WAIT_FOR_NEW_PACKET =>
	
	    if(empty = '0') then 
		
		  NEXT_STATE  <= START_NEW_PACKET_PROCESSING;
		  
		else
		
		  NEXT_STATE  <= WAIT_FOR_NEW_PACKET;		  
		
		end if;		  


	-- the first 64 bits (DW0) of 80 bit Timestamp information is sent to MCDMA 

	when START_NEW_PACKET_PROCESSING =>	
	   
	    if(m_axis_tready  = '1' and s_axis_tvalid  = '1') then		  
		  
		  NEXT_STATE  <= SEND_TS_DW_0_TO_MCDMA;
		  
		else
		
		  NEXT_STATE  <= START_NEW_PACKET_PROCESSING;
		  
		end if;	 	

    		
-- the first 64 bits (DW0) of 80 bit Timestamp information is sent to MCDMA 

	when SEND_TS_DW_0_TO_MCDMA =>	
	   
	    if(m_axis_tready  = '1' ) then		  
		  
		  NEXT_STATE  <= SEND_TS_DW_1_TO_MCDMA;
		  
		else
		
		  NEXT_STATE  <= SEND_TS_DW_0_TO_MCDMA;
		  
		end if;	 	


-- the remaining 16 bits of 80 bit Timestamp info is sent to MCDMA along with Qualifier bit 

      when SEND_TS_DW_1_TO_MCDMA =>
	  
	    if(m_axis_tready  = '1') then	 
	     
		  NEXT_STATE           <= ACCEPT_RX_PACKET;
		  
		else
		
		  NEXT_STATE           <= SEND_TS_DW_1_TO_MCDMA;
		  
		end if;				

     -- in this state, the DUT indicates to the Master, that it is ready to accept the new packet by asserting the
     -- "s_axi_tready" when MCDMA is ready to accept the data and waits for the new packet arrival by continuously checking the "s_axi_tvalid"
     -- when s_axi_tvalid is asserted, the first word is stored in a FIFO and moves to the next state STORE_RX_PACKET_DATA  to
     -- store the next Data words required for the PTP Packet detection. 

     when ACCEPT_RX_PACKET => 	 		
     	     
	  -- if(s_axis_tvalid  = '1' and m_axis_tready = '1' and s_axis_tlast  = '1' ) then
	    if(s_axis_tvalid  = '1' and s_axis_tready_int = '1' and s_axis_tlast  = '1' ) then	
	   
	   	 
		  
	     NEXT_STATE  <= PACKET_RX_DONE;		   		    
	     		  
	   else 
	 	
		 NEXT_STATE  <= ACCEPT_RX_PACKET;
		  
	  end if;	         		  		  
	 
		
	  -- reset all the flags and counters required for next Packet PTP Detection
	  -- Move to WAIT_FOR_NEW_PACKET state, to start a new Packet processing
	  when PACKET_RX_DONE =>
	  
	      NEXT_STATE  <= PROCESS_NEXT_PACKET;
	   
	
	
	  when PROCESS_NEXT_PACKET =>
	  
	      NEXT_STATE  <= WAIT_FOR_NEW_PACKET;	      
	       
	   
	end case; 
	
	
	
    
end process;


-- once MCDMA is ready, reset the stream FIFOs in the data path. This state is one time after Power ON 
-- this will cleanup the incomplete packets stored during power on 

proc_fifo_reset : process (rx_axis_clk_in)
  begin

    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
 
      if (rx_axis_reset_in = '0') then

        fifo_reset_int <= '0';         
               
      elsif(CURRENT_STATE = WAIT_FOR_MCDMA_READY and NEXT_STATE = WAIT_FOR_NEW_PACKET)  then
      
        fifo_reset_int <= '0';
        
       else
      
        fifo_reset_int <=  '1';	
         
        
     end if;
     
   end if;
   
 end process;


 
 
  
 -- this process generates slave tready for controlling the data flow from the AXI Streaming FIFO 
-- based on the tready from MCDMA and the different states of the FSM 

proc_tready:  process(rx_axis_clk_in)
  begin

    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then

      if (rx_axis_reset_in = '0') then
  
        s_axis_tready_int    <=  '0';	  
  
      else  
        
        -- deassert s_axi_tready and do not accept the data from FIFO until the Timestamp information Datawords 
		-- and Received datawords stored in FIFO are sent to MCDMA.      

	   if(m_axis_tready = '1') then
	      
	      if ((CURRENT_STATE = SEND_TS_DW_1_TO_MCDMA and NEXT_STATE = ACCEPT_RX_PACKET) or    	      
    	      (CURRENT_STATE = ACCEPT_RX_PACKET and NEXT_STATE = ACCEPT_RX_PACKET) ) then

          	 

            s_axis_tready_int    <=  '1';	

	      else 
	  
	        s_axis_tready_int    <=  '0';  
	      
	      end if;
	      
	    else
	     
	      s_axis_tready_int    <= 	'0';	     
	     
	     
	    end if;		   
	    
	  end if; --end (rx_axis_reset_in = '1')
	
   end if; -- end rx_axis_clk_in'event
	
  end process; 


-- --maxis interface signals to MCDMA 
proc_tvalid_tdata:  process(rx_axis_clk_in )
begin

 if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then

    if (rx_axis_reset_in = '0') then
  
      m_axis_tvalid_int  <=  '0';   
      m_axis_tdata_int   <=  (others     => '0');
      m_axis_tkeep       <=  (others     => '0');
     -- s_axis_tready_int  <=  '0';
      m_axis_tlast_int   <=  '0'; 
     
    else 	  
	
	  if(CURRENT_STATE = SEND_TS_DW_0_TO_MCDMA and NEXT_STATE = SEND_TS_DW_1_TO_MCDMA) then  
	  
	  --valid is asserted and the Timestamp first 64 bits are sent to MCDMA
	    m_axis_tvalid_int  <=  '1'; 
	    m_axis_tdata_int   <=  TS_DATA_WORD_0; 
	    m_axis_tkeep       <=  x"FF" ;	
	   -- s_axis_tready_int  <=  '0'; 
	    m_axis_tlast_int   <=  '0';   
		  
      elsif(CURRENT_STATE = SEND_TS_DW_1_TO_MCDMA and NEXT_STATE = ACCEPT_RX_PACKET) then 
	  
      --valid is asserted and the Timestamp remaining 16 bits with Qualifier are sent to MCDMA
        m_axis_tvalid_int  <= '1';
        m_axis_tdata_int   <=  TS_DATA_WORD_1;
        m_axis_tkeep       <=  x"FF" ;
       -- s_axis_tready_int  <=  '0';
        m_axis_tlast_int   <=  '0'; 
            
      elsif((CURRENT_STATE = ACCEPT_RX_PACKET and NEXT_STATE = ACCEPT_RX_PACKET) or
            (CURRENT_STATE = ACCEPT_RX_PACKET and NEXT_STATE = PACKET_RX_DONE  )) then 
      --elsif(CURRENT_STATE = ACCEPT_RX_PACKET and NEXT_STATE = ACCEPT_RX_PACKET ) then
	    -- remaining packet in streaming FIFO is sent to MCDMA
        m_axis_tvalid_int  <=  s_axis_tvalid ;
        m_axis_tdata_int   <=  s_axis_tdata ;	
        m_axis_tkeep       <=  s_axis_tkeep ;
        --s_axis_tready_int  <=  m_axis_tready
        if(s_axis_tvalid = '1' and  m_axis_tready = '1' and s_axis_tlast = '1' ) then  
	  
	      m_axis_tlast_int   <=  s_axis_tlast ; 
	    
	    else
	  
	      m_axis_tlast_int      <=  '0'; 
	  
	    end if;           
            
	  else
	  
	    m_axis_tvalid_int  <=  '0';   
        m_axis_tdata_int   <=  (others     => '0');
        m_axis_tkeep       <=  (others     => '0');
        -- s_axis_tready_int  <=  '0';
        m_axis_tlast_int   <=  '0';
	  
	  end if;	 
	
	end if; -- end (rx_axis_reset_in = '1')
	
  end if;	--end rx_axis_clk_in'event
	
end process proc_tvalid_tdata;      
                                                              
     
 

  
  
  -- process to reaad the qualifier bit and timestamp from fifo
  
  proc_Qualifier_rd :process(rx_axis_clk_in )                   
  begin                                                         
                                                              
    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then        
                                                              
      if (rx_axis_reset_in = '0') then      
        
		rd_en <= '0';		
  
      else         
		
        if(CURRENT_STATE = ACCEPT_RX_PACKET and NEXT_STATE = PACKET_RX_DONE and empty = '0') then    
       --if(CURRENT_STATE = SEND_TS_DW_1_TO_MCDMA and NEXT_STATE = ACCEPT_RX_PACKET and empty = '0') then    
        -- when a new packet is received, read its corresponding Timestamp information from the TOD FIFO
          
		  rd_en <= '1';
       
        else
    
          
		  rd_en <= '0';
       
        end if;
    
      end if;
 
    end if; 
 
  end process;   

 
 
 -- Process to control the data written from MRMAC to Stream FIFO when it reaches a threshold
 -- this does the graceful exit of each and avoids storing incomplete packets in Stream FIFO.
 
--proc_fifo_valid :process(mrmac_last, mrmac_valid, fifo_full, rx_axis_reset_in )                   
--begin

proc_fifo_valid :process (rx_axis_clk_in)
--process(s_axis_tvalid, s_axis_tready, s_axis_tlast, fifo_full, rx_axis_reset_in )                   
begin                                                         
                                                              
  if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then                                                         
                                                              
  
    if (rx_axis_reset_in = '0') then 
  
      fifo_valid_int        <= '1';
    
    else
    --when FIFO Prog_full is asserted and current packet valid and last signal 
	-- are received, then deassert the valid signal of Stream FIFO
      if( mrmac_last = '1' and mrmac_valid = '1') then 
      
        if(fifo_full = '1' ) then
     
          fifo_valid_int     <= '0';
        
        
         elsif(fifo_full = '0') then 
     
           fifo_valid_int    <= '1'; 
           
         end if;   
       
      else 
     
         fifo_valid_int      <=  fifo_valid_int  ;
         
      end if;   
  
    end if;  
    
  end if; 
  
  
end process;


-- process to write the t2_TOD in a FIFO when pdelay_req_ptp packet is received
proc_t2_TOD_p2p: process(rx_axis_clk_in )                   
begin                                                         
                                                              
  if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then        
                                                              
    if (rx_axis_reset_in = '0') then 
  
      wr_en_t2_TOD      <= '0';      
      
    
    else
    
      if(rd_data(14) = '1' and s_axis_tvalid = '1' and  s_axis_tready_int = '1' and s_axis_tlast = '1') then 
     
        wr_en_t2_TOD        <= '1';        
        
        
      else
      
        wr_en_t2_TOD        <= '0';        
        
      end if;   
  
    end if;   
  
  end if;
  
end process;




     
 
  TS_DATA_WORD_0    <=  rx_timestamp_tod(63 downto 0);
  TS_DATA_WORD_1    <=  x"00000000" & rd_data & rx_timestamp_tod(79 downto 64);		
		  		  
  --s_axis_tready     <=  s_axis_tready_int;
  
  s_axis_tready     <=  s_axis_tready_int; -- and m_axis_tready ;
  	
  m_axis_tvalid     <=  m_axis_tvalid_int;
  m_axis_tlast      <=  m_axis_tlast_int ;
  m_axis_tdata      <=  m_axis_tdata_int;         
  fifo_reset        <=  fifo_reset_int;
  fifo_valid        <=  fifo_valid_int;
 

end Behavioral;
	   
		   
			   	
