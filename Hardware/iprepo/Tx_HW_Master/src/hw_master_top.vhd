--(C) Copyright 2020 - 2021 Xilinx, Inc.
--Copyright (C) 2022 - 2023, Advanced Micro Devices, Inc
--SPDX-License-Identifier: Apache-2.0
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2021 05:05:16 PM
-- Design Name: 
-- Module Name: hw_master_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hw_master_top is

generic (

		-- Parameters of Axi Master Bus Interface M00_AXI
		C_M00_AXI_BURST_LEN		: integer	:= 3;
		C_M00_AXI_ID_WIDTH		: integer	:= 1;
		C_M00_AXI_ADDR_WIDTH	: integer	:= 64;
		C_M00_AXI_DATA_WIDTH	: integer	:= 32;
		C_M00_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_M00_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_M00_AXI_WUSER_WIDTH	: integer	:= 0;
		C_M00_AXI_RUSER_WIDTH	: integer	:= 0;
		C_M00_AXI_BUSER_WIDTH	: integer	:= 0
	);
	

  Port (   
           s_axis_clk             : in STD_LOGIC;
           s_axis_resetn          : in STD_LOGIC;
           s_axis_cntrl_tdata     : in STD_LOGIC_VECTOR (31 downto 0);
           s_axis_cntrl_tvalid    : in STD_LOGIC;
           s_axis_cntrl_tlast     : in STD_LOGIC;
           s_axis_cntrl_tready    : out STD_LOGIC;
           tx_timestamp_tod       : in STD_LOGIC_VECTOR (79 downto 0);
           tx_timestamp_tod_valid : in STD_LOGIC;
           s_axis_cntrl_tkeep     : in STD_LOGIC_VECTOR (3 downto 0);
           tx_ptp_1588op_in       : out std_logic_vector (1 downto 0);
           interrupt              : out std_logic;
           tx_ptp_tstamp_tag_in   : in std_logic_vector (15 downto 0);
           s_axis_mm2s_tlast      : in std_logic;
           s_axis_mm2s_tvalid     : in std_logic;
           data_ready             : out std_logic;
           data_valid             : out std_logic;
           mrmac_tx_tready        : in std_logic;
           m_axis_sts_tready      : in STD_LOGIC;                      
           m_axis_sts_tdata       : out STD_LOGIC_VECTOR (31 downto 0); 
           m_axis_sts_tvalid      : out STD_LOGIC;                     
           m_axis_sts_tlast       : out STD_LOGIC;                      
           m_axis_sts_tkeep       : out STD_LOGIC_VECTOR (3 downto 0);  
           s_axis_s2mm_tvalid     : in std_logic;                       
           s_axis_s2mm_tlast      : in std_logic;                        
           m_axis_s2mm_tready     : in std_logic;                    
           t2_tdata_in        : in std_logic_vector (63 downto 0);
		   m_axis_tready  : in STD_LOGIC :='0';
		   -- output data to the 1stp helper block
           m_axis_tdata   : out STD_LOGIC_VECTOR (31 downto 0);
		   -- output valid to the 1stp helper block
           m_axis_tvalid  : out STD_LOGIC := '0';
		   -- output tlast to the 1stp helper block	   
           m_axis_tlast   : out STD_LOGIC := '0';
		   -- output tkeep to the 1stp helper block
           m_axis_tkeep   : out STD_LOGIC_VECTOR (3 downto 0);
		   --tlast from cmd fifo           
		   cmd_tlast  : in std_logic;
		   --tready from cmd fifo		   
		   cmd_tready : in std_logic;
		   --tvalid from cmd fifo		   
		   cmd_tvalid : in std_logic;
		   -- write enable to capture t2 timestamp		   
		   t2_wr_en: in std_logic;	   


                   
		   m00_axi_aclk	          : in std_logic;
		   m00_axi_aresetn	      : in std_logic;
		   m00_axi_awid	          : out std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
		   m00_axi_awaddr	      : out std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
		   m00_axi_awlen	      : out std_logic_vector(7 downto 0);
		   m00_axi_awsize	      : out std_logic_vector(2 downto 0);
		   m00_axi_awburst	      : out std_logic_vector(1 downto 0);
		   m00_axi_awlock	      : out std_logic;
		   m00_axi_awcache	      : out std_logic_vector(3 downto 0);
		   m00_axi_awprot	      : out std_logic_vector(2 downto 0);
		   m00_axi_awqos	      : out std_logic_vector(3 downto 0);
		   m00_axi_awvalid	      : out std_logic;
		   m00_axi_awready	      : in std_logic;
		   m00_axi_wdata	      : out std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
		   m00_axi_wstrb	      : out std_logic_vector(C_M00_AXI_DATA_WIDTH/8-1 downto 0);
		   m00_axi_wlast	      : out std_logic;
		   m00_axi_wvalid	      : out std_logic;
		   m00_axi_wready	      : in std_logic;
		   m00_axi_bid	          : in std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
		   m00_axi_bresp	      : in std_logic_vector(1 downto 0);
		   m00_axi_bvalid	      : in std_logic;
		   m00_axi_bready	      : out std_logic;
		   m00_axi_arid	          : out std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
		   m00_axi_araddr	      : out std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
		   m00_axi_arlen	      : out std_logic_vector(7 downto 0);
		   m00_axi_arsize	      : out std_logic_vector(2 downto 0);
		   m00_axi_arburst	      : out std_logic_vector(1 downto 0);
		   m00_axi_arlock	      : out std_logic;
		   m00_axi_arcache	      : out std_logic_vector(3 downto 0);
		   m00_axi_arprot	      : out std_logic_vector(2 downto 0);
		   m00_axi_arqos	      : out std_logic_vector(3 downto 0);
		   m00_axi_arvalid	      : out std_logic;
		   m00_axi_arready	      : in std_logic;
		   m00_axi_rid	          : in std_logic_vector(C_M00_AXI_ID_WIDTH-1 downto 0);
		   m00_axi_rdata	      : in std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
		   m00_axi_rresp	      : in std_logic_vector(1 downto 0);
		   m00_axi_rlast	      : in std_logic;
		   m00_axi_rvalid	      : in std_logic;
		   m00_axi_rready	      : out std_logic
		
		
           
       );
