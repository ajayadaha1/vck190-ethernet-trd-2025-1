--(C) Copyright 2020 - 2021 Xilinx, Inc.
--Copyright (C) 2022 - 2023, Advanced Micro Devices, Inc
--SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2021 01:52:08 PM
-- Design Name: 
-- Module Name: sts_strm_src - Behavioral
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




-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2021 08:10:30 PM
-- Design Name: 
-- Module Name: strm_data - Behavioral
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sts_strm_src is
    Port ( 
	       -- input Ready from the MCDMA status stream
		   m_axis_sts_tready  : in STD_LOGIC;
		   -- output data to the input of MCDMA status stream
           m_axis_sts_tdata   : out STD_LOGIC_VECTOR (31 downto 0);
		   -- output valid to the input of MCDMA status stream
           m_axis_sts_tvalid  : out STD_LOGIC;
		   -- output tlast to the input of MCDMA status stream		   
           m_axis_sts_tlast   : out STD_LOGIC;
		   -- output tkeep to the input of MCDMA status stream	
           m_axis_sts_tkeep   : out STD_LOGIC_VECTOR (3 downto 0);
		   -- input tvalid from the FIFO connecting to the MCDMA S2MM stream
           s_axis_s2mm_tvalid : in std_logic;
		   -- input tlast from the FIFO connecting to the MCDMA S2MM stream
           s_axis_s2mm_tlast  : in std_logic;
		   -- output tready to the FIFO connecting to the MCDMA S2MM stream
           m_axis_s2mm_tready : in std_logic;
		   -- Global Clock Signal
           s_axis_clk         : in STD_LOGIC;
		   -- Global Reset Signal		   
           s_axis_resetn      : in STD_LOGIC

         ); 
end sts_strm_src;

architecture Behavioral of sts_strm_src is

type states is (idle,start_rdy_cnt,sts_flag,app0,app1,app2,app3,app4);

-- count to increment whenever input redy is obtained 
signal rdy_count: std_logic_vector (2 downto 0):= (others => '0');
-- idle: this state is responsible to assign default values to all signals  
-- start_rdy_cnt: this state starts the ready count based on other handshaking signals
-- sts_flag: this state sends the status stream flag to MCDMA status stream interface
-- app0: This sends the app0 data
-- app1: This sends the app1 data
-- app2: This sends the app2 data
-- app3: This sends the app3 data
-- app4: This sends the app4 data
signal curr_state, nxt_state    : states;
-- tvalid signal to the input of MCDMA status stream
signal m_axis_sts_tvalid_sig: std_logic;


begin

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

process (s_axis_s2mm_tvalid, s_axis_s2mm_tlast, m_axis_s2mm_tready,m_axis_sts_tready,rdy_count)

begin

  Case curr_state is
  
    when idle =>
    nxt_state <= start_rdy_cnt;
    
    
    when start_rdy_cnt =>
    if (s_axis_s2mm_tvalid = '1' and s_axis_s2mm_tlast = '1' and m_axis_s2mm_tready = '1') then
      nxt_state <= sts_flag;
    else 
      nxt_state <= start_rdy_cnt;
    end if;
    
    
   when sts_flag =>
   if (m_axis_sts_tready = '1' and rdy_count = "001" ) then
     nxt_state <= app0;
   else
     nxt_state <= sts_flag;
   end if;
   
   
   when app0 =>
   if (m_axis_sts_tready = '1' and rdy_count = "010" ) then
     nxt_state <= app1;
   else
     nxt_state <= app0;
   end if;
    
    
   when app1 =>
   if (m_axis_sts_tready = '1' and rdy_count = "011" ) then
     nxt_state <= app2;
   else
     nxt_state <= app1;
   end if;
   
   
   when app2 =>
   if (m_axis_sts_tready = '1' and rdy_count = "100" ) then
     nxt_state <= app3;
   else
     nxt_state <= app2;
   end if;
   
   
   when app3 =>
   if (m_axis_sts_tready = '1' and rdy_count = "101"  ) then
     nxt_state <= app4;
   else
     nxt_state <= app3;
   end if;
   
   
   when app4 =>
   if (m_axis_sts_tready = '1' and rdy_count = "110"  ) then
     nxt_state <= idle;
   else
     nxt_state <= app4;
   end if;
   
   
   
   when others =>
     nxt_state <= idle;
   
  end Case;
