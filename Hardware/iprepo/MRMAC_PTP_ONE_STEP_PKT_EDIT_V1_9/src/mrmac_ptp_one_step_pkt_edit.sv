
// ------------------------------------------------------------------------------
//   (c) Copyright 2018-2020 Xilinx, Inc. All rights reserved.
// 
//   This file contains confidential and proprietary information
//   of Xilinx, Inc. and is protected under U.S. and
//   international copyright and other intellectual property
//   laws.
// 
//   DISCLAIMER
//   This disclaimer is not a license and does not grant any
//   rights to the materials distributed herewith. Except as
//   otherwise provided in a valid license issued to you by
//   Xilinx, and to the maximum extent permitted by applicable
//   law: (1) THESE MATERIALS ARE MADE AVAILABLE \"AS IS\" AND
//   WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//   AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//   BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//   INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//   (2) Xilinx shall not be liable (whether in contract or tort,
//   including negligence, or under any other theory of
//   liability) for any loss or damage of any kind or nature
//   related to, arising under or in connection with these
//   materials, including for any direct, or any indirect,
//   special, incidental, or consequential loss or damage
//   (including loss of data, profits, goodwill, or any type of
//   loss or damage suffered as a result of any action brought
//   by a third party) even if such damage or loss was
//   reasonably foreseeable or Xilinx had been advised of the
//   possibility of the same.
// 
//   CRITICAL APPLICATIONS
//   Xilinx products are not designed or intended to be fail-
//   safe, or for use in any application requiring fail-safe
//   performance, such as life-support or safety devices or
//   systems, Class III medical devices, nuclear facilities,
//   applications related to the deployment of airbags, or any
//   other applications that could lead to death, personal
//   injury, or severe property or environmental damage
//   (individually and collectively, \"Critical
//   Applications\"). Customer assumes the sole risk and
//   liability of any use of Xilinx products in Critical
//   Applications, subject only to applicable laws and
//   regulations governing limitations on product liability.
// 
//   THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//   PART OF THIS FILE AT ALL TIMES.
// ------------------------------------------------------------------------------

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module mrmac_ptp_one_step_pkt_edit (

  input  wire clk,
  input  wire rst,

  input  wire ctl_tx_ptp_1step_enable,
  input  wire ctl_data_rate,  // 1 = 10G, 0 = 25G

  input  wire [79:0] ctl_tx_systemtimerin_ts,
  input  wire [63:0] ctl_tx_systemtimerin_cf,

  input  wire s_tvalid,
  //input  wire sopin,
  input  wire [63:0] s_tdata,
  input  wire s_tlast,
  input  wire [7:0] s_tkeep,
  input  wire s_terr,
  output wire s_tready,
  

  ///// Command interface  
  input  wire 		 s_cmd_tvalid_0,
  input  wire [31:0] s_cmd_tdata_0,
  input  wire 		 s_cmd_tlast_0,
  input  wire [7:0]  s_cmd_tkeep_0,
  input  wire        s_cmd_tuser_0,
  output wire        s_cmd_tready_0,
  
  
  
  output wire [1:0]  m_ptp_1588op,
  output wire        m_ptp_upd_chcksum,
  output wire [15:0] m_ptp_cf_offset,
  output wire [15:0] m_ptp_tag,

  // Output side - AXI-Stream
  output logic       m_tvalid,
  output logic[63:0] m_tdata,
  output logic       m_tlast,
  output logic[ 7:0] m_tkeep,
  output logic       m_tuser,
  input  logic       m_tready,

  // Overflow and Underflow, for monitoring
  output wire        overflow,
  output wire        underflow

);




  wire [(32*4)-1:0] cmd_data_0;
  wire 				cmd_data_valid;
  logic  [1:0] client0_tx_axis_ptp_1588op ;
  logic  [15:0] client0_tx_axis_ptp_cf_offset ;
  logic  [15:0] client0_tx_axis_ptp_cksum_offset;
  logic  [15:0] client0_tx_axis_ptp_tag_field;
  logic  client0_tx_axis_ptp_udp_chksum;
  logic  [63:0] client0_tx_axis_ptp_pdel_cf;
  logic  client0_tx_axis_ptp_pdelay_flag;

   mrmac_ptp_axis_shifter #(
      .XIL_SHIFT_NUM_WORDS(4),
      .XIL_SHIFT_NUM_WORDS_LOG2(3)
   ) I_mrmac_0_axis_shifter_0 (
     .clk (clk ),
     .rst (rst ),
     // Command FIFO 
     .s_cmd_tvalid  ( s_cmd_tvalid_0 ),
     .s_cmd_tdata   ( s_cmd_tdata_0  ),
     .s_cmd_tlast   ( s_cmd_tlast_0  ),
     .s_cmd_tkeep   ( s_cmd_tkeep_0  ), // ignore
     .s_cmd_tuser   ( s_cmd_tuser_0  ),
     .s_cmd_tready  ( s_cmd_tready_0 ),
     .s_dat_tvalid  ( s_tvalid ),
     .s_dat_tlast   ( s_tlast ),
     .s_dat_tready  ( s_tready ),
     .dat_o         ( cmd_data_0 ),
     .val_o         ( cmd_data_valid )
   );

   logic [63:0] tx_tod_corr_0_0_int;
   always @*
    begin
        client0_tx_axis_ptp_1588op       = cmd_data_0[1:0];
        client0_tx_axis_ptp_udp_chksum   = cmd_data_0[2];
        client0_tx_axis_ptp_pdelay_flag  = cmd_data_0[3];
        client0_tx_axis_ptp_tag_field    = cmd_data_0[31:16];
        client0_tx_axis_ptp_cf_offset    = cmd_data_0[47:32];
        client0_tx_axis_ptp_cksum_offset = cmd_data_0[63:48];

        client0_tx_axis_ptp_pdel_cf      = cmd_data_0[127:64];

        tx_tod_corr_0_0_int = (cmd_data_0[3]) ? client0_tx_axis_ptp_pdel_cf : ctl_tx_systemtimerin_cf ;
    end
 

  
   
   
   mrmac_ptp_one_step_pkt_edit_core i_mrmac_ptp_one_step_pkt_edit_core_0 (
     .clk                     ( clk ),
     .rst                     ( rst ),
     .ctl_tx_ptp_1step_enable ( 1'b1 ),
     .ctl_data_rate           ( 1'b0 ),  // 1 = 10G, 0 = 25G
     .ctl_tx_systemtimerin_ts ( ctl_tx_systemtimerin_ts ),
     .ctl_tx_systemtimerin_cf ( tx_tod_corr_0_0_int ),
     .s_tvalid                ( s_tvalid),
     .s_tdata                 ( s_tdata ),
     .s_tlast                 ( s_tlast ),
     .s_tkeep                 ( s_tkeep ), 
     .s_terr                  ( s_terr  ),
     .s_tready                ( s_tready  ),
     .s_ptp_1588op            ( {client0_tx_axis_ptp_pdelay_flag, client0_tx_axis_ptp_1588op[1:0]} ),
     .s_ptp_udp_chksum        ( client0_tx_axis_ptp_udp_chksum ),
     .s_ptp_cf_offset         ( client0_tx_axis_ptp_cf_offset ),
     .s_ptp_chksum_offset     ( client0_tx_axis_ptp_cksum_offset ),
     .s_ptp_tag               ( client0_tx_axis_ptp_tag_field ),
     .m_ptp_1588op            ( m_ptp_1588op  ), 
     .m_ptp_upd_chcksum       ( m_ptp_upd_chcksum ),
     .m_ptp_cf_offset         ( m_ptp_cf_offset  ),
     .m_ptp_tag               ( m_ptp_tag  ),
     .m_tvalid                ( m_tvalid ),         // to mrmac.
     .m_tdata                 ( m_tdata  ), 
     .m_tlast                 ( m_tlast ),        
     .m_tkeep                 ( m_tkeep ),   
     .m_tuser                 ( m_tuser  ),    
     .m_tready                ( m_tready ),
     .overflow                (   ),
     .underflow               (   )
   );

 










endmodule