end hw_master_top;


architecture Behavioral of hw_master_top is

           -- signal to initialize write into FIFO
		   signal init_mem_write        : std_logic;
		   -- signal to initialize the Memory write
           signal init_axi_txn          : std_logic;
		   -- signal indicating memory write completed
           signal write_done            : std_logic;
		   -- signal to capture completion of memory write
           signal txn_done              : std_logic;
		   -- 64 bit address read out from FIFO
           signal base_addr             : std_logic_vector (63 downto 0);
		   -- 96 bit timestamp value read out from FIFO
           signal start_data_value      : std_logic_vector (95 downto 0);
		   -- signal to capture any Error in memory write
           signal error_mem_write       : std_logic;
		   -- signal to capture any Error in memory write
           signal error                 : std_logic;
		   -- 160 bit address and timestamp data to be written to FIFO
           signal fifo_wr_data          : std_logic_vector (159 downto 0);
		   -- initiate FIFO read
           signal init_mem_txn          : std_logic; 
		   -- 16 bit input tag from MRMAC
           signal ptp_ts_tag_in         : std_logic_vector (15 downto 0);
		   -- 16 bit output tag to MRMAC
           signal ptp_ts_tag_out        : std_logic_vector (15 downto 0);
		   -- 96 bit timestamp read out from the FIFO
           signal fifo_ts_output        : std_logic_vector (95 downto 0);
		   -- 64 bit address read out from the FIFO
           signal fifo_addr_output      : std_logic_vector (63 downto 0);

		   -- FIFO empty signal
		   signal FIFO_READ_0_empty     : STD_LOGIC;
		   -- Data read from FIFO
		   signal FIFO_READ_0_rd_data   : STD_LOGIC_VECTOR ( 159 downto 0 );
		   -- FIFO read enable input
		   signal FIFO_READ_0_rd_en     : STD_LOGIC;
		   -- Data to be written into FIFO
		   signal FIFO_WRITE_0_wr_data  : STD_LOGIC_VECTOR ( 159 downto 0 );
		   -- FIFO write enable input
		   signal FIFO_WRITE_0_wr_en    : STD_LOGIC;
		   -- reset signal to FIFO
		   signal rst_0                 : STD_LOGIC;
		   -- Clock to FIFO
		   signal wr_clk_0              : STD_LOGIC;
		   -- signal to reset FIFO. Active HIGH
		   signal fifo_s_axis_reset     : std_logic;
           --input data to 1-step fifo
           signal data_fifo_in          : std_logic_vector (31 downto 0);	
           
	 