end process;
   
  
-- This process increments the rdy_count signal based on the states  
proc_rdy_cnt: process (s_axis_clk)
begin
  if (s_axis_clk = '1' and s_axis_clk' event) then
    if (s_axis_resetn = '0') then
    rdy_count <= (others => '0');
  
    else
  
      if (curr_state = start_rdy_cnt and nxt_state = sts_flag) then
      rdy_count <= rdy_count + "1";
      elsif (curr_state = sts_flag and nxt_state = app0) then
      rdy_count <= rdy_count + "1";
      elsif (curr_state = app0 and nxt_state = app1) then
      rdy_count <= rdy_count + "1";
      elsif (curr_state = app1 and nxt_state = app2) then
      rdy_count <= rdy_count + "1";
      elsif (curr_state = app2 and nxt_state = app3) then
      rdy_count <= rdy_count + "1";
      elsif (curr_state = app3 and nxt_state = app4) then
      rdy_count <= rdy_count + "1";
      elsif (curr_state = app4 and nxt_state = idle) then
      rdy_count <= (others => '0');
      else 
      rdy_count <= rdy_count;
      end if;
	  -- increase ready count in every state
    end if;
  end if;
end process;
    

--This process assigns the flag data to the iput of MCDMA status stream   
proc_tdata: process (s_axis_clk)
begin
  if (s_axis_clk = '1' and s_axis_clk' event) then
    if (s_axis_resetn = '0') then
    m_axis_sts_tdata <= (others => '0' );
    
    else
  
      if (curr_state = start_rdy_cnt and nxt_state = sts_flag) then
      m_axis_sts_tdata <= x"50000000" ;
      elsif (curr_state = sts_flag and nxt_state = sts_flag) then
      m_axis_sts_tdata <= x"50000000" ;
	  -- send the particular flag value 0x50000000 to the MRMAC status stream
      else
      m_axis_sts_tdata <= (others => '0' );
      end if;
    end if;
  end if;
end process;
   

-- This process controls the valid signal to the input of MCDMA status stream   
proc_tvalid: process (s_axis_clk)
begin
  if (s_axis_clk = '1' and s_axis_clk' event) then
    if (s_axis_resetn = '0') then
    m_axis_sts_tvalid_sig <= '0';
    
    else
    
      if (curr_state = start_rdy_cnt and nxt_state = sts_flag) then
      m_axis_sts_tvalid_sig <= '1'; 
      elsif (curr_state = app4 and nxt_state = idle) then
      m_axis_sts_tvalid_sig <= '0';
      else
      m_axis_sts_tvalid_sig <= m_axis_sts_tvalid_sig;
	  -- hold valid high until all app fields are sent
     end if;
   end if;  
  end if;
end process;


-- This process controls the tkeep signal to the input of MCDMA status stream 
proc_tkeep: process (s_axis_clk)
begin
  if (s_axis_clk = '1' and s_axis_clk' event) then
    if (s_axis_resetn = '0') then
    m_axis_sts_tkeep <= x"0";  
  
    else
  
      if (curr_state = idle and nxt_state = start_rdy_cnt ) then
      m_axis_sts_tkeep <= x"0";
      elsif (curr_state = app4 and nxt_state = idle) then
      m_axis_sts_tkeep <= x"0";
      elsif (curr_state = start_rdy_cnt and nxt_state = app0) then
      m_axis_sts_tkeep <= x"0";
      else
      m_axis_sts_tkeep <= x"F";
	  -- valid data goes only when flag is sent.
	  -- tkeep will be low for other cycles
      end if;
    end if;
  end if;
end process;  


-- This process controls the tlast signal to the input of MCDMA status stream 
proc_tlast: process (s_axis_clk)
begin
  if (s_axis_clk = '1' and s_axis_clk' event) then
    if (s_axis_resetn = '0') then 
    m_axis_sts_tlast <= '0';
    
    else
  
      if (curr_state = app3 and nxt_state = app4 ) then
        m_axis_sts_tlast <= '1';
      elsif (curr_state = app4 and nxt_state = app4) then
         m_axis_sts_tlast <= '1';
		 -- make tlast high when sending last app field
      else
      m_axis_sts_tlast <= '0'; 
      end if;
    end if;
  end if;
end process;    
       

  
  m_axis_sts_tvalid <= m_axis_sts_tvalid_sig;

end Behavioral;

