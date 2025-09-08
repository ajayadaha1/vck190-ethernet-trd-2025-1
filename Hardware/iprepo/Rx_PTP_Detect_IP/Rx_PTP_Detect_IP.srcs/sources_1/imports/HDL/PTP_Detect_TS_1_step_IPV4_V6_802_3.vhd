  --(C) Copyright 2020 - 2021 Xilinx, Inc.
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
entity RX_PTP_PKT_DETECT_one_step is
   port(
	     rx_axis_clk_in		    :  in std_logic;         
		 -- axis clock 390.625 MHz
		 rx_axis_reset_in	    :  in std_logic;		 
		 -- axis reset sync with rx_axis_clk_in			 
		 s_axis_tdata 	        :  in std_logic_vector(63 downto 0); 
		 -- 64 bit AXI data received 
		 s_axis_tkeep           :  in std_logic_vector(7 downto 0);  
		 -- indicates valid bytes 
		 s_axis_tlast           :  in std_logic;                     
		 -- indicates last byte of the transaction
		 s_axis_tvalid          :  in std_logic;		             
		 -- indicates the data recieved is a valid data
		 s_axis_tready          :  in std_logic;                    
         -- asserted when the DUT is ready to accept data                                                         
		 wr_en                  :  out std_logic;
		 -- write enable to store the Rx data during PTP detection in a native FIFO
		 wr_data                :  out std_logic_vector(15 downto 0);
		 -- store the Rx data during PTP detection in a native FIFO
		 
		 fifo_full		        :  in std_logic; 
		 
		 fifo_deassert		    :  out std_logic;
		 
		 s_axis_tlast_mux       :  in std_logic;                     
		 -- indicates last byte of the transaction
		 s_axis_tvalid_mux      :  in std_logic;		             
		 -- indicates the data recieved is a valid data
		 s_axis_tready_fifo     :  in std_logic
                  
		);
     
end RX_PTP_PKT_DETECT_one_step;

architecture Behavioral of RX_PTP_PKT_DETECT_one_step is
 
  
  signal Qualifier                  : std_logic := '0';
  -- Flag to indicate the PTP detected or not 
  signal mem_write_count            : unsigned(3 downto 0):= (others => '0'); 
  -- counts the received data stored in the FIFO during PTP pkt detection depending on TYPE field 
  signal IPV4_Addr_15_0             : std_logic;
  -- IPV4 Packet LSB 16 Address bits 
  signal IPV4_Addr_31_16            : std_logic;
  -- IPV4 Packet MSB 16 Address bits 
  signal IPV6_Addr_15_0             : std_logic; 
  -- IPV6 Packet LSB 16 Address bits 
  signal IPV6_Addr_79_16            : std_logic; 
  -- IPV6 Packet 16 to 79 Address bits 
  signal IPV4_packet                : std_logic;
  -- IPV4 Packet Flag
  signal IPV6_packet                : std_logic;  
  -- IPV6 Packet Flag
  signal PTP_802_3_packet           : std_logic; 
  -- 802.3 PTP Packet Flag
  signal Non_PTP_802_3_packet       : std_logic;                         
  -- 802.3 Non PTP Packet Flag 
  signal UDP_IPV4_PKT               : std_logic;  
  -- UDP IPV4 Packet Flag  
  signal TCP_IPV4_PKT               : std_logic;  
  -- TCP IPV4 Packet Flag  
  signal ptp_pdelay_req_pkt         : std_logic; 
  signal UDP_IPV4_PTP_PKT           : std_logic; 
  signal UDP_IPV6_PTP_PKT           : std_logic; 
  
  signal Rx_active                  : std_logic:= '0'; 
  
  signal IPV4_Addr_31_16_p          : std_logic:= '0';   
  
  signal UDP_IPV6_PKT               : std_logic:= '0'; 
  
  signal TCP_IPV6_PKT               : std_logic:= '0';    
  
  signal IPV6_Addr_127_80           : std_logic:= '0'; 
  
  signal IPV6_Addr_127_80_p         : std_logic:= '0';   
  
  signal wr_en_int                  : std_logic:= '0'; 
  
  signal wr_data_int                : std_logic_vector(15 downto 0):= (others => '0'); 

  signal wr_en_done                 : std_logic:= '0'; 
  
  signal fifo_deassert_int          : std_logic:= '1'; 
  
  
        
    
  
  type STATE is ( WAIT_FOR_NEW_PACKET, PROCESS_RX_PACKET);                 
 
  signal CURRENT_STATE, NEXT_STATE : STATE := WAIT_FOR_NEW_PACKET; 
  
  -- WAIT_FOR_NEW_PACKET    : wait for New Rx Packet and move to STORE_RX_PACKET_DATA state once tvalid is asserted
  
  -- PACKET_RX_DONE         : Reset all the control signals in this state and move to WAIT_FOR_NEW_PACKET for processing new packet 