-- Tx Hardware Master component which provides address and timestamp for memory write
  component hw_master1 is
  
      Port ( 
           S_AXIS_CLK              : in STD_LOGIC;
           S_AXIS_RESETN           : in STD_LOGIC;
           S_AXIS_CNTRL_TDATA      : in STD_LOGIC_VECTOR (31 downto 0);
           S_AXIS_CNTRL_TVALID     : in STD_LOGIC;
           S_AXIS_CNTRL_TLAST      : in STD_LOGIC;
           S_AXIS_CNTRL_TREADY     : out STD_LOGIC;
           TX_TIMESTAMP_TOD        : in STD_LOGIC_VECTOR (79 downto 0);
           TX_TIMESTAMP_TOD_VALID  : in STD_LOGIC;
           S_AXIS_CNTRL_TKEEP      : in STD_LOGIC_VECTOR (3 downto 0);
           TX_PTP_1588OP_IN        : out std_logic_vector (1 downto 0);
           INTERRUPT               : out std_logic;         
           INIT_MEM_WRITE          : out std_logic;
           WRITES_DONE	           : in std_logic;
           ERROR                   : in std_logic;
           FIFO_INPUT              : out std_logic_vector (159 downto 0);
           TX_PTP_TSTAMP_TAG_IN    : in std_logic_vector (15 downto 0);
           S_AXIS_MM2S_TLAST       : in std_logic;
           S_AXIS_MM2S_TVALID      : in std_logic;
           DATA_READY              : out std_logic;
           DATA_VALID              : out std_logic;
           MRMAC_TX_TREADY         : in std_logic;
           DATA_FIFO_IN            : out std_logic_vector (31 downto 0);
           t2_tdata_in        : in std_logic_vector (63 downto 0);
		   m_axis_tready  : in STD_LOGIC :='0';
		   -- output data to the 1stp helper block
           m_axis_tdata   : out STD_LOGIC_VECTOR (31 downto 0);
		   -- output valid to the 1stp helper block
           m_axis_tvalid  : out STD_LOGIC := '0';
		   -- output tlast to the 1stp helper block	   
           m_axis_tlast   : out STD_LOGIC := '0';
		   -- output tkeep to the 1stp helper block
           m_axis_tkeep   : out STD_LOGIC_VECTOR (3 downto 0);
		   --tlast from cmd fifo
		   cmd_tlast  : in std_logic;
		   -- ready from cmd fifo
		   cmd_tready : in std_logic;
		   -- valid from cmd fifo
		   cmd_tvalid : in std_logic;
		   -- write enable to capture t2 timestamp
		   t2_wr_en: in std_logic
                   
           );

end component hw_master1;


-- AXI Native to Memory Map component for writing timestamp into the specified memory address
component axi4_full_v1_0_M00_AXI is

		generic (
		-- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		C_M_AXI_BURST_LEN	: integer	    := 3;
		-- Thread ID Width
		C_M_AXI_ID_WIDTH	: integer	    := 1;
		-- Width of Address Bus
		C_M_AXI_ADDR_WIDTH	: integer	    := 64;
		-- Width of Data Bus
		C_M_AXI_DATA_WIDTH	: integer	    := 32;
		-- Width of User Write Address Bus
		C_M_AXI_AWUSER_WIDTH	: integer	:= 0;
		-- Width of User Read Address Bus
		C_M_AXI_ARUSER_WIDTH	: integer	:= 0;
		-- Width of User Write Data Bus
		C_M_AXI_WUSER_WIDTH	: integer	    := 0;
		-- Width of User Read Data Bus
		C_M_AXI_RUSER_WIDTH	: integer	    := 0;
		-- Width of User Response Bus
		C_M_AXI_BUSER_WIDTH	: integer	    := 0
		 );

		port (
        INIT_AXI_TXN	: in std_logic;
		TXN_DONE	    : out std_logic;
		ERROR	        : out std_logic;
		M_AXI_ACLK	    : in std_logic;
		M_AXI_ARESETN	: in std_logic;
		M_AXI_AWID	    : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_AWLEN	    : out std_logic_vector(7 downto 0);
		M_AXI_AWSIZE	: out std_logic_vector(2 downto 0);
		M_AXI_AWBURST	: out std_logic_vector(1 downto 0);
		M_AXI_AWLOCK	: out std_logic;
		M_AXI_AWCACHE	: out std_logic_vector(3 downto 0);
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		M_AXI_AWQOS	    : out std_logic_vector(3 downto 0);
		M_AXI_AWUSER	: out std_logic_vector(C_M_AXI_AWUSER_WIDTH-1 downto 0);
		M_AXI_AWVALID	: out std_logic;
		M_AXI_AWREADY	: in std_logic;
		M_AXI_WDATA	    : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_WSTRB	    : out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		M_AXI_WLAST	    : out std_logic;
		M_AXI_WUSER	    : out std_logic_vector(C_M_AXI_WUSER_WIDTH-1 downto 0);
		M_AXI_WVALID	: out std_logic;
		M_AXI_WREADY	: in std_logic;
		M_AXI_BID	    : in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_BRESP	    : in std_logic_vector(1 downto 0);
		M_AXI_BUSER	    : in std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
		M_AXI_BVALID	: in std_logic;
		M_AXI_BREADY	: out std_logic;
		M_AXI_ARID	    : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_ARLEN	    : out std_logic_vector(7 downto 0);
		M_AXI_ARSIZE	: out std_logic_vector(2 downto 0);
		M_AXI_ARBURST	: out std_logic_vector(1 downto 0);
		M_AXI_ARLOCK	: out std_logic;
		M_AXI_ARCACHE	: out std_logic_vector(3 downto 0);
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		M_AXI_ARQOS	    : out std_logic_vector(3 downto 0);
		M_AXI_ARUSER	: out std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
		M_AXI_ARVALID	: out std_logic;
		M_AXI_ARREADY	: in std_logic;
		M_AXI_RID	    : in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_RDATA	    : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_RRESP	    : in std_logic_vector(1 downto 0);
		M_AXI_RLAST	    : in std_logic;
		M_AXI_RUSER	    : in std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
		M_AXI_RVALID	: in std_logic;
		M_AXI_RREADY	: out std_logic;
	    BASE_ADDR		: in std_logic_vector (63 downto 0);
	    START_DATA		: in std_logic_vector (95 downto 0);
	    INIT_MEM_TXN    : out std_logic;
	    FIFO_EMPTY      : in std_logic
		);
	end component axi4_full_v1_0_M00_AXI;	
	
	
-- FIFO between the hardware master and AXI Native to MM component	
component ts_fifo_i is
  port (
    rst_0 				 : in STD_LOGIC;
    wr_clk_0 			 : in STD_LOGIC;
    FIFO_READ_0_empty    : out STD_LOGIC;
    FIFO_READ_0_rd_data  : out STD_LOGIC_VECTOR ( 159 downto 0 );
    FIFO_READ_0_rd_en    : in STD_LOGIC;
    FIFO_WRITE_0_wr_data : in STD_LOGIC_VECTOR ( 159 downto 0 );
    FIFO_WRITE_0_wr_en   : in STD_LOGIC
  );
  end component ts_fifo_i;


-- stream source input to the MCDMA status stream
component sts_strm_src is

port(  
         M_AXIS_STS_TREADY  : in STD_LOGIC;
         M_AXIS_STS_TDATA   : out STD_LOGIC_VECTOR (31 downto 0);
         M_AXIS_STS_TVALID  : out STD_LOGIC;
         M_AXIS_STS_TLAST   : out STD_LOGIC;
         M_AXIS_STS_TKEEP   : out STD_LOGIC_VECTOR (3 downto 0);
         S_AXIS_S2MM_TVALID : in std_logic;
         S_AXIS_S2MM_TLAST  : in std_logic;
         M_AXIS_S2MM_TREADY : in std_logic;
         S_AXIS_CLK         : in STD_LOGIC;
         S_AXIS_RESETN      : in STD_LOGIC
	);
end component sts_strm_src;



begin


hw_master1_inst:hw_master1