begin

		  
 -- process to assert the different Packet Type Flags required for PTP Packet detection
 -- this process uses "mem_write_count", incremented in other process "proc_mem_write_count"
 
 Proc_Pkt_Type: process (rx_axis_clk_in)
  begin
    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
      if (rx_axis_reset_in = '0') then
        
            
       IPV4_packet      <= '0';
       IPV6_packet      <= '0';
       PTP_802_3_packet <= '0';
       Non_PTP_802_3_packet <= '0';
       
       
      else 
      
        if(s_axis_tvalid = '1' and  s_axis_tready = '1') then        
         
          if(mem_write_count = "0000") then
         
            IPV4_packet          <= '0';
            IPV6_packet          <= '0';
            PTP_802_3_packet     <= '0';
            Non_PTP_802_3_packet <= '0';     
         
          elsif(mem_write_count = "0001" ) then
		  
		    if(s_axis_tdata(47 downto 32) = x"F788") then 
            -- when the DW1 is received and it has TYPE field of IEEE 802.3 PTP packet x"88F7", assert the corresponding flag
         
              PTP_802_3_packet <= '1';
			  
			            
            elsif(s_axis_tdata(47 downto 32) = x"0008") then       
            -- when the DW1 is received and it has TYPE field of IPV4 packet 33x"0800", assert the corresponding flag
      
              IPV4_packet <= '1';
			
	        elsif(s_axis_tdata(47 downto 32) = x"DD86") then 
            -- when the DW1 is received and it has TYPE field of IPV4 packet x"86DD", assert the corresponding flag
        
              IPV6_packet      <= '1';     
        
            --elsif(s_axis_tdata(47 downto 32) /= x"0081") then
			else
            -- when the Type field does not match with any of the above Types, then it is a IEEE 802.3 Non-PTP packet          
          
              Non_PTP_802_3_packet <= '1';
			  
			end if;	    
            
          else
          
            IPV4_packet          <= IPV4_packet;
            IPV6_packet          <= IPV6_packet;        
            PTP_802_3_packet     <= PTP_802_3_packet;          
            Non_PTP_802_3_packet <= Non_PTP_802_3_packet;             
            
          end if;  -- end  if(mem_write_count and s_axis_tdata(47 downto 32)-Type field) comparision         
         
         else
         
           IPV4_packet          <= IPV4_packet;
           IPV6_packet          <= IPV6_packet;        
           PTP_802_3_packet     <= PTP_802_3_packet;             
           Non_PTP_802_3_packet <= Non_PTP_802_3_packet;          
          
         end if;   -- end if(s_axis_tvalid = '1' and  s_axis_tready_int = '1' )        
    
      end if; -- end if (rx_axis_reset_in = '0')
    
    end if;-- end if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then      
    
  end process Proc_Pkt_Type;
  
  
  
  IPV4_PKT_Prtcl: process (rx_axis_clk_in)
  begin
    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
      if (rx_axis_reset_in = '0' or mem_write_count = "0000") then     
       
        UDP_IPV4_PKT        <= '0';
		TCP_IPV4_PKT        <= '0';
		UDP_IPV6_PKT        <= '0';
        TCP_IPV6_PKT        <= '0';
		
      else 
      
        if(IPV4_packet = '1' and IPV6_packet = '0' and PTP_802_3_packet = '0' and Non_PTP_802_3_packet = '0') then
		  
		  if(mem_write_count = "0010" and s_axis_tdata(63 downto 56) = x"11" ) then 
		  
		    UDP_IPV4_PKT <= '1';
			TCP_IPV4_PKT <= '0';
			 
		  elsif(mem_write_count = "0010" and s_axis_tdata(63 downto 56) = x"06" ) then 
		  
		    UDP_IPV4_PKT <= '0';
			TCP_IPV4_PKT <= '1';
			 			 		  
		  else
         
            UDP_IPV4_PKT     <= UDP_IPV4_PKT;
		    TCP_IPV4_PKT     <= TCP_IPV4_PKT;
		            
          end if; -- end if(mem_write_count = "011" and IP Addresses and UDP/TCP protocol compariosion
		  
		elsif(IPV4_packet = '0' and IPV6_packet = '1' and PTP_802_3_packet = '0' and Non_PTP_802_3_packet = '0') then
		
		  if(mem_write_count = "0010" and s_axis_tdata(63 downto 56) = x"11" ) then 
		  
		    UDP_IPV6_PKT   <= '1';
		    TCP_IPV6_PKT   <= '0';
			
		  elsif(mem_write_count = "0010" and s_axis_tdata(63 downto 56) = x"06" ) then 
		  
		    UDP_IPV6_PKT <= '0';
			TCP_IPV6_PKT <= '1';
			 			 		  
		  else
         
            UDP_IPV6_PKT     <= UDP_IPV6_PKT;
		    TCP_IPV6_PKT     <= TCP_IPV6_PKT;
		            
          end if; -- end if(mem_write_count = "0
		  
        end if;  -- end if(IPV4_packet = '1') then         
        
      end if; -- if (rx_axis_reset_in = '0')       
      
     end if; -- if (rx_axis_clk_in'event and rx_axis_clk_in ='1')
     
   end process;    
   
   
   
   
   
   IPV4_PKT_Addr: process (rx_axis_clk_in)
  begin
    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
      if (rx_axis_reset_in = '0' or mem_write_count = "0000") then     
       
        IPV4_Addr_15_0      <= '0';
        IPV4_Addr_31_16     <= '0';	
        IPV4_Addr_31_16_p   <= '0';	
		
      	IPV6_Addr_15_0      <= '0';
		IPV6_Addr_79_16     <= '0';
		IPV6_Addr_127_80    <= '0';
		IPV6_Addr_127_80_p  <= '0';
        		
		
      else 
      
        if(UDP_IPV4_PKT = '1' and UDP_IPV6_PKT = '0' and PTP_802_3_packet = '0' and Non_PTP_802_3_packet = '0') then
		  
		  if(mem_write_count = "0011" and s_axis_tdata(63 downto 48) = x"00E0") then 
          -- when the DW3 of received IPV4 packet Address has LSB 16 bits x"E000", assert the corresponding flag          
            IPV4_Addr_15_0   <= '1';
              
          elsif(mem_write_count = "0100" and ((s_axis_tdata (15 downto 8) = x"81" or s_axis_tdata (15 downto 8) = x"82" 
		        or s_axis_tdata (15 downto 8) = x"83" or s_axis_tdata (15 downto 8) = x"84") and (s_axis_tdata (7 downto 0) = x"01"))) then      
          -- when the DW4 of received IPV6 packet Address[15:0] bits x"0181/82/83/84", assert the corresponding flag 
            IPV4_Addr_31_16  <= '1';
            
          elsif(mem_write_count = "0100" and (s_axis_tdata (15 downto 0) = x"6B00")) then
            
			IPV4_Addr_31_16_p  <= '1';	         
        
          else
         
            IPV4_Addr_15_0     <= IPV4_Addr_15_0;
            IPV4_Addr_31_16    <= IPV4_Addr_31_16;
            IPV4_Addr_31_16_p  <= IPV4_Addr_31_16_p  ;           
           
          end if; -- end if(mem_write_count = "011" and IP Addresses and UDP/TCP protocol compariosion
		  
		elsif(UDP_IPV4_PKT = '0' and UDP_IPV6_PKT = '1' and PTP_802_3_packet = '0' and Non_PTP_802_3_packet = '0') then
		
		  if(mem_write_count = "0100" and  s_axis_tdata(63 downto 48) = x"02FF") then 
		  
		    IPV6_Addr_15_0      <= '1';            

          elsif(mem_write_count = "0101" and  s_axis_tdata = x"0000000000000000") then

            IPV6_Addr_79_16     <= '1';
            
          elsif(mem_write_count = "0110" and  s_axis_tdata (47 downto 0) = x"810100000000") then			

		    IPV6_Addr_127_80    <= '1';
			
		  elsif(mem_write_count = "0110" and  s_axis_tdata (47 downto 0) = x"6B0000000000") then			
		  
		    IPV6_Addr_127_80_p  <= '1';
			
		  else
		  
		    IPV6_Addr_15_0      <= IPV6_Addr_15_0;
		    IPV6_Addr_79_16     <= IPV6_Addr_79_16;
		    IPV6_Addr_127_80    <= IPV6_Addr_127_80;
		    IPV6_Addr_127_80_p  <= IPV6_Addr_127_80_p;
			
		  end if;
          
        end if;  -- end if(IPV4_packet = '1'and IPV6_packet = '0' and PTP_802_3_packet = '0' and Non_PTP_802_3_packet = '0')     
        
      end if; -- if (rx_axis_reset_in = '0')       
      
     end if; -- if (rx_axis_clk_in'event and rx_axis_clk_in ='1')
     
   end process;    
   
   
   
   
   
proc_ptp_pkt: process (rx_axis_clk_in )
  begin
    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
	
      if (rx_axis_reset_in = '0' or mem_write_count = "0000") then          
		
		UDP_IPV4_PTP_PKT    <= '0';	
		UDP_IPV6_PTP_PKT    <= '0';	
        Qualifier           <= '0';	
        ptp_pdelay_req_pkt  <= '0';		
		
	  elsif(mem_write_count =  "0101" and UDP_IPV4_PKT = '1' and IPV4_Addr_15_0 = '1' and IPV4_Addr_31_16 = '1') then
	 
	    UDP_IPV4_PTP_PKT    <= '1';	
		Qualifier           <= '1';
		
		
	  elsif(mem_write_count =  "0101" and UDP_IPV4_PKT = '1' and IPV4_Addr_15_0 = '1' and IPV4_Addr_31_16_p = '1') then
		
	    UDP_IPV4_PTP_PKT    <= '1';	
		Qualifier           <= '1';
		
		
		if(s_axis_tvalid = '1' and  s_axis_tready = '1' and s_axis_tdata (19 downto 16) = x"2") then
		
		  ptp_pdelay_req_pkt <= '1';
		  
		else
		
		  ptp_pdelay_req_pkt <= '0';
		  
		end if;	
		
	  elsif(mem_write_count =  "0001" and s_axis_tdata (47 downto 32) = x"F788") then
	  
	    Qualifier           <= '1';
	     

        if(s_axis_tvalid = '1' and  s_axis_tready = '1' and s_axis_tdata (51 downto 48) = x"2") then

          ptp_pdelay_req_pkt <= '1';
		  
		else
		
		  ptp_pdelay_req_pkt <= '0';
		  
		end if;	

       elsif(mem_write_count =  "0111" and UDP_IPV6_PKT = '1' and IPV6_Addr_15_0 = '1' and IPV6_Addr_79_16 = '1' and IPV6_Addr_127_80 = '1')then 

          UDP_IPV6_PTP_PKT    <= '1';	
		  Qualifier           <= '1';

        elsif(mem_write_count =  "0111" and UDP_IPV6_PKT = '1' and IPV6_Addr_15_0 = '1' and IPV6_Addr_79_16 = '1' and IPV6_Addr_127_80_p = '1')then 

          UDP_IPV6_PTP_PKT    <= '1';	
		  Qualifier           <= '1';
		  
          if(s_axis_tvalid = '1' and  s_axis_tready = '1' and s_axis_tdata (51 downto 48) = x"2") then
		
		    ptp_pdelay_req_pkt <= '1';
		  
		  else
		
		    ptp_pdelay_req_pkt <= '0';
		  
		  end if;			  
		
	    else
	  
	      UDP_IPV4_PTP_PKT    <= UDP_IPV4_PTP_PKT;
          UDP_IPV6_PTP_PKT    <= UDP_IPV6_PTP_PKT;		  
		  Qualifier           <= Qualifier;	
          ptp_pdelay_req_pkt  <= ptp_pdelay_req_pkt ;		
	  
	  end if; -- if (rx_axis_reset_in = '0') 
	  
	end if;  --if (rx_axis_clk_in'event and rx_axis_clk_in ='1')     
	
  end process proc_ptp_pkt;	  
-- process current_state 
proc_state : process (rx_axis_clk_in)
  begin
    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
      if (rx_axis_reset_in = '0') then
 
        CURRENT_STATE <= WAIT_FOR_NEW_PACKET;
        
	  else
	
	    CURRENT_STATE <= NEXT_STATE;
	    
	  end if;
	  
	end if;
	
  end process;	
-- this process implements the FSM and passes through different states based on Received S_AXIS Transaction and
-- other flags .
proc_nextstate : process (CURRENT_STATE, s_axis_tvalid, s_axis_tready, s_axis_tlast)
begin 
  NEXT_STATE <= CURRENT_STATE;
  case CURRENT_STATE is
   
     -- in this state, the DUT indicates to the Master, that it is ready to accept the new packet by asserting the
     -- "s_axi_tready" when MCDMA is ready to accept the data and waits for the new packet arrival by continuously checking the "s_axi_tvalid"
     -- when s_axi_tvalid is asserted, the first word is stored in a FIFO and moves to the next state STORE_RX_PACKET_DATA  to
     -- store the next Data words required for the PTP Packet detection. 
	when WAIT_FOR_NEW_PACKET  =>
	    
      if(s_axis_tvalid  = '1' and s_axis_tready = '1' and  s_axis_tlast  = '0' ) then		 
		  
	    NEXT_STATE  <=  PROCESS_RX_PACKET;		    
	     		  
	  else 
		
		NEXT_STATE  <=  WAIT_FOR_NEW_PACKET;
		  
	  end if;  
	  
--	  Rx_active   <= '0' ;   
	  		
     -- in this state, checks the Packet Type Flags to store the required number of data words for PTP detection
     -- when the Flag of 802.3 PTP Packet or 802.3 Non-PTP packet is asserted, it stays for 3 clock cycles
     -- when the Flag of PTP packet over UDP/IPV4 is asserted ,it remains in the same state for 5 clock cycles
     -- till 5 words are stored,to get the 32 bit Multicast IP address available in the 3rd and 4th words of the packet.
     -- when the Flag of PTP packet over UDP/IPV6 is asserted and it remains in the same state 
     -- till 7 words are stored, to get the 128 bit Multicast IP address available in the 4th, 5th and 6th words of the packet.	 
	when PROCESS_RX_PACKET =>
	
	        	      
	  if (s_axis_tvalid  = '1' and s_axis_tready = '1' and s_axis_tlast  = '1') then
	    
	    --if(s_axis_tlast  = '1' ) then 
		
	    --NEXT_STATE  <= 	RX_LAST_DATAWORD;	
	    NEXT_STATE  <= WAIT_FOR_NEW_PACKET;
--	    Rx_active   <= '0' ;
		   		     
	  else
		  
		NEXT_STATE  <= PROCESS_RX_PACKET  ;	
		
--		Rx_active   <=  '1';	       
		   
		--  end if;	
		  
	  end if;
	  
	 when others => 
	 
	   
	   NEXT_STATE  <= WAIT_FOR_NEW_PACKET;
	  
	  
	end case; 
    
end process;



--proc_Rxactive : process ( s_axis_tvalid, s_axis_tready, s_axis_tlast)
--begin 

--  if (s_axis_tvalid  = '1' and s_axis_tready = '1' and s_axis_tlast  = '0') then
	    
	    
--	Rx_active   <= '1' ;
	    
--  elsif (s_axis_tvalid  = '1' and s_axis_tready = '1' and s_axis_tlast  = '1') then
	  
--	Rx_active   <= '0' ;
	  
--  else
	  
--	Rx_active   <= '0' ;
	  
--  end if;

--end process;



proc_mem_write_count : process (rx_axis_clk_in)
  begin
    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
      if (rx_axis_reset_in = '0') then
        
        mem_write_count <= "0000"; 
                
      else    
        
        if (CURRENT_STATE = WAIT_FOR_NEW_PACKET and NEXT_STATE = PROCESS_RX_PACKET)then
            
          -- increment the mem_write_count when the valid data is received  depending on the pkt protocol      
          mem_write_count <= mem_write_count + 1;            
            
        elsif (CURRENT_STATE = PROCESS_RX_PACKET and NEXT_STATE = PROCESS_RX_PACKET) then          
                     
		  --if (s_axis_tvalid  = '1' and s_axis_tready = '1' and mem_write_count <= "1010") then
		  if (s_axis_tvalid  = '1' and s_axis_tready = '1' and mem_write_count < "1001") then
            
            -- increment the mem_write_count when the valid data is received  depending on the pkt protocol      
            mem_write_count <= mem_write_count + 1;  
          else
		    mem_write_count <= mem_write_count ;  
          
		  end if;
		  
        elsif(CURRENT_STATE = PROCESS_RX_PACKET   and NEXT_STATE = WAIT_FOR_NEW_PACKET ) then
        
          -- make the count 0 when the current packet is processed.              
          mem_write_count <= "0000";                 
        
        else
          -- once the required amount data is stored, do not increment the count                
          mem_write_count <= mem_write_count;                       
                   
        end if; -- end mem write count 
                
	  end if; -- end rx_axis_reset_in
	  
	end if; -- end rx_axis_clk_in	
	
  end process proc_mem_write_count;	
  
  
  write_to_fifo: process (rx_axis_clk_in)
  begin
    if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
    
      if (rx_axis_reset_in = '0') then
	  
	    wr_en_int   <= '0';
		
		wr_data_int <= (others => '0');
		
	  elsif(mem_write_count = "0110" and wr_en_int ='0' and s_axis_tvalid  = '1' and s_axis_tready = '1') then
	  	  
	    wr_en_int   <= '1';
		
		wr_data_int <= Qualifier &  ptp_pdelay_req_pkt & "00" & x"000"; 
     
      else
      
	    wr_en_int   <= '0';
				
		wr_data_int <= wr_data_int;	  
	  
	  end if;
	  
	end if;
	
  end process;	
  
  
  
  -- Process to control the data written from MRMAC to Stream FIFO when it reaches a threshold
 -- this does the graceful exit of each and avoids storing incomplete packets in Stream FIFO.
 
proc_fifo_deassert_int :process (rx_axis_clk_in)
--process(s_axis_tvalid, s_axis_tready, s_axis_tlast, fifo_full, rx_axis_reset_in )                   
begin                                                         
                                                              
  if (rx_axis_clk_in'event and rx_axis_clk_in ='1') then
  
    if (rx_axis_reset_in = '0') then 
  
      fifo_deassert_int        <= '1';
    
    else
    --when FIFO Prog_full is asserted and current packet valid and last signal 
	-- are received, then deassert the valid signal of Stream FIFO
      if( s_axis_tvalid_mux  = '1' and s_axis_tready_fifo = '1' and s_axis_tlast_mux  = '1' ) then 
      
        if(fifo_full = '1' ) then
     
          fifo_deassert_int     <= '0';
        
        
         elsif(fifo_full = '0') then 
     
           fifo_deassert_int    <= '1'; 
           
         end if;   
       
      else 
      
      
         if(fifo_full = '0' and  fifo_deassert_int = '0') then
     
            fifo_deassert_int     <= '1';        
        
         else  
     
           fifo_deassert_int    <= fifo_deassert_int;             
     
         end if; 
         
      end if;   
  
    end if;  
    
  end if; 
  
  
end process;
  
  
  wr_en    <=   wr_en_int;
  
  wr_data  <=   wr_data_int; 
  
  fifo_deassert      <=  fifo_deassert_int;
  
  
  end Behavioral;