port map (

           S_AXIS_CLK 			  => s_axis_clk,
           S_AXIS_RESETN 		  => s_axis_resetn,
           S_AXIS_CNTRL_TDATA 	  => s_axis_cntrl_tdata,
           S_AXIS_CNTRL_TVALID    => s_axis_cntrl_tvalid,
           S_AXIS_CNTRL_TLAST     => s_axis_cntrl_tlast,
           S_AXIS_CNTRL_TREADY    => s_axis_cntrl_tready,
           TX_TIMESTAMP_TOD 	  => tx_timestamp_tod,
           TX_TIMESTAMP_TOD_VALID => tx_timestamp_tod_valid,
           S_AXIS_CNTRL_TKEEP 	  => s_axis_cntrl_tkeep,
           TX_PTP_1588OP_IN 	  => tx_ptp_1588op_in,
           INTERRUPT 			  => interrupt,
           INIT_MEM_WRITE 		  => init_mem_write,
           WRITES_DONE 		      => write_done,
           ERROR                  => error_mem_write,
           FIFO_INPUT             => fifo_wr_data,
           TX_PTP_TSTAMP_TAG_IN   => tx_ptp_tstamp_tag_in,
           S_AXIS_MM2S_TLAST      => s_axis_mm2s_tlast,
           S_AXIS_MM2S_TVALID     => s_axis_mm2s_tvalid ,
           DATA_READY             => data_ready,
           DATA_VALID             => data_valid,
           MRMAC_TX_TREADY        => mrmac_tx_tready,
           DATA_FIFO_IN           => data_fifo_in,
           t2_tdata_in 		      => t2_tdata_in,      
		   m_axis_tready          => m_axis_tready,
		   -- output data to the 1stp helper block
           m_axis_tdata   => m_axis_tdata,
		   -- output valid to the 1stp helper block
           m_axis_tvalid  => m_axis_tvalid,
		   -- output tlast to the 1stp helper block	   
           m_axis_tlast  => m_axis_tlast,
		   -- output tkeep to the 1stp helper block
           m_axis_tkeep   => m_axis_tkeep,
           --tlast from cmd fifo
           cmd_tlast    => cmd_tlast,
           -- valid from cmd fifo
           cmd_tvalid => cmd_tvalid,
           -- ready from cmd fifo
           cmd_tready => cmd_tready,
           -- write enable to capture t2 timestamp
           t2_wr_en => t2_wr_en
           		                           
        );
        


-- Instantiation of Axi Bus Interface M00_AXI
axi4_full_v1_0_M00_AXI_inst : axi4_full_v1_0_M00_AXI
	generic map (
		C_M_AXI_BURST_LEN	    => C_M00_AXI_BURST_LEN,
		C_M_AXI_ID_WIDTH	    => C_M00_AXI_ID_WIDTH,
		C_M_AXI_ADDR_WIDTH	    => C_M00_AXI_ADDR_WIDTH,
		C_M_AXI_DATA_WIDTH	    => C_M00_AXI_DATA_WIDTH,
		C_M_AXI_AWUSER_WIDTH	=> C_M00_AXI_AWUSER_WIDTH,
		C_M_AXI_ARUSER_WIDTH	=> C_M00_AXI_ARUSER_WIDTH,
		C_M_AXI_WUSER_WIDTH	    => C_M00_AXI_WUSER_WIDTH,
		C_M_AXI_RUSER_WIDTH	    => C_M00_AXI_RUSER_WIDTH,
		C_M_AXI_BUSER_WIDTH	    => C_M00_AXI_BUSER_WIDTH
				)
	port map (
		INIT_AXI_TXN	=> init_axi_txn,
		ERROR			=> error,
		TXN_DONE		=> txn_done,
		M_AXI_ACLK	    => m00_axi_aclk,
		M_AXI_ARESETN	=> m00_axi_aresetn,
		M_AXI_AWID	    => m00_axi_awid,
		M_AXI_AWADDR	=> m00_axi_awaddr,
		M_AXI_AWLEN	    => m00_axi_awlen,
		M_AXI_AWSIZE	=> m00_axi_awsize,
		M_AXI_AWBURST	=> m00_axi_awburst,
		M_AXI_AWLOCK	=> m00_axi_awlock,
		M_AXI_AWCACHE	=> m00_axi_awcache,
		M_AXI_AWPROT	=> m00_axi_awprot,
		M_AXI_AWQOS	    => m00_axi_awqos,
		M_AXI_AWUSER	=> open,
		M_AXI_AWVALID	=> m00_axi_awvalid,
		M_AXI_AWREADY	=> m00_axi_awready,
		M_AXI_WDATA	    => m00_axi_wdata,
		M_AXI_WSTRB	    => m00_axi_wstrb,
		M_AXI_WLAST	    => m00_axi_wlast,
		M_AXI_WUSER	    => open,
		M_AXI_WVALID	=> m00_axi_wvalid,
		M_AXI_WREADY	=> m00_axi_wready,
		M_AXI_BID	    => m00_axi_bid,
		M_AXI_BRESP	    => m00_axi_bresp,
		M_AXI_BUSER	    => (others => '0'),
		M_AXI_BVALID	=> m00_axi_bvalid,
		M_AXI_BREADY	=> m00_axi_bready,
		M_AXI_ARID	    => m00_axi_arid,
		M_AXI_ARADDR	=> m00_axi_araddr,
		M_AXI_ARLEN	    => m00_axi_arlen,
		M_AXI_ARSIZE	=> m00_axi_arsize,
		M_AXI_ARBURST	=> m00_axi_arburst,
		M_AXI_ARLOCK	=> m00_axi_arlock,
		M_AXI_ARCACHE	=> m00_axi_arcache,
		M_AXI_ARPROT	=> m00_axi_arprot,
		M_AXI_ARQOS	    => m00_axi_arqos,
		M_AXI_ARUSER	=> open,
		M_AXI_ARVALID	=> m00_axi_arvalid,
		M_AXI_ARREADY	=> m00_axi_arready,
		M_AXI_RID	    => m00_axi_rid,
		M_AXI_RDATA	    => m00_axi_rdata,
		M_AXI_RRESP	    => m00_axi_rresp,
		M_AXI_RLAST	    => m00_axi_rlast,
		M_AXI_RUSER	    => (others => '0'),
		M_AXI_RVALID	=> m00_axi_rvalid,
		M_AXI_RREADY	=> m00_axi_rready,
		BASE_ADDR 		=> fifo_addr_output,
		START_DATA 		=> fifo_ts_output,
		INIT_MEM_TXN    => init_mem_txn,
		FIFO_EMPTY      =>  FIFO_READ_0_empty
	);
	

	write_done <= txn_done;
	error_mem_write <= error;
	fifo_s_axis_reset <= not (s_axis_resetn);
	
ts_fifo: component ts_fifo_i
     port map (
      FIFO_READ_0_empty 				 => FIFO_READ_0_empty,
      FIFO_READ_0_rd_data(159 downto 0)  => FIFO_READ_0_rd_data(159 downto 0),
      FIFO_READ_0_rd_en 				 => FIFO_READ_0_rd_en,
      FIFO_WRITE_0_wr_data(159 downto 0) => FIFO_WRITE_0_wr_data(159 downto 0),
      FIFO_WRITE_0_wr_en				 => FIFO_WRITE_0_wr_en,
      rst_0 							 => fifo_s_axis_reset,
      wr_clk_0 							 => s_axis_clk
    );
    

    
sts_strm_src_inst: component sts_strm_src
port map (
    M_AXIS_STS_TREADY     =>  m_axis_sts_tready,  
    M_AXIS_STS_TDATA      =>  m_axis_sts_tdata,   
    M_AXIS_STS_TVALID     =>  m_axis_sts_tvalid,   
    M_AXIS_STS_TLAST      =>  m_axis_sts_tlast,   
    M_AXIS_STS_TKEEP      =>  m_axis_sts_tkeep,   
    S_AXIS_S2MM_TVALID    =>  s_axis_s2mm_tvalid,   
    S_AXIS_S2MM_TLAST     =>  s_axis_s2mm_tlast,   
    M_AXIS_S2MM_TREADY    =>  m_axis_s2mm_tready,   
    S_AXIS_CLK            =>  s_axis_clk,    
    S_AXIS_RESETN         =>  s_axis_resetn   
        );



	-- process to read the address and timestamp data from FIFO
    process (s_axis_clk) 
	
    begin
	
      if (s_axis_clk = '1' and s_axis_clk' event) then
    
        fifo_ts_output   <= FIFO_READ_0_rd_data(159 downto 64);
        fifo_addr_output <= FIFO_READ_0_rd_data(63 downto 0);
		-- read address and data from the FIFO when the FIFO is non empty
      end if;
    end process;
    
    
    FIFO_WRITE_0_wr_data <= fifo_wr_data;
    FIFO_WRITE_0_wr_en   <= init_mem_write;
    FIFO_READ_0_rd_en    <= init_mem_txn;
    init_axi_txn         <= not (FIFO_READ_0_empty);
    
    
end Behavioral;
