
################################################################
# This is a generated script based on design: mrmac_subsys
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source mrmac_subsys_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S
   set_property BOARD_PART xilinx.com:vck190:part0:3.3 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name vck190_ethernet_trd_2025_1 

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_noc:1.1\
xilinx.com:ip:mrmac:3.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:versal_cips:3.4\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:axi_apb_bridge:3.0\
xilinx.com:ip:bufg_gt:1.0\
xilinx.com:ip:gt_quad_base:1.1\
xilinx.com:ip:util_reduced_logic:2.0\
user.org:user:RX_PTP_PKT_DETECT_one_step:1.1\
xilinx.com:ip:axi_mcdma:1.2\
xilinx.com:ip:axis_data_fifo:2.0\
user.org:user:mrmac_10g_mux:1.0\
user.org:user:mrmac_ptp_one_step_pkt_edit:1.0\
user.org:user:mrmac_ptp_timestamp_if:1.0\
user.org:user:mrmac_systimer_bus_if:1.0\
xilinx.com:ip:ptp_1588_timer_syncer:2.0\
user.org:user:RX_PTP_TS_PREPEND:1.1\
xilinx.com:ip:emb_fifo_gen:1.0\
user.org:XUP:hw_master_top:2.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: ptp_logic
proc create_hier_cell_ptp_logic_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_ptp_logic_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_1step

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_sts


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir O -from 0 -to 0 Res1
  create_bd_pin -dir O -from 0 -to 0 Res2
  create_bd_pin -dir I -from 0 -to 0 -type rst axis_rx_rstn
  create_bd_pin -dir I cmd_tlast
  create_bd_pin -dir I cmd_tready
  create_bd_pin -dir I cmd_tvalid
  create_bd_pin -dir I -from 15 -to 0 din
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir I fifo_full
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O m_axis_s2mm_tready
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir I mrmac_tlast
  create_bd_pin -dir I -from 0 -to 0 rx_axis_tvalid_0
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir I s_axis_mm2s_tvalid
  create_bd_pin -dir I s_axis_s2mm_tlast
  create_bd_pin -dir I s_axis_s2mm_tvalid
  create_bd_pin -dir I -from 63 -to 0 s_axis_tdata
  create_bd_pin -dir I -from 7 -to 0 s_axis_tkeep
  create_bd_pin -dir I tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I wr_en

  # Create instance: RX_PTP_TS_PREPEND_0, and set properties
  set RX_PTP_TS_PREPEND_0 [ create_bd_cell -type ip -vlnv user.org:user:RX_PTP_TS_PREPEND:1.1 RX_PTP_TS_PREPEND_0 ]

  # Create instance: axis_data_fifo_2, and set properties
  set axis_data_fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_2 ]
  set_property -dict [list \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_2


  # Create instance: emb_fifo_gen_0, and set properties
  set emb_fifo_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_0 ]
  set_property -dict [list \
    CONFIG.DATA_COUNT_WIDTH {10} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.FIFO_WRITE_DEPTH {512} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {80} \
  ] $emb_fifo_gen_0


  # Create instance: emb_fifo_gen_1, and set properties
  set emb_fifo_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_1 ]
  set_property -dict [list \
    CONFIG.DATA_COUNT_WIDTH {10} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.FIFO_WRITE_DEPTH {512} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {16} \
  ] $emb_fifo_gen_1


  # Create instance: hw_master_top_0, and set properties
  set hw_master_top_0 [ create_bd_cell -type ip -vlnv user.org:XUP:hw_master_top:2.0 hw_master_top_0 ]
  set_property CONFIG.C_M00_AXI_ADDR_WIDTH {64} $hw_master_top_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_1


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_2


  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_3


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_4


  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_5 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_5


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m00_axi] [get_bd_intf_pins hw_master_top_0/m00_axi]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_axis_1step] [get_bd_intf_pins hw_master_top_0/m_axis_1step]
  connect_bd_intf_net -intf_net RX_PTP_TS_PREPEND_0_m_axis [get_bd_intf_pins m_axis] [get_bd_intf_pins RX_PTP_TS_PREPEND_0/m_axis]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_CNTRL [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_data_fifo_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_2_M_AXIS [get_bd_intf_pins axis_data_fifo_2/M_AXIS] [get_bd_intf_pins hw_master_top_0/s_axis_cntrl]
  connect_bd_intf_net -intf_net hw_master_top_0_m_axis_sts [get_bd_intf_pins m_axis_sts] [get_bd_intf_pins hw_master_top_0/m_axis_sts]

  # Create port connections
  connect_bd_net -net RX_PTP_PKT_DETECT_TS_0_fifo_valid  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_valid] \
  [get_bd_pins util_vector_logic_3/Op1] \
  [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_fifo_reset  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_reset] \
  [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_rd_en  [get_bd_pins RX_PTP_TS_PREPEND_0/rd_en] \
  [get_bd_pins emb_fifo_gen_0/rd_en] \
  [get_bd_pins emb_fifo_gen_1/rd_en]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_wr_en_t2_TOD  [get_bd_pins RX_PTP_TS_PREPEND_0/wr_en_t2_TOD] \
  [get_bd_pins hw_master_top_0/t2_wr_en]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tready] \
  [get_bd_pins m_axis_s2mm_tready] \
  [get_bd_pins hw_master_top_0/m_axis_s2mm_tready]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins tx_axis_tlast_0] \
  [get_bd_pins hw_master_top_0/s_axis_mm2s_tlast]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins s_axis_mm2s_tvalid] \
  [get_bd_pins hw_master_top_0/s_axis_mm2s_tvalid] \
  [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tdata  [get_bd_pins s_axis_tdata] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tkeep  [get_bd_pins s_axis_tkeep] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tlast  [get_bd_pins s_axis_s2mm_tlast] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tlast] \
  [get_bd_pins hw_master_top_0/s_axis_s2mm_tlast]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tvalid  [get_bd_pins s_axis_s2mm_tvalid] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tvalid] \
  [get_bd_pins hw_master_top_0/s_axis_s2mm_tvalid]
  connect_bd_net -net cmd_tlast_1  [get_bd_pins cmd_tlast] \
  [get_bd_pins hw_master_top_0/cmd_tlast]
  connect_bd_net -net cmd_tready_1  [get_bd_pins cmd_tready] \
  [get_bd_pins hw_master_top_0/cmd_tready]
  connect_bd_net -net cmd_tvalid_1  [get_bd_pins cmd_tvalid] \
  [get_bd_pins hw_master_top_0/cmd_tvalid]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins hw_master_top_0/t2_tdata_in]
  connect_bd_net -net din_1  [get_bd_pins din] \
  [get_bd_pins emb_fifo_gen_1/din]
  connect_bd_net -net emb_fifo_gen_0_data_count  [get_bd_pins emb_fifo_gen_0/data_count] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/TOD_data_count]
  connect_bd_net -net emb_fifo_gen_0_dout  [get_bd_pins emb_fifo_gen_0/dout] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_timestamp_tod]
  connect_bd_net -net emb_fifo_gen_1_dout  [get_bd_pins emb_fifo_gen_1/dout] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rd_data]
  connect_bd_net -net emb_fifo_gen_1_empty  [get_bd_pins emb_fifo_gen_1/empty] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/empty]
  connect_bd_net -net fifo_full_1  [get_bd_pins fifo_full] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_full]
  connect_bd_net -net hw_master_top_0_data_ready  [get_bd_pins hw_master_top_0/data_ready] \
  [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net hw_master_top_0_data_valid  [get_bd_pins hw_master_top_0/data_valid] \
  [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net hw_master_top_0_interrupt  [get_bd_pins hw_master_top_0/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net hw_master_top_0_tx_ptp_1588op_in  [get_bd_pins hw_master_top_0/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net hw_master_top_0_tx_ptp_tstamp_tag_out -boundary_type lower  [get_bd_pins tx_ptp_tstamp_tag_out]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_axis_clk_in] \
  [get_bd_pins axis_data_fifo_2/s_axis_aclk] \
  [get_bd_pins emb_fifo_gen_0/wr_clk] \
  [get_bd_pins emb_fifo_gen_1/wr_clk] \
  [get_bd_pins hw_master_top_0/s_axis_clk] \
  [get_bd_pins hw_master_top_0/m00_axi_aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins axis_data_fifo_2/s_axis_aresetn] \
  [get_bd_pins hw_master_top_0/s_axis_resetn] \
  [get_bd_pins hw_master_top_0/m00_axi_aresetn]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins mrmac_tlast] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/mrmac_last]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/mrmac_valid] \
  [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins emb_fifo_gen_0/din]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins util_vector_logic_4/Op2]
  connect_bd_net -net s_axis_aresetn1_1  [get_bd_pins axis_rx_rstn] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_axis_reset_in] \
  [get_bd_pins util_vector_logic_2/Op2]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins hw_master_top_0/mrmac_tx_tready] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins hw_master_top_0/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins hw_master_top_0/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins hw_master_top_0/tx_timestamp_tod_valid]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins Res1]
  connect_bd_net -net util_vector_logic_1_Res  [get_bd_pins util_vector_logic_1/Res] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins util_vector_logic_2/Res] \
  [get_bd_pins Res] \
  [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net util_vector_logic_3_Res  [get_bd_pins util_vector_logic_3/Res] \
  [get_bd_pins Res2]
  connect_bd_net -net util_vector_logic_4_Res  [get_bd_pins util_vector_logic_4/Res] \
  [get_bd_pins emb_fifo_gen_0/wr_en]
  connect_bd_net -net util_vector_logic_5_Res  [get_bd_pins util_vector_logic_5/Res] \
  [get_bd_pins emb_fifo_gen_0/rst] \
  [get_bd_pins emb_fifo_gen_1/rst]
  connect_bd_net -net wr_en_1  [get_bd_pins wr_en] \
  [get_bd_pins emb_fifo_gen_1/wr_en]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ptp_logic
proc create_hier_cell_ptp_logic_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_ptp_logic_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_1step

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_sts


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir O -from 0 -to 0 Res1
  create_bd_pin -dir O -from 0 -to 0 Res2
  create_bd_pin -dir I -from 0 -to 0 -type rst axis_rx_rstn
  create_bd_pin -dir I cmd_tlast
  create_bd_pin -dir I cmd_tready
  create_bd_pin -dir I cmd_tvalid
  create_bd_pin -dir I -from 15 -to 0 din
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir I fifo_full
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O m_axis_s2mm_tready
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir I mrmac_tlast
  create_bd_pin -dir I -from 0 -to 0 rx_axis_tvalid_0
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir I s_axis_mm2s_tvalid
  create_bd_pin -dir I s_axis_s2mm_tlast
  create_bd_pin -dir I s_axis_s2mm_tvalid
  create_bd_pin -dir I -from 63 -to 0 s_axis_tdata
  create_bd_pin -dir I -from 7 -to 0 s_axis_tkeep
  create_bd_pin -dir I tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I wr_en

  # Create instance: RX_PTP_TS_PREPEND_0, and set properties
  set RX_PTP_TS_PREPEND_0 [ create_bd_cell -type ip -vlnv user.org:user:RX_PTP_TS_PREPEND:1.1 RX_PTP_TS_PREPEND_0 ]

  # Create instance: axis_data_fifo_2, and set properties
  set axis_data_fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_2 ]
  set_property -dict [list \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_2


  # Create instance: emb_fifo_gen_0, and set properties
  set emb_fifo_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_0 ]
  set_property -dict [list \
    CONFIG.DATA_COUNT_WIDTH {10} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.FIFO_WRITE_DEPTH {512} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {80} \
  ] $emb_fifo_gen_0


  # Create instance: emb_fifo_gen_1, and set properties
  set emb_fifo_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_1 ]
  set_property -dict [list \
    CONFIG.DATA_COUNT_WIDTH {10} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.FIFO_WRITE_DEPTH {512} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {16} \
  ] $emb_fifo_gen_1


  # Create instance: hw_master_top_0, and set properties
  set hw_master_top_0 [ create_bd_cell -type ip -vlnv user.org:XUP:hw_master_top:2.0 hw_master_top_0 ]
  set_property CONFIG.C_M00_AXI_ADDR_WIDTH {64} $hw_master_top_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_1


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_2


  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_3


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_4


  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_5 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_5


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m00_axi] [get_bd_intf_pins hw_master_top_0/m00_axi]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_axis_1step] [get_bd_intf_pins hw_master_top_0/m_axis_1step]
  connect_bd_intf_net -intf_net RX_PTP_TS_PREPEND_0_m_axis [get_bd_intf_pins m_axis] [get_bd_intf_pins RX_PTP_TS_PREPEND_0/m_axis]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_CNTRL [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_data_fifo_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_2_M_AXIS [get_bd_intf_pins axis_data_fifo_2/M_AXIS] [get_bd_intf_pins hw_master_top_0/s_axis_cntrl]
  connect_bd_intf_net -intf_net hw_master_top_0_m_axis_sts [get_bd_intf_pins m_axis_sts] [get_bd_intf_pins hw_master_top_0/m_axis_sts]

  # Create port connections
  connect_bd_net -net RX_PTP_PKT_DETECT_TS_0_fifo_valid  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_valid] \
  [get_bd_pins util_vector_logic_3/Op1] \
  [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_fifo_reset  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_reset] \
  [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_rd_en  [get_bd_pins RX_PTP_TS_PREPEND_0/rd_en] \
  [get_bd_pins emb_fifo_gen_0/rd_en] \
  [get_bd_pins emb_fifo_gen_1/rd_en]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_wr_en_t2_TOD  [get_bd_pins RX_PTP_TS_PREPEND_0/wr_en_t2_TOD] \
  [get_bd_pins hw_master_top_0/t2_wr_en]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tready] \
  [get_bd_pins m_axis_s2mm_tready] \
  [get_bd_pins hw_master_top_0/m_axis_s2mm_tready]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins tx_axis_tlast_0] \
  [get_bd_pins hw_master_top_0/s_axis_mm2s_tlast]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins s_axis_mm2s_tvalid] \
  [get_bd_pins hw_master_top_0/s_axis_mm2s_tvalid] \
  [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tdata  [get_bd_pins s_axis_tdata] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tkeep  [get_bd_pins s_axis_tkeep] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tlast  [get_bd_pins s_axis_s2mm_tlast] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tlast] \
  [get_bd_pins hw_master_top_0/s_axis_s2mm_tlast]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tvalid  [get_bd_pins s_axis_s2mm_tvalid] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tvalid] \
  [get_bd_pins hw_master_top_0/s_axis_s2mm_tvalid]
  connect_bd_net -net cmd_tlast_1  [get_bd_pins cmd_tlast] \
  [get_bd_pins hw_master_top_0/cmd_tlast]
  connect_bd_net -net cmd_tready_1  [get_bd_pins cmd_tready] \
  [get_bd_pins hw_master_top_0/cmd_tready]
  connect_bd_net -net cmd_tvalid_1  [get_bd_pins cmd_tvalid] \
  [get_bd_pins hw_master_top_0/cmd_tvalid]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins hw_master_top_0/t2_tdata_in]
  connect_bd_net -net din_1  [get_bd_pins din] \
  [get_bd_pins emb_fifo_gen_1/din]
  connect_bd_net -net emb_fifo_gen_0_data_count  [get_bd_pins emb_fifo_gen_0/data_count] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/TOD_data_count]
  connect_bd_net -net emb_fifo_gen_0_dout  [get_bd_pins emb_fifo_gen_0/dout] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_timestamp_tod]
  connect_bd_net -net emb_fifo_gen_1_dout  [get_bd_pins emb_fifo_gen_1/dout] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rd_data]
  connect_bd_net -net emb_fifo_gen_1_empty  [get_bd_pins emb_fifo_gen_1/empty] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/empty]
  connect_bd_net -net fifo_full_1  [get_bd_pins fifo_full] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_full]
  connect_bd_net -net hw_master_top_0_data_ready  [get_bd_pins hw_master_top_0/data_ready] \
  [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net hw_master_top_0_data_valid  [get_bd_pins hw_master_top_0/data_valid] \
  [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net hw_master_top_0_interrupt  [get_bd_pins hw_master_top_0/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net hw_master_top_0_tx_ptp_1588op_in  [get_bd_pins hw_master_top_0/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net hw_master_top_0_tx_ptp_tstamp_tag_out -boundary_type lower  [get_bd_pins tx_ptp_tstamp_tag_out]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_axis_clk_in] \
  [get_bd_pins axis_data_fifo_2/s_axis_aclk] \
  [get_bd_pins emb_fifo_gen_0/wr_clk] \
  [get_bd_pins emb_fifo_gen_1/wr_clk] \
  [get_bd_pins hw_master_top_0/s_axis_clk] \
  [get_bd_pins hw_master_top_0/m00_axi_aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins axis_data_fifo_2/s_axis_aresetn] \
  [get_bd_pins hw_master_top_0/s_axis_resetn] \
  [get_bd_pins hw_master_top_0/m00_axi_aresetn]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins mrmac_tlast] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/mrmac_last]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/mrmac_valid] \
  [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins emb_fifo_gen_0/din]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins util_vector_logic_4/Op2]
  connect_bd_net -net s_axis_aresetn1_1  [get_bd_pins axis_rx_rstn] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_axis_reset_in] \
  [get_bd_pins util_vector_logic_2/Op2]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins hw_master_top_0/mrmac_tx_tready] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins hw_master_top_0/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins hw_master_top_0/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins hw_master_top_0/tx_timestamp_tod_valid]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins Res1]
  connect_bd_net -net util_vector_logic_1_Res  [get_bd_pins util_vector_logic_1/Res] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins util_vector_logic_2/Res] \
  [get_bd_pins Res] \
  [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net util_vector_logic_3_Res  [get_bd_pins util_vector_logic_3/Res] \
  [get_bd_pins Res2]
  connect_bd_net -net util_vector_logic_4_Res  [get_bd_pins util_vector_logic_4/Res] \
  [get_bd_pins emb_fifo_gen_0/wr_en]
  connect_bd_net -net util_vector_logic_5_Res  [get_bd_pins util_vector_logic_5/Res] \
  [get_bd_pins emb_fifo_gen_0/rst] \
  [get_bd_pins emb_fifo_gen_1/rst]
  connect_bd_net -net wr_en_1  [get_bd_pins wr_en] \
  [get_bd_pins emb_fifo_gen_1/wr_en]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ptp_logic
proc create_hier_cell_ptp_logic_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_ptp_logic_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_1step

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_sts


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir O -from 0 -to 0 Res1
  create_bd_pin -dir O -from 0 -to 0 Res2
  create_bd_pin -dir I -from 0 -to 0 -type rst axis_rx_rstn
  create_bd_pin -dir I cmd_tlast
  create_bd_pin -dir I cmd_tready
  create_bd_pin -dir I cmd_tvalid
  create_bd_pin -dir I -from 15 -to 0 din
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir I fifo_full
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O m_axis_s2mm_tready
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir I mrmac_tlast
  create_bd_pin -dir I -from 0 -to 0 rx_axis_tvalid_0
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir I s_axis_mm2s_tvalid
  create_bd_pin -dir I s_axis_s2mm_tlast
  create_bd_pin -dir I s_axis_s2mm_tvalid
  create_bd_pin -dir I -from 63 -to 0 s_axis_tdata
  create_bd_pin -dir I -from 7 -to 0 s_axis_tkeep
  create_bd_pin -dir I tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I wr_en

  # Create instance: RX_PTP_TS_PREPEND_0, and set properties
  set RX_PTP_TS_PREPEND_0 [ create_bd_cell -type ip -vlnv user.org:user:RX_PTP_TS_PREPEND:1.1 RX_PTP_TS_PREPEND_0 ]

  # Create instance: axis_data_fifo_2, and set properties
  set axis_data_fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_2 ]
  set_property -dict [list \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_2


  # Create instance: emb_fifo_gen_0, and set properties
  set emb_fifo_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_0 ]
  set_property -dict [list \
    CONFIG.DATA_COUNT_WIDTH {10} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.FIFO_WRITE_DEPTH {512} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {80} \
  ] $emb_fifo_gen_0


  # Create instance: emb_fifo_gen_1, and set properties
  set emb_fifo_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_1 ]
  set_property -dict [list \
    CONFIG.DATA_COUNT_WIDTH {10} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.FIFO_WRITE_DEPTH {512} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {16} \
  ] $emb_fifo_gen_1


  # Create instance: hw_master_top_0, and set properties
  set hw_master_top_0 [ create_bd_cell -type ip -vlnv user.org:XUP:hw_master_top:2.0 hw_master_top_0 ]
  set_property CONFIG.C_M00_AXI_ADDR_WIDTH {64} $hw_master_top_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_1


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_2


  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_3


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_4


  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_5 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_5


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m00_axi] [get_bd_intf_pins hw_master_top_0/m00_axi]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_axis_1step] [get_bd_intf_pins hw_master_top_0/m_axis_1step]
  connect_bd_intf_net -intf_net RX_PTP_TS_PREPEND_0_m_axis [get_bd_intf_pins m_axis] [get_bd_intf_pins RX_PTP_TS_PREPEND_0/m_axis]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_CNTRL [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_data_fifo_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_2_M_AXIS [get_bd_intf_pins axis_data_fifo_2/M_AXIS] [get_bd_intf_pins hw_master_top_0/s_axis_cntrl]
  connect_bd_intf_net -intf_net hw_master_top_0_m_axis_sts [get_bd_intf_pins m_axis_sts] [get_bd_intf_pins hw_master_top_0/m_axis_sts]

  # Create port connections
  connect_bd_net -net RX_PTP_PKT_DETECT_TS_0_fifo_valid  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_valid] \
  [get_bd_pins util_vector_logic_3/Op1] \
  [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_fifo_reset  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_reset] \
  [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_rd_en  [get_bd_pins RX_PTP_TS_PREPEND_0/rd_en] \
  [get_bd_pins emb_fifo_gen_0/rd_en] \
  [get_bd_pins emb_fifo_gen_1/rd_en]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_wr_en_t2_TOD  [get_bd_pins RX_PTP_TS_PREPEND_0/wr_en_t2_TOD] \
  [get_bd_pins hw_master_top_0/t2_wr_en]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tready] \
  [get_bd_pins m_axis_s2mm_tready] \
  [get_bd_pins hw_master_top_0/m_axis_s2mm_tready]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins tx_axis_tlast_0] \
  [get_bd_pins hw_master_top_0/s_axis_mm2s_tlast]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins s_axis_mm2s_tvalid] \
  [get_bd_pins hw_master_top_0/s_axis_mm2s_tvalid] \
  [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tdata  [get_bd_pins s_axis_tdata] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tkeep  [get_bd_pins s_axis_tkeep] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tlast  [get_bd_pins s_axis_s2mm_tlast] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tlast] \
  [get_bd_pins hw_master_top_0/s_axis_s2mm_tlast]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tvalid  [get_bd_pins s_axis_s2mm_tvalid] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tvalid] \
  [get_bd_pins hw_master_top_0/s_axis_s2mm_tvalid]
  connect_bd_net -net cmd_tlast_1  [get_bd_pins cmd_tlast] \
  [get_bd_pins hw_master_top_0/cmd_tlast]
  connect_bd_net -net cmd_tready_1  [get_bd_pins cmd_tready] \
  [get_bd_pins hw_master_top_0/cmd_tready]
  connect_bd_net -net cmd_tvalid_1  [get_bd_pins cmd_tvalid] \
  [get_bd_pins hw_master_top_0/cmd_tvalid]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins hw_master_top_0/t2_tdata_in]
  connect_bd_net -net din_1  [get_bd_pins din] \
  [get_bd_pins emb_fifo_gen_1/din]
  connect_bd_net -net emb_fifo_gen_0_data_count  [get_bd_pins emb_fifo_gen_0/data_count] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/TOD_data_count]
  connect_bd_net -net emb_fifo_gen_0_dout  [get_bd_pins emb_fifo_gen_0/dout] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_timestamp_tod]
  connect_bd_net -net emb_fifo_gen_1_dout  [get_bd_pins emb_fifo_gen_1/dout] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rd_data]
  connect_bd_net -net emb_fifo_gen_1_empty  [get_bd_pins emb_fifo_gen_1/empty] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/empty]
  connect_bd_net -net fifo_full_1  [get_bd_pins fifo_full] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_full]
  connect_bd_net -net hw_master_top_0_data_ready  [get_bd_pins hw_master_top_0/data_ready] \
  [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net hw_master_top_0_data_valid  [get_bd_pins hw_master_top_0/data_valid] \
  [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net hw_master_top_0_interrupt  [get_bd_pins hw_master_top_0/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net hw_master_top_0_tx_ptp_1588op_in  [get_bd_pins hw_master_top_0/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net hw_master_top_0_tx_ptp_tstamp_tag_out -boundary_type lower  [get_bd_pins tx_ptp_tstamp_tag_out]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_axis_clk_in] \
  [get_bd_pins axis_data_fifo_2/s_axis_aclk] \
  [get_bd_pins emb_fifo_gen_0/wr_clk] \
  [get_bd_pins emb_fifo_gen_1/wr_clk] \
  [get_bd_pins hw_master_top_0/s_axis_clk] \
  [get_bd_pins hw_master_top_0/m00_axi_aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins axis_data_fifo_2/s_axis_aresetn] \
  [get_bd_pins hw_master_top_0/s_axis_resetn] \
  [get_bd_pins hw_master_top_0/m00_axi_aresetn]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins mrmac_tlast] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/mrmac_last]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/mrmac_valid] \
  [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins emb_fifo_gen_0/din]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins util_vector_logic_4/Op2]
  connect_bd_net -net s_axis_aresetn1_1  [get_bd_pins axis_rx_rstn] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_axis_reset_in] \
  [get_bd_pins util_vector_logic_2/Op2]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins hw_master_top_0/mrmac_tx_tready] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins hw_master_top_0/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins hw_master_top_0/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins hw_master_top_0/tx_timestamp_tod_valid]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins Res1]
  connect_bd_net -net util_vector_logic_1_Res  [get_bd_pins util_vector_logic_1/Res] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins util_vector_logic_2/Res] \
  [get_bd_pins Res] \
  [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net util_vector_logic_3_Res  [get_bd_pins util_vector_logic_3/Res] \
  [get_bd_pins Res2]
  connect_bd_net -net util_vector_logic_4_Res  [get_bd_pins util_vector_logic_4/Res] \
  [get_bd_pins emb_fifo_gen_0/wr_en]
  connect_bd_net -net util_vector_logic_5_Res  [get_bd_pins util_vector_logic_5/Res] \
  [get_bd_pins emb_fifo_gen_0/rst] \
  [get_bd_pins emb_fifo_gen_1/rst]
  connect_bd_net -net wr_en_1  [get_bd_pins wr_en] \
  [get_bd_pins emb_fifo_gen_1/wr_en]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ptp_logic
proc create_hier_cell_ptp_logic { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_ptp_logic() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_1step

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_sts


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir O -from 0 -to 0 Res1
  create_bd_pin -dir O -from 0 -to 0 Res2
  create_bd_pin -dir I -from 0 -to 0 -type rst axis_rx_rstn
  create_bd_pin -dir I cmd_tlast
  create_bd_pin -dir I cmd_tready
  create_bd_pin -dir I cmd_tvalid
  create_bd_pin -dir I -from 15 -to 0 din
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir I fifo_full
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O m_axis_s2mm_tready
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir I mrmac_tlast
  create_bd_pin -dir I -from 0 -to 0 rx_axis_tvalid_0
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir I s_axis_mm2s_tvalid
  create_bd_pin -dir I s_axis_s2mm_tlast
  create_bd_pin -dir I s_axis_s2mm_tvalid
  create_bd_pin -dir I -from 63 -to 0 s_axis_tdata
  create_bd_pin -dir I -from 7 -to 0 s_axis_tkeep
  create_bd_pin -dir I tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I wr_en

  # Create instance: RX_PTP_TS_PREPEND_0, and set properties
  set RX_PTP_TS_PREPEND_0 [ create_bd_cell -type ip -vlnv user.org:user:RX_PTP_TS_PREPEND:1.1 RX_PTP_TS_PREPEND_0 ]

  # Create instance: axis_data_fifo_2, and set properties
  set axis_data_fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_2 ]
  set_property -dict [list \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_2


  # Create instance: emb_fifo_gen_0, and set properties
  set emb_fifo_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_0 ]
  set_property -dict [list \
    CONFIG.DATA_COUNT_WIDTH {10} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.FIFO_WRITE_DEPTH {512} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {80} \
  ] $emb_fifo_gen_0


  # Create instance: emb_fifo_gen_1, and set properties
  set emb_fifo_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_fifo_gen:1.0 emb_fifo_gen_1 ]
  set_property -dict [list \
    CONFIG.DATA_COUNT_WIDTH {10} \
    CONFIG.ENABLE_ALMOST_EMPTY {false} \
    CONFIG.ENABLE_ALMOST_FULL {false} \
    CONFIG.ENABLE_OVERFLOW {false} \
    CONFIG.ENABLE_PROGRAMMABLE_EMPTY {false} \
    CONFIG.ENABLE_PROGRAMMABLE_FULL {false} \
    CONFIG.ENABLE_UNDERFLOW {false} \
    CONFIG.ENABLE_WRITE_ACK {false} \
    CONFIG.FIFO_WRITE_DEPTH {512} \
    CONFIG.READ_MODE {FWFT} \
    CONFIG.WRITE_DATA_WIDTH {16} \
  ] $emb_fifo_gen_1


  # Create instance: hw_master_top_0, and set properties
  set hw_master_top_0 [ create_bd_cell -type ip -vlnv user.org:XUP:hw_master_top:2.0 hw_master_top_0 ]
  set_property CONFIG.C_M00_AXI_ADDR_WIDTH {64} $hw_master_top_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_1


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_2


  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_3


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_4


  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_5 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_5


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m00_axi] [get_bd_intf_pins hw_master_top_0/m00_axi]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_axis_1step] [get_bd_intf_pins hw_master_top_0/m_axis_1step]
  connect_bd_intf_net -intf_net RX_PTP_TS_PREPEND_0_m_axis [get_bd_intf_pins m_axis] [get_bd_intf_pins RX_PTP_TS_PREPEND_0/m_axis]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_CNTRL [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_data_fifo_2/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_2_M_AXIS [get_bd_intf_pins axis_data_fifo_2/M_AXIS] [get_bd_intf_pins hw_master_top_0/s_axis_cntrl]
  connect_bd_intf_net -intf_net hw_master_top_0_m_axis_sts [get_bd_intf_pins m_axis_sts] [get_bd_intf_pins hw_master_top_0/m_axis_sts]

  # Create port connections
  connect_bd_net -net RX_PTP_PKT_DETECT_TS_0_fifo_valid  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_valid] \
  [get_bd_pins util_vector_logic_3/Op1] \
  [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_fifo_reset  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_reset] \
  [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_rd_en  [get_bd_pins RX_PTP_TS_PREPEND_0/rd_en] \
  [get_bd_pins emb_fifo_gen_0/rd_en] \
  [get_bd_pins emb_fifo_gen_1/rd_en]
  connect_bd_net -net RX_PTP_TS_PREPEND_0_wr_en_t2_TOD  [get_bd_pins RX_PTP_TS_PREPEND_0/wr_en_t2_TOD] \
  [get_bd_pins hw_master_top_0/t2_wr_en]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tready] \
  [get_bd_pins m_axis_s2mm_tready] \
  [get_bd_pins hw_master_top_0/m_axis_s2mm_tready]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins tx_axis_tlast_0] \
  [get_bd_pins hw_master_top_0/s_axis_mm2s_tlast]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins s_axis_mm2s_tvalid] \
  [get_bd_pins hw_master_top_0/s_axis_mm2s_tvalid] \
  [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tdata  [get_bd_pins s_axis_tdata] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tkeep  [get_bd_pins s_axis_tkeep] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tlast  [get_bd_pins s_axis_s2mm_tlast] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tlast] \
  [get_bd_pins hw_master_top_0/s_axis_s2mm_tlast]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tvalid  [get_bd_pins s_axis_s2mm_tvalid] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/s_axis_tvalid] \
  [get_bd_pins hw_master_top_0/s_axis_s2mm_tvalid]
  connect_bd_net -net cmd_tlast_1  [get_bd_pins cmd_tlast] \
  [get_bd_pins hw_master_top_0/cmd_tlast]
  connect_bd_net -net cmd_tready_1  [get_bd_pins cmd_tready] \
  [get_bd_pins hw_master_top_0/cmd_tready]
  connect_bd_net -net cmd_tvalid_1  [get_bd_pins cmd_tvalid] \
  [get_bd_pins hw_master_top_0/cmd_tvalid]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins hw_master_top_0/t2_tdata_in]
  connect_bd_net -net din_1  [get_bd_pins din] \
  [get_bd_pins emb_fifo_gen_1/din]
  connect_bd_net -net emb_fifo_gen_0_data_count  [get_bd_pins emb_fifo_gen_0/data_count] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/TOD_data_count]
  connect_bd_net -net emb_fifo_gen_0_dout  [get_bd_pins emb_fifo_gen_0/dout] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_timestamp_tod]
  connect_bd_net -net emb_fifo_gen_1_dout  [get_bd_pins emb_fifo_gen_1/dout] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rd_data]
  connect_bd_net -net emb_fifo_gen_1_empty  [get_bd_pins emb_fifo_gen_1/empty] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/empty]
  connect_bd_net -net fifo_full_1  [get_bd_pins fifo_full] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/fifo_full]
  connect_bd_net -net hw_master_top_0_data_ready  [get_bd_pins hw_master_top_0/data_ready] \
  [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net hw_master_top_0_data_valid  [get_bd_pins hw_master_top_0/data_valid] \
  [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net hw_master_top_0_interrupt  [get_bd_pins hw_master_top_0/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net hw_master_top_0_tx_ptp_1588op_in  [get_bd_pins hw_master_top_0/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_axis_clk_in] \
  [get_bd_pins axis_data_fifo_2/s_axis_aclk] \
  [get_bd_pins emb_fifo_gen_0/wr_clk] \
  [get_bd_pins emb_fifo_gen_1/wr_clk] \
  [get_bd_pins hw_master_top_0/s_axis_clk] \
  [get_bd_pins hw_master_top_0/m00_axi_aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins axis_data_fifo_2/s_axis_aresetn] \
  [get_bd_pins hw_master_top_0/s_axis_resetn] \
  [get_bd_pins hw_master_top_0/m00_axi_aresetn]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins mrmac_tlast] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/mrmac_last]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/mrmac_valid] \
  [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins emb_fifo_gen_0/din]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins util_vector_logic_4/Op2]
  connect_bd_net -net s_axis_aresetn1_1  [get_bd_pins axis_rx_rstn] \
  [get_bd_pins RX_PTP_TS_PREPEND_0/rx_axis_reset_in] \
  [get_bd_pins util_vector_logic_2/Op2]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins hw_master_top_0/mrmac_tx_tready] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins hw_master_top_0/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins hw_master_top_0/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins hw_master_top_0/tx_timestamp_tod_valid]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins Res1]
  connect_bd_net -net util_vector_logic_1_Res  [get_bd_pins util_vector_logic_1/Res] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins util_vector_logic_2/Res] \
  [get_bd_pins Res] \
  [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net util_vector_logic_3_Res  [get_bd_pins util_vector_logic_3/Res] \
  [get_bd_pins Res2]
  connect_bd_net -net util_vector_logic_4_Res  [get_bd_pins util_vector_logic_4/Res] \
  [get_bd_pins emb_fifo_gen_0/wr_en]
  connect_bd_net -net util_vector_logic_5_Res  [get_bd_pins util_vector_logic_5/Res] \
  [get_bd_pins emb_fifo_gen_0/rst] \
  [get_bd_pins emb_fifo_gen_1/rst]
  connect_bd_net -net wr_en_1  [get_bd_pins wr_en] \
  [get_bd_pins emb_fifo_gen_1/wr_en]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_rst_slice_hier_ch3
proc create_hier_cell_clk_rst_slice_hier_ch3_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst_slice_hier_ch3_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rst
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rst_out
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rstn_out
  create_bd_pin -dir I -from 3 -to 0 ts_rst
  create_bd_pin -dir O -from 0 -to 0 ts_rst_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rst
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rst_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rstn_out

  # Create instance: xlslice_rx_axis_rst, and set properties
  set xlslice_rx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_axis_rst


  # Create instance: xlslice_rx_axis_rstn_ch3, and set properties
  set xlslice_rx_axis_rstn_ch3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rstn_ch3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
  ] $xlslice_rx_axis_rstn_ch3


  # Create instance: xlslice_ts_rst, and set properties
  set xlslice_ts_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_ts_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_ts_rst


  # Create instance: xlslice_tx_axis_rst, and set properties
  set xlslice_tx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rst


  # Create instance: xlslice_tx_axis_rstn_ch3, and set properties
  set xlslice_tx_axis_rstn_ch3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rstn_ch3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rstn_ch3


  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_tx_axis_rstn_ch3/Din]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_rx_axis_rstn_ch3/Din]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins xlslice_tx_axis_rstn_ch3/Dout] \
  [get_bd_pins tx_axis_rstn_out]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins xlslice_rx_axis_rstn_ch3/Dout] \
  [get_bd_pins rx_axis_rstn_out]
  connect_bd_net -net rx_axis_rst_1  [get_bd_pins rx_axis_rst] \
  [get_bd_pins xlslice_rx_axis_rst/Din]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst] \
  [get_bd_pins xlslice_ts_rst/Din]
  connect_bd_net -net tx_axis_rst_1  [get_bd_pins tx_axis_rst] \
  [get_bd_pins xlslice_tx_axis_rst/Din]
  connect_bd_net -net xlslice_rx_axis_rst_Dout  [get_bd_pins xlslice_rx_axis_rst/Dout] \
  [get_bd_pins rx_axis_rst_out]
  connect_bd_net -net xlslice_ts_rst_Dout  [get_bd_pins xlslice_ts_rst/Dout] \
  [get_bd_pins ts_rst_out]
  connect_bd_net -net xlslice_tx_axis_rst_Dout  [get_bd_pins xlslice_tx_axis_rst/Dout] \
  [get_bd_pins tx_axis_rst_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_rst_slice_hier_ch2
proc create_hier_cell_clk_rst_slice_hier_ch2_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst_slice_hier_ch2_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rst
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rst_out
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rstn_out
  create_bd_pin -dir I -from 3 -to 0 ts_rst
  create_bd_pin -dir O -from 0 -to 0 ts_rst_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rst
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rst_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rstn_out

  # Create instance: xlslice_rx_axis_rst, and set properties
  set xlslice_rx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_axis_rst


  # Create instance: xlslice_rx_axis_rstn_ch2, and set properties
  set xlslice_rx_axis_rstn_ch2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rstn_ch2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
  ] $xlslice_rx_axis_rstn_ch2


  # Create instance: xlslice_ts_rst, and set properties
  set xlslice_ts_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_ts_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_ts_rst


  # Create instance: xlslice_tx_axis_rst, and set properties
  set xlslice_tx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rst


  # Create instance: xlslice_tx_axis_rstn_ch2, and set properties
  set xlslice_tx_axis_rstn_ch2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rstn_ch2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rstn_ch2


  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_tx_axis_rstn_ch2/Din]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_rx_axis_rstn_ch2/Din]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins xlslice_tx_axis_rstn_ch2/Dout] \
  [get_bd_pins tx_axis_rstn_out]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins xlslice_rx_axis_rstn_ch2/Dout] \
  [get_bd_pins rx_axis_rstn_out]
  connect_bd_net -net rx_axis_rst_1  [get_bd_pins rx_axis_rst] \
  [get_bd_pins xlslice_rx_axis_rst/Din]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst] \
  [get_bd_pins xlslice_ts_rst/Din]
  connect_bd_net -net tx_axis_rst_1  [get_bd_pins tx_axis_rst] \
  [get_bd_pins xlslice_tx_axis_rst/Din]
  connect_bd_net -net xlslice_rx_axis_rst_Dout  [get_bd_pins xlslice_rx_axis_rst/Dout] \
  [get_bd_pins rx_axis_rst_out]
  connect_bd_net -net xlslice_ts_rst_Dout  [get_bd_pins xlslice_ts_rst/Dout] \
  [get_bd_pins ts_rst_out]
  connect_bd_net -net xlslice_tx_axis_rst_Dout  [get_bd_pins xlslice_tx_axis_rst/Dout] \
  [get_bd_pins tx_axis_rst_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_rst_slice_hier_ch1
proc create_hier_cell_clk_rst_slice_hier_ch1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst_slice_hier_ch1_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rst
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rst_out
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rstn_out
  create_bd_pin -dir I -from 3 -to 0 ts_rst
  create_bd_pin -dir O -from 0 -to 0 ts_rst_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rst
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rst_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rstn_out

  # Create instance: xlslice_rx_axis_rst, and set properties
  set xlslice_rx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_axis_rst


  # Create instance: xlslice_rx_axis_rstn_ch1, and set properties
  set xlslice_rx_axis_rstn_ch1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rstn_ch1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_axis_rstn_ch1


  # Create instance: xlslice_ts_rst, and set properties
  set xlslice_ts_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_ts_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_ts_rst


  # Create instance: xlslice_tx_axis_rst, and set properties
  set xlslice_tx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rst


  # Create instance: xlslice_tx_axis_rstn_ch1, and set properties
  set xlslice_tx_axis_rstn_ch1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rstn_ch1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rstn_ch1


  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_tx_axis_rstn_ch1/Din]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_rx_axis_rstn_ch1/Din]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins xlslice_tx_axis_rstn_ch1/Dout] \
  [get_bd_pins tx_axis_rstn_out]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins xlslice_rx_axis_rstn_ch1/Dout] \
  [get_bd_pins rx_axis_rstn_out]
  connect_bd_net -net rx_axis_rst_1  [get_bd_pins rx_axis_rst] \
  [get_bd_pins xlslice_rx_axis_rst/Din]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst] \
  [get_bd_pins xlslice_ts_rst/Din]
  connect_bd_net -net tx_axis_rst_1  [get_bd_pins tx_axis_rst] \
  [get_bd_pins xlslice_tx_axis_rst/Din]
  connect_bd_net -net xlslice_rx_axis_rst_Dout  [get_bd_pins xlslice_rx_axis_rst/Dout] \
  [get_bd_pins rx_axis_rst_out]
  connect_bd_net -net xlslice_ts_rst_Dout  [get_bd_pins xlslice_ts_rst/Dout] \
  [get_bd_pins ts_rst_out]
  connect_bd_net -net xlslice_tx_axis_rst_Dout  [get_bd_pins xlslice_tx_axis_rst/Dout] \
  [get_bd_pins tx_axis_rst_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_rst_slice_hier_ch0
proc create_hier_cell_clk_rst_slice_hier_ch0_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst_slice_hier_ch0_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rst
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rst_out
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rstn_out
  create_bd_pin -dir I -from 3 -to 0 ts_rst
  create_bd_pin -dir O -from 0 -to 0 ts_rst_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rst
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rst_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rstn_out

  # Create instance: xlslice_rx_axis_rst, and set properties
  set xlslice_rx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rst ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_rx_axis_rst


  # Create instance: xlslice_rx_axis_rstn_ch0, and set properties
  set xlslice_rx_axis_rstn_ch0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rstn_ch0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_rx_axis_rstn_ch0


  # Create instance: xlslice_ts_rst, and set properties
  set xlslice_ts_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_ts_rst ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_ts_rst


  # Create instance: xlslice_tx_axis_rst, and set properties
  set xlslice_tx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rst ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_axis_rst


  # Create instance: xlslice_tx_axis_rstn_ch0, and set properties
  set xlslice_tx_axis_rstn_ch0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rstn_ch0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_axis_rstn_ch0


  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_tx_axis_rstn_ch0/Din]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_rx_axis_rstn_ch0/Din]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins xlslice_tx_axis_rstn_ch0/Dout] \
  [get_bd_pins tx_axis_rstn_out]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins xlslice_rx_axis_rstn_ch0/Dout] \
  [get_bd_pins rx_axis_rstn_out]
  connect_bd_net -net rx_axis_rst_1  [get_bd_pins rx_axis_rst] \
  [get_bd_pins xlslice_rx_axis_rst/Din]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst] \
  [get_bd_pins xlslice_ts_rst/Din]
  connect_bd_net -net tx_axis_rst_1  [get_bd_pins tx_axis_rst] \
  [get_bd_pins xlslice_tx_axis_rst/Din]
  connect_bd_net -net xlslice_rx_axis_rst_Dout  [get_bd_pins xlslice_rx_axis_rst/Dout] \
  [get_bd_pins rx_axis_rst_out]
  connect_bd_net -net xlslice_ts_rst_Dout  [get_bd_pins xlslice_ts_rst/Dout] \
  [get_bd_pins ts_rst_out]
  connect_bd_net -net xlslice_tx_axis_rst_Dout  [get_bd_pins xlslice_tx_axis_rst/Dout] \
  [get_bd_pins tx_axis_rst_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: SYS_TIMER_3
proc create_hier_cell_SYS_TIMER_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_SYS_TIMER_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_0


  # Create pins
  create_bd_pin -dir O mrmac_rx_ptp_st_overwrite_0
  create_bd_pin -dir O mrmac_rx_ptp_st_sync_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_rx_ptp_systimer_0
  create_bd_pin -dir O mrmac_tx_ptp_st_overwrite_0
  create_bd_pin -dir O mrmac_tx_ptp_st_sync_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_tx_ptp_systimer_0
  create_bd_pin -dir I -type clk rx_axis_clk_0
  create_bd_pin -dir I -type rst rx_axis_rst_0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I -from 54 -to 0 rx_ptp_tstamp_0
  create_bd_pin -dir O -from 79 -to 0 rx_timestamp_tod_0
  create_bd_pin -dir O rx_timestamp_tod_valid_0
  create_bd_pin -dir I -type clk s_axi_aclk_0
  create_bd_pin -dir I -type rst s_axi_aresetn_0
  create_bd_pin -dir I tod_1pps_in
  create_bd_pin -dir O tod_1pps_out
  create_bd_pin -dir O tod_intr
  create_bd_pin -dir I ts_clk
  create_bd_pin -dir I ts_rst
  create_bd_pin -dir I -type clk tx_axis_clk_0
  create_bd_pin -dir I -type rst tx_axis_rst_0
  create_bd_pin -dir I -from 54 -to 0 tx_ptp_tstamp_0
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_0
  create_bd_pin -dir I tx_ptp_tstamp_valid_0
  create_bd_pin -dir O -from 15 -to 0 tx_timestamp_tag_tod_0
  create_bd_pin -dir O -from 79 -to 0 tx_timestamp_tod_0
  create_bd_pin -dir O tx_timestamp_tod_valid_0
  create_bd_pin -dir O -from 63 -to 0 tx_tod_corr_3
  create_bd_pin -dir O -from 31 -to 0 tx_tod_ns_3
  create_bd_pin -dir O -from 47 -to 0 tx_tod_sec_3

  # Create instance: Tie_16b800, and set properties
  set Tie_16b800 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_16b800 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x800} \
    CONFIG.CONST_WIDTH {16} \
  ] $Tie_16b800


  # Create instance: Tie_16bC6, and set properties
  set Tie_16bC6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_16bC6 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0xC6} \
    CONFIG.CONST_WIDTH {16} \
  ] $Tie_16bC6


  # Create instance: Tie_1b0, and set properties
  set Tie_1b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_1b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $Tie_1b0


  # Create instance: Tie_1b1, and set properties
  set Tie_1b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_1b1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $Tie_1b1


  # Create instance: Tie_250MHz_period, and set properties
  set Tie_250MHz_period [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_250MHz_period ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0004000000000000} \
    CONFIG.CONST_WIDTH {64} \
  ] $Tie_250MHz_period


  # Create instance: Tie_250MHz_period_0, and set properties
  set Tie_250MHz_period_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_250MHz_period_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x04000000000000} \
    CONFIG.CONST_WIDTH {56} \
  ] $Tie_250MHz_period_0


  # Create instance: Tie_2b0, and set properties
  set Tie_2b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_2b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {2} \
  ] $Tie_2b0


  # Create instance: Tie_32b1, and set properties
  set Tie_32b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_32b1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {32} \
  ] $Tie_32b1


  # Create instance: Tie_55b0, and set properties
  set Tie_55b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_55b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {55} \
  ] $Tie_55b0


  # Create instance: mrmac_ptp_timestamp_0, and set properties
  set mrmac_ptp_timestamp_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_ptp_timestamp_if:1.0 mrmac_ptp_timestamp_0 ]

  # Create instance: mrmac_systimer_bus_if_0, and set properties
  set mrmac_systimer_bus_if_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_systimer_bus_if:1.0 mrmac_systimer_bus_if_0 ]

  # Create instance: ptp_1588_timer_syncer_0, and set properties
  set ptp_1588_timer_syncer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ptp_1588_timer_syncer:2.0 ptp_1588_timer_syncer_0 ]
  set_property -dict [list \
    CONFIG.CORE_MODE {Timer_Syncer} \
    CONFIG.ENABLE_EXT_TOD_BUS {1} \
    CONFIG.NUM_PORTS {1} \
    CONFIG.TIMER_FORMAT {Both} \
    CONFIG.TS_CLK_PERIOD {4.0} \
  ] $ptp_1588_timer_syncer_0


  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_0_1 [get_bd_intf_pins s_axi_0] [get_bd_intf_pins ptp_1588_timer_syncer_0/s_axi]

  # Create port connections
  connect_bd_net -net Tie_0_dout  [get_bd_pins Tie_1b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust_vld] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust_vld] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_rx_ptp_st_sync] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_tx_ptp_st_sync]
  connect_bd_net -net Tie_16b800_dout  [get_bd_pins Tie_16b800/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_half_period_adjust]
  connect_bd_net -net Tie_16bC6_dout  [get_bd_pins Tie_16bC6/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_1clk_adjust]
  connect_bd_net -net Tie_1b1_dout  [get_bd_pins Tie_1b1/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_overwrite] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_overwrite]
  connect_bd_net -net Tie_250MHz_period_dout  [get_bd_pins Tie_250MHz_period/dout] \
  [get_bd_pins ptp_1588_timer_syncer_0/core_tx0_period_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/core_rx0_period_0]
  connect_bd_net -net Tie_2b0_dout  [get_bd_pins Tie_2b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust_type] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust_type]
  connect_bd_net -net Tie_32b1_dout  [get_bd_pins Tie_32b1/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust]
  connect_bd_net -net Tie_55b0_dout  [get_bd_pins Tie_55b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_rx_ptp_systemtimer] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_tx_ptp_systemtimer]
  connect_bd_net -net mrmac_ptp_timestamp_0_rx_timestamp_tod  [get_bd_pins mrmac_ptp_timestamp_0/rx_timestamp_tod] \
  [get_bd_pins rx_timestamp_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_rx_timestamp_tod_valid  [get_bd_pins mrmac_ptp_timestamp_0/rx_timestamp_tod_valid] \
  [get_bd_pins rx_timestamp_tod_valid_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tag_tod  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tag_tod] \
  [get_bd_pins tx_timestamp_tag_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tod  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tod] \
  [get_bd_pins tx_timestamp_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tod_valid  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tod_valid] \
  [get_bd_pins tx_timestamp_tod_valid_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_st_overwrite  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_st_overwrite] \
  [get_bd_pins mrmac_rx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_st_sync  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_st_sync] \
  [get_bd_pins mrmac_rx_ptp_st_sync_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_systimer  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_systimer] \
  [get_bd_pins mrmac_rx_ptp_systimer_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_st_overwrite  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_st_overwrite] \
  [get_bd_pins mrmac_tx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_st_sync  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_st_sync] \
  [get_bd_pins mrmac_tx_ptp_st_sync_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_systimer  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_systimer] \
  [get_bd_pins mrmac_tx_ptp_systimer_0]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_corr_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_corr_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_corr] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_corr]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_ns_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_ns_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_ns] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_ns]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_sec_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_sec_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_sec] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_sec]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_corr_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_corr_0] \
  [get_bd_pins tx_tod_corr_3] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_corr] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_corr]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_ns_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_ns_0] \
  [get_bd_pins tx_tod_ns_3] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_ns] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_ns]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_sec_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_sec_0] \
  [get_bd_pins tx_tod_sec_3] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_sec] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_sec]
  connect_bd_net -net ptp_1588_timer_syncer_1_tod_1pps_out  [get_bd_pins ptp_1588_timer_syncer_0/tod_1pps_out] \
  [get_bd_pins tod_1pps_out]
  connect_bd_net -net ptp_1588_timer_syncer_1_tod_intr  [get_bd_pins ptp_1588_timer_syncer_0/tod_intr] \
  [get_bd_pins tod_intr]
  connect_bd_net -net rx_axis_clk_0_1  [get_bd_pins rx_axis_clk_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_clk]
  connect_bd_net -net rx_axis_rst_0_1  [get_bd_pins rx_axis_rst_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_rst]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_tvalid]
  connect_bd_net -net rx_ptp_tstamp_0_1  [get_bd_pins rx_ptp_tstamp_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_ptp_tstamp]
  connect_bd_net -net s_axi_aclk_0_1  [get_bd_pins s_axi_aclk_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_0_1  [get_bd_pins s_axi_aresetn_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/s_axi_aresetn]
  connect_bd_net -net tod_1pps_in_1  [get_bd_pins tod_1pps_in] \
  [get_bd_pins ptp_1588_timer_syncer_0/tod_1pps_in]
  connect_bd_net -net ts_clk_1  [get_bd_pins ts_clk] \
  [get_bd_pins mrmac_ptp_timestamp_0/ts_clk] \
  [get_bd_pins mrmac_systimer_bus_if_0/ts_clk] \
  [get_bd_pins ptp_1588_timer_syncer_0/ts_clk] \
  [get_bd_pins ptp_1588_timer_syncer_0/tx_phy_clk_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/rx_phy_clk_0]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst] \
  [get_bd_pins mrmac_ptp_timestamp_0/rst] \
  [get_bd_pins mrmac_systimer_bus_if_0/rst] \
  [get_bd_pins ptp_1588_timer_syncer_0/ts_rst] \
  [get_bd_pins ptp_1588_timer_syncer_0/tx_phy_rst_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/rx_phy_rst_0]
  connect_bd_net -net tx_axis_clk_0_1  [get_bd_pins tx_axis_clk_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_axis_clk]
  connect_bd_net -net tx_axis_rst_0_1  [get_bd_pins tx_axis_rst_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_axis_rst]
  connect_bd_net -net tx_ptp_tstamp_0_1  [get_bd_pins tx_ptp_tstamp_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp]
  connect_bd_net -net tx_ptp_tstamp_tag_0_1  [get_bd_pins tx_ptp_tstamp_tag_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp_tag]
  connect_bd_net -net tx_ptp_tstamp_valid_0_1  [get_bd_pins tx_ptp_tstamp_valid_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp_valid]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins Tie_250MHz_period_0/dout] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_period] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_period]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: SYS_TIMER_2
proc create_hier_cell_SYS_TIMER_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_SYS_TIMER_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_0


  # Create pins
  create_bd_pin -dir O mrmac_rx_ptp_st_overwrite_0
  create_bd_pin -dir O mrmac_rx_ptp_st_sync_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_rx_ptp_systimer_0
  create_bd_pin -dir O mrmac_tx_ptp_st_overwrite_0
  create_bd_pin -dir O mrmac_tx_ptp_st_sync_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_tx_ptp_systimer_0
  create_bd_pin -dir I -type clk rx_axis_clk_0
  create_bd_pin -dir I -type rst rx_axis_rst_0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I -from 54 -to 0 rx_ptp_tstamp_0
  create_bd_pin -dir O -from 79 -to 0 rx_timestamp_tod_0
  create_bd_pin -dir O rx_timestamp_tod_valid_0
  create_bd_pin -dir I -type clk s_axi_aclk_0
  create_bd_pin -dir I -type rst s_axi_aresetn_0
  create_bd_pin -dir I tod_1pps_in
  create_bd_pin -dir O tod_1pps_out
  create_bd_pin -dir O tod_intr
  create_bd_pin -dir I ts_clk
  create_bd_pin -dir I ts_rst
  create_bd_pin -dir I -type clk tx_axis_clk_0
  create_bd_pin -dir I -type rst tx_axis_rst_0
  create_bd_pin -dir I -from 54 -to 0 tx_ptp_tstamp_0
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_0
  create_bd_pin -dir I tx_ptp_tstamp_valid_0
  create_bd_pin -dir O -from 15 -to 0 tx_timestamp_tag_tod_0
  create_bd_pin -dir O -from 79 -to 0 tx_timestamp_tod_0
  create_bd_pin -dir O tx_timestamp_tod_valid_0
  create_bd_pin -dir O -from 63 -to 0 tx_tod_corr_2
  create_bd_pin -dir O -from 31 -to 0 tx_tod_ns_2
  create_bd_pin -dir O -from 47 -to 0 tx_tod_sec_2

  # Create instance: Tie_16b800, and set properties
  set Tie_16b800 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_16b800 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x800} \
    CONFIG.CONST_WIDTH {16} \
  ] $Tie_16b800


  # Create instance: Tie_16bC6, and set properties
  set Tie_16bC6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_16bC6 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0xC6} \
    CONFIG.CONST_WIDTH {16} \
  ] $Tie_16bC6


  # Create instance: Tie_1b0, and set properties
  set Tie_1b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_1b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $Tie_1b0


  # Create instance: Tie_1b1, and set properties
  set Tie_1b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_1b1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $Tie_1b1


  # Create instance: Tie_250MHz_period, and set properties
  set Tie_250MHz_period [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_250MHz_period ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0004000000000000} \
    CONFIG.CONST_WIDTH {64} \
  ] $Tie_250MHz_period


  # Create instance: Tie_250MHz_period_0, and set properties
  set Tie_250MHz_period_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_250MHz_period_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x04000000000000} \
    CONFIG.CONST_WIDTH {56} \
  ] $Tie_250MHz_period_0


  # Create instance: Tie_2b0, and set properties
  set Tie_2b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_2b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {2} \
  ] $Tie_2b0


  # Create instance: Tie_32b1, and set properties
  set Tie_32b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_32b1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {32} \
  ] $Tie_32b1


  # Create instance: Tie_55b0, and set properties
  set Tie_55b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_55b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {55} \
  ] $Tie_55b0


  # Create instance: mrmac_ptp_timestamp_0, and set properties
  set mrmac_ptp_timestamp_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_ptp_timestamp_if:1.0 mrmac_ptp_timestamp_0 ]

  # Create instance: mrmac_systimer_bus_if_0, and set properties
  set mrmac_systimer_bus_if_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_systimer_bus_if:1.0 mrmac_systimer_bus_if_0 ]

  # Create instance: ptp_1588_timer_syncer_0, and set properties
  set ptp_1588_timer_syncer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ptp_1588_timer_syncer:2.0 ptp_1588_timer_syncer_0 ]
  set_property -dict [list \
    CONFIG.CORE_MODE {Timer_Syncer} \
    CONFIG.ENABLE_EXT_TOD_BUS {1} \
    CONFIG.NUM_PORTS {1} \
    CONFIG.TIMER_FORMAT {Both} \
    CONFIG.TS_CLK_PERIOD {4.0} \
  ] $ptp_1588_timer_syncer_0


  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_0_1 [get_bd_intf_pins s_axi_0] [get_bd_intf_pins ptp_1588_timer_syncer_0/s_axi]

  # Create port connections
  connect_bd_net -net Tie_0_dout  [get_bd_pins Tie_1b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust_vld] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust_vld] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_rx_ptp_st_sync] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_tx_ptp_st_sync]
  connect_bd_net -net Tie_16b800_dout  [get_bd_pins Tie_16b800/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_half_period_adjust]
  connect_bd_net -net Tie_16bC6_dout  [get_bd_pins Tie_16bC6/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_1clk_adjust]
  connect_bd_net -net Tie_1b1_dout  [get_bd_pins Tie_1b1/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_overwrite] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_overwrite]
  connect_bd_net -net Tie_250MHz_period_dout  [get_bd_pins Tie_250MHz_period/dout] \
  [get_bd_pins ptp_1588_timer_syncer_0/core_tx0_period_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/core_rx0_period_0]
  connect_bd_net -net Tie_2b0_dout  [get_bd_pins Tie_2b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust_type] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust_type]
  connect_bd_net -net Tie_32b1_dout  [get_bd_pins Tie_32b1/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust]
  connect_bd_net -net Tie_55b0_dout  [get_bd_pins Tie_55b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_rx_ptp_systemtimer] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_tx_ptp_systemtimer]
  connect_bd_net -net mrmac_ptp_timestamp_0_rx_timestamp_tod  [get_bd_pins mrmac_ptp_timestamp_0/rx_timestamp_tod] \
  [get_bd_pins rx_timestamp_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_rx_timestamp_tod_valid  [get_bd_pins mrmac_ptp_timestamp_0/rx_timestamp_tod_valid] \
  [get_bd_pins rx_timestamp_tod_valid_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tag_tod  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tag_tod] \
  [get_bd_pins tx_timestamp_tag_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tod  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tod] \
  [get_bd_pins tx_timestamp_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tod_valid  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tod_valid] \
  [get_bd_pins tx_timestamp_tod_valid_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_st_overwrite  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_st_overwrite] \
  [get_bd_pins mrmac_rx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_st_sync  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_st_sync] \
  [get_bd_pins mrmac_rx_ptp_st_sync_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_systimer  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_systimer] \
  [get_bd_pins mrmac_rx_ptp_systimer_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_st_overwrite  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_st_overwrite] \
  [get_bd_pins mrmac_tx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_st_sync  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_st_sync] \
  [get_bd_pins mrmac_tx_ptp_st_sync_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_systimer  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_systimer] \
  [get_bd_pins mrmac_tx_ptp_systimer_0]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_corr_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_corr_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_corr] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_corr]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_ns_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_ns_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_ns] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_ns]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_sec_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_sec_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_sec] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_sec]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_corr_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_corr_0] \
  [get_bd_pins tx_tod_corr_2] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_corr] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_corr]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_ns_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_ns_0] \
  [get_bd_pins tx_tod_ns_2] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_ns] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_ns]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_sec_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_sec_0] \
  [get_bd_pins tx_tod_sec_2] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_sec] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_sec]
  connect_bd_net -net ptp_1588_timer_syncer_1_tod_1pps_out  [get_bd_pins ptp_1588_timer_syncer_0/tod_1pps_out] \
  [get_bd_pins tod_1pps_out]
  connect_bd_net -net ptp_1588_timer_syncer_1_tod_intr  [get_bd_pins ptp_1588_timer_syncer_0/tod_intr] \
  [get_bd_pins tod_intr]
  connect_bd_net -net rx_axis_clk_0_1  [get_bd_pins rx_axis_clk_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_clk]
  connect_bd_net -net rx_axis_rst_0_1  [get_bd_pins rx_axis_rst_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_rst]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_tvalid]
  connect_bd_net -net rx_ptp_tstamp_0_1  [get_bd_pins rx_ptp_tstamp_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_ptp_tstamp]
  connect_bd_net -net s_axi_aclk_0_1  [get_bd_pins s_axi_aclk_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_0_1  [get_bd_pins s_axi_aresetn_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/s_axi_aresetn]
  connect_bd_net -net tod_1pps_in_1  [get_bd_pins tod_1pps_in] \
  [get_bd_pins ptp_1588_timer_syncer_0/tod_1pps_in]
  connect_bd_net -net ts_clk_1  [get_bd_pins ts_clk] \
  [get_bd_pins mrmac_ptp_timestamp_0/ts_clk] \
  [get_bd_pins mrmac_systimer_bus_if_0/ts_clk] \
  [get_bd_pins ptp_1588_timer_syncer_0/ts_clk] \
  [get_bd_pins ptp_1588_timer_syncer_0/tx_phy_clk_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/rx_phy_clk_0]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst] \
  [get_bd_pins mrmac_ptp_timestamp_0/rst] \
  [get_bd_pins mrmac_systimer_bus_if_0/rst] \
  [get_bd_pins ptp_1588_timer_syncer_0/ts_rst] \
  [get_bd_pins ptp_1588_timer_syncer_0/tx_phy_rst_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/rx_phy_rst_0]
  connect_bd_net -net tx_axis_clk_0_1  [get_bd_pins tx_axis_clk_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_axis_clk]
  connect_bd_net -net tx_axis_rst_0_1  [get_bd_pins tx_axis_rst_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_axis_rst]
  connect_bd_net -net tx_ptp_tstamp_0_1  [get_bd_pins tx_ptp_tstamp_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp]
  connect_bd_net -net tx_ptp_tstamp_tag_0_1  [get_bd_pins tx_ptp_tstamp_tag_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp_tag]
  connect_bd_net -net tx_ptp_tstamp_valid_0_1  [get_bd_pins tx_ptp_tstamp_valid_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp_valid]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins Tie_250MHz_period_0/dout] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_period] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_period]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: SYS_TIMER_1
proc create_hier_cell_SYS_TIMER_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_SYS_TIMER_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_0


  # Create pins
  create_bd_pin -dir O mrmac_rx_ptp_st_overwrite_0
  create_bd_pin -dir O mrmac_rx_ptp_st_sync_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_rx_ptp_systimer_0
  create_bd_pin -dir O mrmac_tx_ptp_st_overwrite_0
  create_bd_pin -dir O mrmac_tx_ptp_st_sync_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_tx_ptp_systimer_0
  create_bd_pin -dir I -type clk rx_axis_clk_0
  create_bd_pin -dir I -type rst rx_axis_rst_0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I -from 54 -to 0 rx_ptp_tstamp_0
  create_bd_pin -dir O -from 79 -to 0 rx_timestamp_tod_0
  create_bd_pin -dir O rx_timestamp_tod_valid_0
  create_bd_pin -dir I -type clk s_axi_aclk_0
  create_bd_pin -dir I -type rst s_axi_aresetn_0
  create_bd_pin -dir I tod_1pps_in
  create_bd_pin -dir O tod_1pps_out
  create_bd_pin -dir O tod_intr
  create_bd_pin -dir I ts_clk
  create_bd_pin -dir I ts_rst
  create_bd_pin -dir I -type clk tx_axis_clk_0
  create_bd_pin -dir I -type rst tx_axis_rst_0
  create_bd_pin -dir I -from 54 -to 0 tx_ptp_tstamp_0
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_0
  create_bd_pin -dir I tx_ptp_tstamp_valid_0
  create_bd_pin -dir O -from 15 -to 0 tx_timestamp_tag_tod_0
  create_bd_pin -dir O -from 79 -to 0 tx_timestamp_tod_0
  create_bd_pin -dir O tx_timestamp_tod_valid_0
  create_bd_pin -dir O -from 63 -to 0 tx_tod_corr_1
  create_bd_pin -dir O -from 31 -to 0 tx_tod_ns_1
  create_bd_pin -dir O -from 47 -to 0 tx_tod_sec_1

  # Create instance: Tie_16b800, and set properties
  set Tie_16b800 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_16b800 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x800} \
    CONFIG.CONST_WIDTH {16} \
  ] $Tie_16b800


  # Create instance: Tie_16bC6, and set properties
  set Tie_16bC6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_16bC6 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0xC6} \
    CONFIG.CONST_WIDTH {16} \
  ] $Tie_16bC6


  # Create instance: Tie_1b0, and set properties
  set Tie_1b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_1b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $Tie_1b0


  # Create instance: Tie_1b1, and set properties
  set Tie_1b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_1b1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $Tie_1b1


  # Create instance: Tie_250MHz_period, and set properties
  set Tie_250MHz_period [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_250MHz_period ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0004000000000000} \
    CONFIG.CONST_WIDTH {64} \
  ] $Tie_250MHz_period


  # Create instance: Tie_250MHz_period_0, and set properties
  set Tie_250MHz_period_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_250MHz_period_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x04000000000000} \
    CONFIG.CONST_WIDTH {56} \
  ] $Tie_250MHz_period_0


  # Create instance: Tie_2b0, and set properties
  set Tie_2b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_2b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {2} \
  ] $Tie_2b0


  # Create instance: Tie_32b1, and set properties
  set Tie_32b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_32b1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {32} \
  ] $Tie_32b1


  # Create instance: Tie_55b0, and set properties
  set Tie_55b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_55b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {55} \
  ] $Tie_55b0


  # Create instance: mrmac_ptp_timestamp_0, and set properties
  set mrmac_ptp_timestamp_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_ptp_timestamp_if:1.0 mrmac_ptp_timestamp_0 ]

  # Create instance: mrmac_systimer_bus_if_0, and set properties
  set mrmac_systimer_bus_if_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_systimer_bus_if:1.0 mrmac_systimer_bus_if_0 ]

  # Create instance: ptp_1588_timer_syncer_0, and set properties
  set ptp_1588_timer_syncer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ptp_1588_timer_syncer:2.0 ptp_1588_timer_syncer_0 ]
  set_property -dict [list \
    CONFIG.CORE_MODE {Timer_Syncer} \
    CONFIG.ENABLE_EXT_TOD_BUS {1} \
    CONFIG.NUM_PORTS {1} \
    CONFIG.TIMER_FORMAT {Both} \
    CONFIG.TS_CLK_PERIOD {4.0} \
  ] $ptp_1588_timer_syncer_0


  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_0_1 [get_bd_intf_pins s_axi_0] [get_bd_intf_pins ptp_1588_timer_syncer_0/s_axi]

  # Create port connections
  connect_bd_net -net Tie_0_dout  [get_bd_pins Tie_1b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust_vld] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust_vld] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_rx_ptp_st_sync] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_tx_ptp_st_sync]
  connect_bd_net -net Tie_16b800_dout  [get_bd_pins Tie_16b800/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_half_period_adjust]
  connect_bd_net -net Tie_16bC6_dout  [get_bd_pins Tie_16bC6/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_1clk_adjust]
  connect_bd_net -net Tie_1b1_dout  [get_bd_pins Tie_1b1/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_overwrite] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_overwrite]
  connect_bd_net -net Tie_250MHz_period_dout  [get_bd_pins Tie_250MHz_period/dout] \
  [get_bd_pins ptp_1588_timer_syncer_0/core_tx0_period_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/core_rx0_period_0]
  connect_bd_net -net Tie_2b0_dout  [get_bd_pins Tie_2b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust_type] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust_type]
  connect_bd_net -net Tie_32b1_dout  [get_bd_pins Tie_32b1/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust]
  connect_bd_net -net Tie_55b0_dout  [get_bd_pins Tie_55b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_rx_ptp_systemtimer] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_tx_ptp_systemtimer]
  connect_bd_net -net mrmac_ptp_timestamp_0_rx_timestamp_tod  [get_bd_pins mrmac_ptp_timestamp_0/rx_timestamp_tod] \
  [get_bd_pins rx_timestamp_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_rx_timestamp_tod_valid  [get_bd_pins mrmac_ptp_timestamp_0/rx_timestamp_tod_valid] \
  [get_bd_pins rx_timestamp_tod_valid_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tag_tod  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tag_tod] \
  [get_bd_pins tx_timestamp_tag_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tod  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tod] \
  [get_bd_pins tx_timestamp_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tod_valid  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tod_valid] \
  [get_bd_pins tx_timestamp_tod_valid_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_st_overwrite  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_st_overwrite] \
  [get_bd_pins mrmac_rx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_st_sync  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_st_sync] \
  [get_bd_pins mrmac_rx_ptp_st_sync_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_systimer  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_systimer] \
  [get_bd_pins mrmac_rx_ptp_systimer_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_st_overwrite  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_st_overwrite] \
  [get_bd_pins mrmac_tx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_st_sync  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_st_sync] \
  [get_bd_pins mrmac_tx_ptp_st_sync_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_systimer  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_systimer] \
  [get_bd_pins mrmac_tx_ptp_systimer_0]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_corr_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_corr_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_corr] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_corr]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_ns_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_ns_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_ns] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_ns]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_sec_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_sec_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_sec] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_sec]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_corr_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_corr_0] \
  [get_bd_pins tx_tod_corr_1] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_corr] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_corr]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_ns_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_ns_0] \
  [get_bd_pins tx_tod_ns_1] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_ns] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_ns]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_sec_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_sec_0] \
  [get_bd_pins tx_tod_sec_1] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_sec] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_sec]
  connect_bd_net -net ptp_1588_timer_syncer_1_tod_1pps_out  [get_bd_pins ptp_1588_timer_syncer_0/tod_1pps_out] \
  [get_bd_pins tod_1pps_out]
  connect_bd_net -net ptp_1588_timer_syncer_1_tod_intr  [get_bd_pins ptp_1588_timer_syncer_0/tod_intr] \
  [get_bd_pins tod_intr]
  connect_bd_net -net rx_axis_clk_0_1  [get_bd_pins rx_axis_clk_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_clk]
  connect_bd_net -net rx_axis_rst_0_1  [get_bd_pins rx_axis_rst_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_rst]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_tvalid]
  connect_bd_net -net rx_ptp_tstamp_0_1  [get_bd_pins rx_ptp_tstamp_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_ptp_tstamp]
  connect_bd_net -net s_axi_aclk_0_1  [get_bd_pins s_axi_aclk_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_0_1  [get_bd_pins s_axi_aresetn_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/s_axi_aresetn]
  connect_bd_net -net tod_1pps_in_1  [get_bd_pins tod_1pps_in] \
  [get_bd_pins ptp_1588_timer_syncer_0/tod_1pps_in]
  connect_bd_net -net ts_clk_1  [get_bd_pins ts_clk] \
  [get_bd_pins mrmac_ptp_timestamp_0/ts_clk] \
  [get_bd_pins mrmac_systimer_bus_if_0/ts_clk] \
  [get_bd_pins ptp_1588_timer_syncer_0/ts_clk] \
  [get_bd_pins ptp_1588_timer_syncer_0/tx_phy_clk_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/rx_phy_clk_0]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst] \
  [get_bd_pins mrmac_ptp_timestamp_0/rst] \
  [get_bd_pins mrmac_systimer_bus_if_0/rst] \
  [get_bd_pins ptp_1588_timer_syncer_0/ts_rst] \
  [get_bd_pins ptp_1588_timer_syncer_0/tx_phy_rst_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/rx_phy_rst_0]
  connect_bd_net -net tx_axis_clk_0_1  [get_bd_pins tx_axis_clk_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_axis_clk]
  connect_bd_net -net tx_axis_rst_0_1  [get_bd_pins tx_axis_rst_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_axis_rst]
  connect_bd_net -net tx_ptp_tstamp_0_1  [get_bd_pins tx_ptp_tstamp_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp]
  connect_bd_net -net tx_ptp_tstamp_tag_0_1  [get_bd_pins tx_ptp_tstamp_tag_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp_tag]
  connect_bd_net -net tx_ptp_tstamp_valid_0_1  [get_bd_pins tx_ptp_tstamp_valid_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp_valid]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins Tie_250MHz_period_0/dout] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_period] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_period]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: SYS_TIMER_0
proc create_hier_cell_SYS_TIMER_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_SYS_TIMER_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_0


  # Create pins
  create_bd_pin -dir O mrmac_rx_ptp_st_overwrite_0
  create_bd_pin -dir O mrmac_rx_ptp_st_sync_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_rx_ptp_systimer_0
  create_bd_pin -dir O mrmac_tx_ptp_st_overwrite_0
  create_bd_pin -dir O mrmac_tx_ptp_st_sync_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_tx_ptp_systimer_0
  create_bd_pin -dir I -type clk rx_axis_clk_0
  create_bd_pin -dir I -type rst rx_axis_rst_0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I -from 54 -to 0 rx_ptp_tstamp_0
  create_bd_pin -dir O -from 79 -to 0 rx_timestamp_tod_0
  create_bd_pin -dir O rx_timestamp_tod_valid_0
  create_bd_pin -dir I -type clk s_axi_aclk_0
  create_bd_pin -dir I -type rst s_axi_aresetn_0
  create_bd_pin -dir I tod_1pps_in
  create_bd_pin -dir O tod_1pps_out
  create_bd_pin -dir O tod_intr
  create_bd_pin -dir I ts_clk
  create_bd_pin -dir I ts_rst
  create_bd_pin -dir I -type clk tx_axis_clk_0
  create_bd_pin -dir I -type rst tx_axis_rst_0
  create_bd_pin -dir I -from 54 -to 0 tx_ptp_tstamp_0
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_0
  create_bd_pin -dir I tx_ptp_tstamp_valid_0
  create_bd_pin -dir O -from 15 -to 0 tx_timestamp_tag_tod_0
  create_bd_pin -dir O -from 79 -to 0 tx_timestamp_tod_0
  create_bd_pin -dir O tx_timestamp_tod_valid_0
  create_bd_pin -dir O -from 63 -to 0 tx_tod_corr_0
  create_bd_pin -dir O -from 31 -to 0 tx_tod_ns_0
  create_bd_pin -dir O -from 47 -to 0 tx_tod_sec_0

  # Create instance: Tie_16b800, and set properties
  set Tie_16b800 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_16b800 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x800} \
    CONFIG.CONST_WIDTH {16} \
  ] $Tie_16b800


  # Create instance: Tie_16bC6, and set properties
  set Tie_16bC6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_16bC6 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0xC6} \
    CONFIG.CONST_WIDTH {16} \
  ] $Tie_16bC6


  # Create instance: Tie_1b0, and set properties
  set Tie_1b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_1b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $Tie_1b0


  # Create instance: Tie_1b1, and set properties
  set Tie_1b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_1b1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $Tie_1b1


  # Create instance: Tie_250MHz_period, and set properties
  set Tie_250MHz_period [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_250MHz_period ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0004000000000000} \
    CONFIG.CONST_WIDTH {64} \
  ] $Tie_250MHz_period


  # Create instance: Tie_250MHz_period_0, and set properties
  set Tie_250MHz_period_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_250MHz_period_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x04000000000000} \
    CONFIG.CONST_WIDTH {56} \
  ] $Tie_250MHz_period_0


  # Create instance: Tie_2b0, and set properties
  set Tie_2b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_2b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {2} \
  ] $Tie_2b0


  # Create instance: Tie_32b1, and set properties
  set Tie_32b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_32b1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {32} \
  ] $Tie_32b1


  # Create instance: Tie_55b0, and set properties
  set Tie_55b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Tie_55b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {55} \
  ] $Tie_55b0


  # Create instance: mrmac_ptp_timestamp_0, and set properties
  set mrmac_ptp_timestamp_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_ptp_timestamp_if:1.0 mrmac_ptp_timestamp_0 ]

  # Create instance: mrmac_systimer_bus_if_0, and set properties
  set mrmac_systimer_bus_if_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_systimer_bus_if:1.0 mrmac_systimer_bus_if_0 ]

  # Create instance: ptp_1588_timer_syncer_0, and set properties
  set ptp_1588_timer_syncer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ptp_1588_timer_syncer:2.0 ptp_1588_timer_syncer_0 ]
  set_property -dict [list \
    CONFIG.CORE_MODE {Timer_Syncer} \
    CONFIG.ENABLE_EXT_TOD_BUS {1} \
    CONFIG.NUM_PORTS {1} \
    CONFIG.TIMER_FORMAT {Both} \
    CONFIG.TS_CLK_PERIOD {4.0} \
  ] $ptp_1588_timer_syncer_0


  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_0_1 [get_bd_intf_pins s_axi_0] [get_bd_intf_pins ptp_1588_timer_syncer_0/s_axi]

  # Create port connections
  connect_bd_net -net Tie_0_dout  [get_bd_pins Tie_1b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust_vld] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust_vld] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_rx_ptp_st_sync] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_tx_ptp_st_sync]
  connect_bd_net -net Tie_16b800_dout  [get_bd_pins Tie_16b800/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_half_period_adjust]
  connect_bd_net -net Tie_16bC6_dout  [get_bd_pins Tie_16bC6/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_1clk_adjust]
  connect_bd_net -net Tie_1b1_dout  [get_bd_pins Tie_1b1/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_overwrite] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_overwrite]
  connect_bd_net -net Tie_250MHz_period_dout  [get_bd_pins Tie_250MHz_period/dout] \
  [get_bd_pins ptp_1588_timer_syncer_0/core_tx0_period_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/core_rx0_period_0]
  connect_bd_net -net Tie_2b0_dout  [get_bd_pins Tie_2b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust_type] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust_type]
  connect_bd_net -net Tie_32b1_dout  [get_bd_pins Tie_32b1/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_rx_st_adjust] \
  [get_bd_pins mrmac_systimer_bus_if_0/ctl_mrmac_tx_st_adjust]
  connect_bd_net -net Tie_55b0_dout  [get_bd_pins Tie_55b0/dout] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_rx_ptp_systemtimer] \
  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_stat_tx_ptp_systemtimer]
  connect_bd_net -net mrmac_ptp_timestamp_0_rx_timestamp_tod  [get_bd_pins mrmac_ptp_timestamp_0/rx_timestamp_tod] \
  [get_bd_pins rx_timestamp_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_rx_timestamp_tod_valid  [get_bd_pins mrmac_ptp_timestamp_0/rx_timestamp_tod_valid] \
  [get_bd_pins rx_timestamp_tod_valid_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tag_tod  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tag_tod] \
  [get_bd_pins tx_timestamp_tag_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tod  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tod] \
  [get_bd_pins tx_timestamp_tod_0]
  connect_bd_net -net mrmac_ptp_timestamp_0_tx_timestamp_tod_valid  [get_bd_pins mrmac_ptp_timestamp_0/tx_timestamp_tod_valid] \
  [get_bd_pins tx_timestamp_tod_valid_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_st_overwrite  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_st_overwrite] \
  [get_bd_pins mrmac_rx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_st_sync  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_st_sync] \
  [get_bd_pins mrmac_rx_ptp_st_sync_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_rx_ptp_systimer  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_rx_ptp_systimer] \
  [get_bd_pins mrmac_rx_ptp_systimer_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_st_overwrite  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_st_overwrite] \
  [get_bd_pins mrmac_tx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_st_sync  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_st_sync] \
  [get_bd_pins mrmac_tx_ptp_st_sync_0]
  connect_bd_net -net mrmac_systimer_bus_if_0_mrmac_tx_ptp_systimer  [get_bd_pins mrmac_systimer_bus_if_0/mrmac_tx_ptp_systimer] \
  [get_bd_pins mrmac_tx_ptp_systimer_0]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_corr_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_corr_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_corr] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_corr]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_ns_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_ns_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_ns] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_ns]
  connect_bd_net -net ptp_1588_timer_syncer_0_rx_tod_sec_0  [get_bd_pins ptp_1588_timer_syncer_0/rx_tod_sec_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_tod_sec] \
  [get_bd_pins mrmac_systimer_bus_if_0/rx_tod_sec]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_corr_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_corr_0] \
  [get_bd_pins tx_tod_corr_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_corr] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_corr]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_ns_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_ns_0] \
  [get_bd_pins tx_tod_ns_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_ns] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_ns]
  connect_bd_net -net ptp_1588_timer_syncer_0_tx_tod_sec_0  [get_bd_pins ptp_1588_timer_syncer_0/tx_tod_sec_0] \
  [get_bd_pins tx_tod_sec_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_tod_sec] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_tod_sec]
  connect_bd_net -net ptp_1588_timer_syncer_1_tod_1pps_out  [get_bd_pins ptp_1588_timer_syncer_0/tod_1pps_out] \
  [get_bd_pins tod_1pps_out]
  connect_bd_net -net ptp_1588_timer_syncer_1_tod_intr  [get_bd_pins ptp_1588_timer_syncer_0/tod_intr] \
  [get_bd_pins tod_intr]
  connect_bd_net -net rx_axis_clk_0_1  [get_bd_pins rx_axis_clk_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_clk]
  connect_bd_net -net rx_axis_rst_0_1  [get_bd_pins rx_axis_rst_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_rst]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_axis_tvalid]
  connect_bd_net -net rx_ptp_tstamp_0_1  [get_bd_pins rx_ptp_tstamp_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/rx_ptp_tstamp]
  connect_bd_net -net s_axi_aclk_0_1  [get_bd_pins s_axi_aclk_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_0_1  [get_bd_pins s_axi_aresetn_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/s_axi_aresetn]
  connect_bd_net -net tod_1pps_in_1  [get_bd_pins tod_1pps_in] \
  [get_bd_pins ptp_1588_timer_syncer_0/tod_1pps_in]
  connect_bd_net -net ts_clk_1  [get_bd_pins ts_clk] \
  [get_bd_pins mrmac_ptp_timestamp_0/ts_clk] \
  [get_bd_pins mrmac_systimer_bus_if_0/ts_clk] \
  [get_bd_pins ptp_1588_timer_syncer_0/ts_clk] \
  [get_bd_pins ptp_1588_timer_syncer_0/tx_phy_clk_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/rx_phy_clk_0]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst] \
  [get_bd_pins mrmac_ptp_timestamp_0/rst] \
  [get_bd_pins mrmac_systimer_bus_if_0/rst] \
  [get_bd_pins ptp_1588_timer_syncer_0/ts_rst] \
  [get_bd_pins ptp_1588_timer_syncer_0/tx_phy_rst_0] \
  [get_bd_pins ptp_1588_timer_syncer_0/rx_phy_rst_0]
  connect_bd_net -net tx_axis_clk_0_1  [get_bd_pins tx_axis_clk_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_axis_clk]
  connect_bd_net -net tx_axis_rst_0_1  [get_bd_pins tx_axis_rst_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_axis_rst]
  connect_bd_net -net tx_ptp_tstamp_0_1  [get_bd_pins tx_ptp_tstamp_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp]
  connect_bd_net -net tx_ptp_tstamp_tag_0_1  [get_bd_pins tx_ptp_tstamp_tag_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp_tag]
  connect_bd_net -net tx_ptp_tstamp_valid_0_1  [get_bd_pins tx_ptp_tstamp_valid_0] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_ptp_tstamp_valid]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins Tie_250MHz_period_0/dout] \
  [get_bd_pins mrmac_ptp_timestamp_0/tx_period] \
  [get_bd_pins mrmac_systimer_bus_if_0/tx_period]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: bufg_gt_txoutclk
proc create_hier_cell_bufg_gt_txoutclk { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_bufg_gt_txoutclk() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk outclk
  create_bd_pin -dir I -type clk outclk2
  create_bd_pin -dir O -from 3 -to 0 tx_usr_clk

  # Create instance: conct_tx_usr_clk, and set properties
  set conct_tx_usr_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_tx_usr_clk ]
  set_property CONFIG.NUM_PORTS {4} $conct_tx_usr_clk


  # Create instance: gt_bufg_gt_txoutclk_ch0, and set properties
  set gt_bufg_gt_txoutclk_ch0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_txoutclk_ch0 ]

  # Create instance: gt_bufg_gt_txoutclk_ch2, and set properties
  set gt_bufg_gt_txoutclk_ch2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_txoutclk_ch2 ]

  # Create port connections
  connect_bd_net -net bufg_gt_0_usrclk  [get_bd_pins gt_bufg_gt_txoutclk_ch0/usrclk] \
  [get_bd_pins conct_tx_usr_clk/In0] \
  [get_bd_pins conct_tx_usr_clk/In1]
  connect_bd_net -net conct_tx_usr_clk_dout  [get_bd_pins conct_tx_usr_clk/dout] \
  [get_bd_pins tx_usr_clk]
  connect_bd_net -net gt_bufg_gt_txoutclk_ch2_usrclk  [get_bd_pins gt_bufg_gt_txoutclk_ch2/usrclk] \
  [get_bd_pins conct_tx_usr_clk/In2] \
  [get_bd_pins conct_tx_usr_clk/In3]
  connect_bd_net -net gt_quad_base_ch0_txoutclk  [get_bd_pins outclk] \
  [get_bd_pins gt_bufg_gt_txoutclk_ch0/outclk]
  connect_bd_net -net outclk2_1  [get_bd_pins outclk2] \
  [get_bd_pins gt_bufg_gt_txoutclk_ch2/outclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: bufg_gt_rxoutclk
proc create_hier_cell_bufg_gt_rxoutclk { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_bufg_gt_rxoutclk() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk outclk
  create_bd_pin -dir I -type clk outclk1
  create_bd_pin -dir I -type clk outclk2
  create_bd_pin -dir I -type clk outclk3
  create_bd_pin -dir O -from 3 -to 0 rx_usr_clk

  # Create instance: conct_rx_usr_clk, and set properties
  set conct_rx_usr_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_rx_usr_clk ]
  set_property CONFIG.NUM_PORTS {4} $conct_rx_usr_clk


  # Create instance: gt_bufg_gt_rxoutclk_ch0, and set properties
  set gt_bufg_gt_rxoutclk_ch0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_rxoutclk_ch0 ]

  # Create instance: gt_bufg_gt_rxoutclk_ch1, and set properties
  set gt_bufg_gt_rxoutclk_ch1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_rxoutclk_ch1 ]

  # Create instance: gt_bufg_gt_rxoutclk_ch2, and set properties
  set gt_bufg_gt_rxoutclk_ch2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_rxoutclk_ch2 ]

  # Create instance: gt_bufg_gt_rxoutclk_ch3, and set properties
  set gt_bufg_gt_rxoutclk_ch3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_rxoutclk_ch3 ]

  # Create port connections
  connect_bd_net -net conct_rx_usr_clk_dout  [get_bd_pins conct_rx_usr_clk/dout] \
  [get_bd_pins rx_usr_clk]
  connect_bd_net -net gt_bufg_gt_rxoutclk_ch0_usrclk  [get_bd_pins gt_bufg_gt_rxoutclk_ch0/usrclk] \
  [get_bd_pins conct_rx_usr_clk/In0]
  connect_bd_net -net gt_bufg_gt_rxoutclk_ch1_usrclk  [get_bd_pins gt_bufg_gt_rxoutclk_ch1/usrclk] \
  [get_bd_pins conct_rx_usr_clk/In1]
  connect_bd_net -net gt_bufg_gt_rxoutclk_ch2_usrclk  [get_bd_pins gt_bufg_gt_rxoutclk_ch2/usrclk] \
  [get_bd_pins conct_rx_usr_clk/In2]
  connect_bd_net -net gt_bufg_gt_rxoutclk_ch3_usrclk  [get_bd_pins gt_bufg_gt_rxoutclk_ch3/usrclk] \
  [get_bd_pins conct_rx_usr_clk/In3]
  connect_bd_net -net outclk1_1  [get_bd_pins outclk1] \
  [get_bd_pins gt_bufg_gt_rxoutclk_ch1/outclk]
  connect_bd_net -net outclk2_1  [get_bd_pins outclk2] \
  [get_bd_pins gt_bufg_gt_rxoutclk_ch2/outclk]
  connect_bd_net -net outclk3_1  [get_bd_pins outclk3] \
  [get_bd_pins gt_bufg_gt_rxoutclk_ch3/outclk]
  connect_bd_net -net outclk_1  [get_bd_pins outclk] \
  [get_bd_pins gt_bufg_gt_rxoutclk_ch0/outclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_rst_slice_hier_ch3
proc create_hier_cell_clk_rst_slice_hier_ch3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst_slice_hier_ch3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rstn_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rstn_out

  # Create instance: xlslice_rx_axis_rstn_ch3, and set properties
  set xlslice_rx_axis_rstn_ch3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rstn_ch3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
  ] $xlslice_rx_axis_rstn_ch3


  # Create instance: xlslice_tx_axis_rstn_ch3, and set properties
  set xlslice_tx_axis_rstn_ch3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rstn_ch3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rstn_ch3


  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_tx_axis_rstn_ch3/Din]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_rx_axis_rstn_ch3/Din]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins xlslice_tx_axis_rstn_ch3/Dout] \
  [get_bd_pins tx_axis_rstn_out]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins xlslice_rx_axis_rstn_ch3/Dout] \
  [get_bd_pins rx_axis_rstn_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_rst_slice_hier_ch2
proc create_hier_cell_clk_rst_slice_hier_ch2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst_slice_hier_ch2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rstn_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rstn_out

  # Create instance: xlslice_rx_axis_rstn_ch2, and set properties
  set xlslice_rx_axis_rstn_ch2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rstn_ch2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
  ] $xlslice_rx_axis_rstn_ch2


  # Create instance: xlslice_tx_axis_rstn_ch2, and set properties
  set xlslice_tx_axis_rstn_ch2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rstn_ch2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rstn_ch2


  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_tx_axis_rstn_ch2/Din]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_rx_axis_rstn_ch2/Din]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins xlslice_tx_axis_rstn_ch2/Dout] \
  [get_bd_pins tx_axis_rstn_out]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins xlslice_rx_axis_rstn_ch2/Dout] \
  [get_bd_pins rx_axis_rstn_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_rst_slice_hier_ch1
proc create_hier_cell_clk_rst_slice_hier_ch1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst_slice_hier_ch1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rstn_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rstn_out

  # Create instance: xlslice_rx_axis_rstn_ch1, and set properties
  set xlslice_rx_axis_rstn_ch1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rstn_ch1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_axis_rstn_ch1


  # Create instance: xlslice_tx_axis_rstn_ch1, and set properties
  set xlslice_tx_axis_rstn_ch1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rstn_ch1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_axis_rstn_ch1


  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_tx_axis_rstn_ch1/Din]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_rx_axis_rstn_ch1/Din]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins xlslice_tx_axis_rstn_ch1/Dout] \
  [get_bd_pins tx_axis_rstn_out]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins xlslice_rx_axis_rstn_ch1/Dout] \
  [get_bd_pins rx_axis_rstn_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_rst_slice_hier_ch0
proc create_hier_cell_clk_rst_slice_hier_ch0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clk_rst_slice_hier_ch0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 rx_axis_rstn_out
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 0 -to 0 tx_axis_rstn_out

  # Create instance: xlslice_rx_axis_rstn_ch0, and set properties
  set xlslice_rx_axis_rstn_ch0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_axis_rstn_ch0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_rx_axis_rstn_ch0


  # Create instance: xlslice_tx_axis_rstn_ch0, and set properties
  set xlslice_tx_axis_rstn_ch0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_axis_rstn_ch0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_axis_rstn_ch0


  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins xlslice_tx_axis_rstn_ch0/Din]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins xlslice_rx_axis_rstn_ch0/Din]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins xlslice_tx_axis_rstn_ch0/Dout] \
  [get_bd_pins tx_axis_rstn_out]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins xlslice_rx_axis_rstn_ch0/Dout] \
  [get_bd_pins rx_axis_rstn_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DATAPATH_MCDMA_3
proc create_hier_cell_DATAPATH_MCDMA_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DATAPATH_MCDMA_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi


  # Create pins
  create_bd_pin -dir I -type rst axis_rx_rstn
  create_bd_pin -dir I -type rst axis_tx_rstn
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O -from 15 -to 0 m_ptp_cf_offset_0
  create_bd_pin -dir O m_ptp_upd_chcksum_0
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir O -type intr mm2s_ch1_introut
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata0
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir O -type intr s2mm_ch1_introut
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I sel_10g_mode
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata0
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user0
  create_bd_pin -dir O tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I -from 31 -to 0 tx_tod_ns_0
  create_bd_pin -dir I -from 47 -to 0 tx_tod_sec_0

  # Create instance: RX_PTP_PKT_DETECT_on_0, and set properties
  set RX_PTP_PKT_DETECT_on_0 [ create_bd_cell -type ip -vlnv user.org:user:RX_PTP_PKT_DETECT_one_step:1.1 RX_PTP_PKT_DETECT_on_0 ]

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.2 axi_mcdma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {256} \
    CONFIG.c_prmry_is_aclk_async {0} \
    CONFIG.c_s2mm_burst_size {256} \
    CONFIG.c_sg_include_stscntrl_strm {1} \
    CONFIG.c_sg_length_width {14} \
  ] $axi_mcdma_0


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_0


  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {8192} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_EMPTY {0} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {0} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.PROG_FULL_THRESH {5000} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_1


  # Create instance: axis_data_fifo_rx_0, and set properties
  set axis_data_fifo_rx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx_0 ]
  set_property -dict [list \
    CONFIG.ACLKEN_CONV_MODE {0} \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {1} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.PROG_FULL_THRESH {2900} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_rx_0


  # Create instance: axis_data_fifo_tx_0, and set properties
  set axis_data_fifo_tx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_tx_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_tx_0


  # Create instance: axis_data_fifo_tx_1, and set properties
  set axis_data_fifo_tx_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_tx_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {64} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_tx_1


  # Create instance: datapath_0_concat_tkeep, and set properties
  set datapath_0_concat_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 datapath_0_concat_tkeep ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {8} \
    CONFIG.IN1_WIDTH {3} \
  ] $datapath_0_concat_tkeep


  # Create instance: datapath_0_constant_tkeep, and set properties
  set datapath_0_constant_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 datapath_0_constant_tkeep ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {3} \
  ] $datapath_0_constant_tkeep


  # Create instance: datapath_0_slice_tkeep, and set properties
  set datapath_0_slice_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 datapath_0_slice_tkeep ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_WIDTH {11} \
    CONFIG.DOUT_WIDTH {8} \
  ] $datapath_0_slice_tkeep


  # Create instance: mrmac_10g_mux_0, and set properties
  set mrmac_10g_mux_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_10g_mux:1.0 mrmac_10g_mux_0 ]

  # Create instance: mrmac_ptp_one_step_p_0, and set properties
  set mrmac_ptp_one_step_p_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_ptp_one_step_pkt_edit:1.0 mrmac_ptp_one_step_p_0 ]

  # Create instance: ptp_logic
  create_hier_cell_ptp_logic_3 $hier_obj ptp_logic

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_4


  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_5 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_5


  # Create instance: util_vector_logic_6, and set properties
  set util_vector_logic_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_6 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_6


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {32} \
    CONFIG.IN1_WIDTH {48} \
  ] $xlconcat_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m00_axi] [get_bd_intf_pins ptp_logic/m00_axi]
  connect_bd_intf_net -intf_net RX_PTP_PKT_DETECT_TS_0_m_axis [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM] [get_bd_intf_pins ptp_logic/m_axis]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_CNTRL [get_bd_intf_pins axi_mcdma_0/M_AXIS_CNTRL] [get_bd_intf_pins ptp_logic/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_tx_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_mcdma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net axis_data_fifo_tx_0_M_AXIS [get_bd_intf_pins axis_data_fifo_tx_0/M_AXIS] [get_bd_intf_pins mrmac_10g_mux_0/tx_s_axis]
  connect_bd_intf_net -intf_net hw_master_top_0_m_axis_sts [get_bd_intf_pins axi_mcdma_0/S_AXIS_STS] [get_bd_intf_pins ptp_logic/m_axis_sts]
  connect_bd_intf_net -intf_net ptp_logic_m_axis_1step [get_bd_intf_pins axis_data_fifo_tx_1/S_AXIS] [get_bd_intf_pins ptp_logic/m_axis_1step]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_fifo_deassert  [get_bd_pins RX_PTP_PKT_DETECT_on_0/fifo_deassert] \
  [get_bd_pins util_vector_logic_4/Op2] \
  [get_bd_pins util_vector_logic_5/Op2] \
  [get_bd_pins util_vector_logic_6/Op2]
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_wr_data  [get_bd_pins RX_PTP_PKT_DETECT_on_0/wr_data] \
  [get_bd_pins ptp_logic/din]
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_wr_en  [get_bd_pins RX_PTP_PKT_DETECT_on_0/wr_en] \
  [get_bd_pins ptp_logic/wr_en]
  connect_bd_net -net axi_mcdma_0_mm2s_ch1_introut  [get_bd_pins axi_mcdma_0/mm2s_ch1_introut] \
  [get_bd_pins mm2s_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s2mm_ch1_introut  [get_bd_pins axi_mcdma_0/s2mm_ch1_introut] \
  [get_bd_pins s2mm_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready  [get_bd_pins ptp_logic/m_axis_s2mm_tready] \
  [get_bd_pins axis_data_fifo_rx_0/m_axis_tready]
  connect_bd_net -net axis_clock_converter_0_m_axis_tvalid  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tvalid] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tvalid_mux] \
  [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net axis_data_fifo_0_m_axis_tdata  [get_bd_pins axis_data_fifo_0/m_axis_tdata] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tdata]
  connect_bd_net -net axis_data_fifo_0_m_axis_tkeep  [get_bd_pins axis_data_fifo_0/m_axis_tkeep] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tkeep]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins axis_data_fifo_0/m_axis_tlast] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tlast] \
  [get_bd_pins ptp_logic/tx_axis_tlast_0]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins axis_data_fifo_0/m_axis_tvalid] \
  [get_bd_pins ptp_logic/s_axis_mm2s_tvalid]
  connect_bd_net -net axis_data_fifo_0_s_axis_tready  [get_bd_pins axis_data_fifo_0/s_axis_tready] \
  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tready]
  connect_bd_net -net axis_data_fifo_1_m_axis_tdata  [get_bd_pins axis_data_fifo_1/m_axis_tdata] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tdata]
  connect_bd_net -net axis_data_fifo_1_m_axis_tkeep  [get_bd_pins axis_data_fifo_1/m_axis_tkeep] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_1_m_axis_tlast  [get_bd_pins axis_data_fifo_1/m_axis_tlast] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tlast]
  connect_bd_net -net axis_data_fifo_1_m_axis_tvalid  [get_bd_pins axis_data_fifo_1/m_axis_tvalid] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tvalid]
  connect_bd_net -net axis_data_fifo_1_prog_full  [get_bd_pins axis_data_fifo_1/prog_full] \
  [get_bd_pins ptp_logic/fifo_full]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tdata  [get_bd_pins axis_data_fifo_rx_0/m_axis_tdata] \
  [get_bd_pins ptp_logic/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tkeep  [get_bd_pins axis_data_fifo_rx_0/m_axis_tkeep] \
  [get_bd_pins ptp_logic/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tlast  [get_bd_pins axis_data_fifo_rx_0/m_axis_tlast] \
  [get_bd_pins ptp_logic/s_axis_s2mm_tlast]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tvalid  [get_bd_pins axis_data_fifo_rx_0/m_axis_tvalid] \
  [get_bd_pins ptp_logic/s_axis_s2mm_tvalid]
  connect_bd_net -net axis_data_fifo_rx_0_prog_full  [get_bd_pins axis_data_fifo_rx_0/prog_full] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/fifo_full]
  connect_bd_net -net axis_data_fifo_rx_0_s_axis_tready  [get_bd_pins axis_data_fifo_rx_0/s_axis_tready] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tready] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tready_fifo] \
  [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tdata  [get_bd_pins axis_data_fifo_tx_1/m_axis_tdata] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tdata_0]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tkeep  [get_bd_pins axis_data_fifo_tx_1/m_axis_tkeep] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tkeep_0]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tlast  [get_bd_pins axis_data_fifo_tx_1/m_axis_tlast] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tlast_0] \
  [get_bd_pins ptp_logic/cmd_tlast]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tvalid  [get_bd_pins axis_data_fifo_tx_1/m_axis_tvalid] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tvalid_0] \
  [get_bd_pins ptp_logic/cmd_tvalid]
  connect_bd_net -net datapath_0_slice_tkeep_Dout  [get_bd_pins datapath_0_slice_tkeep/Dout] \
  [get_bd_pins axis_data_fifo_1/s_axis_tkeep]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_systemtimerin_cf] \
  [get_bd_pins ptp_logic/din_0]
  connect_bd_net -net hw_master_top_0_interrupt  [get_bd_pins ptp_logic/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net m_axis_aresetn1_1  [get_bd_pins axis_tx_rstn] \
  [get_bd_pins axis_data_fifo_0/s_axis_aresetn] \
  [get_bd_pins axis_data_fifo_tx_1/s_axis_aresetn] \
  [get_bd_pins mrmac_10g_mux_0/tx_s_aresetn]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/rx_axis_clk_in] \
  [get_bd_pins mrmac_ptp_one_step_p_0/clk] \
  [get_bd_pins ptp_logic/mcdma_clk] \
  [get_bd_pins axi_mcdma_0/s_axi_aclk] \
  [get_bd_pins axis_data_fifo_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_1/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_tx_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_tx_1/s_axis_aclk] \
  [get_bd_pins mrmac_10g_mux_0/tx_s_aclk] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins ptp_logic/mcdma_resetn] \
  [get_bd_pins axis_data_fifo_tx_0/s_axis_aresetn] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user0  [get_bd_pins rx_axis_tkeep_user0] \
  [get_bd_pins datapath_0_slice_tkeep/Din]
  connect_bd_net -net mrmac_10g_mux_0_rx_m_axis_tdata  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tdata] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tdata] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tdata]
  connect_bd_net -net mrmac_10g_mux_0_rx_m_axis_tkeep  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tkeep] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tkeep] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tkeep]
  connect_bd_net -net mrmac_10g_mux_0_rx_s_axis_tready  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tready] \
  [get_bd_pins axis_data_fifo_1/m_axis_tready]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tdata  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tdata] \
  [get_bd_pins axis_data_fifo_0/s_axis_tdata]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tkeep  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tkeep] \
  [get_bd_pins axis_data_fifo_0/s_axis_tkeep]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tlast  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tlast] \
  [get_bd_pins axis_data_fifo_0/s_axis_tlast]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tvalid  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tvalid] \
  [get_bd_pins axis_data_fifo_0/s_axis_tvalid]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_cf_offset  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_cf_offset] \
  [get_bd_pins m_ptp_cf_offset_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_tag  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_tag] \
  [get_bd_pins tx_ptp_tstamp_tag_out]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_upd_chcksum  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_upd_chcksum] \
  [get_bd_pins m_ptp_upd_chcksum_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tdata1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tdata] \
  [get_bd_pins tx_axis_tdata0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tkeep1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tkeep] \
  [get_bd_pins datapath_0_concat_tkeep/In0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tlast1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tlast] \
  [get_bd_pins tx_axis_tlast_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tvalid1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tvalid] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_s_cmd_tready_0  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tready_0] \
  [get_bd_pins ptp_logic/cmd_tready] \
  [get_bd_pins axis_data_fifo_tx_1/m_axis_tready]
  connect_bd_net -net mrmac_ptp_one_step_p_0_s_tready1  [get_bd_pins mrmac_ptp_one_step_p_0/s_tready] \
  [get_bd_pins ptp_logic/tx_axis_tready_0]
  connect_bd_net -net ptp_logic_Res2  [get_bd_pins ptp_logic/Res2] \
  [get_bd_pins axis_data_fifo_1/s_axis_tvalid]
  connect_bd_net -net ptp_logic_tx_axis_tvalid_0  [get_bd_pins ptp_logic/tx_axis_tvalid_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tvalid]
  connect_bd_net -net ptp_logic_tx_ptp_1588op_in  [get_bd_pins ptp_logic/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net rx_axis_tdata0_1  [get_bd_pins rx_axis_tdata0] \
  [get_bd_pins axis_data_fifo_1/s_axis_tdata]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins ptp_logic/mrmac_tlast] \
  [get_bd_pins axis_data_fifo_1/s_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins ptp_logic/rx_axis_tvalid_0]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins ptp_logic/rx_timestamp_tod]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins ptp_logic/rx_timestamp_tod_valid]
  connect_bd_net -net s_axis_aresetn1_1  [get_bd_pins axis_rx_rstn] \
  [get_bd_pins ptp_logic/axis_rx_rstn]
  connect_bd_net -net s_axis_aresetn_1  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axi_mcdma_0/axi_resetn]
  connect_bd_net -net s_axis_tlast_2  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tlast] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tlast_mux] \
  [get_bd_pins util_vector_logic_6/Op1]
  connect_bd_net -net sel_10g_mode_1  [get_bd_pins sel_10g_mode] \
  [get_bd_pins mrmac_10g_mux_0/sel_10g_mode]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/m_tready]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins ptp_logic/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins ptp_logic/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins ptp_logic/tx_timestamp_tod_valid]
  connect_bd_net -net tx_tod_ns_0_1  [get_bd_pins tx_tod_ns_0] \
  [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net tx_tod_sec_0_1  [get_bd_pins tx_tod_sec_0] \
  [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins ptp_logic/Res1] \
  [get_bd_pins axis_data_fifo_0/m_axis_tready]
  connect_bd_net -net util_vector_logic_0_Res1  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins mrmac_ptp_one_step_p_0/rst]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins ptp_logic/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/rx_axis_reset_in] \
  [get_bd_pins axis_data_fifo_1/s_axis_aresetn] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_aresetn] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_aresetn]
  connect_bd_net -net util_vector_logic_4_Res  [get_bd_pins util_vector_logic_4/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tvalid] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tvalid]
  connect_bd_net -net util_vector_logic_5_Res  [get_bd_pins util_vector_logic_5/Res] \
  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tready]
  connect_bd_net -net util_vector_logic_6_Res  [get_bd_pins util_vector_logic_6/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tlast] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tlast]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_lite_aclk] \
  [get_bd_pins axi_mcdma_0/s_axi_lite_aclk]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins datapath_0_concat_tkeep/dout] \
  [get_bd_pins tx_axis_tkeep_user0]
  connect_bd_net -net xlconcat_0_dout1  [get_bd_pins xlconcat_0/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_systemtimerin_ts]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_terr]
  connect_bd_net -net xlconstant_1_dout  [get_bd_pins datapath_0_constant_tkeep/dout] \
  [get_bd_pins datapath_0_concat_tkeep/In1]
  connect_bd_net -net xlconstant_1_dout1  [get_bd_pins xlconstant_1/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_data_rate] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_ptp_1step_enable]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DATAPATH_MCDMA_2
proc create_hier_cell_DATAPATH_MCDMA_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DATAPATH_MCDMA_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi


  # Create pins
  create_bd_pin -dir I -type rst axis_rx_rstn
  create_bd_pin -dir I -type rst axis_tx_rstn
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O -from 15 -to 0 m_ptp_cf_offset_0
  create_bd_pin -dir O m_ptp_upd_chcksum_0
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir O -type intr mm2s_ch1_introut
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata0
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir O -type intr s2mm_ch1_introut
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I sel_10g_mode
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata0
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user0
  create_bd_pin -dir O tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I -from 31 -to 0 tx_tod_ns_0
  create_bd_pin -dir I -from 47 -to 0 tx_tod_sec_0

  # Create instance: RX_PTP_PKT_DETECT_on_0, and set properties
  set RX_PTP_PKT_DETECT_on_0 [ create_bd_cell -type ip -vlnv user.org:user:RX_PTP_PKT_DETECT_one_step:1.1 RX_PTP_PKT_DETECT_on_0 ]

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.2 axi_mcdma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {256} \
    CONFIG.c_prmry_is_aclk_async {0} \
    CONFIG.c_s2mm_burst_size {256} \
    CONFIG.c_sg_include_stscntrl_strm {1} \
    CONFIG.c_sg_length_width {14} \
  ] $axi_mcdma_0


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_0


  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {8192} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_EMPTY {0} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {0} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.PROG_FULL_THRESH {5000} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_1


  # Create instance: axis_data_fifo_rx_0, and set properties
  set axis_data_fifo_rx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx_0 ]
  set_property -dict [list \
    CONFIG.ACLKEN_CONV_MODE {0} \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {1} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.PROG_FULL_THRESH {2900} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_rx_0


  # Create instance: axis_data_fifo_tx_0, and set properties
  set axis_data_fifo_tx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_tx_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_tx_0


  # Create instance: axis_data_fifo_tx_1, and set properties
  set axis_data_fifo_tx_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_tx_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {64} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_tx_1


  # Create instance: datapath_0_concat_tkeep, and set properties
  set datapath_0_concat_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 datapath_0_concat_tkeep ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {8} \
    CONFIG.IN1_WIDTH {3} \
  ] $datapath_0_concat_tkeep


  # Create instance: datapath_0_constant_tkeep, and set properties
  set datapath_0_constant_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 datapath_0_constant_tkeep ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {3} \
  ] $datapath_0_constant_tkeep


  # Create instance: datapath_0_slice_tkeep, and set properties
  set datapath_0_slice_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 datapath_0_slice_tkeep ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_WIDTH {11} \
    CONFIG.DOUT_WIDTH {8} \
  ] $datapath_0_slice_tkeep


  # Create instance: mrmac_10g_mux_0, and set properties
  set mrmac_10g_mux_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_10g_mux:1.0 mrmac_10g_mux_0 ]

  # Create instance: mrmac_ptp_one_step_p_0, and set properties
  set mrmac_ptp_one_step_p_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_ptp_one_step_pkt_edit:1.0 mrmac_ptp_one_step_p_0 ]

  # Create instance: ptp_logic
  create_hier_cell_ptp_logic_2 $hier_obj ptp_logic

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_4


  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_5 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_5


  # Create instance: util_vector_logic_6, and set properties
  set util_vector_logic_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_6 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_6


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {32} \
    CONFIG.IN1_WIDTH {48} \
  ] $xlconcat_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m00_axi] [get_bd_intf_pins ptp_logic/m00_axi]
  connect_bd_intf_net -intf_net RX_PTP_PKT_DETECT_TS_0_m_axis [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM] [get_bd_intf_pins ptp_logic/m_axis]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_CNTRL [get_bd_intf_pins axi_mcdma_0/M_AXIS_CNTRL] [get_bd_intf_pins ptp_logic/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_tx_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_mcdma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net axis_data_fifo_tx_0_M_AXIS [get_bd_intf_pins axis_data_fifo_tx_0/M_AXIS] [get_bd_intf_pins mrmac_10g_mux_0/tx_s_axis]
  connect_bd_intf_net -intf_net hw_master_top_0_m_axis_sts [get_bd_intf_pins axi_mcdma_0/S_AXIS_STS] [get_bd_intf_pins ptp_logic/m_axis_sts]
  connect_bd_intf_net -intf_net ptp_logic_m_axis_1step [get_bd_intf_pins axis_data_fifo_tx_1/S_AXIS] [get_bd_intf_pins ptp_logic/m_axis_1step]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_fifo_deassert  [get_bd_pins RX_PTP_PKT_DETECT_on_0/fifo_deassert] \
  [get_bd_pins util_vector_logic_4/Op2] \
  [get_bd_pins util_vector_logic_5/Op2] \
  [get_bd_pins util_vector_logic_6/Op2]
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_wr_data  [get_bd_pins RX_PTP_PKT_DETECT_on_0/wr_data] \
  [get_bd_pins ptp_logic/din]
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_wr_en  [get_bd_pins RX_PTP_PKT_DETECT_on_0/wr_en] \
  [get_bd_pins ptp_logic/wr_en]
  connect_bd_net -net axi_mcdma_0_mm2s_ch1_introut  [get_bd_pins axi_mcdma_0/mm2s_ch1_introut] \
  [get_bd_pins mm2s_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s2mm_ch1_introut  [get_bd_pins axi_mcdma_0/s2mm_ch1_introut] \
  [get_bd_pins s2mm_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready  [get_bd_pins ptp_logic/m_axis_s2mm_tready] \
  [get_bd_pins axis_data_fifo_rx_0/m_axis_tready]
  connect_bd_net -net axis_clock_converter_0_m_axis_tvalid  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tvalid] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tvalid_mux] \
  [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net axis_data_fifo_0_m_axis_tdata  [get_bd_pins axis_data_fifo_0/m_axis_tdata] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tdata]
  connect_bd_net -net axis_data_fifo_0_m_axis_tkeep  [get_bd_pins axis_data_fifo_0/m_axis_tkeep] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tkeep]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins axis_data_fifo_0/m_axis_tlast] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tlast] \
  [get_bd_pins ptp_logic/tx_axis_tlast_0]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins axis_data_fifo_0/m_axis_tvalid] \
  [get_bd_pins ptp_logic/s_axis_mm2s_tvalid]
  connect_bd_net -net axis_data_fifo_0_s_axis_tready  [get_bd_pins axis_data_fifo_0/s_axis_tready] \
  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tready]
  connect_bd_net -net axis_data_fifo_1_m_axis_tdata  [get_bd_pins axis_data_fifo_1/m_axis_tdata] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tdata]
  connect_bd_net -net axis_data_fifo_1_m_axis_tkeep  [get_bd_pins axis_data_fifo_1/m_axis_tkeep] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_1_m_axis_tlast  [get_bd_pins axis_data_fifo_1/m_axis_tlast] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tlast]
  connect_bd_net -net axis_data_fifo_1_m_axis_tvalid  [get_bd_pins axis_data_fifo_1/m_axis_tvalid] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tvalid]
  connect_bd_net -net axis_data_fifo_1_prog_full  [get_bd_pins axis_data_fifo_1/prog_full] \
  [get_bd_pins ptp_logic/fifo_full]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tdata  [get_bd_pins axis_data_fifo_rx_0/m_axis_tdata] \
  [get_bd_pins ptp_logic/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tkeep  [get_bd_pins axis_data_fifo_rx_0/m_axis_tkeep] \
  [get_bd_pins ptp_logic/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tlast  [get_bd_pins axis_data_fifo_rx_0/m_axis_tlast] \
  [get_bd_pins ptp_logic/s_axis_s2mm_tlast]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tvalid  [get_bd_pins axis_data_fifo_rx_0/m_axis_tvalid] \
  [get_bd_pins ptp_logic/s_axis_s2mm_tvalid]
  connect_bd_net -net axis_data_fifo_rx_0_prog_full  [get_bd_pins axis_data_fifo_rx_0/prog_full] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/fifo_full]
  connect_bd_net -net axis_data_fifo_rx_0_s_axis_tready  [get_bd_pins axis_data_fifo_rx_0/s_axis_tready] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tready] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tready_fifo] \
  [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tdata  [get_bd_pins axis_data_fifo_tx_1/m_axis_tdata] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tdata_0]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tkeep  [get_bd_pins axis_data_fifo_tx_1/m_axis_tkeep] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tkeep_0]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tlast  [get_bd_pins axis_data_fifo_tx_1/m_axis_tlast] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tlast_0] \
  [get_bd_pins ptp_logic/cmd_tlast]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tvalid  [get_bd_pins axis_data_fifo_tx_1/m_axis_tvalid] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tvalid_0] \
  [get_bd_pins ptp_logic/cmd_tvalid]
  connect_bd_net -net datapath_0_slice_tkeep_Dout  [get_bd_pins datapath_0_slice_tkeep/Dout] \
  [get_bd_pins axis_data_fifo_1/s_axis_tkeep]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_systemtimerin_cf] \
  [get_bd_pins ptp_logic/din_0]
  connect_bd_net -net hw_master_top_0_interrupt  [get_bd_pins ptp_logic/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net m_axis_aresetn1_1  [get_bd_pins axis_tx_rstn] \
  [get_bd_pins axis_data_fifo_0/s_axis_aresetn] \
  [get_bd_pins axis_data_fifo_tx_1/s_axis_aresetn] \
  [get_bd_pins mrmac_10g_mux_0/tx_s_aresetn]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/rx_axis_clk_in] \
  [get_bd_pins mrmac_ptp_one_step_p_0/clk] \
  [get_bd_pins ptp_logic/mcdma_clk] \
  [get_bd_pins axi_mcdma_0/s_axi_aclk] \
  [get_bd_pins axis_data_fifo_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_1/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_tx_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_tx_1/s_axis_aclk] \
  [get_bd_pins mrmac_10g_mux_0/tx_s_aclk] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins ptp_logic/mcdma_resetn] \
  [get_bd_pins axis_data_fifo_tx_0/s_axis_aresetn] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user0  [get_bd_pins rx_axis_tkeep_user0] \
  [get_bd_pins datapath_0_slice_tkeep/Din]
  connect_bd_net -net mrmac_10g_mux_0_rx_m_axis_tdata  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tdata] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tdata] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tdata]
  connect_bd_net -net mrmac_10g_mux_0_rx_m_axis_tkeep  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tkeep] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tkeep] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tkeep]
  connect_bd_net -net mrmac_10g_mux_0_rx_s_axis_tready  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tready] \
  [get_bd_pins axis_data_fifo_1/m_axis_tready]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tdata  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tdata] \
  [get_bd_pins axis_data_fifo_0/s_axis_tdata]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tkeep  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tkeep] \
  [get_bd_pins axis_data_fifo_0/s_axis_tkeep]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tlast  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tlast] \
  [get_bd_pins axis_data_fifo_0/s_axis_tlast]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tvalid  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tvalid] \
  [get_bd_pins axis_data_fifo_0/s_axis_tvalid]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_cf_offset  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_cf_offset] \
  [get_bd_pins m_ptp_cf_offset_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_tag  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_tag] \
  [get_bd_pins tx_ptp_tstamp_tag_out]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_upd_chcksum  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_upd_chcksum] \
  [get_bd_pins m_ptp_upd_chcksum_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tdata1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tdata] \
  [get_bd_pins tx_axis_tdata0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tkeep1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tkeep] \
  [get_bd_pins datapath_0_concat_tkeep/In0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tlast1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tlast] \
  [get_bd_pins tx_axis_tlast_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tvalid1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tvalid] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_s_cmd_tready_0  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tready_0] \
  [get_bd_pins ptp_logic/cmd_tready] \
  [get_bd_pins axis_data_fifo_tx_1/m_axis_tready]
  connect_bd_net -net mrmac_ptp_one_step_p_0_s_tready1  [get_bd_pins mrmac_ptp_one_step_p_0/s_tready] \
  [get_bd_pins ptp_logic/tx_axis_tready_0]
  connect_bd_net -net ptp_logic_Res2  [get_bd_pins ptp_logic/Res2] \
  [get_bd_pins axis_data_fifo_1/s_axis_tvalid]
  connect_bd_net -net ptp_logic_tx_axis_tvalid_0  [get_bd_pins ptp_logic/tx_axis_tvalid_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tvalid]
  connect_bd_net -net ptp_logic_tx_ptp_1588op_in  [get_bd_pins ptp_logic/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net rx_axis_tdata0_1  [get_bd_pins rx_axis_tdata0] \
  [get_bd_pins axis_data_fifo_1/s_axis_tdata]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins ptp_logic/mrmac_tlast] \
  [get_bd_pins axis_data_fifo_1/s_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins ptp_logic/rx_axis_tvalid_0]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins ptp_logic/rx_timestamp_tod]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins ptp_logic/rx_timestamp_tod_valid]
  connect_bd_net -net s_axis_aresetn1_1  [get_bd_pins axis_rx_rstn] \
  [get_bd_pins ptp_logic/axis_rx_rstn]
  connect_bd_net -net s_axis_aresetn_1  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axi_mcdma_0/axi_resetn]
  connect_bd_net -net s_axis_tlast_2  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tlast] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tlast_mux] \
  [get_bd_pins util_vector_logic_6/Op1]
  connect_bd_net -net sel_10g_mode_1  [get_bd_pins sel_10g_mode] \
  [get_bd_pins mrmac_10g_mux_0/sel_10g_mode]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/m_tready]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins ptp_logic/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins ptp_logic/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins ptp_logic/tx_timestamp_tod_valid]
  connect_bd_net -net tx_tod_ns_0_1  [get_bd_pins tx_tod_ns_0] \
  [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net tx_tod_sec_0_1  [get_bd_pins tx_tod_sec_0] \
  [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins ptp_logic/Res1] \
  [get_bd_pins axis_data_fifo_0/m_axis_tready]
  connect_bd_net -net util_vector_logic_0_Res1  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins mrmac_ptp_one_step_p_0/rst]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins ptp_logic/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/rx_axis_reset_in] \
  [get_bd_pins axis_data_fifo_1/s_axis_aresetn] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_aresetn] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_aresetn]
  connect_bd_net -net util_vector_logic_4_Res  [get_bd_pins util_vector_logic_4/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tvalid] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tvalid]
  connect_bd_net -net util_vector_logic_5_Res  [get_bd_pins util_vector_logic_5/Res] \
  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tready]
  connect_bd_net -net util_vector_logic_6_Res  [get_bd_pins util_vector_logic_6/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tlast] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tlast]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_lite_aclk] \
  [get_bd_pins axi_mcdma_0/s_axi_lite_aclk]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins datapath_0_concat_tkeep/dout] \
  [get_bd_pins tx_axis_tkeep_user0]
  connect_bd_net -net xlconcat_0_dout1  [get_bd_pins xlconcat_0/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_systemtimerin_ts]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_terr]
  connect_bd_net -net xlconstant_1_dout  [get_bd_pins datapath_0_constant_tkeep/dout] \
  [get_bd_pins datapath_0_concat_tkeep/In1]
  connect_bd_net -net xlconstant_1_dout1  [get_bd_pins xlconstant_1/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_data_rate] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_ptp_1step_enable]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DATAPATH_MCDMA_1
proc create_hier_cell_DATAPATH_MCDMA_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DATAPATH_MCDMA_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi


  # Create pins
  create_bd_pin -dir I -type rst axis_rx_rstn
  create_bd_pin -dir I -type rst axis_tx_rstn
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O -from 15 -to 0 m_ptp_cf_offset_0
  create_bd_pin -dir O m_ptp_upd_chcksum_0
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir O -type intr mm2s_ch1_introut
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata0
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir O -type intr s2mm_ch1_introut
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I sel_10g_mode
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata0
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user0
  create_bd_pin -dir O tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I -from 31 -to 0 tx_tod_ns_0
  create_bd_pin -dir I -from 47 -to 0 tx_tod_sec_0

  # Create instance: RX_PTP_PKT_DETECT_on_0, and set properties
  set RX_PTP_PKT_DETECT_on_0 [ create_bd_cell -type ip -vlnv user.org:user:RX_PTP_PKT_DETECT_one_step:1.1 RX_PTP_PKT_DETECT_on_0 ]

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.2 axi_mcdma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {256} \
    CONFIG.c_prmry_is_aclk_async {0} \
    CONFIG.c_s2mm_burst_size {256} \
    CONFIG.c_sg_include_stscntrl_strm {1} \
    CONFIG.c_sg_length_width {14} \
  ] $axi_mcdma_0


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_0


  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {8192} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_EMPTY {0} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {0} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.PROG_FULL_THRESH {5000} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_1


  # Create instance: axis_data_fifo_rx_0, and set properties
  set axis_data_fifo_rx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx_0 ]
  set_property -dict [list \
    CONFIG.ACLKEN_CONV_MODE {0} \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {1} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.PROG_FULL_THRESH {2900} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_rx_0


  # Create instance: axis_data_fifo_tx_0, and set properties
  set axis_data_fifo_tx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_tx_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_tx_0


  # Create instance: axis_data_fifo_tx_1, and set properties
  set axis_data_fifo_tx_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_tx_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {64} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_tx_1


  # Create instance: datapath_0_concat_tkeep, and set properties
  set datapath_0_concat_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 datapath_0_concat_tkeep ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {8} \
    CONFIG.IN1_WIDTH {3} \
  ] $datapath_0_concat_tkeep


  # Create instance: datapath_0_constant_tkeep, and set properties
  set datapath_0_constant_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 datapath_0_constant_tkeep ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {3} \
  ] $datapath_0_constant_tkeep


  # Create instance: datapath_0_slice_tkeep, and set properties
  set datapath_0_slice_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 datapath_0_slice_tkeep ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_WIDTH {11} \
    CONFIG.DOUT_WIDTH {8} \
  ] $datapath_0_slice_tkeep


  # Create instance: mrmac_10g_mux_0, and set properties
  set mrmac_10g_mux_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_10g_mux:1.0 mrmac_10g_mux_0 ]

  # Create instance: mrmac_ptp_one_step_p_0, and set properties
  set mrmac_ptp_one_step_p_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_ptp_one_step_pkt_edit:1.0 mrmac_ptp_one_step_p_0 ]

  # Create instance: ptp_logic
  create_hier_cell_ptp_logic_1 $hier_obj ptp_logic

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_4


  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_5 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_5


  # Create instance: util_vector_logic_6, and set properties
  set util_vector_logic_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_6 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_6


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {32} \
    CONFIG.IN1_WIDTH {48} \
  ] $xlconcat_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m00_axi] [get_bd_intf_pins ptp_logic/m00_axi]
  connect_bd_intf_net -intf_net RX_PTP_PKT_DETECT_TS_0_m_axis [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM] [get_bd_intf_pins ptp_logic/m_axis]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_CNTRL [get_bd_intf_pins axi_mcdma_0/M_AXIS_CNTRL] [get_bd_intf_pins ptp_logic/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_tx_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_mcdma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net axis_data_fifo_tx_0_M_AXIS [get_bd_intf_pins axis_data_fifo_tx_0/M_AXIS] [get_bd_intf_pins mrmac_10g_mux_0/tx_s_axis]
  connect_bd_intf_net -intf_net hw_master_top_0_m_axis_sts [get_bd_intf_pins axi_mcdma_0/S_AXIS_STS] [get_bd_intf_pins ptp_logic/m_axis_sts]
  connect_bd_intf_net -intf_net ptp_logic_m_axis_1step [get_bd_intf_pins axis_data_fifo_tx_1/S_AXIS] [get_bd_intf_pins ptp_logic/m_axis_1step]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_fifo_deassert  [get_bd_pins RX_PTP_PKT_DETECT_on_0/fifo_deassert] \
  [get_bd_pins util_vector_logic_4/Op2] \
  [get_bd_pins util_vector_logic_5/Op2] \
  [get_bd_pins util_vector_logic_6/Op2]
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_wr_data  [get_bd_pins RX_PTP_PKT_DETECT_on_0/wr_data] \
  [get_bd_pins ptp_logic/din]
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_wr_en  [get_bd_pins RX_PTP_PKT_DETECT_on_0/wr_en] \
  [get_bd_pins ptp_logic/wr_en]
  connect_bd_net -net axi_mcdma_0_mm2s_ch1_introut  [get_bd_pins axi_mcdma_0/mm2s_ch1_introut] \
  [get_bd_pins mm2s_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s2mm_ch1_introut  [get_bd_pins axi_mcdma_0/s2mm_ch1_introut] \
  [get_bd_pins s2mm_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready  [get_bd_pins ptp_logic/m_axis_s2mm_tready] \
  [get_bd_pins axis_data_fifo_rx_0/m_axis_tready]
  connect_bd_net -net axis_clock_converter_0_m_axis_tvalid  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tvalid] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tvalid_mux] \
  [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net axis_data_fifo_0_m_axis_tdata  [get_bd_pins axis_data_fifo_0/m_axis_tdata] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tdata]
  connect_bd_net -net axis_data_fifo_0_m_axis_tkeep  [get_bd_pins axis_data_fifo_0/m_axis_tkeep] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tkeep]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins axis_data_fifo_0/m_axis_tlast] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tlast] \
  [get_bd_pins ptp_logic/tx_axis_tlast_0]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins axis_data_fifo_0/m_axis_tvalid] \
  [get_bd_pins ptp_logic/s_axis_mm2s_tvalid]
  connect_bd_net -net axis_data_fifo_0_s_axis_tready  [get_bd_pins axis_data_fifo_0/s_axis_tready] \
  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tready]
  connect_bd_net -net axis_data_fifo_1_m_axis_tdata  [get_bd_pins axis_data_fifo_1/m_axis_tdata] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tdata]
  connect_bd_net -net axis_data_fifo_1_m_axis_tkeep  [get_bd_pins axis_data_fifo_1/m_axis_tkeep] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_1_m_axis_tlast  [get_bd_pins axis_data_fifo_1/m_axis_tlast] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tlast]
  connect_bd_net -net axis_data_fifo_1_m_axis_tvalid  [get_bd_pins axis_data_fifo_1/m_axis_tvalid] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tvalid]
  connect_bd_net -net axis_data_fifo_1_prog_full  [get_bd_pins axis_data_fifo_1/prog_full] \
  [get_bd_pins ptp_logic/fifo_full]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tdata  [get_bd_pins axis_data_fifo_rx_0/m_axis_tdata] \
  [get_bd_pins ptp_logic/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tkeep  [get_bd_pins axis_data_fifo_rx_0/m_axis_tkeep] \
  [get_bd_pins ptp_logic/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tlast  [get_bd_pins axis_data_fifo_rx_0/m_axis_tlast] \
  [get_bd_pins ptp_logic/s_axis_s2mm_tlast]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tvalid  [get_bd_pins axis_data_fifo_rx_0/m_axis_tvalid] \
  [get_bd_pins ptp_logic/s_axis_s2mm_tvalid]
  connect_bd_net -net axis_data_fifo_rx_0_prog_full  [get_bd_pins axis_data_fifo_rx_0/prog_full] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/fifo_full]
  connect_bd_net -net axis_data_fifo_rx_0_s_axis_tready  [get_bd_pins axis_data_fifo_rx_0/s_axis_tready] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tready] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tready_fifo] \
  [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tdata  [get_bd_pins axis_data_fifo_tx_1/m_axis_tdata] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tdata_0]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tkeep  [get_bd_pins axis_data_fifo_tx_1/m_axis_tkeep] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tkeep_0]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tlast  [get_bd_pins axis_data_fifo_tx_1/m_axis_tlast] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tlast_0] \
  [get_bd_pins ptp_logic/cmd_tlast]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tvalid  [get_bd_pins axis_data_fifo_tx_1/m_axis_tvalid] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tvalid_0] \
  [get_bd_pins ptp_logic/cmd_tvalid]
  connect_bd_net -net datapath_0_slice_tkeep_Dout  [get_bd_pins datapath_0_slice_tkeep/Dout] \
  [get_bd_pins axis_data_fifo_1/s_axis_tkeep]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_systemtimerin_cf] \
  [get_bd_pins ptp_logic/din_0]
  connect_bd_net -net hw_master_top_0_interrupt  [get_bd_pins ptp_logic/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net m_axis_aresetn1_1  [get_bd_pins axis_tx_rstn] \
  [get_bd_pins axis_data_fifo_0/s_axis_aresetn] \
  [get_bd_pins axis_data_fifo_tx_1/s_axis_aresetn] \
  [get_bd_pins mrmac_10g_mux_0/tx_s_aresetn]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/rx_axis_clk_in] \
  [get_bd_pins mrmac_ptp_one_step_p_0/clk] \
  [get_bd_pins ptp_logic/mcdma_clk] \
  [get_bd_pins axi_mcdma_0/s_axi_aclk] \
  [get_bd_pins axis_data_fifo_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_1/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_tx_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_tx_1/s_axis_aclk] \
  [get_bd_pins mrmac_10g_mux_0/tx_s_aclk] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins ptp_logic/mcdma_resetn] \
  [get_bd_pins axis_data_fifo_tx_0/s_axis_aresetn] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user0  [get_bd_pins rx_axis_tkeep_user0] \
  [get_bd_pins datapath_0_slice_tkeep/Din]
  connect_bd_net -net mrmac_10g_mux_0_rx_m_axis_tdata  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tdata] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tdata] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tdata]
  connect_bd_net -net mrmac_10g_mux_0_rx_m_axis_tkeep  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tkeep] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tkeep] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tkeep]
  connect_bd_net -net mrmac_10g_mux_0_rx_s_axis_tready  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tready] \
  [get_bd_pins axis_data_fifo_1/m_axis_tready]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tdata  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tdata] \
  [get_bd_pins axis_data_fifo_0/s_axis_tdata]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tkeep  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tkeep] \
  [get_bd_pins axis_data_fifo_0/s_axis_tkeep]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tlast  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tlast] \
  [get_bd_pins axis_data_fifo_0/s_axis_tlast]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tvalid  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tvalid] \
  [get_bd_pins axis_data_fifo_0/s_axis_tvalid]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_cf_offset  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_cf_offset] \
  [get_bd_pins m_ptp_cf_offset_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_tag  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_tag] \
  [get_bd_pins tx_ptp_tstamp_tag_out]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_upd_chcksum  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_upd_chcksum] \
  [get_bd_pins m_ptp_upd_chcksum_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tdata1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tdata] \
  [get_bd_pins tx_axis_tdata0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tkeep1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tkeep] \
  [get_bd_pins datapath_0_concat_tkeep/In0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tlast1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tlast] \
  [get_bd_pins tx_axis_tlast_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tvalid1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tvalid] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_s_cmd_tready_0  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tready_0] \
  [get_bd_pins ptp_logic/cmd_tready] \
  [get_bd_pins axis_data_fifo_tx_1/m_axis_tready]
  connect_bd_net -net mrmac_ptp_one_step_p_0_s_tready1  [get_bd_pins mrmac_ptp_one_step_p_0/s_tready] \
  [get_bd_pins ptp_logic/tx_axis_tready_0]
  connect_bd_net -net ptp_logic_Res2  [get_bd_pins ptp_logic/Res2] \
  [get_bd_pins axis_data_fifo_1/s_axis_tvalid]
  connect_bd_net -net ptp_logic_tx_axis_tvalid_0  [get_bd_pins ptp_logic/tx_axis_tvalid_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tvalid]
  connect_bd_net -net ptp_logic_tx_ptp_1588op_in  [get_bd_pins ptp_logic/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net rx_axis_tdata0_1  [get_bd_pins rx_axis_tdata0] \
  [get_bd_pins axis_data_fifo_1/s_axis_tdata]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins ptp_logic/mrmac_tlast] \
  [get_bd_pins axis_data_fifo_1/s_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins ptp_logic/rx_axis_tvalid_0]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins ptp_logic/rx_timestamp_tod]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins ptp_logic/rx_timestamp_tod_valid]
  connect_bd_net -net s_axis_aresetn1_1  [get_bd_pins axis_rx_rstn] \
  [get_bd_pins ptp_logic/axis_rx_rstn]
  connect_bd_net -net s_axis_aresetn_1  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axi_mcdma_0/axi_resetn]
  connect_bd_net -net s_axis_tlast_2  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tlast] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tlast_mux] \
  [get_bd_pins util_vector_logic_6/Op1]
  connect_bd_net -net sel_10g_mode_1  [get_bd_pins sel_10g_mode] \
  [get_bd_pins mrmac_10g_mux_0/sel_10g_mode]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/m_tready]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins ptp_logic/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins ptp_logic/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins ptp_logic/tx_timestamp_tod_valid]
  connect_bd_net -net tx_tod_ns_0_1  [get_bd_pins tx_tod_ns_0] \
  [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net tx_tod_sec_0_1  [get_bd_pins tx_tod_sec_0] \
  [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins ptp_logic/Res1] \
  [get_bd_pins axis_data_fifo_0/m_axis_tready]
  connect_bd_net -net util_vector_logic_0_Res1  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins mrmac_ptp_one_step_p_0/rst]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins ptp_logic/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/rx_axis_reset_in] \
  [get_bd_pins axis_data_fifo_1/s_axis_aresetn] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_aresetn] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_aresetn]
  connect_bd_net -net util_vector_logic_4_Res  [get_bd_pins util_vector_logic_4/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tvalid] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tvalid]
  connect_bd_net -net util_vector_logic_5_Res  [get_bd_pins util_vector_logic_5/Res] \
  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tready]
  connect_bd_net -net util_vector_logic_6_Res  [get_bd_pins util_vector_logic_6/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tlast] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tlast]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_lite_aclk] \
  [get_bd_pins axi_mcdma_0/s_axi_lite_aclk]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins datapath_0_concat_tkeep/dout] \
  [get_bd_pins tx_axis_tkeep_user0]
  connect_bd_net -net xlconcat_0_dout1  [get_bd_pins xlconcat_0/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_systemtimerin_ts]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_terr]
  connect_bd_net -net xlconstant_1_dout  [get_bd_pins datapath_0_constant_tkeep/dout] \
  [get_bd_pins datapath_0_concat_tkeep/In1]
  connect_bd_net -net xlconstant_1_dout1  [get_bd_pins xlconstant_1/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_data_rate] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_ptp_1step_enable]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DATAPATH_MCDMA_0
proc create_hier_cell_DATAPATH_MCDMA_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DATAPATH_MCDMA_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi


  # Create pins
  create_bd_pin -dir I -type rst axis_rx_rstn
  create_bd_pin -dir I -type rst axis_tx_rstn
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O -from 15 -to 0 m_ptp_cf_offset_0
  create_bd_pin -dir O m_ptp_upd_chcksum_0
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir O -type intr mm2s_ch1_introut
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata0
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user0
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir O -type intr s2mm_ch1_introut
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I sel_10g_mode
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata0
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user0
  create_bd_pin -dir O tx_axis_tlast_0
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I -from 31 -to 0 tx_tod_ns_0
  create_bd_pin -dir I -from 47 -to 0 tx_tod_sec_0

  # Create instance: RX_PTP_PKT_DETECT_on_0, and set properties
  set RX_PTP_PKT_DETECT_on_0 [ create_bd_cell -type ip -vlnv user.org:user:RX_PTP_PKT_DETECT_one_step:1.1 RX_PTP_PKT_DETECT_on_0 ]

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.2 axi_mcdma_0 ]
  set_property -dict [list \
    CONFIG.c_include_mm2s_dre {1} \
    CONFIG.c_include_s2mm_dre {1} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {256} \
    CONFIG.c_prmry_is_aclk_async {0} \
    CONFIG.c_s2mm_burst_size {256} \
    CONFIG.c_sg_include_stscntrl_strm {1} \
    CONFIG.c_sg_length_width {14} \
  ] $axi_mcdma_0


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_0


  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {8192} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_EMPTY {0} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {1} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.PROG_FULL_THRESH {5000} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_1


  # Create instance: axis_data_fifo_rx_0, and set properties
  set axis_data_fifo_rx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx_0 ]
  set_property -dict [list \
    CONFIG.ACLKEN_CONV_MODE {0} \
    CONFIG.FIFO_DEPTH {4096} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_PROG_FULL {1} \
    CONFIG.HAS_RD_DATA_COUNT {1} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.PROG_FULL_THRESH {2900} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_rx_0


  # Create instance: axis_data_fifo_tx_0, and set properties
  set axis_data_fifo_tx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_tx_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {2048} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.TDATA_NUM_BYTES {8} \
  ] $axis_data_fifo_tx_0


  # Create instance: axis_data_fifo_tx_1, and set properties
  set axis_data_fifo_tx_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_tx_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {64} \
    CONFIG.FIFO_MODE {2} \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_WR_DATA_COUNT {1} \
    CONFIG.IS_ACLK_ASYNC {0} \
    CONFIG.TDATA_NUM_BYTES {4} \
  ] $axis_data_fifo_tx_1


  # Create instance: datapath_0_concat_tkeep, and set properties
  set datapath_0_concat_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 datapath_0_concat_tkeep ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {8} \
    CONFIG.IN1_WIDTH {3} \
  ] $datapath_0_concat_tkeep


  # Create instance: datapath_0_constant_tkeep, and set properties
  set datapath_0_constant_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 datapath_0_constant_tkeep ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {3} \
  ] $datapath_0_constant_tkeep


  # Create instance: datapath_0_slice_tkeep, and set properties
  set datapath_0_slice_tkeep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 datapath_0_slice_tkeep ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_WIDTH {11} \
    CONFIG.DOUT_WIDTH {8} \
  ] $datapath_0_slice_tkeep


  # Create instance: mrmac_10g_mux_0, and set properties
  set mrmac_10g_mux_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_10g_mux:1.0 mrmac_10g_mux_0 ]

  # Create instance: mrmac_ptp_one_step_p_0, and set properties
  set mrmac_ptp_one_step_p_0 [ create_bd_cell -type ip -vlnv user.org:user:mrmac_ptp_one_step_pkt_edit:1.0 mrmac_ptp_one_step_p_0 ]

  # Create instance: ptp_logic
  create_hier_cell_ptp_logic $hier_obj ptp_logic

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_2


  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_3


  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_4 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_4


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {32} \
    CONFIG.IN1_WIDTH {48} \
  ] $xlconcat_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m00_axi] [get_bd_intf_pins ptp_logic/m00_axi]
  connect_bd_intf_net -intf_net RX_PTP_PKT_DETECT_TS_0_m_axis [get_bd_intf_pins axi_mcdma_0/S_AXIS_S2MM] [get_bd_intf_pins ptp_logic/m_axis]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_CNTRL [get_bd_intf_pins axi_mcdma_0/M_AXIS_CNTRL] [get_bd_intf_pins ptp_logic/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_tx_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_mcdma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net axis_data_fifo_tx_0_M_AXIS [get_bd_intf_pins axis_data_fifo_tx_0/M_AXIS] [get_bd_intf_pins mrmac_10g_mux_0/tx_s_axis]
  connect_bd_intf_net -intf_net hw_master_top_0_m_axis_sts [get_bd_intf_pins axi_mcdma_0/S_AXIS_STS] [get_bd_intf_pins ptp_logic/m_axis_sts]
  connect_bd_intf_net -intf_net ptp_logic_m_axis_1step [get_bd_intf_pins axis_data_fifo_tx_1/S_AXIS] [get_bd_intf_pins ptp_logic/m_axis_1step]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_wr_data  [get_bd_pins RX_PTP_PKT_DETECT_on_0/wr_data] \
  [get_bd_pins ptp_logic/din]
  connect_bd_net -net RX_PTP_PKT_DETECT_on_0_wr_en  [get_bd_pins RX_PTP_PKT_DETECT_on_0/wr_en] \
  [get_bd_pins ptp_logic/wr_en]
  connect_bd_net -net axi_mcdma_0_mm2s_ch1_introut  [get_bd_pins axi_mcdma_0/mm2s_ch1_introut] \
  [get_bd_pins mm2s_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s2mm_ch1_introut  [get_bd_pins axi_mcdma_0/s2mm_ch1_introut] \
  [get_bd_pins s2mm_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s_axis_s2mm_tready  [get_bd_pins ptp_logic/m_axis_s2mm_tready] \
  [get_bd_pins axis_data_fifo_rx_0/m_axis_tready]
  connect_bd_net -net axis_clock_converter_0_m_axis_tvalid  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tvalid] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tvalid_mux] \
  [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net axis_data_fifo_0_m_axis_tdata  [get_bd_pins axis_data_fifo_0/m_axis_tdata] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tdata]
  connect_bd_net -net axis_data_fifo_0_m_axis_tkeep  [get_bd_pins axis_data_fifo_0/m_axis_tkeep] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tkeep]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins axis_data_fifo_0/m_axis_tlast] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tlast] \
  [get_bd_pins ptp_logic/tx_axis_tlast_0]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins axis_data_fifo_0/m_axis_tvalid] \
  [get_bd_pins ptp_logic/s_axis_mm2s_tvalid]
  connect_bd_net -net axis_data_fifo_0_s_axis_tready  [get_bd_pins axis_data_fifo_0/s_axis_tready] \
  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tready]
  connect_bd_net -net axis_data_fifo_1_m_axis_tdata  [get_bd_pins axis_data_fifo_1/m_axis_tdata] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tdata]
  connect_bd_net -net axis_data_fifo_1_m_axis_tkeep  [get_bd_pins axis_data_fifo_1/m_axis_tkeep] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_1_m_axis_tlast  [get_bd_pins axis_data_fifo_1/m_axis_tlast] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tlast]
  connect_bd_net -net axis_data_fifo_1_m_axis_tvalid  [get_bd_pins axis_data_fifo_1/m_axis_tvalid] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tvalid]
  connect_bd_net -net axis_data_fifo_1_prog_full  [get_bd_pins axis_data_fifo_1/prog_full] \
  [get_bd_pins ptp_logic/fifo_full]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tdata  [get_bd_pins axis_data_fifo_rx_0/m_axis_tdata] \
  [get_bd_pins ptp_logic/s_axis_tdata]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tkeep  [get_bd_pins axis_data_fifo_rx_0/m_axis_tkeep] \
  [get_bd_pins ptp_logic/s_axis_tkeep]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tlast  [get_bd_pins axis_data_fifo_rx_0/m_axis_tlast] \
  [get_bd_pins ptp_logic/s_axis_s2mm_tlast]
  connect_bd_net -net axis_data_fifo_rx_0_m_axis_tvalid  [get_bd_pins axis_data_fifo_rx_0/m_axis_tvalid] \
  [get_bd_pins ptp_logic/s_axis_s2mm_tvalid]
  connect_bd_net -net axis_data_fifo_rx_0_prog_full  [get_bd_pins axis_data_fifo_rx_0/prog_full] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/fifo_full]
  connect_bd_net -net axis_data_fifo_rx_0_s_axis_tready  [get_bd_pins axis_data_fifo_rx_0/s_axis_tready] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tready] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tready_fifo] \
  [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tdata  [get_bd_pins axis_data_fifo_tx_1/m_axis_tdata] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tdata_0]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tkeep  [get_bd_pins axis_data_fifo_tx_1/m_axis_tkeep] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tkeep_0]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tlast  [get_bd_pins axis_data_fifo_tx_1/m_axis_tlast] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tlast_0] \
  [get_bd_pins ptp_logic/cmd_tlast]
  connect_bd_net -net axis_data_fifo_tx_1_m_axis_tvalid  [get_bd_pins axis_data_fifo_tx_1/m_axis_tvalid] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tvalid_0] \
  [get_bd_pins ptp_logic/cmd_tvalid]
  connect_bd_net -net datapath_0_slice_tkeep_Dout  [get_bd_pins datapath_0_slice_tkeep/Dout] \
  [get_bd_pins axis_data_fifo_1/s_axis_tkeep]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_systemtimerin_cf] \
  [get_bd_pins ptp_logic/din_0]
  connect_bd_net -net hw_master_top_0_interrupt  [get_bd_pins ptp_logic/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net m_axis_aresetn1_1  [get_bd_pins axis_tx_rstn] \
  [get_bd_pins axis_data_fifo_0/s_axis_aresetn] \
  [get_bd_pins axis_data_fifo_tx_1/s_axis_aresetn] \
  [get_bd_pins mrmac_10g_mux_0/tx_s_aresetn]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/rx_axis_clk_in] \
  [get_bd_pins mrmac_ptp_one_step_p_0/clk] \
  [get_bd_pins ptp_logic/mcdma_clk] \
  [get_bd_pins axi_mcdma_0/s_axi_aclk] \
  [get_bd_pins axis_data_fifo_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_1/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_tx_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_tx_1/s_axis_aclk] \
  [get_bd_pins mrmac_10g_mux_0/tx_s_aclk] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins ptp_logic/mcdma_resetn] \
  [get_bd_pins axis_data_fifo_tx_0/s_axis_aresetn] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user0  [get_bd_pins rx_axis_tkeep_user0] \
  [get_bd_pins datapath_0_slice_tkeep/Din]
  connect_bd_net -net mrmac_10g_mux_0_rx_m_axis_tdata  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tdata] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tdata] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tdata]
  connect_bd_net -net mrmac_10g_mux_0_rx_m_axis_tkeep  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tkeep] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tkeep] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tkeep]
  connect_bd_net -net mrmac_10g_mux_0_rx_s_axis_tready  [get_bd_pins mrmac_10g_mux_0/rx_s_axis_tready] \
  [get_bd_pins axis_data_fifo_1/m_axis_tready]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tdata  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tdata] \
  [get_bd_pins axis_data_fifo_0/s_axis_tdata]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tkeep  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tkeep] \
  [get_bd_pins axis_data_fifo_0/s_axis_tkeep]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tlast  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tlast] \
  [get_bd_pins axis_data_fifo_0/s_axis_tlast]
  connect_bd_net -net mrmac_10g_mux_0_tx_m_axis_tvalid  [get_bd_pins mrmac_10g_mux_0/tx_m_axis_tvalid] \
  [get_bd_pins axis_data_fifo_0/s_axis_tvalid]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_cf_offset  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_cf_offset] \
  [get_bd_pins m_ptp_cf_offset_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_tag  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_tag] \
  [get_bd_pins tx_ptp_tstamp_tag_out]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_ptp_upd_chcksum  [get_bd_pins mrmac_ptp_one_step_p_0/m_ptp_upd_chcksum] \
  [get_bd_pins m_ptp_upd_chcksum_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tdata1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tdata] \
  [get_bd_pins tx_axis_tdata0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tkeep1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tkeep] \
  [get_bd_pins datapath_0_concat_tkeep/In0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tlast1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tlast] \
  [get_bd_pins tx_axis_tlast_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_m_tvalid1  [get_bd_pins mrmac_ptp_one_step_p_0/m_tvalid] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net mrmac_ptp_one_step_p_0_s_cmd_tready_0  [get_bd_pins mrmac_ptp_one_step_p_0/s_cmd_tready_0] \
  [get_bd_pins ptp_logic/cmd_tready] \
  [get_bd_pins axis_data_fifo_tx_1/m_axis_tready]
  connect_bd_net -net mrmac_ptp_one_step_p_0_s_tready1  [get_bd_pins mrmac_ptp_one_step_p_0/s_tready] \
  [get_bd_pins ptp_logic/tx_axis_tready_0]
  connect_bd_net -net ptp_logic_Res2  [get_bd_pins ptp_logic/Res2] \
  [get_bd_pins axis_data_fifo_1/s_axis_tvalid]
  connect_bd_net -net ptp_logic_tx_axis_tvalid_0  [get_bd_pins ptp_logic/tx_axis_tvalid_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_tvalid]
  connect_bd_net -net ptp_logic_tx_ptp_1588op_in  [get_bd_pins ptp_logic/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net rx_axis_tdata0_1  [get_bd_pins rx_axis_tdata0] \
  [get_bd_pins axis_data_fifo_1/s_axis_tdata]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins ptp_logic/mrmac_tlast] \
  [get_bd_pins axis_data_fifo_1/s_axis_tlast]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins ptp_logic/rx_axis_tvalid_0]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins ptp_logic/rx_timestamp_tod]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins ptp_logic/rx_timestamp_tod_valid]
  connect_bd_net -net s_axis_aresetn1_1  [get_bd_pins axis_rx_rstn] \
  [get_bd_pins ptp_logic/axis_rx_rstn]
  connect_bd_net -net s_axis_aresetn_1  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axi_mcdma_0/axi_resetn]
  connect_bd_net -net s_axis_tlast_2  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tlast] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tlast_mux] \
  [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net sel_10g_mode_1  [get_bd_pins sel_10g_mode] \
  [get_bd_pins mrmac_10g_mux_0/sel_10g_mode]
  connect_bd_net -net tx_axis_tready_0_1  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins mrmac_ptp_one_step_p_0/m_tready]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins ptp_logic/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins ptp_logic/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins ptp_logic/tx_timestamp_tod_valid]
  connect_bd_net -net tx_tod_ns_0_1  [get_bd_pins tx_tod_ns_0] \
  [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net tx_tod_sec_0_1  [get_bd_pins tx_tod_sec_0] \
  [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins ptp_logic/Res1] \
  [get_bd_pins axis_data_fifo_0/m_axis_tready]
  connect_bd_net -net util_vector_logic_0_Res1  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins mrmac_ptp_one_step_p_0/rst]
  connect_bd_net -net util_vector_logic_1_Res  [get_bd_pins RX_PTP_PKT_DETECT_on_0/fifo_deassert] \
  [get_bd_pins util_vector_logic_2/Op2] \
  [get_bd_pins util_vector_logic_3/Op2] \
  [get_bd_pins util_vector_logic_4/Op2]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins ptp_logic/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/rx_axis_reset_in] \
  [get_bd_pins axis_data_fifo_1/s_axis_aresetn] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_aresetn] \
  [get_bd_pins mrmac_10g_mux_0/rx_s_aresetn]
  connect_bd_net -net util_vector_logic_2_Res1  [get_bd_pins util_vector_logic_2/Res] \
  [get_bd_pins mrmac_10g_mux_0/rx_m_axis_tready]
  connect_bd_net -net util_vector_logic_3_Res  [get_bd_pins util_vector_logic_3/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tvalid] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tvalid]
  connect_bd_net -net util_vector_logic_4_Res  [get_bd_pins util_vector_logic_4/Res] \
  [get_bd_pins RX_PTP_PKT_DETECT_on_0/s_axis_tlast] \
  [get_bd_pins axis_data_fifo_rx_0/s_axis_tlast]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_lite_aclk] \
  [get_bd_pins axi_mcdma_0/s_axi_lite_aclk]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins datapath_0_concat_tkeep/dout] \
  [get_bd_pins tx_axis_tkeep_user0]
  connect_bd_net -net xlconcat_0_dout1  [get_bd_pins xlconcat_0/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_systemtimerin_ts]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/s_terr]
  connect_bd_net -net xlconstant_1_dout  [get_bd_pins datapath_0_constant_tkeep/dout] \
  [get_bd_pins datapath_0_concat_tkeep/In1]
  connect_bd_net -net xlconstant_1_dout1  [get_bd_pins xlconstant_1/dout] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_data_rate] \
  [get_bd_pins mrmac_ptp_one_step_p_0/ctl_tx_ptp_1step_enable]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: MRMAC_1588_HELPER_HIER
proc create_hier_cell_MRMAC_1588_HELPER_HIER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_MRMAC_1588_HELPER_HIER() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI


  # Create pins
  create_bd_pin -dir I axis_tx_rx_clk
  create_bd_pin -dir O -from 0 -to 0 ctl_rx_ptp_st_overwrite_ch0
  create_bd_pin -dir O -from 0 -to 0 ctl_rx_ptp_st_overwrite_ch1
  create_bd_pin -dir O -from 0 -to 0 ctl_rx_ptp_st_overwrite_ch2
  create_bd_pin -dir O -from 0 -to 0 ctl_rx_ptp_st_overwrite_ch3
  create_bd_pin -dir O -from 0 -to 0 ctl_tx_ptp_st_overwrite_ch0
  create_bd_pin -dir O -from 0 -to 0 ctl_tx_ptp_st_overwrite_ch1
  create_bd_pin -dir O -from 0 -to 0 ctl_tx_ptp_st_overwrite_ch2
  create_bd_pin -dir O -from 0 -to 0 ctl_tx_ptp_st_overwrite_ch3
  create_bd_pin -dir O mrmac_rx_ptp_st_sync_0
  create_bd_pin -dir O mrmac_rx_ptp_st_sync_1
  create_bd_pin -dir O mrmac_rx_ptp_st_sync_2
  create_bd_pin -dir O mrmac_rx_ptp_st_sync_3
  create_bd_pin -dir O -from 54 -to 0 mrmac_rx_ptp_systimer_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_rx_ptp_systimer_1
  create_bd_pin -dir O -from 54 -to 0 mrmac_rx_ptp_systimer_2
  create_bd_pin -dir O -from 54 -to 0 mrmac_rx_ptp_systimer_3
  create_bd_pin -dir O mrmac_tx_ptp_st_sync_0
  create_bd_pin -dir O mrmac_tx_ptp_st_sync_1
  create_bd_pin -dir O mrmac_tx_ptp_st_sync_2
  create_bd_pin -dir O mrmac_tx_ptp_st_sync_3
  create_bd_pin -dir O -from 54 -to 0 mrmac_tx_ptp_systimer_0
  create_bd_pin -dir O -from 54 -to 0 mrmac_tx_ptp_systimer_1
  create_bd_pin -dir O -from 54 -to 0 mrmac_tx_ptp_systimer_2
  create_bd_pin -dir O -from 54 -to 0 mrmac_tx_ptp_systimer_3
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rst
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tlast_1
  create_bd_pin -dir I rx_axis_tlast_2
  create_bd_pin -dir I rx_axis_tlast_3
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I rx_axis_tvalid_1
  create_bd_pin -dir I rx_axis_tvalid_2
  create_bd_pin -dir I rx_axis_tvalid_3
  create_bd_pin -dir I -from 54 -to 0 rx_ptp_tstamp_0
  create_bd_pin -dir I -from 54 -to 0 rx_ptp_tstamp_1
  create_bd_pin -dir I -from 54 -to 0 rx_ptp_tstamp_2
  create_bd_pin -dir I -from 54 -to 0 rx_ptp_tstamp_3
  create_bd_pin -dir O -from 79 -to 0 rx_timestamp_tod_0
  create_bd_pin -dir O -from 79 -to 0 rx_timestamp_tod_1
  create_bd_pin -dir O -from 79 -to 0 rx_timestamp_tod_2
  create_bd_pin -dir O -from 79 -to 0 rx_timestamp_tod_3
  create_bd_pin -dir O rx_timestamp_tod_valid_0
  create_bd_pin -dir O rx_timestamp_tod_valid_1
  create_bd_pin -dir O rx_timestamp_tod_valid_2
  create_bd_pin -dir O rx_timestamp_tod_valid_3
  create_bd_pin -dir I -type clk s_axi_rx_timer_aclk
  create_bd_pin -dir I s_axi_rx_timer_aresetn_sc
  create_bd_pin -dir I tod_1pps_in
  create_bd_pin -dir O tod_1pps_out
  create_bd_pin -dir O tod_intr
  create_bd_pin -dir I ts_clk
  create_bd_pin -dir I -from 3 -to 0 ts_rst_0
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rst
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir I -from 54 -to 0 tx_ptp_tstamp_0
  create_bd_pin -dir I -from 54 -to 0 tx_ptp_tstamp_1
  create_bd_pin -dir I -from 54 -to 0 tx_ptp_tstamp_2
  create_bd_pin -dir I -from 54 -to 0 tx_ptp_tstamp_3
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_0
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_1
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_2
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_3
  create_bd_pin -dir I tx_ptp_tstamp_valid_0
  create_bd_pin -dir I tx_ptp_tstamp_valid_1
  create_bd_pin -dir I tx_ptp_tstamp_valid_2
  create_bd_pin -dir I tx_ptp_tstamp_valid_3
  create_bd_pin -dir O -from 79 -to 0 tx_timestamp_tod_0
  create_bd_pin -dir O -from 79 -to 0 tx_timestamp_tod_1
  create_bd_pin -dir O -from 79 -to 0 tx_timestamp_tod_2
  create_bd_pin -dir O -from 79 -to 0 tx_timestamp_tod_3
  create_bd_pin -dir O tx_timestamp_tod_valid_0
  create_bd_pin -dir O tx_timestamp_tod_valid_1
  create_bd_pin -dir O tx_timestamp_tod_valid_2
  create_bd_pin -dir O tx_timestamp_tod_valid_3
  create_bd_pin -dir O -from 63 -to 0 tx_tod_corr_0
  create_bd_pin -dir O -from 63 -to 0 tx_tod_corr_1
  create_bd_pin -dir O -from 63 -to 0 tx_tod_corr_2
  create_bd_pin -dir O -from 63 -to 0 tx_tod_corr_3
  create_bd_pin -dir O -from 31 -to 0 tx_tod_ns_0
  create_bd_pin -dir O -from 31 -to 0 tx_tod_ns_1
  create_bd_pin -dir O -from 31 -to 0 tx_tod_ns_2
  create_bd_pin -dir O -from 31 -to 0 tx_tod_ns_3
  create_bd_pin -dir O -from 47 -to 0 tx_tod_sec_0
  create_bd_pin -dir O -from 47 -to 0 tx_tod_sec_1
  create_bd_pin -dir O -from 47 -to 0 tx_tod_sec_2
  create_bd_pin -dir O -from 47 -to 0 tx_tod_sec_3

  # Create instance: SYS_TIMER_0
  create_hier_cell_SYS_TIMER_0 $hier_obj SYS_TIMER_0

  # Create instance: SYS_TIMER_1
  create_hier_cell_SYS_TIMER_1 $hier_obj SYS_TIMER_1

  # Create instance: SYS_TIMER_2
  create_hier_cell_SYS_TIMER_2 $hier_obj SYS_TIMER_2

  # Create instance: SYS_TIMER_3
  create_hier_cell_SYS_TIMER_3 $hier_obj SYS_TIMER_3

  # Create instance: Tod_intr_all, and set properties
  set Tod_intr_all [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 Tod_intr_all ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {4} \
  ] $Tod_intr_all


  # Create instance: clk_rst_slice_hier_ch0
  create_hier_cell_clk_rst_slice_hier_ch0_1 $hier_obj clk_rst_slice_hier_ch0

  # Create instance: clk_rst_slice_hier_ch1
  create_hier_cell_clk_rst_slice_hier_ch1_1 $hier_obj clk_rst_slice_hier_ch1

  # Create instance: clk_rst_slice_hier_ch2
  create_hier_cell_clk_rst_slice_hier_ch2_1 $hier_obj clk_rst_slice_hier_ch2

  # Create instance: clk_rst_slice_hier_ch3
  create_hier_cell_clk_rst_slice_hier_ch3_1 $hier_obj clk_rst_slice_hier_ch3

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {4} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: xlconcat_tod_intr, and set properties
  set xlconcat_tod_intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_tod_intr ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {1} \
    CONFIG.IN2_WIDTH {1} \
    CONFIG.IN3_WIDTH {1} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_tod_intr


  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins SYS_TIMER_0/s_axi_0]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins SYS_TIMER_1/s_axi_0]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins SYS_TIMER_2/s_axi_0]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins smartconnect_0/M03_AXI] [get_bd_intf_pins SYS_TIMER_3/s_axi_0]

  # Create port connections
  connect_bd_net -net SYS_TIMER_0_mrmac_rx_ptp_st_overwrite_0  [get_bd_pins SYS_TIMER_0/mrmac_rx_ptp_st_overwrite_0] \
  [get_bd_pins ctl_rx_ptp_st_overwrite_ch0]
  connect_bd_net -net SYS_TIMER_0_mrmac_rx_ptp_st_sync_0  [get_bd_pins SYS_TIMER_0/mrmac_rx_ptp_st_sync_0] \
  [get_bd_pins mrmac_rx_ptp_st_sync_0]
  connect_bd_net -net SYS_TIMER_0_mrmac_rx_ptp_systimer_0  [get_bd_pins SYS_TIMER_0/mrmac_rx_ptp_systimer_0] \
  [get_bd_pins mrmac_rx_ptp_systimer_0]
  connect_bd_net -net SYS_TIMER_0_mrmac_tx_ptp_st_overwrite_0  [get_bd_pins SYS_TIMER_0/mrmac_tx_ptp_st_overwrite_0] \
  [get_bd_pins ctl_tx_ptp_st_overwrite_ch0]
  connect_bd_net -net SYS_TIMER_0_mrmac_tx_ptp_st_sync_0  [get_bd_pins SYS_TIMER_0/mrmac_tx_ptp_st_sync_0] \
  [get_bd_pins mrmac_tx_ptp_st_sync_0]
  connect_bd_net -net SYS_TIMER_0_mrmac_tx_ptp_systimer_0  [get_bd_pins SYS_TIMER_0/mrmac_tx_ptp_systimer_0] \
  [get_bd_pins mrmac_tx_ptp_systimer_0]
  connect_bd_net -net SYS_TIMER_0_rx_timestamp_tod_0  [get_bd_pins SYS_TIMER_0/rx_timestamp_tod_0] \
  [get_bd_pins rx_timestamp_tod_0]
  connect_bd_net -net SYS_TIMER_0_rx_timestamp_tod_valid_0  [get_bd_pins SYS_TIMER_0/rx_timestamp_tod_valid_0] \
  [get_bd_pins rx_timestamp_tod_valid_0]
  connect_bd_net -net SYS_TIMER_0_tod_1pps_out  [get_bd_pins SYS_TIMER_0/tod_1pps_out] \
  [get_bd_pins tod_1pps_out]
  connect_bd_net -net SYS_TIMER_0_tod_intr  [get_bd_pins SYS_TIMER_0/tod_intr] \
  [get_bd_pins xlconcat_tod_intr/In0]
  connect_bd_net -net SYS_TIMER_0_tx_timestamp_tod_0  [get_bd_pins SYS_TIMER_0/tx_timestamp_tod_0] \
  [get_bd_pins tx_timestamp_tod_0]
  connect_bd_net -net SYS_TIMER_0_tx_timestamp_tod_valid_0  [get_bd_pins SYS_TIMER_0/tx_timestamp_tod_valid_0] \
  [get_bd_pins tx_timestamp_tod_valid_0]
  connect_bd_net -net SYS_TIMER_0_tx_tod_corr_0  [get_bd_pins SYS_TIMER_0/tx_tod_corr_0] \
  [get_bd_pins tx_tod_corr_0]
  connect_bd_net -net SYS_TIMER_0_tx_tod_ns_0  [get_bd_pins SYS_TIMER_0/tx_tod_ns_0] \
  [get_bd_pins tx_tod_ns_0]
  connect_bd_net -net SYS_TIMER_0_tx_tod_sec_0  [get_bd_pins SYS_TIMER_0/tx_tod_sec_0] \
  [get_bd_pins tx_tod_sec_0]
  connect_bd_net -net SYS_TIMER_1_mrmac_rx_ptp_st_overwrite_0  [get_bd_pins SYS_TIMER_1/mrmac_rx_ptp_st_overwrite_0] \
  [get_bd_pins ctl_rx_ptp_st_overwrite_ch1]
  connect_bd_net -net SYS_TIMER_1_mrmac_rx_ptp_st_sync_0  [get_bd_pins SYS_TIMER_1/mrmac_rx_ptp_st_sync_0] \
  [get_bd_pins mrmac_rx_ptp_st_sync_1]
  connect_bd_net -net SYS_TIMER_1_mrmac_rx_ptp_systimer_0  [get_bd_pins SYS_TIMER_1/mrmac_rx_ptp_systimer_0] \
  [get_bd_pins mrmac_rx_ptp_systimer_1]
  connect_bd_net -net SYS_TIMER_1_mrmac_tx_ptp_st_overwrite_0  [get_bd_pins SYS_TIMER_1/mrmac_tx_ptp_st_overwrite_0] \
  [get_bd_pins ctl_tx_ptp_st_overwrite_ch1]
  connect_bd_net -net SYS_TIMER_1_mrmac_tx_ptp_st_sync_0  [get_bd_pins SYS_TIMER_1/mrmac_tx_ptp_st_sync_0] \
  [get_bd_pins mrmac_tx_ptp_st_sync_1]
  connect_bd_net -net SYS_TIMER_1_mrmac_tx_ptp_systimer_0  [get_bd_pins SYS_TIMER_1/mrmac_tx_ptp_systimer_0] \
  [get_bd_pins mrmac_tx_ptp_systimer_1]
  connect_bd_net -net SYS_TIMER_1_rx_timestamp_tod_0  [get_bd_pins SYS_TIMER_1/rx_timestamp_tod_0] \
  [get_bd_pins rx_timestamp_tod_1]
  connect_bd_net -net SYS_TIMER_1_rx_timestamp_tod_valid_0  [get_bd_pins SYS_TIMER_1/rx_timestamp_tod_valid_0] \
  [get_bd_pins rx_timestamp_tod_valid_1]
  connect_bd_net -net SYS_TIMER_1_tod_intr  [get_bd_pins SYS_TIMER_1/tod_intr] \
  [get_bd_pins xlconcat_tod_intr/In1]
  connect_bd_net -net SYS_TIMER_1_tx_timestamp_tod_0  [get_bd_pins SYS_TIMER_1/tx_timestamp_tod_0] \
  [get_bd_pins tx_timestamp_tod_1]
  connect_bd_net -net SYS_TIMER_1_tx_timestamp_tod_valid_0  [get_bd_pins SYS_TIMER_1/tx_timestamp_tod_valid_0] \
  [get_bd_pins tx_timestamp_tod_valid_1]
  connect_bd_net -net SYS_TIMER_1_tx_tod_corr_1  [get_bd_pins SYS_TIMER_1/tx_tod_corr_1] \
  [get_bd_pins tx_tod_corr_1]
  connect_bd_net -net SYS_TIMER_1_tx_tod_ns_1  [get_bd_pins SYS_TIMER_1/tx_tod_ns_1] \
  [get_bd_pins tx_tod_ns_1]
  connect_bd_net -net SYS_TIMER_1_tx_tod_sec_1  [get_bd_pins SYS_TIMER_1/tx_tod_sec_1] \
  [get_bd_pins tx_tod_sec_1]
  connect_bd_net -net SYS_TIMER_2_mrmac_rx_ptp_st_overwrite_0  [get_bd_pins SYS_TIMER_2/mrmac_rx_ptp_st_overwrite_0] \
  [get_bd_pins ctl_rx_ptp_st_overwrite_ch2]
  connect_bd_net -net SYS_TIMER_2_mrmac_rx_ptp_st_sync_0  [get_bd_pins SYS_TIMER_2/mrmac_rx_ptp_st_sync_0] \
  [get_bd_pins mrmac_rx_ptp_st_sync_2]
  connect_bd_net -net SYS_TIMER_2_mrmac_rx_ptp_systimer_0  [get_bd_pins SYS_TIMER_2/mrmac_rx_ptp_systimer_0] \
  [get_bd_pins mrmac_rx_ptp_systimer_2]
  connect_bd_net -net SYS_TIMER_2_mrmac_tx_ptp_st_overwrite_0  [get_bd_pins SYS_TIMER_2/mrmac_tx_ptp_st_overwrite_0] \
  [get_bd_pins ctl_tx_ptp_st_overwrite_ch2]
  connect_bd_net -net SYS_TIMER_2_mrmac_tx_ptp_st_sync_0  [get_bd_pins SYS_TIMER_2/mrmac_tx_ptp_st_sync_0] \
  [get_bd_pins mrmac_tx_ptp_st_sync_2]
  connect_bd_net -net SYS_TIMER_2_mrmac_tx_ptp_systimer_0  [get_bd_pins SYS_TIMER_2/mrmac_tx_ptp_systimer_0] \
  [get_bd_pins mrmac_tx_ptp_systimer_2]
  connect_bd_net -net SYS_TIMER_2_rx_timestamp_tod_0  [get_bd_pins SYS_TIMER_2/rx_timestamp_tod_0] \
  [get_bd_pins rx_timestamp_tod_2]
  connect_bd_net -net SYS_TIMER_2_rx_timestamp_tod_valid_0  [get_bd_pins SYS_TIMER_2/rx_timestamp_tod_valid_0] \
  [get_bd_pins rx_timestamp_tod_valid_2]
  connect_bd_net -net SYS_TIMER_2_tod_intr  [get_bd_pins SYS_TIMER_2/tod_intr] \
  [get_bd_pins xlconcat_tod_intr/In2]
  connect_bd_net -net SYS_TIMER_2_tx_timestamp_tod_0  [get_bd_pins SYS_TIMER_2/tx_timestamp_tod_0] \
  [get_bd_pins tx_timestamp_tod_2]
  connect_bd_net -net SYS_TIMER_2_tx_timestamp_tod_valid_0  [get_bd_pins SYS_TIMER_2/tx_timestamp_tod_valid_0] \
  [get_bd_pins tx_timestamp_tod_valid_2]
  connect_bd_net -net SYS_TIMER_2_tx_tod_corr_2  [get_bd_pins SYS_TIMER_2/tx_tod_corr_2] \
  [get_bd_pins tx_tod_corr_2]
  connect_bd_net -net SYS_TIMER_2_tx_tod_ns_2  [get_bd_pins SYS_TIMER_2/tx_tod_ns_2] \
  [get_bd_pins tx_tod_ns_2]
  connect_bd_net -net SYS_TIMER_2_tx_tod_sec_2  [get_bd_pins SYS_TIMER_2/tx_tod_sec_2] \
  [get_bd_pins tx_tod_sec_2]
  connect_bd_net -net SYS_TIMER_3_mrmac_rx_ptp_st_overwrite_0  [get_bd_pins SYS_TIMER_3/mrmac_rx_ptp_st_overwrite_0] \
  [get_bd_pins ctl_rx_ptp_st_overwrite_ch3]
  connect_bd_net -net SYS_TIMER_3_mrmac_rx_ptp_st_sync_0  [get_bd_pins SYS_TIMER_3/mrmac_rx_ptp_st_sync_0] \
  [get_bd_pins mrmac_rx_ptp_st_sync_3]
  connect_bd_net -net SYS_TIMER_3_mrmac_rx_ptp_systimer_0  [get_bd_pins SYS_TIMER_3/mrmac_rx_ptp_systimer_0] \
  [get_bd_pins mrmac_rx_ptp_systimer_3]
  connect_bd_net -net SYS_TIMER_3_mrmac_tx_ptp_st_overwrite_0  [get_bd_pins SYS_TIMER_3/mrmac_tx_ptp_st_overwrite_0] \
  [get_bd_pins ctl_tx_ptp_st_overwrite_ch3]
  connect_bd_net -net SYS_TIMER_3_mrmac_tx_ptp_st_sync_0  [get_bd_pins SYS_TIMER_3/mrmac_tx_ptp_st_sync_0] \
  [get_bd_pins mrmac_tx_ptp_st_sync_3]
  connect_bd_net -net SYS_TIMER_3_mrmac_tx_ptp_systimer_0  [get_bd_pins SYS_TIMER_3/mrmac_tx_ptp_systimer_0] \
  [get_bd_pins mrmac_tx_ptp_systimer_3]
  connect_bd_net -net SYS_TIMER_3_rx_timestamp_tod_0  [get_bd_pins SYS_TIMER_3/rx_timestamp_tod_0] \
  [get_bd_pins rx_timestamp_tod_3]
  connect_bd_net -net SYS_TIMER_3_rx_timestamp_tod_valid_0  [get_bd_pins SYS_TIMER_3/rx_timestamp_tod_valid_0] \
  [get_bd_pins rx_timestamp_tod_valid_3]
  connect_bd_net -net SYS_TIMER_3_tod_intr  [get_bd_pins SYS_TIMER_3/tod_intr] \
  [get_bd_pins xlconcat_tod_intr/In3]
  connect_bd_net -net SYS_TIMER_3_tx_timestamp_tod_0  [get_bd_pins SYS_TIMER_3/tx_timestamp_tod_0] \
  [get_bd_pins tx_timestamp_tod_3]
  connect_bd_net -net SYS_TIMER_3_tx_timestamp_tod_valid_0  [get_bd_pins SYS_TIMER_3/tx_timestamp_tod_valid_0] \
  [get_bd_pins tx_timestamp_tod_valid_3]
  connect_bd_net -net SYS_TIMER_3_tx_tod_corr_3  [get_bd_pins SYS_TIMER_3/tx_tod_corr_3] \
  [get_bd_pins tx_tod_corr_3]
  connect_bd_net -net SYS_TIMER_3_tx_tod_ns_3  [get_bd_pins SYS_TIMER_3/tx_tod_ns_3] \
  [get_bd_pins tx_tod_ns_3]
  connect_bd_net -net SYS_TIMER_3_tx_tod_sec_3  [get_bd_pins SYS_TIMER_3/tx_tod_sec_3] \
  [get_bd_pins tx_tod_sec_3]
  connect_bd_net -net Tod_intr_all_Res  [get_bd_pins Tod_intr_all/Res] \
  [get_bd_pins tod_intr]
  connect_bd_net -net clk_rst_slice_hier_ch0_rx_axis_rst_out  [get_bd_pins clk_rst_slice_hier_ch0/rx_axis_rst_out] \
  [get_bd_pins SYS_TIMER_0/rx_axis_rst_0]
  connect_bd_net -net clk_rst_slice_hier_ch0_ts_rst_out  [get_bd_pins clk_rst_slice_hier_ch0/ts_rst_out] \
  [get_bd_pins SYS_TIMER_0/ts_rst]
  connect_bd_net -net clk_rst_slice_hier_ch0_tx_axis_rst_out  [get_bd_pins clk_rst_slice_hier_ch0/tx_axis_rst_out] \
  [get_bd_pins SYS_TIMER_0/tx_axis_rst_0]
  connect_bd_net -net clk_rst_slice_hier_ch1_rx_axis_rst_out  [get_bd_pins clk_rst_slice_hier_ch1/rx_axis_rst_out] \
  [get_bd_pins SYS_TIMER_1/rx_axis_rst_0]
  connect_bd_net -net clk_rst_slice_hier_ch1_ts_rst_out  [get_bd_pins clk_rst_slice_hier_ch1/ts_rst_out] \
  [get_bd_pins SYS_TIMER_1/ts_rst]
  connect_bd_net -net clk_rst_slice_hier_ch1_tx_axis_clk_out  [get_bd_pins axis_tx_rx_clk] \
  [get_bd_pins SYS_TIMER_0/rx_axis_clk_0] \
  [get_bd_pins SYS_TIMER_0/tx_axis_clk_0] \
  [get_bd_pins SYS_TIMER_1/rx_axis_clk_0] \
  [get_bd_pins SYS_TIMER_1/tx_axis_clk_0] \
  [get_bd_pins SYS_TIMER_2/rx_axis_clk_0] \
  [get_bd_pins SYS_TIMER_2/tx_axis_clk_0] \
  [get_bd_pins SYS_TIMER_3/rx_axis_clk_0] \
  [get_bd_pins SYS_TIMER_3/tx_axis_clk_0]
  connect_bd_net -net clk_rst_slice_hier_ch1_tx_axis_rst_out  [get_bd_pins clk_rst_slice_hier_ch1/tx_axis_rst_out] \
  [get_bd_pins SYS_TIMER_1/tx_axis_rst_0]
  connect_bd_net -net clk_rst_slice_hier_ch2_rx_axis_rst_out  [get_bd_pins clk_rst_slice_hier_ch2/rx_axis_rst_out] \
  [get_bd_pins SYS_TIMER_2/rx_axis_rst_0]
  connect_bd_net -net clk_rst_slice_hier_ch2_ts_rst_out  [get_bd_pins clk_rst_slice_hier_ch2/ts_rst_out] \
  [get_bd_pins SYS_TIMER_2/ts_rst]
  connect_bd_net -net clk_rst_slice_hier_ch2_tx_axis_rst_out  [get_bd_pins clk_rst_slice_hier_ch2/tx_axis_rst_out] \
  [get_bd_pins SYS_TIMER_2/tx_axis_rst_0]
  connect_bd_net -net clk_rst_slice_hier_ch3_rx_axis_rst_out  [get_bd_pins clk_rst_slice_hier_ch3/rx_axis_rst_out] \
  [get_bd_pins SYS_TIMER_3/rx_axis_rst_0]
  connect_bd_net -net clk_rst_slice_hier_ch3_ts_rst_out  [get_bd_pins clk_rst_slice_hier_ch3/ts_rst_out] \
  [get_bd_pins SYS_TIMER_3/ts_rst]
  connect_bd_net -net clk_rst_slice_hier_ch3_tx_axis_rst_out  [get_bd_pins clk_rst_slice_hier_ch3/tx_axis_rst_out] \
  [get_bd_pins SYS_TIMER_3/tx_axis_rst_0]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn  [get_bd_pins s_axi_rx_timer_aresetn_sc] \
  [get_bd_pins SYS_TIMER_0/s_axi_aresetn_0] \
  [get_bd_pins SYS_TIMER_1/s_axi_aresetn_0] \
  [get_bd_pins SYS_TIMER_2/s_axi_aresetn_0] \
  [get_bd_pins SYS_TIMER_3/s_axi_aresetn_0] \
  [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net rx_axis_rst_1  [get_bd_pins rx_axis_rst] \
  [get_bd_pins clk_rst_slice_hier_ch0/rx_axis_rst] \
  [get_bd_pins clk_rst_slice_hier_ch1/rx_axis_rst] \
  [get_bd_pins clk_rst_slice_hier_ch2/rx_axis_rst] \
  [get_bd_pins clk_rst_slice_hier_ch3/rx_axis_rst]
  connect_bd_net -net rx_axis_rstn_1  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch0/rx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch1/rx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch2/rx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch3/rx_axis_rstn]
  connect_bd_net -net rx_axis_tlast_0_1  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins SYS_TIMER_0/rx_axis_tlast_0]
  connect_bd_net -net rx_axis_tlast_0_2  [get_bd_pins rx_axis_tlast_1] \
  [get_bd_pins SYS_TIMER_1/rx_axis_tlast_0]
  connect_bd_net -net rx_axis_tlast_0_3  [get_bd_pins rx_axis_tlast_2] \
  [get_bd_pins SYS_TIMER_2/rx_axis_tlast_0]
  connect_bd_net -net rx_axis_tlast_0_4  [get_bd_pins rx_axis_tlast_3] \
  [get_bd_pins SYS_TIMER_3/rx_axis_tlast_0]
  connect_bd_net -net rx_axis_tvalid_0_1  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins SYS_TIMER_0/rx_axis_tvalid_0]
  connect_bd_net -net rx_axis_tvalid_0_2  [get_bd_pins rx_axis_tvalid_1] \
  [get_bd_pins SYS_TIMER_1/rx_axis_tvalid_0]
  connect_bd_net -net rx_axis_tvalid_0_3  [get_bd_pins rx_axis_tvalid_2] \
  [get_bd_pins SYS_TIMER_2/rx_axis_tvalid_0]
  connect_bd_net -net rx_axis_tvalid_0_4  [get_bd_pins rx_axis_tvalid_3] \
  [get_bd_pins SYS_TIMER_3/rx_axis_tvalid_0]
  connect_bd_net -net rx_ptp_tstamp_0_1  [get_bd_pins rx_ptp_tstamp_0] \
  [get_bd_pins SYS_TIMER_0/rx_ptp_tstamp_0]
  connect_bd_net -net rx_ptp_tstamp_0_2  [get_bd_pins rx_ptp_tstamp_1] \
  [get_bd_pins SYS_TIMER_1/rx_ptp_tstamp_0]
  connect_bd_net -net rx_ptp_tstamp_0_3  [get_bd_pins rx_ptp_tstamp_2] \
  [get_bd_pins SYS_TIMER_2/rx_ptp_tstamp_0]
  connect_bd_net -net rx_ptp_tstamp_0_4  [get_bd_pins rx_ptp_tstamp_3] \
  [get_bd_pins SYS_TIMER_3/rx_ptp_tstamp_0]
  connect_bd_net -net tod_1pps_in_1  [get_bd_pins tod_1pps_in] \
  [get_bd_pins SYS_TIMER_0/tod_1pps_in] \
  [get_bd_pins SYS_TIMER_1/tod_1pps_in] \
  [get_bd_pins SYS_TIMER_2/tod_1pps_in] \
  [get_bd_pins SYS_TIMER_3/tod_1pps_in]
  connect_bd_net -net ts_clk_1  [get_bd_pins ts_clk] \
  [get_bd_pins SYS_TIMER_0/ts_clk] \
  [get_bd_pins SYS_TIMER_1/ts_clk] \
  [get_bd_pins SYS_TIMER_2/ts_clk] \
  [get_bd_pins SYS_TIMER_3/ts_clk]
  connect_bd_net -net ts_rst_1  [get_bd_pins ts_rst_0] \
  [get_bd_pins clk_rst_slice_hier_ch0/ts_rst] \
  [get_bd_pins clk_rst_slice_hier_ch1/ts_rst] \
  [get_bd_pins clk_rst_slice_hier_ch2/ts_rst] \
  [get_bd_pins clk_rst_slice_hier_ch3/ts_rst]
  connect_bd_net -net tx_axis_rst_1  [get_bd_pins tx_axis_rst] \
  [get_bd_pins clk_rst_slice_hier_ch0/tx_axis_rst] \
  [get_bd_pins clk_rst_slice_hier_ch1/tx_axis_rst] \
  [get_bd_pins clk_rst_slice_hier_ch2/tx_axis_rst] \
  [get_bd_pins clk_rst_slice_hier_ch3/tx_axis_rst]
  connect_bd_net -net tx_axis_rstn_1  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch0/tx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch1/tx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch2/tx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch3/tx_axis_rstn]
  connect_bd_net -net tx_ptp_tstamp_0_1  [get_bd_pins tx_ptp_tstamp_0] \
  [get_bd_pins SYS_TIMER_0/tx_ptp_tstamp_0]
  connect_bd_net -net tx_ptp_tstamp_0_2  [get_bd_pins tx_ptp_tstamp_1] \
  [get_bd_pins SYS_TIMER_1/tx_ptp_tstamp_0]
  connect_bd_net -net tx_ptp_tstamp_0_3  [get_bd_pins tx_ptp_tstamp_2] \
  [get_bd_pins SYS_TIMER_2/tx_ptp_tstamp_0]
  connect_bd_net -net tx_ptp_tstamp_0_4  [get_bd_pins tx_ptp_tstamp_3] \
  [get_bd_pins SYS_TIMER_3/tx_ptp_tstamp_0]
  connect_bd_net -net tx_ptp_tstamp_tag_0_1  [get_bd_pins tx_ptp_tstamp_tag_0] \
  [get_bd_pins SYS_TIMER_0/tx_ptp_tstamp_tag_0]
  connect_bd_net -net tx_ptp_tstamp_tag_0_2  [get_bd_pins tx_ptp_tstamp_tag_1] \
  [get_bd_pins SYS_TIMER_1/tx_ptp_tstamp_tag_0]
  connect_bd_net -net tx_ptp_tstamp_tag_0_3  [get_bd_pins tx_ptp_tstamp_tag_2] \
  [get_bd_pins SYS_TIMER_2/tx_ptp_tstamp_tag_0]
  connect_bd_net -net tx_ptp_tstamp_tag_0_4  [get_bd_pins tx_ptp_tstamp_tag_3] \
  [get_bd_pins SYS_TIMER_3/tx_ptp_tstamp_tag_0]
  connect_bd_net -net tx_ptp_tstamp_valid_0_1  [get_bd_pins tx_ptp_tstamp_valid_0] \
  [get_bd_pins SYS_TIMER_0/tx_ptp_tstamp_valid_0]
  connect_bd_net -net tx_ptp_tstamp_valid_0_2  [get_bd_pins tx_ptp_tstamp_valid_1] \
  [get_bd_pins SYS_TIMER_1/tx_ptp_tstamp_valid_0]
  connect_bd_net -net tx_ptp_tstamp_valid_0_3  [get_bd_pins tx_ptp_tstamp_valid_2] \
  [get_bd_pins SYS_TIMER_2/tx_ptp_tstamp_valid_0]
  connect_bd_net -net tx_ptp_tstamp_valid_0_4  [get_bd_pins tx_ptp_tstamp_valid_3] \
  [get_bd_pins SYS_TIMER_3/tx_ptp_tstamp_valid_0]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_rx_timer_aclk] \
  [get_bd_pins SYS_TIMER_0/s_axi_aclk_0] \
  [get_bd_pins SYS_TIMER_1/s_axi_aclk_0] \
  [get_bd_pins SYS_TIMER_2/s_axi_aclk_0] \
  [get_bd_pins SYS_TIMER_3/s_axi_aclk_0] \
  [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net xlconcat_tod_intr_dout  [get_bd_pins xlconcat_tod_intr/dout] \
  [get_bd_pins Tod_intr_all/Op1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: GT_WRAPPER
proc create_hier_cell_GT_WRAPPER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_GT_WRAPPER() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI4_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX0_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX1_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX2_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX3_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX0_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX1_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX2_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX3_GT_IP_Interface


  # Create pins
  create_bd_pin -dir I -from 3 -to 0 RX_MST_DP_RESET
  create_bd_pin -dir O -from 0 -to 0 RX_REC_CLK_out_n_0
  create_bd_pin -dir O -from 0 -to 0 RX_REC_CLK_out_p_0
  create_bd_pin -dir I -from 3 -to 0 TX_MST_DP_RESET
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O -type rst ch0_rxmstresetdone
  create_bd_pin -dir O ch0_rxpmaresetdone
  create_bd_pin -dir O -type rst ch0_txmstresetdone
  create_bd_pin -dir O ch0_txpmaresetdone
  create_bd_pin -dir O -type rst ch1_rxmstresetdone
  create_bd_pin -dir O ch1_rxpmaresetdone
  create_bd_pin -dir O -type rst ch1_txmstresetdone
  create_bd_pin -dir O ch1_txpmaresetdone
  create_bd_pin -dir O -type rst ch2_rxmstresetdone
  create_bd_pin -dir O ch2_rxpmaresetdone
  create_bd_pin -dir O -type rst ch2_txmstresetdone
  create_bd_pin -dir O ch2_txpmaresetdone
  create_bd_pin -dir O -type rst ch3_rxmstresetdone
  create_bd_pin -dir O ch3_rxpmaresetdone
  create_bd_pin -dir O -type rst ch3_txmstresetdone
  create_bd_pin -dir O ch3_txpmaresetdone
  create_bd_pin -dir O gt_refclk_div2_fwd
  create_bd_pin -dir O -from 3 -to 0 gt_reset_all
  create_bd_pin -dir O -from 3 -to 0 gt_reset_rx_datapath
  create_bd_pin -dir O -from 3 -to 0 gt_reset_tx_datapath
  create_bd_pin -dir I -from 3 -to 0 gt_rxn_in_0
  create_bd_pin -dir I -from 3 -to 0 gt_rxp_in_0
  create_bd_pin -dir O -from 3 -to 0 gt_txn_out_0
  create_bd_pin -dir O -from 3 -to 0 gt_txp_out_0
  create_bd_pin -dir O gtpowergood
  create_bd_pin -dir I -from 3 -to 0 rx_mst_reset_in
  create_bd_pin -dir I -from 3 -to 0 rx_userrdy_in
  create_bd_pin -dir O -from 3 -to 0 rx_usr_clk1
  create_bd_pin -dir O -from 3 -to 0 rx_usr_clk2
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -from 3 -to 0 tx_mst_reset_in
  create_bd_pin -dir I -from 3 -to 0 tx_userrdy_in
  create_bd_pin -dir O -from 3 -to 0 tx_usr_clk
  create_bd_pin -dir O -from 3 -to 0 tx_usr_clk2

  # Create instance: axi_gpio_gt_rate_reset_ctl_0, and set properties
  set axi_gpio_gt_rate_reset_ctl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_rate_reset_ctl_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_0


  # Create instance: axi_gpio_gt_rate_reset_ctl_1, and set properties
  set axi_gpio_gt_rate_reset_ctl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_rate_reset_ctl_1 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_1


  # Create instance: axi_gpio_gt_rate_reset_ctl_2, and set properties
  set axi_gpio_gt_rate_reset_ctl_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_rate_reset_ctl_2 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_2


  # Create instance: axi_gpio_gt_rate_reset_ctl_3, and set properties
  set axi_gpio_gt_rate_reset_ctl_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_rate_reset_ctl_3 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_rate_reset_ctl_3


  # Create instance: axi_gpio_gt_reset_mask, and set properties
  set axi_gpio_gt_reset_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_reset_mask ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {8} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_gt_reset_mask


  # Create instance: bufg_gt_div_val, and set properties
  set bufg_gt_div_val [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 bufg_gt_div_val ]
  set_property CONFIG.CONST_WIDTH {3} $bufg_gt_div_val


  # Create instance: bufg_gt_rxoutclk
  create_hier_cell_bufg_gt_rxoutclk $hier_obj bufg_gt_rxoutclk

  # Create instance: bufg_gt_txoutclk
  create_hier_cell_bufg_gt_txoutclk $hier_obj bufg_gt_txoutclk

  # Create instance: conct_rx_mst_reset_done_out, and set properties
  set conct_rx_mst_reset_done_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_rx_mst_reset_done_out ]
  set_property CONFIG.NUM_PORTS {4} $conct_rx_mst_reset_done_out


  # Create instance: conct_rx_usr_clk2, and set properties
  set conct_rx_usr_clk2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_rx_usr_clk2 ]
  set_property CONFIG.NUM_PORTS {4} $conct_rx_usr_clk2


  # Create instance: conct_tx_mst_reset_done_out, and set properties
  set conct_tx_mst_reset_done_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_tx_mst_reset_done_out ]
  set_property CONFIG.NUM_PORTS {4} $conct_tx_mst_reset_done_out


  # Create instance: conct_tx_usr_clk2, and set properties
  set conct_tx_usr_clk2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 conct_tx_usr_clk2 ]
  set_property CONFIG.NUM_PORTS {4} $conct_tx_usr_clk2


  # Create instance: gt_axi_apb_bridge_0, and set properties
  set gt_axi_apb_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge:3.0 gt_axi_apb_bridge_0 ]
  set_property CONFIG.C_APB_NUM_SLAVES {1} $gt_axi_apb_bridge_0


  # Create instance: gt_bufg_gt_refclk_fwd, and set properties
  set gt_bufg_gt_refclk_fwd [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_refclk_fwd ]
  set_property CONFIG.FREQ_HZ {322265625} $gt_bufg_gt_refclk_fwd


  # Create instance: gt_bufg_gt_rxoutclk_div2_ch0, and set properties
  set gt_bufg_gt_rxoutclk_div2_ch0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_rxoutclk_div2_ch0 ]

  # Create instance: gt_bufg_gt_rxoutclk_div2_ch1, and set properties
  set gt_bufg_gt_rxoutclk_div2_ch1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_rxoutclk_div2_ch1 ]

  # Create instance: gt_bufg_gt_rxoutclk_div2_ch2, and set properties
  set gt_bufg_gt_rxoutclk_div2_ch2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_rxoutclk_div2_ch2 ]

  # Create instance: gt_bufg_gt_rxoutclk_div2_ch3, and set properties
  set gt_bufg_gt_rxoutclk_div2_ch3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_rxoutclk_div2_ch3 ]

  # Create instance: gt_bufg_gt_txoutclk_div2_ch0, and set properties
  set gt_bufg_gt_txoutclk_div2_ch0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_txoutclk_div2_ch0 ]

  # Create instance: gt_bufg_gt_txoutclk_div2_ch2, and set properties
  set gt_bufg_gt_txoutclk_div2_ch2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 gt_bufg_gt_txoutclk_div2_ch2 ]

  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {99.999908} \
    CONFIG.CHANNEL_ORDERING {/GT_WRAPPER/gt_quad_base/TX0_GT_IP_Interface mrmac_subsys_mrmac_0_core_0_0./mrmac_0_core/gt_tx_serdes_interface_0.0 /GT_WRAPPER/gt_quad_base/TX1_GT_IP_Interface mrmac_subsys_mrmac_0_core_0_1./mrmac_0_core/gt_tx_serdes_interface_1.1\
/GT_WRAPPER/gt_quad_base/TX2_GT_IP_Interface mrmac_subsys_mrmac_0_core_0_2./mrmac_0_core/gt_tx_serdes_interface_2.2 /GT_WRAPPER/gt_quad_base/TX3_GT_IP_Interface mrmac_subsys_mrmac_0_core_0_3./mrmac_0_core/gt_tx_serdes_interface_3.3\
/GT_WRAPPER/gt_quad_base/RX0_GT_IP_Interface mrmac_subsys_mrmac_0_core_0_0./mrmac_0_core/gt_rx_serdes_interface_0.0 /GT_WRAPPER/gt_quad_base/RX1_GT_IP_Interface mrmac_subsys_mrmac_0_core_0_1./mrmac_0_core/gt_rx_serdes_interface_1.1\
/GT_WRAPPER/gt_quad_base/RX2_GT_IP_Interface mrmac_subsys_mrmac_0_core_0_2./mrmac_0_core/gt_rx_serdes_interface_2.2 /GT_WRAPPER/gt_quad_base/RX3_GT_IP_Interface mrmac_subsys_mrmac_0_core_0_3./mrmac_0_core/gt_rx_serdes_interface_3.3}\
\
    CONFIG.GT_TYPE {GTY} \
    CONFIG.PORTS_INFO_DICT { LANE_SEL_DICT {PROT0 {RX0 TX0} PROT1 {RX1 TX1} PROT2 {RX2 TX2} PROT3 {RX3 TX3}} GT_TYPE {GTY} REG_CONF_INTF {APB3_INTF} BOARD_PARAMETER {} } \
    CONFIG.PROT0_ENABLE {true} \
    CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT0_LR0_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 25.78125 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW\
RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO\
RX_COUPLING AC RX_TERMINATION PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL\
1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0\
false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3\
0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1\
false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ\
1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false\
RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2\
false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3 0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1\
false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000\
RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE\
ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT0_LR10_SETTINGS {NA NA} \
    CONFIG.PROT0_LR11_SETTINGS {NA NA} \
    CONFIG.PROT0_LR12_SETTINGS {NA NA} \
    CONFIG.PROT0_LR13_SETTINGS {NA NA} \
    CONFIG.PROT0_LR14_SETTINGS {NA NA} \
    CONFIG.PROT0_LR15_SETTINGS {NA NA} \
    CONFIG.PROT0_LR1_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 10.3125 TX_PLL_TYPE RPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 32 TX_INT_DATA_WIDTH 32 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE RPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 10.3125 RX_PLL_TYPE RPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH\
32 RX_INT_DATA_WIDTH 32 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE RPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION\
PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000\
RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 00000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false\
RX_CB_VAL_0_1 00000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 00000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 00000000 RX_CB_K_0_3\
false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 00000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 00000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2\
false RX_CB_VAL_1_2 00000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 00000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY\
5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 00000000\
RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 00000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 00000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false\
RX_CC_MASK_0_3 false RX_CC_VAL_0_3 00000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 00000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1\
00000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 00000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 00000000 RX_CC_K_1_3 false RX_CC_DISP_1_3\
false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 6.1862627 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN\
DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT0_LR2_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 25.78125 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW\
RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO\
RX_COUPLING AC RX_TERMINATION PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL\
1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0\
false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3\
0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1\
false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ\
1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false\
RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2\
false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3 0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1\
false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000\
RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE\
ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT0_LR3_SETTINGS {NA NA} \
    CONFIG.PROT0_LR4_SETTINGS {NA NA} \
    CONFIG.PROT0_LR5_SETTINGS {NA NA} \
    CONFIG.PROT0_LR6_SETTINGS {NA NA} \
    CONFIG.PROT0_LR7_SETTINGS {NA NA} \
    CONFIG.PROT0_LR8_SETTINGS {NA NA} \
    CONFIG.PROT0_LR9_SETTINGS {NA NA} \
    CONFIG.PROT0_NO_OF_LANES {1} \
    CONFIG.PROT0_PRESET {None} \
    CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
    CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
    CONFIG.PROT1_ENABLE {true} \
    CONFIG.PROT1_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT1_LR0_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 25.78125 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW\
RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO\
RX_COUPLING AC RX_TERMINATION PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL\
1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0\
false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3\
0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1\
false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ\
1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false\
RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2\
false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3 0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1\
false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000\
RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE\
ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT1_LR10_SETTINGS {NA NA} \
    CONFIG.PROT1_LR11_SETTINGS {NA NA} \
    CONFIG.PROT1_LR12_SETTINGS {NA NA} \
    CONFIG.PROT1_LR13_SETTINGS {NA NA} \
    CONFIG.PROT1_LR14_SETTINGS {NA NA} \
    CONFIG.PROT1_LR15_SETTINGS {NA NA} \
    CONFIG.PROT1_LR1_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 10.3125 TX_PLL_TYPE RPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 32 TX_INT_DATA_WIDTH 32 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE RPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 10.3125 RX_PLL_TYPE RPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH\
32 RX_INT_DATA_WIDTH 32 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE RPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION\
PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000\
RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 00000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false\
RX_CB_VAL_0_1 00000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 00000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 00000000 RX_CB_K_0_3\
false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 00000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 00000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2\
false RX_CB_VAL_1_2 00000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 00000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY\
5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 00000000\
RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 00000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 00000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false\
RX_CC_MASK_0_3 false RX_CC_VAL_0_3 00000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 00000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1\
00000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 00000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 00000000 RX_CC_K_1_3 false RX_CC_DISP_1_3\
false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 6.1862627 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN\
DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT1_LR2_SETTINGS {NA NA} \
    CONFIG.PROT1_LR3_SETTINGS {NA NA} \
    CONFIG.PROT1_LR4_SETTINGS {NA NA} \
    CONFIG.PROT1_LR5_SETTINGS {NA NA} \
    CONFIG.PROT1_LR6_SETTINGS {NA NA} \
    CONFIG.PROT1_LR7_SETTINGS {NA NA} \
    CONFIG.PROT1_LR8_SETTINGS {NA NA} \
    CONFIG.PROT1_LR9_SETTINGS {NA NA} \
    CONFIG.PROT1_NO_OF_LANES {1} \
    CONFIG.PROT1_NO_OF_RX_LANES {1} \
    CONFIG.PROT1_NO_OF_TX_LANES {1} \
    CONFIG.PROT1_PRESET {None} \
    CONFIG.PROT1_RX_MASTERCLK_SRC {RX1} \
    CONFIG.PROT1_TX_MASTERCLK_SRC {TX1} \
    CONFIG.PROT2_ENABLE {true} \
    CONFIG.PROT2_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT2_LR0_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 25.78125 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW\
RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO\
RX_COUPLING AC RX_TERMINATION PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL\
1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0\
false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3\
0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1\
false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ\
1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false\
RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2\
false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3 0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1\
false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000\
RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE\
ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT2_LR10_SETTINGS {NA NA} \
    CONFIG.PROT2_LR11_SETTINGS {NA NA} \
    CONFIG.PROT2_LR12_SETTINGS {NA NA} \
    CONFIG.PROT2_LR13_SETTINGS {NA NA} \
    CONFIG.PROT2_LR14_SETTINGS {NA NA} \
    CONFIG.PROT2_LR15_SETTINGS {NA NA} \
    CONFIG.PROT2_LR1_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 10.3125 TX_PLL_TYPE RPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 32 TX_INT_DATA_WIDTH 32 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE RPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 10.3125 RX_PLL_TYPE RPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH\
32 RX_INT_DATA_WIDTH 32 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE RPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION\
PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000\
RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 00000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false\
RX_CB_VAL_0_1 00000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 00000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 00000000 RX_CB_K_0_3\
false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 00000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 00000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2\
false RX_CB_VAL_1_2 00000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 00000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY\
5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 00000000\
RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 00000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 00000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false\
RX_CC_MASK_0_3 false RX_CC_VAL_0_3 00000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 00000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1\
00000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 00000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 00000000 RX_CC_K_1_3 false RX_CC_DISP_1_3\
false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 6.1862627 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN\
DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT2_LR2_SETTINGS {NA NA} \
    CONFIG.PROT2_LR3_SETTINGS {NA NA} \
    CONFIG.PROT2_LR4_SETTINGS {NA NA} \
    CONFIG.PROT2_LR5_SETTINGS {NA NA} \
    CONFIG.PROT2_LR6_SETTINGS {NA NA} \
    CONFIG.PROT2_LR7_SETTINGS {NA NA} \
    CONFIG.PROT2_LR8_SETTINGS {NA NA} \
    CONFIG.PROT2_LR9_SETTINGS {NA NA} \
    CONFIG.PROT2_NO_OF_LANES {1} \
    CONFIG.PROT2_NO_OF_RX_LANES {1} \
    CONFIG.PROT2_NO_OF_TX_LANES {1} \
    CONFIG.PROT2_PRESET {None} \
    CONFIG.PROT2_RX_MASTERCLK_SRC {RX2} \
    CONFIG.PROT2_TX_MASTERCLK_SRC {TX2} \
    CONFIG.PROT3_ENABLE {true} \
    CONFIG.PROT3_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT3_LR0_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 25.78125 TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 80 TX_INT_DATA_WIDTH 80 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 25.78125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW\
RX_USER_DATA_WIDTH 80 RX_INT_DATA_WIDTH 80 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO\
RX_COUPLING AC RX_TERMINATION PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL\
1010000011 RX_COMMA_MASK 0000000000 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0\
false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3\
0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1\
false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ\
1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false\
RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2\
false RX_CC_DISP_0_2 false RX_CC_MASK_0_3 false RX_CC_VAL_0_3 0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1\
false RX_CC_VAL_1_1 0000000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000\
RX_CC_K_1_3 false RX_CC_DISP_1_3 false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE\
ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT3_LR10_SETTINGS {NA NA} \
    CONFIG.PROT3_LR11_SETTINGS {NA NA} \
    CONFIG.PROT3_LR12_SETTINGS {NA NA} \
    CONFIG.PROT3_LR13_SETTINGS {NA NA} \
    CONFIG.PROT3_LR14_SETTINGS {NA NA} \
    CONFIG.PROT3_LR15_SETTINGS {NA NA} \
    CONFIG.PROT3_LR1_SETTINGS { PRESET None RX_PAM_SEL NRZ TX_PAM_SEL NRZ RX_GRAY_BYP true TX_GRAY_BYP true RX_GRAY_LITTLEENDIAN true TX_GRAY_LITTLEENDIAN true RX_PRECODE_BYP true TX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN\
false TX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET None GT_TYPE GTY GT_DIRECTION DUPLEX TX_LINE_RATE 10.3125 TX_PLL_TYPE RPLL TX_REFCLK_FREQUENCY 322.265625 TX_ACTUAL_REFCLK_FREQUENCY 322.265625000000\
TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH 32 TX_INT_DATA_WIDTH 32 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE\
TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE RPLL TXPROGDIV_FREQ_VAL 644.531 TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP\
A RX_LINE_RATE 10.3125 RX_PLL_TYPE RPLL RX_REFCLK_FREQUENCY 322.265625 RX_ACTUAL_REFCLK_FREQUENCY 322.265625000000 RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH\
32 RX_INT_DATA_WIDTH 32 RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE RPLL RXPROGDIV_FREQ_VAL 644.531 INS_LOSS_NYQ 20 RX_EQ_MODE AUTO RX_COUPLING AC RX_TERMINATION\
PROGRAMMABLE RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 0 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD 1 RX_COMMA_SHOW_REALIGN_ENABLE\
true PCIE_ENABLE false TX_LANE_DESKEW_HDMI_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000\
RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 00000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false\
RX_CB_VAL_0_1 00000000 RX_CB_K_0_1 false RX_CB_DISP_0_1 false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 00000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 00000000 RX_CB_K_0_3\
false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0 00000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 00000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2\
false RX_CB_VAL_1_2 00000000 RX_CB_K_1_2 false RX_CB_DISP_1_2 false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 00000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY\
5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 00000000\
RX_CC_K_0_0 false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 00000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 00000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false\
RX_CC_MASK_0_3 false RX_CC_VAL_0_3 00000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 00000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1\
00000000 RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 00000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 00000000 RX_CC_K_1_3 false RX_CC_DISP_1_3\
false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 6.1862627 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN\
DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0} \
    CONFIG.PROT3_LR2_SETTINGS {NA NA} \
    CONFIG.PROT3_LR3_SETTINGS {NA NA} \
    CONFIG.PROT3_LR4_SETTINGS {NA NA} \
    CONFIG.PROT3_LR5_SETTINGS {NA NA} \
    CONFIG.PROT3_LR6_SETTINGS {NA NA} \
    CONFIG.PROT3_LR7_SETTINGS {NA NA} \
    CONFIG.PROT3_LR8_SETTINGS {NA NA} \
    CONFIG.PROT3_LR9_SETTINGS {NA NA} \
    CONFIG.PROT3_NO_OF_LANES {1} \
    CONFIG.PROT3_NO_OF_RX_LANES {1} \
    CONFIG.PROT3_NO_OF_TX_LANES {1} \
    CONFIG.PROT3_PRESET {None} \
    CONFIG.PROT3_RX_MASTERCLK_SRC {RX3} \
    CONFIG.PROT3_TX_MASTERCLK_SRC {TX3} \
    CONFIG.PROT4_LR0_SETTINGS { GT_TYPE GTY GT_DIRECTION DUPLEX INS_LOSS_NYQ 20 INTERNAL_PRESET None OOB_ENABLE false PCIE_ENABLE false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 PRESET None RESET_SEQUENCE_INTERVAL\
0 RXPROGDIV_FREQ_ENABLE false RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 322.265625 RX_64B66B_CRC false RX_RATE_GROUP A RX_64B66B_DECODER false RX_64B66B_DESCRAMBLER false RX_ACTUAL_REFCLK_FREQUENCY\
156.25 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_MODE 1 RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE\
RX_CB_DISP_0_0 false RX_CB_DISP_0_1 false RX_CB_DISP_0_2 false RX_CB_DISP_0_3 false RX_CB_DISP_1_0 false RX_CB_DISP_1_1 false RX_CB_DISP_1_2 false RX_CB_DISP_1_3 false RX_CB_K_0_0 false RX_CB_K_0_1 false\
RX_CB_K_0_2 false RX_CB_K_0_3 false RX_CB_K_1_0 false RX_CB_K_1_1 false RX_CB_K_1_2 false RX_CB_K_1_3 false RX_CB_LEN_SEQ 1 RX_CB_MASK_0_0 false RX_CB_MASK_0_1 false RX_CB_MASK_0_2 false RX_CB_MASK_0_3\
false RX_CB_MASK_1_0 false RX_CB_MASK_1_1 false RX_CB_MASK_1_2 false RX_CB_MASK_1_3 false RX_CB_MAX_LEVEL 1 RX_CB_MAX_SKEW 1 RX_CB_NUM_SEQ 0 RX_CB_VAL_0_0 00000000 RX_CB_VAL_0_1 00000000 RX_CB_VAL_0_2\
00000000 RX_CB_VAL_0_3 00000000 RX_CB_VAL_1_0 00000000 RX_CB_VAL_1_1 00000000 RX_CB_VAL_1_2 00000000 RX_CB_VAL_1_3 00000000 RX_CC_DISP_0_0 false RX_CC_DISP_0_1 false RX_CC_DISP_0_2 false RX_CC_DISP_0_3\
false RX_CC_DISP_1_0 false RX_CC_DISP_1_1 false RX_CC_DISP_1_2 false RX_CC_DISP_1_3 false RX_CC_KEEP_IDLE DISABLE RX_CC_K_0_0 false RX_CC_K_0_1 false RX_CC_K_0_2 false RX_CC_K_0_3 false RX_CC_K_1_0 false\
RX_CC_K_1_1 false RX_CC_K_1_2 false RX_CC_K_1_3 false RX_CC_LEN_SEQ 1 RX_CC_MASK_0_0 false RX_CC_MASK_0_1 false RX_CC_MASK_0_2 false RX_CC_MASK_0_3 false RX_CC_MASK_1_0 false RX_CC_MASK_1_1 false RX_CC_MASK_1_2\
false RX_CC_MASK_1_3 false RX_CC_NUM_SEQ 0 RX_CC_PERIODICITY 5000 RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000\
RX_CC_VAL_0_0 0000000000 RX_CC_VAL_0_1 0000000000 RX_CC_VAL_0_2 0000000000 RX_CC_VAL_0_3 0000000000 RX_CC_VAL_1_0 0000000000 RX_CC_VAL_1_1 0000000000 RX_CC_VAL_1_2 0000000000 RX_CC_VAL_1_3 0000000000 RX_COMMA_ALIGN_WORD\
1 RX_COMMA_DOUBLE_ENABLE false RX_COMMA_MASK 1111111111 RX_COMMA_M_ENABLE false RX_COMMA_M_VAL 1010000011 RX_COMMA_PRESET NONE RX_COMMA_P_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_SHOW_REALIGN_ENABLE\
true RX_COMMA_VALID_ONLY 0 RX_COUPLING AC RX_DATA_DECODING RAW RX_EQ_MODE AUTO RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_INT_DATA_WIDTH 32 RX_JTOL_FC 0 RX_JTOL_LF_SLOPE -20 RX_LINE_RATE 10.3125 RX_OUTCLK_SOURCE\
RXOUTCLKPMA RX_PLL_TYPE LCPLL RX_PPM_OFFSET 0 RX_REFCLK_FREQUENCY 156.25 RX_REFCLK_SOURCE R0 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_TERMINATION PROGRAMMABLE RX_TERMINATION_PROG_VALUE 800 RX_USER_DATA_WIDTH\
32 TXPROGDIV_FREQ_ENABLE false TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 322.265625 TX_64B66B_CRC false TX_RATE_GROUP A TX_64B66B_ENCODER false TX_64B66B_SCRAMBLER false TX_ACTUAL_REFCLK_FREQUENCY\
156.25 TX_BUFFER_BYPASS_MODE Fast_Sync TX_BUFFER_MODE 1 TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_DATA_ENCODING RAW TX_DIFF_SWING_EMPH_MODE CUSTOM TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_INT_DATA_WIDTH\
32 TX_LINE_RATE 10.3125 TX_OUTCLK_SOURCE TXOUTCLKPMA TX_PIPM_ENABLE false TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 156.25 TX_REFCLK_SOURCE R0 TX_USER_DATA_WIDTH 32} \
    CONFIG.PROT5_LR0_SETTINGS { GT_TYPE GTY GT_DIRECTION DUPLEX INS_LOSS_NYQ 20 INTERNAL_PRESET None OOB_ENABLE false PCIE_ENABLE false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 PRESET None RESET_SEQUENCE_INTERVAL\
0 RXPROGDIV_FREQ_ENABLE false RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 322.265625 RX_64B66B_CRC false RX_RATE_GROUP A RX_64B66B_DECODER false RX_64B66B_DESCRAMBLER false RX_ACTUAL_REFCLK_FREQUENCY\
156.25 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_MODE 1 RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE\
RX_CB_DISP_0_0 false RX_CB_DISP_0_1 false RX_CB_DISP_0_2 false RX_CB_DISP_0_3 false RX_CB_DISP_1_0 false RX_CB_DISP_1_1 false RX_CB_DISP_1_2 false RX_CB_DISP_1_3 false RX_CB_K_0_0 false RX_CB_K_0_1 false\
RX_CB_K_0_2 false RX_CB_K_0_3 false RX_CB_K_1_0 false RX_CB_K_1_1 false RX_CB_K_1_2 false RX_CB_K_1_3 false RX_CB_LEN_SEQ 1 RX_CB_MASK_0_0 false RX_CB_MASK_0_1 false RX_CB_MASK_0_2 false RX_CB_MASK_0_3\
false RX_CB_MASK_1_0 false RX_CB_MASK_1_1 false RX_CB_MASK_1_2 false RX_CB_MASK_1_3 false RX_CB_MAX_LEVEL 1 RX_CB_MAX_SKEW 1 RX_CB_NUM_SEQ 0 RX_CB_VAL_0_0 00000000 RX_CB_VAL_0_1 00000000 RX_CB_VAL_0_2\
00000000 RX_CB_VAL_0_3 00000000 RX_CB_VAL_1_0 00000000 RX_CB_VAL_1_1 00000000 RX_CB_VAL_1_2 00000000 RX_CB_VAL_1_3 00000000 RX_CC_DISP_0_0 false RX_CC_DISP_0_1 false RX_CC_DISP_0_2 false RX_CC_DISP_0_3\
false RX_CC_DISP_1_0 false RX_CC_DISP_1_1 false RX_CC_DISP_1_2 false RX_CC_DISP_1_3 false RX_CC_KEEP_IDLE DISABLE RX_CC_K_0_0 false RX_CC_K_0_1 false RX_CC_K_0_2 false RX_CC_K_0_3 false RX_CC_K_1_0 false\
RX_CC_K_1_1 false RX_CC_K_1_2 false RX_CC_K_1_3 false RX_CC_LEN_SEQ 1 RX_CC_MASK_0_0 false RX_CC_MASK_0_1 false RX_CC_MASK_0_2 false RX_CC_MASK_0_3 false RX_CC_MASK_1_0 false RX_CC_MASK_1_1 false RX_CC_MASK_1_2\
false RX_CC_MASK_1_3 false RX_CC_NUM_SEQ 0 RX_CC_PERIODICITY 5000 RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000\
RX_CC_VAL_0_0 0000000000 RX_CC_VAL_0_1 0000000000 RX_CC_VAL_0_2 0000000000 RX_CC_VAL_0_3 0000000000 RX_CC_VAL_1_0 0000000000 RX_CC_VAL_1_1 0000000000 RX_CC_VAL_1_2 0000000000 RX_CC_VAL_1_3 0000000000 RX_COMMA_ALIGN_WORD\
1 RX_COMMA_DOUBLE_ENABLE false RX_COMMA_MASK 1111111111 RX_COMMA_M_ENABLE false RX_COMMA_M_VAL 1010000011 RX_COMMA_PRESET NONE RX_COMMA_P_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_SHOW_REALIGN_ENABLE\
true RX_COMMA_VALID_ONLY 0 RX_COUPLING AC RX_DATA_DECODING RAW RX_EQ_MODE AUTO RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_INT_DATA_WIDTH 32 RX_JTOL_FC 0 RX_JTOL_LF_SLOPE -20 RX_LINE_RATE 10.3125 RX_OUTCLK_SOURCE\
RXOUTCLKPMA RX_PLL_TYPE LCPLL RX_PPM_OFFSET 0 RX_REFCLK_FREQUENCY 156.25 RX_REFCLK_SOURCE R0 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_TERMINATION PROGRAMMABLE RX_TERMINATION_PROG_VALUE 800 RX_USER_DATA_WIDTH\
32 TXPROGDIV_FREQ_ENABLE false TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 322.265625 TX_64B66B_CRC false TX_RATE_GROUP A TX_64B66B_ENCODER false TX_64B66B_SCRAMBLER false TX_ACTUAL_REFCLK_FREQUENCY\
156.25 TX_BUFFER_BYPASS_MODE Fast_Sync TX_BUFFER_MODE 1 TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_DATA_ENCODING RAW TX_DIFF_SWING_EMPH_MODE CUSTOM TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_INT_DATA_WIDTH\
32 TX_LINE_RATE 10.3125 TX_OUTCLK_SOURCE TXOUTCLKPMA TX_PIPM_ENABLE false TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 156.25 TX_REFCLK_SOURCE R0 TX_USER_DATA_WIDTH 32} \
    CONFIG.PROT6_LR0_SETTINGS { GT_TYPE GTY GT_DIRECTION DUPLEX INS_LOSS_NYQ 20 INTERNAL_PRESET None OOB_ENABLE false PCIE_ENABLE false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 PRESET None RESET_SEQUENCE_INTERVAL\
0 RXPROGDIV_FREQ_ENABLE false RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 322.265625 RX_64B66B_CRC false RX_RATE_GROUP A RX_64B66B_DECODER false RX_64B66B_DESCRAMBLER false RX_ACTUAL_REFCLK_FREQUENCY\
156.25 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_MODE 1 RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE\
RX_CB_DISP_0_0 false RX_CB_DISP_0_1 false RX_CB_DISP_0_2 false RX_CB_DISP_0_3 false RX_CB_DISP_1_0 false RX_CB_DISP_1_1 false RX_CB_DISP_1_2 false RX_CB_DISP_1_3 false RX_CB_K_0_0 false RX_CB_K_0_1 false\
RX_CB_K_0_2 false RX_CB_K_0_3 false RX_CB_K_1_0 false RX_CB_K_1_1 false RX_CB_K_1_2 false RX_CB_K_1_3 false RX_CB_LEN_SEQ 1 RX_CB_MASK_0_0 false RX_CB_MASK_0_1 false RX_CB_MASK_0_2 false RX_CB_MASK_0_3\
false RX_CB_MASK_1_0 false RX_CB_MASK_1_1 false RX_CB_MASK_1_2 false RX_CB_MASK_1_3 false RX_CB_MAX_LEVEL 1 RX_CB_MAX_SKEW 1 RX_CB_NUM_SEQ 0 RX_CB_VAL_0_0 00000000 RX_CB_VAL_0_1 00000000 RX_CB_VAL_0_2\
00000000 RX_CB_VAL_0_3 00000000 RX_CB_VAL_1_0 00000000 RX_CB_VAL_1_1 00000000 RX_CB_VAL_1_2 00000000 RX_CB_VAL_1_3 00000000 RX_CC_DISP_0_0 false RX_CC_DISP_0_1 false RX_CC_DISP_0_2 false RX_CC_DISP_0_3\
false RX_CC_DISP_1_0 false RX_CC_DISP_1_1 false RX_CC_DISP_1_2 false RX_CC_DISP_1_3 false RX_CC_KEEP_IDLE DISABLE RX_CC_K_0_0 false RX_CC_K_0_1 false RX_CC_K_0_2 false RX_CC_K_0_3 false RX_CC_K_1_0 false\
RX_CC_K_1_1 false RX_CC_K_1_2 false RX_CC_K_1_3 false RX_CC_LEN_SEQ 1 RX_CC_MASK_0_0 false RX_CC_MASK_0_1 false RX_CC_MASK_0_2 false RX_CC_MASK_0_3 false RX_CC_MASK_1_0 false RX_CC_MASK_1_1 false RX_CC_MASK_1_2\
false RX_CC_MASK_1_3 false RX_CC_NUM_SEQ 0 RX_CC_PERIODICITY 5000 RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000\
RX_CC_VAL_0_0 0000000000 RX_CC_VAL_0_1 0000000000 RX_CC_VAL_0_2 0000000000 RX_CC_VAL_0_3 0000000000 RX_CC_VAL_1_0 0000000000 RX_CC_VAL_1_1 0000000000 RX_CC_VAL_1_2 0000000000 RX_CC_VAL_1_3 0000000000 RX_COMMA_ALIGN_WORD\
1 RX_COMMA_DOUBLE_ENABLE false RX_COMMA_MASK 1111111111 RX_COMMA_M_ENABLE false RX_COMMA_M_VAL 1010000011 RX_COMMA_PRESET NONE RX_COMMA_P_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_SHOW_REALIGN_ENABLE\
true RX_COMMA_VALID_ONLY 0 RX_COUPLING AC RX_DATA_DECODING RAW RX_EQ_MODE AUTO RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_INT_DATA_WIDTH 32 RX_JTOL_FC 0 RX_JTOL_LF_SLOPE -20 RX_LINE_RATE 10.3125 RX_OUTCLK_SOURCE\
RXOUTCLKPMA RX_PLL_TYPE LCPLL RX_PPM_OFFSET 0 RX_REFCLK_FREQUENCY 156.25 RX_REFCLK_SOURCE R0 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_TERMINATION PROGRAMMABLE RX_TERMINATION_PROG_VALUE 800 RX_USER_DATA_WIDTH\
32 TXPROGDIV_FREQ_ENABLE false TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 322.265625 TX_64B66B_CRC false TX_RATE_GROUP A TX_64B66B_ENCODER false TX_64B66B_SCRAMBLER false TX_ACTUAL_REFCLK_FREQUENCY\
156.25 TX_BUFFER_BYPASS_MODE Fast_Sync TX_BUFFER_MODE 1 TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_DATA_ENCODING RAW TX_DIFF_SWING_EMPH_MODE CUSTOM TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_INT_DATA_WIDTH\
32 TX_LINE_RATE 10.3125 TX_OUTCLK_SOURCE TXOUTCLKPMA TX_PIPM_ENABLE false TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 156.25 TX_REFCLK_SOURCE R0 TX_USER_DATA_WIDTH 32} \
    CONFIG.PROT7_LR0_SETTINGS { GT_TYPE GTY GT_DIRECTION DUPLEX INS_LOSS_NYQ 20 INTERNAL_PRESET None OOB_ENABLE false PCIE_ENABLE false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 PRESET None RESET_SEQUENCE_INTERVAL\
0 RXPROGDIV_FREQ_ENABLE false RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 322.265625 RX_64B66B_CRC false RX_RATE_GROUP A RX_64B66B_DECODER false RX_64B66B_DESCRAMBLER false RX_ACTUAL_REFCLK_FREQUENCY\
156.25 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_MODE 1 RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE\
RX_CB_DISP_0_0 false RX_CB_DISP_0_1 false RX_CB_DISP_0_2 false RX_CB_DISP_0_3 false RX_CB_DISP_1_0 false RX_CB_DISP_1_1 false RX_CB_DISP_1_2 false RX_CB_DISP_1_3 false RX_CB_K_0_0 false RX_CB_K_0_1 false\
RX_CB_K_0_2 false RX_CB_K_0_3 false RX_CB_K_1_0 false RX_CB_K_1_1 false RX_CB_K_1_2 false RX_CB_K_1_3 false RX_CB_LEN_SEQ 1 RX_CB_MASK_0_0 false RX_CB_MASK_0_1 false RX_CB_MASK_0_2 false RX_CB_MASK_0_3\
false RX_CB_MASK_1_0 false RX_CB_MASK_1_1 false RX_CB_MASK_1_2 false RX_CB_MASK_1_3 false RX_CB_MAX_LEVEL 1 RX_CB_MAX_SKEW 1 RX_CB_NUM_SEQ 0 RX_CB_VAL_0_0 00000000 RX_CB_VAL_0_1 00000000 RX_CB_VAL_0_2\
00000000 RX_CB_VAL_0_3 00000000 RX_CB_VAL_1_0 00000000 RX_CB_VAL_1_1 00000000 RX_CB_VAL_1_2 00000000 RX_CB_VAL_1_3 00000000 RX_CC_DISP_0_0 false RX_CC_DISP_0_1 false RX_CC_DISP_0_2 false RX_CC_DISP_0_3\
false RX_CC_DISP_1_0 false RX_CC_DISP_1_1 false RX_CC_DISP_1_2 false RX_CC_DISP_1_3 false RX_CC_KEEP_IDLE DISABLE RX_CC_K_0_0 false RX_CC_K_0_1 false RX_CC_K_0_2 false RX_CC_K_0_3 false RX_CC_K_1_0 false\
RX_CC_K_1_1 false RX_CC_K_1_2 false RX_CC_K_1_3 false RX_CC_LEN_SEQ 1 RX_CC_MASK_0_0 false RX_CC_MASK_0_1 false RX_CC_MASK_0_2 false RX_CC_MASK_0_3 false RX_CC_MASK_1_0 false RX_CC_MASK_1_1 false RX_CC_MASK_1_2\
false RX_CC_MASK_1_3 false RX_CC_NUM_SEQ 0 RX_CC_PERIODICITY 5000 RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT 0 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000\
RX_CC_VAL_0_0 0000000000 RX_CC_VAL_0_1 0000000000 RX_CC_VAL_0_2 0000000000 RX_CC_VAL_0_3 0000000000 RX_CC_VAL_1_0 0000000000 RX_CC_VAL_1_1 0000000000 RX_CC_VAL_1_2 0000000000 RX_CC_VAL_1_3 0000000000 RX_COMMA_ALIGN_WORD\
1 RX_COMMA_DOUBLE_ENABLE false RX_COMMA_MASK 1111111111 RX_COMMA_M_ENABLE false RX_COMMA_M_VAL 1010000011 RX_COMMA_PRESET NONE RX_COMMA_P_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_SHOW_REALIGN_ENABLE\
true RX_COMMA_VALID_ONLY 0 RX_COUPLING AC RX_DATA_DECODING RAW RX_EQ_MODE AUTO RX_FRACN_ENABLED false RX_FRACN_NUMERATOR 0 RX_INT_DATA_WIDTH 32 RX_JTOL_FC 0 RX_JTOL_LF_SLOPE -20 RX_LINE_RATE 10.3125 RX_OUTCLK_SOURCE\
RXOUTCLKPMA RX_PLL_TYPE LCPLL RX_PPM_OFFSET 0 RX_REFCLK_FREQUENCY 156.25 RX_REFCLK_SOURCE R0 RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_TERMINATION PROGRAMMABLE RX_TERMINATION_PROG_VALUE 800 RX_USER_DATA_WIDTH\
32 TXPROGDIV_FREQ_ENABLE false TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 322.265625 TX_64B66B_CRC false TX_RATE_GROUP A TX_64B66B_ENCODER false TX_64B66B_SCRAMBLER false TX_ACTUAL_REFCLK_FREQUENCY\
156.25 TX_BUFFER_BYPASS_MODE Fast_Sync TX_BUFFER_MODE 1 TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE TX_DATA_ENCODING RAW TX_DIFF_SWING_EMPH_MODE CUSTOM TX_FRACN_ENABLED false TX_FRACN_NUMERATOR 0 TX_INT_DATA_WIDTH\
32 TX_LINE_RATE 10.3125 TX_OUTCLK_SOURCE TXOUTCLKPMA TX_PIPM_ENABLE false TX_PLL_TYPE LCPLL TX_REFCLK_FREQUENCY 156.25 TX_REFCLK_SOURCE R0 TX_USER_DATA_WIDTH 32} \
    CONFIG.PROT_OUTCLK_VALUES {CH0_RXOUTCLK 644.531 CH0_TXOUTCLK 644.531 CH1_RXOUTCLK 644.531 CH1_TXOUTCLK 644.531 CH2_RXOUTCLK 644.531 CH2_TXOUTCLK 644.531 CH3_RXOUTCLK 644.531 CH3_TXOUTCLK 644.531} \
    CONFIG.QUAD_USAGE {TX_QUAD_CH {TXQuad_0_/GT_WRAPPER/gt_quad_base {/GT_WRAPPER/gt_quad_base mrmac_subsys_mrmac_0_core_0_0.IP_CH0,mrmac_subsys_mrmac_0_core_0_1.IP_CH1,mrmac_subsys_mrmac_0_core_0_2.IP_CH2,mrmac_subsys_mrmac_0_core_0_3.IP_CH3\
MSTRCLK 1,1,1,1 IS_CURRENT_QUAD 1}} RX_QUAD_CH {RXQuad_0_/GT_WRAPPER/gt_quad_base {/GT_WRAPPER/gt_quad_base mrmac_subsys_mrmac_0_core_0_0.IP_CH0,mrmac_subsys_mrmac_0_core_0_1.IP_CH1,mrmac_subsys_mrmac_0_core_0_2.IP_CH2,mrmac_subsys_mrmac_0_core_0_3.IP_CH3\
MSTRCLK 1,1,1,1 IS_CURRENT_QUAD 1}}} \
    CONFIG.REFCLK_LIST {{/CLK_IN_D_clk_p[0]} {/CLK_IN_D_clk_p[0]}} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_PROT1_R0_322.265625_MHz_unique1 HSCLK0_RPLLGTREFCLK0 refclk_PROT0_R0_PROT1_R0_322.265625_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT2_R0_PROT3_R0_322.265625_MHz_unique1\
HSCLK1_RPLLGTREFCLK0 refclk_PROT2_R0_PROT3_R0_322.265625_MHz_unique1} \
    CONFIG.REG_CONF_INTF {APB3_INTF} \
    CONFIG.RX0_LANE_SEL {PROT0} \
    CONFIG.RX1_LANE_SEL {PROT1} \
    CONFIG.RX2_LANE_SEL {PROT2} \
    CONFIG.RX3_LANE_SEL {PROT3} \
    CONFIG.TX0_LANE_SEL {PROT0} \
    CONFIG.TX1_LANE_SEL {PROT1} \
    CONFIG.TX2_LANE_SEL {PROT2} \
    CONFIG.TX3_LANE_SEL {PROT3} \
  ] $gt_quad_base

  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY.VALUE_MODE {auto} \
    CONFIG.CHANNEL_ORDERING.VALUE_MODE {auto} \
    CONFIG.PROT0_ENABLE.VALUE_MODE {auto} \
    CONFIG.PROT0_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT1_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT2_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT3_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.QUAD_USAGE.VALUE_MODE {auto} \
    CONFIG.REFCLK_LIST.VALUE_MODE {auto} \
  ] $gt_quad_base


  # Create instance: gt_rate_ctl_ch0_tx_rx, and set properties
  set gt_rate_ctl_ch0_tx_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_rate_ctl_ch0_tx_rx ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DOUT_WIDTH {8} \
  ] $gt_rate_ctl_ch0_tx_rx


  # Create instance: gt_rate_ctl_ch1_tx_rx, and set properties
  set gt_rate_ctl_ch1_tx_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_rate_ctl_ch1_tx_rx ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {8} \
  ] $gt_rate_ctl_ch1_tx_rx


  # Create instance: gt_rate_ctl_ch2_tx_rx, and set properties
  set gt_rate_ctl_ch2_tx_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_rate_ctl_ch2_tx_rx ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {8} \
  ] $gt_rate_ctl_ch2_tx_rx


  # Create instance: gt_rate_ctl_ch3_tx_rx, and set properties
  set gt_rate_ctl_ch3_tx_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gt_rate_ctl_ch3_tx_rx ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {8} \
  ] $gt_rate_ctl_ch3_tx_rx


  # Create instance: mrmac_obuf_ds_gte5_0, and set properties
  set mrmac_obuf_ds_gte5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mrmac_obuf_ds_gte5_0 ]
  set_property CONFIG.C_BUF_TYPE {OBUFDS_GTE} $mrmac_obuf_ds_gte5_0


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {5} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {4} \
    CONFIG.IN1_WIDTH {4} \
  ] $xlconcat_0


  # Create instance: xlconcat_gt_rest_all, and set properties
  set xlconcat_gt_rest_all [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_gt_rest_all ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_rest_all


  # Create instance: xlconcat_gt_rest_rx_datapath, and set properties
  set xlconcat_gt_rest_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_gt_rest_rx_datapath ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_rest_rx_datapath


  # Create instance: xlconcat_gt_rest_tx_datapath, and set properties
  set xlconcat_gt_rest_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_gt_rest_tx_datapath ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_gt_rest_tx_datapath


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlslice_gt_reset_all_0, and set properties
  set xlslice_gt_reset_all_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_all_0 ]
  set_property CONFIG.DIN_WIDTH {3} $xlslice_gt_reset_all_0


  # Create instance: xlslice_gt_reset_all_1, and set properties
  set xlslice_gt_reset_all_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_all_1 ]
  set_property CONFIG.DIN_WIDTH {3} $xlslice_gt_reset_all_1


  # Create instance: xlslice_gt_reset_all_2, and set properties
  set xlslice_gt_reset_all_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_all_2 ]
  set_property CONFIG.DIN_WIDTH {3} $xlslice_gt_reset_all_2


  # Create instance: xlslice_gt_reset_all_3, and set properties
  set xlslice_gt_reset_all_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_all_3 ]
  set_property CONFIG.DIN_WIDTH {3} $xlslice_gt_reset_all_3


  # Create instance: xlslice_gt_reset_rx_datapath_0, and set properties
  set xlslice_gt_reset_rx_datapath_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_rx_datapath_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_rx_datapath_0


  # Create instance: xlslice_gt_reset_rx_datapath_1, and set properties
  set xlslice_gt_reset_rx_datapath_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_rx_datapath_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_rx_datapath_1


  # Create instance: xlslice_gt_reset_rx_datapath_2, and set properties
  set xlslice_gt_reset_rx_datapath_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_rx_datapath_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_rx_datapath_2


  # Create instance: xlslice_gt_reset_rx_datapath_3, and set properties
  set xlslice_gt_reset_rx_datapath_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_rx_datapath_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_rx_datapath_3


  # Create instance: xlslice_gt_reset_tx_datapath_0, and set properties
  set xlslice_gt_reset_tx_datapath_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_tx_datapath_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_tx_datapath_0


  # Create instance: xlslice_gt_reset_tx_datapath_1, and set properties
  set xlslice_gt_reset_tx_datapath_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_tx_datapath_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_tx_datapath_1


  # Create instance: xlslice_gt_reset_tx_datapath_2, and set properties
  set xlslice_gt_reset_tx_datapath_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_tx_datapath_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_tx_datapath_2


  # Create instance: xlslice_gt_reset_tx_datapath_3, and set properties
  set xlslice_gt_reset_tx_datapath_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset_tx_datapath_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset_tx_datapath_3


  # Create instance: xlslice_rx_mst_dp_rst_0, and set properties
  set xlslice_rx_mst_dp_rst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_dp_rst_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_dp_rst_0


  # Create instance: xlslice_rx_mst_dp_rst_1, and set properties
  set xlslice_rx_mst_dp_rst_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_dp_rst_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_dp_rst_1


  # Create instance: xlslice_rx_mst_dp_rst_2, and set properties
  set xlslice_rx_mst_dp_rst_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_dp_rst_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_dp_rst_2


  # Create instance: xlslice_rx_mst_dp_rst_3, and set properties
  set xlslice_rx_mst_dp_rst_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_dp_rst_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_dp_rst_3


  # Create instance: xlslice_rx_mst_reset_0, and set properties
  set xlslice_rx_mst_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_reset_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_rx_mst_reset_0


  # Create instance: xlslice_rx_mst_reset_1, and set properties
  set xlslice_rx_mst_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_reset_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_reset_1


  # Create instance: xlslice_rx_mst_reset_2, and set properties
  set xlslice_rx_mst_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_reset_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_reset_2


  # Create instance: xlslice_rx_mst_reset_3, and set properties
  set xlslice_rx_mst_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_mst_reset_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_mst_reset_3


  # Create instance: xlslice_rx_userrdy_0, and set properties
  set xlslice_rx_userrdy_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_userrdy_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_rx_userrdy_0


  # Create instance: xlslice_rx_userrdy_1, and set properties
  set xlslice_rx_userrdy_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_userrdy_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_userrdy_1


  # Create instance: xlslice_rx_userrdy_2, and set properties
  set xlslice_rx_userrdy_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_userrdy_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_userrdy_2


  # Create instance: xlslice_rx_userrdy_3, and set properties
  set xlslice_rx_userrdy_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_userrdy_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_userrdy_3


  # Create instance: xlslice_tx_mst_dp_rst_0, and set properties
  set xlslice_tx_mst_dp_rst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_dp_rst_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_mst_dp_rst_0


  # Create instance: xlslice_tx_mst_dp_rst_1, and set properties
  set xlslice_tx_mst_dp_rst_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_dp_rst_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
  ] $xlslice_tx_mst_dp_rst_1


  # Create instance: xlslice_tx_mst_dp_rst_2, and set properties
  set xlslice_tx_mst_dp_rst_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_dp_rst_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_dp_rst_2


  # Create instance: xlslice_tx_mst_dp_rst_3, and set properties
  set xlslice_tx_mst_dp_rst_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_dp_rst_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_dp_rst_3


  # Create instance: xlslice_tx_mst_reset_0, and set properties
  set xlslice_tx_mst_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_reset_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_mst_reset_0


  # Create instance: xlslice_tx_mst_reset_1, and set properties
  set xlslice_tx_mst_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_reset_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_reset_1


  # Create instance: xlslice_tx_mst_reset_2, and set properties
  set xlslice_tx_mst_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_reset_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_reset_2


  # Create instance: xlslice_tx_mst_reset_3, and set properties
  set xlslice_tx_mst_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_mst_reset_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_mst_reset_3


  # Create instance: xlslice_tx_userrdy_0, and set properties
  set xlslice_tx_userrdy_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_userrdy_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_tx_userrdy_0


  # Create instance: xlslice_tx_userrdy_1, and set properties
  set xlslice_tx_userrdy_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_userrdy_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_userrdy_1


  # Create instance: xlslice_tx_userrdy_2, and set properties
  set xlslice_tx_userrdy_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_userrdy_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_userrdy_2


  # Create instance: xlslice_tx_userrdy_3, and set properties
  set xlslice_tx_userrdy_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_userrdy_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_userrdy_3


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_pins CLK_IN_D] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M [get_bd_intf_pins gt_axi_apb_bridge_0/APB_M] [get_bd_intf_pins gt_quad_base/APB3_INTF]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_0 [get_bd_intf_pins RX0_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_1 [get_bd_intf_pins RX1_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_2 [get_bd_intf_pins RX2_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_3 [get_bd_intf_pins RX3_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_0 [get_bd_intf_pins TX0_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_1 [get_bd_intf_pins TX1_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_2 [get_bd_intf_pins TX2_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_3 [get_bd_intf_pins TX3_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_gpio_gt_reset_mask/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins AXI4_LITE] [get_bd_intf_pins gt_axi_apb_bridge_0/AXI4_LITE]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI1 [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_1/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_2/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins axi_gpio_gt_rate_reset_ctl_3/S_AXI] [get_bd_intf_pins smartconnect_0/M04_AXI]

  # Create port connections
  connect_bd_net -net RX_MST_DP_RESET_1  [get_bd_pins RX_MST_DP_RESET] \
  [get_bd_pins xlslice_rx_mst_dp_rst_0/Din] \
  [get_bd_pins xlslice_rx_mst_dp_rst_1/Din] \
  [get_bd_pins xlslice_rx_mst_dp_rst_2/Din] \
  [get_bd_pins xlslice_rx_mst_dp_rst_3/Din]
  connect_bd_net -net TX_MST_DP_RESET_1  [get_bd_pins TX_MST_DP_RESET] \
  [get_bd_pins xlslice_tx_mst_dp_rst_0/Din] \
  [get_bd_pins xlslice_tx_mst_dp_rst_1/Din] \
  [get_bd_pins xlslice_tx_mst_dp_rst_2/Din] \
  [get_bd_pins xlslice_tx_mst_dp_rst_3/Din]
  connect_bd_net -net aresetn_1  [get_bd_pins aresetn] \
  [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net axi_gpio_1_gpio_io_o  [get_bd_pins gt_rate_ctl_ch1_tx_rx/Dout] \
  [get_bd_pins gt_quad_base/ch1_txrate] \
  [get_bd_pins gt_quad_base/ch1_rxrate]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_0_gpio2_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/gpio2_io_o] \
  [get_bd_pins xlslice_gt_reset_all_0/Din] \
  [get_bd_pins xlslice_gt_reset_rx_datapath_0/Din] \
  [get_bd_pins xlslice_gt_reset_tx_datapath_0/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_0_gpio_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/gpio_io_o] \
  [get_bd_pins gt_rate_ctl_ch0_tx_rx/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_1_gpio2_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_1/gpio2_io_o] \
  [get_bd_pins xlslice_gt_reset_all_1/Din] \
  [get_bd_pins xlslice_gt_reset_rx_datapath_1/Din] \
  [get_bd_pins xlslice_gt_reset_tx_datapath_1/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_1_gpio_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_1/gpio_io_o] \
  [get_bd_pins gt_rate_ctl_ch1_tx_rx/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_2_gpio2_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_2/gpio2_io_o] \
  [get_bd_pins xlslice_gt_reset_all_2/Din] \
  [get_bd_pins xlslice_gt_reset_rx_datapath_2/Din] \
  [get_bd_pins xlslice_gt_reset_tx_datapath_2/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_2_gpio_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_2/gpio_io_o] \
  [get_bd_pins gt_rate_ctl_ch2_tx_rx/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_3_gpio2_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_3/gpio2_io_o] \
  [get_bd_pins xlslice_gt_reset_all_3/Din] \
  [get_bd_pins xlslice_gt_reset_rx_datapath_3/Din] \
  [get_bd_pins xlslice_gt_reset_tx_datapath_3/Din]
  connect_bd_net -net axi_gpio_gt_rate_reset_ctl_3_gpio_io_o  [get_bd_pins axi_gpio_gt_rate_reset_ctl_3/gpio_io_o] \
  [get_bd_pins gt_rate_ctl_ch3_tx_rx/Din]
  connect_bd_net -net bufg_gt_div_val_dout  [get_bd_pins bufg_gt_div_val/dout] \
  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch0/gt_bufgtdiv] \
  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch1/gt_bufgtdiv] \
  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch2/gt_bufgtdiv] \
  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch3/gt_bufgtdiv] \
  [get_bd_pins gt_bufg_gt_txoutclk_div2_ch0/gt_bufgtdiv] \
  [get_bd_pins gt_bufg_gt_txoutclk_div2_ch2/gt_bufgtdiv]
  connect_bd_net -net bufg_gt_rxoutclk_rx_usr_clk  [get_bd_pins bufg_gt_rxoutclk/rx_usr_clk] \
  [get_bd_pins rx_usr_clk1]
  connect_bd_net -net bufg_gt_txoutclk_tx_usr_clk  [get_bd_pins bufg_gt_txoutclk/tx_usr_clk] \
  [get_bd_pins tx_usr_clk]
  connect_bd_net -net conct_rx_mst_reset_done_out1_dout  [get_bd_pins conct_tx_mst_reset_done_out/dout] \
  [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net conct_rx_mst_reset_done_out_dout  [get_bd_pins conct_rx_mst_reset_done_out/dout] \
  [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net conct_rx_usr_clk2_dout  [get_bd_pins conct_rx_usr_clk2/dout] \
  [get_bd_pins rx_usr_clk2]
  connect_bd_net -net conct_tx_usr_clk2_dout  [get_bd_pins conct_tx_usr_clk2/dout] \
  [get_bd_pins tx_usr_clk2]
  connect_bd_net -net gt_bufg_gt_refclk_fwd_usrclk  [get_bd_pins gt_bufg_gt_refclk_fwd/usrclk] \
  [get_bd_pins gt_refclk_div2_fwd]
  connect_bd_net -net gt_bufg_gt_rxoutclk_div2_ch0_usrclk  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch0/usrclk] \
  [get_bd_pins conct_rx_usr_clk2/In0] \
  [get_bd_pins gt_quad_base/ch0_rxusrclk]
  connect_bd_net -net gt_bufg_gt_rxoutclk_div2_ch1_usrclk  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch1/usrclk] \
  [get_bd_pins conct_rx_usr_clk2/In1] \
  [get_bd_pins gt_quad_base/ch1_rxusrclk]
  connect_bd_net -net gt_bufg_gt_rxoutclk_div2_ch2_usrclk  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch2/usrclk] \
  [get_bd_pins conct_rx_usr_clk2/In2] \
  [get_bd_pins gt_quad_base/ch2_rxusrclk]
  connect_bd_net -net gt_bufg_gt_rxoutclk_div2_ch3_usrclk  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch3/usrclk] \
  [get_bd_pins conct_rx_usr_clk2/In3] \
  [get_bd_pins gt_quad_base/ch3_rxusrclk]
  connect_bd_net -net gt_bufg_gt_txoutclk_div2_ch0_usrclk  [get_bd_pins gt_bufg_gt_txoutclk_div2_ch0/usrclk] \
  [get_bd_pins conct_tx_usr_clk2/In0] \
  [get_bd_pins conct_tx_usr_clk2/In1] \
  [get_bd_pins gt_quad_base/ch0_txusrclk] \
  [get_bd_pins gt_quad_base/ch1_txusrclk]
  connect_bd_net -net gt_bufg_gt_txoutclk_div2_ch2_usrclk  [get_bd_pins gt_bufg_gt_txoutclk_div2_ch2/usrclk] \
  [get_bd_pins conct_tx_usr_clk2/In2] \
  [get_bd_pins conct_tx_usr_clk2/In3] \
  [get_bd_pins gt_quad_base/ch2_txusrclk] \
  [get_bd_pins gt_quad_base/ch3_txusrclk]
  connect_bd_net -net gt_quad_base_ch0_rxmstresetdone  [get_bd_pins gt_quad_base/ch0_rxmstresetdone] \
  [get_bd_pins ch0_rxmstresetdone] \
  [get_bd_pins conct_rx_mst_reset_done_out/In0]
  connect_bd_net -net gt_quad_base_ch0_rxoutclk  [get_bd_pins gt_quad_base/ch0_rxoutclk] \
  [get_bd_pins bufg_gt_rxoutclk/outclk] \
  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch0/outclk]
  connect_bd_net -net gt_quad_base_ch0_rxpmaresetdone  [get_bd_pins gt_quad_base/ch0_rxpmaresetdone] \
  [get_bd_pins ch0_rxpmaresetdone]
  connect_bd_net -net gt_quad_base_ch0_txmstresetdone  [get_bd_pins gt_quad_base/ch0_txmstresetdone] \
  [get_bd_pins ch0_txmstresetdone] \
  [get_bd_pins conct_tx_mst_reset_done_out/In0]
  connect_bd_net -net gt_quad_base_ch0_txoutclk  [get_bd_pins gt_quad_base/ch0_txoutclk] \
  [get_bd_pins bufg_gt_txoutclk/outclk] \
  [get_bd_pins gt_bufg_gt_txoutclk_div2_ch0/outclk]
  connect_bd_net -net gt_quad_base_ch0_txpmaresetdone  [get_bd_pins gt_quad_base/ch0_txpmaresetdone] \
  [get_bd_pins ch0_txpmaresetdone]
  connect_bd_net -net gt_quad_base_ch1_rxmstresetdone  [get_bd_pins gt_quad_base/ch1_rxmstresetdone] \
  [get_bd_pins ch1_rxmstresetdone] \
  [get_bd_pins conct_rx_mst_reset_done_out/In1]
  connect_bd_net -net gt_quad_base_ch1_rxoutclk  [get_bd_pins gt_quad_base/ch1_rxoutclk] \
  [get_bd_pins bufg_gt_rxoutclk/outclk1] \
  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch1/outclk]
  connect_bd_net -net gt_quad_base_ch1_rxpmaresetdone  [get_bd_pins gt_quad_base/ch1_rxpmaresetdone] \
  [get_bd_pins ch1_rxpmaresetdone]
  connect_bd_net -net gt_quad_base_ch1_txmstresetdone  [get_bd_pins gt_quad_base/ch1_txmstresetdone] \
  [get_bd_pins ch1_txmstresetdone] \
  [get_bd_pins conct_tx_mst_reset_done_out/In1]
  connect_bd_net -net gt_quad_base_ch1_txpmaresetdone  [get_bd_pins gt_quad_base/ch1_txpmaresetdone] \
  [get_bd_pins ch1_txpmaresetdone]
  connect_bd_net -net gt_quad_base_ch2_rxmstresetdone  [get_bd_pins gt_quad_base/ch2_rxmstresetdone] \
  [get_bd_pins ch2_rxmstresetdone] \
  [get_bd_pins conct_rx_mst_reset_done_out/In2]
  connect_bd_net -net gt_quad_base_ch2_rxoutclk  [get_bd_pins gt_quad_base/ch2_rxoutclk] \
  [get_bd_pins bufg_gt_rxoutclk/outclk2] \
  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch2/outclk]
  connect_bd_net -net gt_quad_base_ch2_rxpmaresetdone  [get_bd_pins gt_quad_base/ch2_rxpmaresetdone] \
  [get_bd_pins ch2_rxpmaresetdone]
  connect_bd_net -net gt_quad_base_ch2_txmstresetdone  [get_bd_pins gt_quad_base/ch2_txmstresetdone] \
  [get_bd_pins ch2_txmstresetdone] \
  [get_bd_pins conct_tx_mst_reset_done_out/In2]
  connect_bd_net -net gt_quad_base_ch2_txoutclk  [get_bd_pins gt_quad_base/ch2_txoutclk] \
  [get_bd_pins bufg_gt_txoutclk/outclk2] \
  [get_bd_pins gt_bufg_gt_txoutclk_div2_ch2/outclk]
  connect_bd_net -net gt_quad_base_ch2_txpmaresetdone  [get_bd_pins gt_quad_base/ch2_txpmaresetdone] \
  [get_bd_pins ch2_txpmaresetdone]
  connect_bd_net -net gt_quad_base_ch3_rxmstresetdone  [get_bd_pins gt_quad_base/ch3_rxmstresetdone] \
  [get_bd_pins ch3_rxmstresetdone] \
  [get_bd_pins conct_rx_mst_reset_done_out/In3]
  connect_bd_net -net gt_quad_base_ch3_rxoutclk  [get_bd_pins gt_quad_base/ch3_rxoutclk] \
  [get_bd_pins bufg_gt_rxoutclk/outclk3] \
  [get_bd_pins gt_bufg_gt_rxoutclk_div2_ch3/outclk]
  connect_bd_net -net gt_quad_base_ch3_rxpmaresetdone  [get_bd_pins gt_quad_base/ch3_rxpmaresetdone] \
  [get_bd_pins ch3_rxpmaresetdone]
  connect_bd_net -net gt_quad_base_ch3_txmstresetdone  [get_bd_pins gt_quad_base/ch3_txmstresetdone] \
  [get_bd_pins ch3_txmstresetdone] \
  [get_bd_pins conct_tx_mst_reset_done_out/In3]
  connect_bd_net -net gt_quad_base_ch3_txpmaresetdone  [get_bd_pins gt_quad_base/ch3_txpmaresetdone] \
  [get_bd_pins ch3_txpmaresetdone]
  connect_bd_net -net gt_quad_base_gtpowergood  [get_bd_pins gt_quad_base/gtpowergood] \
  [get_bd_pins gtpowergood]
  connect_bd_net -net gt_quad_base_txn  [get_bd_pins gt_quad_base/txn] \
  [get_bd_pins gt_txn_out_0]
  connect_bd_net -net gt_quad_base_txp  [get_bd_pins gt_quad_base/txp] \
  [get_bd_pins gt_txp_out_0]
  connect_bd_net -net gt_rxn_in_0_1  [get_bd_pins gt_rxn_in_0] \
  [get_bd_pins gt_quad_base/rxn]
  connect_bd_net -net gt_rxp_in_0_1  [get_bd_pins gt_rxp_in_0] \
  [get_bd_pins gt_quad_base/rxp]
  connect_bd_net -net mrmac_obuf_ds_gte5_0_OBUFDS_GTE5_O  [get_bd_pins mrmac_obuf_ds_gte5_0/OBUFDS_GTE5_O] \
  [get_bd_pins RX_REC_CLK_out_p_0]
  connect_bd_net -net mrmac_obuf_ds_gte5_0_OBUFDS_GTE5_OB  [get_bd_pins mrmac_obuf_ds_gte5_0/OBUFDS_GTE5_OB] \
  [get_bd_pins RX_REC_CLK_out_n_0]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/s_axi_aresetn] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_1/s_axi_aresetn] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_2/s_axi_aresetn] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_3/s_axi_aresetn] \
  [get_bd_pins axi_gpio_gt_reset_mask/s_axi_aresetn] \
  [get_bd_pins gt_axi_apb_bridge_0/s_axi_aresetn] \
  [get_bd_pins gt_quad_base/apb3presetn]
  connect_bd_net -net rec_clk_out_out_ds_bufggt  [get_bd_pins gt_quad_base/hsclk0_rxrecclkout0] \
  [get_bd_pins mrmac_obuf_ds_gte5_0/OBUFDS_GTE5_I]
  connect_bd_net -net rx_mst_reset_in_1  [get_bd_pins rx_mst_reset_in] \
  [get_bd_pins xlslice_rx_mst_reset_0/Din] \
  [get_bd_pins xlslice_rx_mst_reset_1/Din] \
  [get_bd_pins xlslice_rx_mst_reset_2/Din] \
  [get_bd_pins xlslice_rx_mst_reset_3/Din]
  connect_bd_net -net rx_userrdy_in_1  [get_bd_pins rx_userrdy_in] \
  [get_bd_pins xlslice_rx_userrdy_0/Din] \
  [get_bd_pins xlslice_rx_userrdy_1/Din] \
  [get_bd_pins xlslice_rx_userrdy_2/Din] \
  [get_bd_pins xlslice_rx_userrdy_3/Din]
  connect_bd_net -net tx_mst_reset_in_1  [get_bd_pins tx_mst_reset_in] \
  [get_bd_pins xlslice_tx_mst_reset_0/Din] \
  [get_bd_pins xlslice_tx_mst_reset_1/Din] \
  [get_bd_pins xlslice_tx_mst_reset_2/Din] \
  [get_bd_pins xlslice_tx_mst_reset_3/Din]
  connect_bd_net -net tx_userrdy_in_1  [get_bd_pins tx_userrdy_in] \
  [get_bd_pins xlslice_tx_userrdy_0/Din] \
  [get_bd_pins xlslice_tx_userrdy_1/Din] \
  [get_bd_pins xlslice_tx_userrdy_2/Din] \
  [get_bd_pins xlslice_tx_userrdy_3/Din]
  connect_bd_net -net util_ds_buf_0_IBUF_DS_ODIV2  [get_bd_pins util_ds_buf_0/IBUF_DS_ODIV2] \
  [get_bd_pins gt_bufg_gt_refclk_fwd/outclk]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT  [get_bd_pins util_ds_buf_0/IBUF_OUT] \
  [get_bd_pins gt_quad_base/GT_REFCLK0] \
  [get_bd_pins gt_quad_base/GT_REFCLK1]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_aclk] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_0/s_axi_aclk] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_1/s_axi_aclk] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_2/s_axi_aclk] \
  [get_bd_pins axi_gpio_gt_rate_reset_ctl_3/s_axi_aclk] \
  [get_bd_pins axi_gpio_gt_reset_mask/s_axi_aclk] \
  [get_bd_pins gt_axi_apb_bridge_0/s_axi_aclk] \
  [get_bd_pins gt_quad_base/apb3clk] \
  [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins xlconcat_0/dout] \
  [get_bd_pins axi_gpio_gt_reset_mask/gpio2_io_i]
  connect_bd_net -net xlconcat_gt_rest_all_dout  [get_bd_pins xlconcat_gt_rest_all/dout] \
  [get_bd_pins gt_reset_all]
  connect_bd_net -net xlconcat_gt_rest_rx_datapath_dout  [get_bd_pins xlconcat_gt_rest_rx_datapath/dout] \
  [get_bd_pins gt_reset_rx_datapath]
  connect_bd_net -net xlconcat_gt_rest_tx_datapath_dout  [get_bd_pins xlconcat_gt_rest_tx_datapath/dout] \
  [get_bd_pins gt_reset_tx_datapath]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins mrmac_obuf_ds_gte5_0/OBUFDS_GTE5_CEB]
  connect_bd_net -net xlslice_0_Dout  [get_bd_pins gt_rate_ctl_ch0_tx_rx/Dout] \
  [get_bd_pins gt_quad_base/ch0_txrate] \
  [get_bd_pins gt_quad_base/ch0_rxrate]
  connect_bd_net -net xlslice_2_Dout  [get_bd_pins gt_rate_ctl_ch2_tx_rx/Dout] \
  [get_bd_pins gt_quad_base/ch2_txrate] \
  [get_bd_pins gt_quad_base/ch2_rxrate]
  connect_bd_net -net xlslice_3_Dout  [get_bd_pins gt_rate_ctl_ch3_tx_rx/Dout] \
  [get_bd_pins gt_quad_base/ch3_txrate] \
  [get_bd_pins gt_quad_base/ch3_rxrate]
  connect_bd_net -net xlslice_gt_reset_all_0_Dout  [get_bd_pins xlslice_gt_reset_all_0/Dout] \
  [get_bd_pins xlconcat_gt_rest_all/In0]
  connect_bd_net -net xlslice_gt_reset_all_1_Dout  [get_bd_pins xlslice_gt_reset_all_1/Dout] \
  [get_bd_pins xlconcat_gt_rest_all/In1]
  connect_bd_net -net xlslice_gt_reset_all_2_Dout  [get_bd_pins xlslice_gt_reset_all_2/Dout] \
  [get_bd_pins xlconcat_gt_rest_all/In2]
  connect_bd_net -net xlslice_gt_reset_all_3_Dout  [get_bd_pins xlslice_gt_reset_all_3/Dout] \
  [get_bd_pins xlconcat_gt_rest_all/In3]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_0_Dout  [get_bd_pins xlslice_gt_reset_rx_datapath_0/Dout] \
  [get_bd_pins xlconcat_gt_rest_rx_datapath/In0]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_1_Dout  [get_bd_pins xlslice_gt_reset_rx_datapath_1/Dout] \
  [get_bd_pins xlconcat_gt_rest_rx_datapath/In1]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_2_Dout  [get_bd_pins xlslice_gt_reset_rx_datapath_2/Dout] \
  [get_bd_pins xlconcat_gt_rest_rx_datapath/In2]
  connect_bd_net -net xlslice_gt_reset_rx_datapath_3_Dout  [get_bd_pins xlslice_gt_reset_rx_datapath_3/Dout] \
  [get_bd_pins xlconcat_gt_rest_rx_datapath/In3]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_0_Dout  [get_bd_pins xlslice_gt_reset_tx_datapath_0/Dout] \
  [get_bd_pins xlconcat_gt_rest_tx_datapath/In0]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_1_Dout  [get_bd_pins xlslice_gt_reset_tx_datapath_1/Dout] \
  [get_bd_pins xlconcat_gt_rest_tx_datapath/In1]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_2_Dout  [get_bd_pins xlslice_gt_reset_tx_datapath_2/Dout] \
  [get_bd_pins xlconcat_gt_rest_tx_datapath/In2]
  connect_bd_net -net xlslice_gt_reset_tx_datapath_3_Dout  [get_bd_pins xlslice_gt_reset_tx_datapath_3/Dout] \
  [get_bd_pins xlconcat_gt_rest_tx_datapath/In3]
  connect_bd_net -net xlslice_rx_mst_dp_rst_0_Dout  [get_bd_pins xlslice_rx_mst_dp_rst_0/Dout] \
  [get_bd_pins gt_quad_base/ch0_rxmstdatapathreset]
  connect_bd_net -net xlslice_rx_mst_dp_rst_1_Dout  [get_bd_pins xlslice_rx_mst_dp_rst_1/Dout] \
  [get_bd_pins gt_quad_base/ch1_rxmstdatapathreset]
  connect_bd_net -net xlslice_rx_mst_dp_rst_2_Dout  [get_bd_pins xlslice_rx_mst_dp_rst_2/Dout] \
  [get_bd_pins gt_quad_base/ch2_rxmstdatapathreset]
  connect_bd_net -net xlslice_rx_mst_dp_rst_3_Dout  [get_bd_pins xlslice_rx_mst_dp_rst_3/Dout] \
  [get_bd_pins gt_quad_base/ch3_rxmstdatapathreset]
  connect_bd_net -net xlslice_rx_mst_reset_0_Dout  [get_bd_pins xlslice_rx_mst_reset_0/Dout] \
  [get_bd_pins gt_quad_base/ch0_rxmstreset]
  connect_bd_net -net xlslice_rx_mst_reset_1_Dout  [get_bd_pins xlslice_rx_mst_reset_1/Dout] \
  [get_bd_pins gt_quad_base/ch1_rxmstreset]
  connect_bd_net -net xlslice_rx_mst_reset_2_Dout  [get_bd_pins xlslice_rx_mst_reset_2/Dout] \
  [get_bd_pins gt_quad_base/ch2_rxmstreset]
  connect_bd_net -net xlslice_rx_mst_reset_3_Dout  [get_bd_pins xlslice_rx_mst_reset_3/Dout] \
  [get_bd_pins gt_quad_base/ch3_rxmstreset]
  connect_bd_net -net xlslice_rx_userrdy_0_Dout  [get_bd_pins xlslice_rx_userrdy_0/Dout] \
  [get_bd_pins gt_quad_base/ch0_rxuserrdy]
  connect_bd_net -net xlslice_rx_userrdy_1_Dout  [get_bd_pins xlslice_rx_userrdy_1/Dout] \
  [get_bd_pins gt_quad_base/ch1_rxuserrdy]
  connect_bd_net -net xlslice_rx_userrdy_2_Dout  [get_bd_pins xlslice_rx_userrdy_2/Dout] \
  [get_bd_pins gt_quad_base/ch2_rxuserrdy]
  connect_bd_net -net xlslice_rx_userrdy_3_Dout  [get_bd_pins xlslice_rx_userrdy_3/Dout] \
  [get_bd_pins gt_quad_base/ch3_rxuserrdy]
  connect_bd_net -net xlslice_tx_mst_dp_rst_0_Dout  [get_bd_pins xlslice_tx_mst_dp_rst_0/Dout] \
  [get_bd_pins gt_quad_base/ch0_txmstdatapathreset]
  connect_bd_net -net xlslice_tx_mst_dp_rst_1_Dout  [get_bd_pins xlslice_tx_mst_dp_rst_1/Dout] \
  [get_bd_pins gt_quad_base/ch1_txmstdatapathreset]
  connect_bd_net -net xlslice_tx_mst_dp_rst_2_Dout  [get_bd_pins xlslice_tx_mst_dp_rst_2/Dout] \
  [get_bd_pins gt_quad_base/ch2_txmstdatapathreset]
  connect_bd_net -net xlslice_tx_mst_dp_rst_3_Dout  [get_bd_pins xlslice_tx_mst_dp_rst_3/Dout] \
  [get_bd_pins gt_quad_base/ch3_txmstdatapathreset]
  connect_bd_net -net xlslice_tx_mst_reset_0_Dout  [get_bd_pins xlslice_tx_mst_reset_0/Dout] \
  [get_bd_pins gt_quad_base/ch0_txmstreset]
  connect_bd_net -net xlslice_tx_mst_reset_1_Dout  [get_bd_pins xlslice_tx_mst_reset_1/Dout] \
  [get_bd_pins gt_quad_base/ch1_txmstreset]
  connect_bd_net -net xlslice_tx_mst_reset_2_Dout  [get_bd_pins xlslice_tx_mst_reset_2/Dout] \
  [get_bd_pins gt_quad_base/ch2_txmstreset]
  connect_bd_net -net xlslice_tx_mst_reset_3_Dout  [get_bd_pins xlslice_tx_mst_reset_3/Dout] \
  [get_bd_pins gt_quad_base/ch3_txmstreset]
  connect_bd_net -net xlslice_tx_userrdy_0_Dout  [get_bd_pins xlslice_tx_userrdy_0/Dout] \
  [get_bd_pins gt_quad_base/ch0_txuserrdy]
  connect_bd_net -net xlslice_tx_userrdy_1_Dout  [get_bd_pins xlslice_tx_userrdy_1/Dout] \
  [get_bd_pins gt_quad_base/ch1_txuserrdy]
  connect_bd_net -net xlslice_tx_userrdy_2_Dout  [get_bd_pins xlslice_tx_userrdy_2/Dout] \
  [get_bd_pins gt_quad_base/ch2_txuserrdy]
  connect_bd_net -net xlslice_tx_userrdy_3_Dout  [get_bd_pins xlslice_tx_userrdy_3/Dout] \
  [get_bd_pins gt_quad_base/ch3_txuserrdy]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DATAPATH_MCDMA_HIER
proc create_hier_cell_DATAPATH_MCDMA_HIER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DATAPATH_MCDMA_HIER() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m00_axi3


  # Create pins
  create_bd_pin -dir I -from 63 -to 0 din_0
  create_bd_pin -dir I -from 63 -to 0 din_1
  create_bd_pin -dir I -from 63 -to 0 din_2
  create_bd_pin -dir I -from 63 -to 0 din_3
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O -type intr interrupt1
  create_bd_pin -dir O -type intr interrupt2
  create_bd_pin -dir O -type intr interrupt3
  create_bd_pin -dir O -from 15 -to 0 m_ptp_cf_offset_0
  create_bd_pin -dir O -from 15 -to 0 m_ptp_cf_offset_0_0
  create_bd_pin -dir O -from 15 -to 0 m_ptp_cf_offset_0_1
  create_bd_pin -dir O -from 15 -to 0 m_ptp_cf_offset_0_2
  create_bd_pin -dir O m_ptp_upd_chcksum_0
  create_bd_pin -dir O m_ptp_upd_chcksum_0_0
  create_bd_pin -dir O m_ptp_upd_chcksum_0_1
  create_bd_pin -dir O m_ptp_upd_chcksum_0_2
  create_bd_pin -dir I mcdma_clk
  create_bd_pin -dir I mcdma_resetn
  create_bd_pin -dir O -type intr mm2s_ch1_introut
  create_bd_pin -dir O -type intr mm2s_ch1_introut1
  create_bd_pin -dir O -type intr mm2s_ch1_introut2
  create_bd_pin -dir O -type intr mm2s_ch1_introut3
  create_bd_pin -dir I -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata0
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata2
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata4
  create_bd_pin -dir I -from 63 -to 0 rx_axis_tdata6
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user0
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user2
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user4
  create_bd_pin -dir I -from 10 -to 0 rx_axis_tkeep_user6
  create_bd_pin -dir I rx_axis_tlast_0
  create_bd_pin -dir I rx_axis_tlast_1
  create_bd_pin -dir I rx_axis_tlast_2
  create_bd_pin -dir I rx_axis_tlast_3
  create_bd_pin -dir I rx_axis_tvalid_0
  create_bd_pin -dir I rx_axis_tvalid_1
  create_bd_pin -dir I rx_axis_tvalid_2
  create_bd_pin -dir I rx_axis_tvalid_3
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod1
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod2
  create_bd_pin -dir I -from 79 -to 0 rx_timestamp_tod3
  create_bd_pin -dir I rx_timestamp_tod_valid
  create_bd_pin -dir I rx_timestamp_tod_valid1
  create_bd_pin -dir I rx_timestamp_tod_valid2
  create_bd_pin -dir I rx_timestamp_tod_valid3
  create_bd_pin -dir O -type intr s2mm_ch1_introut
  create_bd_pin -dir O -type intr s2mm_ch1_introut1
  create_bd_pin -dir O -type intr s2mm_ch1_introut2
  create_bd_pin -dir O -type intr s2mm_ch1_introut3
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata0
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata2
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata4
  create_bd_pin -dir O -from 63 -to 0 tx_axis_tdata6
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user0
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user2
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user4
  create_bd_pin -dir O -from 10 -to 0 tx_axis_tkeep_user6
  create_bd_pin -dir O tx_axis_tlast_0
  create_bd_pin -dir O tx_axis_tlast_1
  create_bd_pin -dir O tx_axis_tlast_2
  create_bd_pin -dir O tx_axis_tlast_3
  create_bd_pin -dir I tx_axis_tready_0
  create_bd_pin -dir I tx_axis_tready_1
  create_bd_pin -dir I tx_axis_tready_2
  create_bd_pin -dir I tx_axis_tready_3
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_0
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_1
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_2
  create_bd_pin -dir O -from 0 -to 0 tx_axis_tvalid_3
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in1
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in2
  create_bd_pin -dir O -from 1 -to 0 tx_ptp_1588op_in3
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in1
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in2
  create_bd_pin -dir I -from 15 -to 0 tx_ptp_tstamp_tag_in3
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out1
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out2
  create_bd_pin -dir O -from 15 -to 0 tx_ptp_tstamp_tag_out3
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod1
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod2
  create_bd_pin -dir I -from 79 -to 0 tx_timestamp_tod3
  create_bd_pin -dir I tx_timestamp_tod_valid
  create_bd_pin -dir I tx_timestamp_tod_valid1
  create_bd_pin -dir I tx_timestamp_tod_valid2
  create_bd_pin -dir I tx_timestamp_tod_valid3
  create_bd_pin -dir I -from 31 -to 0 tx_tod_ns_0
  create_bd_pin -dir I -from 31 -to 0 tx_tod_ns_1
  create_bd_pin -dir I -from 31 -to 0 tx_tod_ns_2
  create_bd_pin -dir I -from 31 -to 0 tx_tod_ns_3
  create_bd_pin -dir I -from 47 -to 0 tx_tod_sec_0
  create_bd_pin -dir I -from 47 -to 0 tx_tod_sec_1
  create_bd_pin -dir I -from 47 -to 0 tx_tod_sec_2
  create_bd_pin -dir I -from 47 -to 0 tx_tod_sec_3

  # Create instance: DATAPATH_MCDMA_0
  create_hier_cell_DATAPATH_MCDMA_0 $hier_obj DATAPATH_MCDMA_0

  # Create instance: DATAPATH_MCDMA_1
  create_hier_cell_DATAPATH_MCDMA_1 $hier_obj DATAPATH_MCDMA_1

  # Create instance: DATAPATH_MCDMA_2
  create_hier_cell_DATAPATH_MCDMA_2 $hier_obj DATAPATH_MCDMA_2

  # Create instance: DATAPATH_MCDMA_3
  create_hier_cell_DATAPATH_MCDMA_3 $hier_obj DATAPATH_MCDMA_3

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {4} \
  ] $axi_gpio_0


  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [list \
    CONFIG.ARUSER_WIDTH {4} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_WRITE_MODE {READ_ONLY} \
  ] $axi_register_slice_0


  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
  set_property -dict [list \
    CONFIG.ARUSER_WIDTH {4} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_WRITE_MODE {READ_ONLY} \
  ] $axi_register_slice_1


  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
  set_property -dict [list \
    CONFIG.ARUSER_WIDTH {4} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_WRITE_MODE {READ_ONLY} \
  ] $axi_register_slice_2


  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
  set_property -dict [list \
    CONFIG.ARUSER_WIDTH {4} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_WRITE_MODE {READ_ONLY} \
  ] $axi_register_slice_3


  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
  set_property -dict [list \
    CONFIG.AWUSER_WIDTH {4} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_WRITE_MODE {WRITE_ONLY} \
  ] $axi_register_slice_4


  # Create instance: axi_register_slice_5, and set properties
  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
  set_property -dict [list \
    CONFIG.AWUSER_WIDTH {4} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_WRITE_MODE {WRITE_ONLY} \
  ] $axi_register_slice_5


  # Create instance: axi_register_slice_6, and set properties
  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
  set_property -dict [list \
    CONFIG.AWUSER_WIDTH {4} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_WRITE_MODE {WRITE_ONLY} \
  ] $axi_register_slice_6


  # Create instance: axi_register_slice_7, and set properties
  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
  set_property -dict [list \
    CONFIG.AWUSER_WIDTH {4} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_WRITE_MODE {WRITE_ONLY} \
  ] $axi_register_slice_7


  # Create instance: axi_register_slice_8, and set properties
  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
  set_property CONFIG.AWUSER_WIDTH {4} $axi_register_slice_8


  # Create instance: axi_register_slice_9, and set properties
  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
  set_property CONFIG.AWUSER_WIDTH {4} $axi_register_slice_9


  # Create instance: axi_register_slice_10, and set properties
  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
  set_property CONFIG.AWUSER_WIDTH {4} $axi_register_slice_10


  # Create instance: axi_register_slice_11, and set properties
  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
  set_property CONFIG.AWUSER_WIDTH {4} $axi_register_slice_11


  # Create instance: clk_rst_slice_hier_ch0
  create_hier_cell_clk_rst_slice_hier_ch0 $hier_obj clk_rst_slice_hier_ch0

  # Create instance: clk_rst_slice_hier_ch1
  create_hier_cell_clk_rst_slice_hier_ch1 $hier_obj clk_rst_slice_hier_ch1

  # Create instance: clk_rst_slice_hier_ch2
  create_hier_cell_clk_rst_slice_hier_ch2 $hier_obj clk_rst_slice_hier_ch2

  # Create instance: clk_rst_slice_hier_ch3
  create_hier_cell_clk_rst_slice_hier_ch3 $hier_obj clk_rst_slice_hier_ch3

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property CONFIG.DIN_WIDTH {4} $xlslice_0


  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_1


  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_2


  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {4} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_3


  # Create interface connections
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins DATAPATH_MCDMA_0/M_AXI_SG]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_0_M_AXI_MM2S [get_bd_intf_pins DATAPATH_MCDMA_0/M_AXI_MM2S] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_0_M_AXI_S2MM [get_bd_intf_pins DATAPATH_MCDMA_0/M_AXI_S2MM] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_0_m00_axi [get_bd_intf_pins DATAPATH_MCDMA_0/m00_axi] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_1_M_AXI_MM2S [get_bd_intf_pins DATAPATH_MCDMA_1/M_AXI_MM2S] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_1_M_AXI_S2MM [get_bd_intf_pins DATAPATH_MCDMA_1/M_AXI_S2MM] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_1_M_AXI_SG [get_bd_intf_pins M_AXI_SG1] [get_bd_intf_pins DATAPATH_MCDMA_1/M_AXI_SG]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_1_m00_axi [get_bd_intf_pins DATAPATH_MCDMA_1/m00_axi] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_2_M_AXI_MM2S [get_bd_intf_pins DATAPATH_MCDMA_2/M_AXI_MM2S] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_2_M_AXI_S2MM [get_bd_intf_pins DATAPATH_MCDMA_2/M_AXI_S2MM] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_2_M_AXI_SG [get_bd_intf_pins M_AXI_SG2] [get_bd_intf_pins DATAPATH_MCDMA_2/M_AXI_SG]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_2_m00_axi [get_bd_intf_pins DATAPATH_MCDMA_2/m00_axi] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_3_M_AXI_MM2S [get_bd_intf_pins DATAPATH_MCDMA_3/M_AXI_MM2S] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_3_M_AXI_S2MM [get_bd_intf_pins DATAPATH_MCDMA_3/M_AXI_S2MM] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_3_M_AXI_SG [get_bd_intf_pins M_AXI_SG3] [get_bd_intf_pins DATAPATH_MCDMA_3/M_AXI_SG]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_3_m00_axi [get_bd_intf_pins DATAPATH_MCDMA_3/m00_axi] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_LITE1_1 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins DATAPATH_MCDMA_1/S_AXI_LITE]
  connect_bd_intf_net -intf_net S_AXI_LITE2_1 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins DATAPATH_MCDMA_2/S_AXI_LITE]
  connect_bd_intf_net -intf_net S_AXI_LITE3_1 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins DATAPATH_MCDMA_3/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins axi_register_slice_0/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_10_M_AXI [get_bd_intf_pins m00_axi2] [get_bd_intf_pins axi_register_slice_10/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_11_M_AXI [get_bd_intf_pins m00_axi3] [get_bd_intf_pins axi_register_slice_11/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_register_slice_1/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_2_M_AXI [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins axi_register_slice_2/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_3_M_AXI [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins axi_register_slice_3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_4_M_AXI [get_bd_intf_pins M_AXI_S2MM1] [get_bd_intf_pins axi_register_slice_4/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_5_M_AXI [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_register_slice_5/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_6_M_AXI [get_bd_intf_pins M_AXI_S2MM2] [get_bd_intf_pins axi_register_slice_6/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_7_M_AXI [get_bd_intf_pins M_AXI_S2MM3] [get_bd_intf_pins axi_register_slice_7/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_8_M_AXI [get_bd_intf_pins m00_axi1] [get_bd_intf_pins axi_register_slice_8/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_9_M_AXI [get_bd_intf_pins m00_axi] [get_bd_intf_pins axi_register_slice_9/M_AXI]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M03_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins DATAPATH_MCDMA_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins tx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch0/tx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch1/tx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch2/tx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch3/tx_axis_rstn]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch0/rx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch1/rx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch2/rx_axis_rstn] \
  [get_bd_pins clk_rst_slice_hier_ch3/rx_axis_rstn]
  connect_bd_net -net DATAPATH_MCDMA_0_interrupt  [get_bd_pins DATAPATH_MCDMA_0/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net DATAPATH_MCDMA_0_m_ptp_cf_offset_0  [get_bd_pins DATAPATH_MCDMA_0/m_ptp_cf_offset_0] \
  [get_bd_pins m_ptp_cf_offset_0]
  connect_bd_net -net DATAPATH_MCDMA_0_m_ptp_upd_chcksum_0  [get_bd_pins DATAPATH_MCDMA_0/m_ptp_upd_chcksum_0] \
  [get_bd_pins m_ptp_upd_chcksum_0]
  connect_bd_net -net DATAPATH_MCDMA_0_tx_ptp_1588op_in  [get_bd_pins DATAPATH_MCDMA_0/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in]
  connect_bd_net -net DATAPATH_MCDMA_0_tx_ptp_tstamp_tag_out  [get_bd_pins DATAPATH_MCDMA_0/tx_ptp_tstamp_tag_out] \
  [get_bd_pins tx_ptp_tstamp_tag_out]
  connect_bd_net -net DATAPATH_MCDMA_1_interrupt  [get_bd_pins DATAPATH_MCDMA_1/interrupt] \
  [get_bd_pins interrupt1]
  connect_bd_net -net DATAPATH_MCDMA_1_m_ptp_cf_offset_0  [get_bd_pins DATAPATH_MCDMA_1/m_ptp_cf_offset_0] \
  [get_bd_pins m_ptp_cf_offset_0_1]
  connect_bd_net -net DATAPATH_MCDMA_1_m_ptp_upd_chcksum_0  [get_bd_pins DATAPATH_MCDMA_1/m_ptp_upd_chcksum_0] \
  [get_bd_pins m_ptp_upd_chcksum_0_2]
  connect_bd_net -net DATAPATH_MCDMA_1_mm2s_ch1_introut  [get_bd_pins DATAPATH_MCDMA_1/mm2s_ch1_introut] \
  [get_bd_pins mm2s_ch1_introut1]
  connect_bd_net -net DATAPATH_MCDMA_1_s2mm_ch1_introut  [get_bd_pins DATAPATH_MCDMA_1/s2mm_ch1_introut] \
  [get_bd_pins s2mm_ch1_introut1]
  connect_bd_net -net DATAPATH_MCDMA_1_tx_axis_tdata0  [get_bd_pins DATAPATH_MCDMA_1/tx_axis_tdata0] \
  [get_bd_pins tx_axis_tdata2]
  connect_bd_net -net DATAPATH_MCDMA_1_tx_axis_tkeep_user0  [get_bd_pins DATAPATH_MCDMA_1/tx_axis_tkeep_user0] \
  [get_bd_pins tx_axis_tkeep_user2]
  connect_bd_net -net DATAPATH_MCDMA_1_tx_axis_tlast_0  [get_bd_pins DATAPATH_MCDMA_1/tx_axis_tlast_0] \
  [get_bd_pins tx_axis_tlast_1]
  connect_bd_net -net DATAPATH_MCDMA_1_tx_axis_tvalid_0  [get_bd_pins DATAPATH_MCDMA_1/tx_axis_tvalid_0] \
  [get_bd_pins tx_axis_tvalid_1]
  connect_bd_net -net DATAPATH_MCDMA_1_tx_ptp_1588op_in  [get_bd_pins DATAPATH_MCDMA_1/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in1]
  connect_bd_net -net DATAPATH_MCDMA_1_tx_ptp_tstamp_tag_out  [get_bd_pins DATAPATH_MCDMA_1/tx_ptp_tstamp_tag_out] \
  [get_bd_pins tx_ptp_tstamp_tag_out1]
  connect_bd_net -net DATAPATH_MCDMA_2_interrupt  [get_bd_pins DATAPATH_MCDMA_2/interrupt] \
  [get_bd_pins interrupt2]
  connect_bd_net -net DATAPATH_MCDMA_2_m_ptp_cf_offset_0  [get_bd_pins DATAPATH_MCDMA_2/m_ptp_cf_offset_0] \
  [get_bd_pins m_ptp_cf_offset_0_0]
  connect_bd_net -net DATAPATH_MCDMA_2_m_ptp_upd_chcksum_0  [get_bd_pins DATAPATH_MCDMA_2/m_ptp_upd_chcksum_0] \
  [get_bd_pins m_ptp_upd_chcksum_0_1]
  connect_bd_net -net DATAPATH_MCDMA_2_mm2s_ch1_introut  [get_bd_pins DATAPATH_MCDMA_2/mm2s_ch1_introut] \
  [get_bd_pins mm2s_ch1_introut2]
  connect_bd_net -net DATAPATH_MCDMA_2_s2mm_ch1_introut  [get_bd_pins DATAPATH_MCDMA_2/s2mm_ch1_introut] \
  [get_bd_pins s2mm_ch1_introut2]
  connect_bd_net -net DATAPATH_MCDMA_2_tx_axis_tdata0  [get_bd_pins DATAPATH_MCDMA_2/tx_axis_tdata0] \
  [get_bd_pins tx_axis_tdata4]
  connect_bd_net -net DATAPATH_MCDMA_2_tx_axis_tkeep_user0  [get_bd_pins DATAPATH_MCDMA_2/tx_axis_tkeep_user0] \
  [get_bd_pins tx_axis_tkeep_user4]
  connect_bd_net -net DATAPATH_MCDMA_2_tx_axis_tlast_0  [get_bd_pins DATAPATH_MCDMA_2/tx_axis_tlast_0] \
  [get_bd_pins tx_axis_tlast_2]
  connect_bd_net -net DATAPATH_MCDMA_2_tx_axis_tvalid_0  [get_bd_pins DATAPATH_MCDMA_2/tx_axis_tvalid_0] \
  [get_bd_pins tx_axis_tvalid_2]
  connect_bd_net -net DATAPATH_MCDMA_2_tx_ptp_1588op_in  [get_bd_pins DATAPATH_MCDMA_2/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in2]
  connect_bd_net -net DATAPATH_MCDMA_2_tx_ptp_tstamp_tag_out  [get_bd_pins DATAPATH_MCDMA_2/tx_ptp_tstamp_tag_out] \
  [get_bd_pins tx_ptp_tstamp_tag_out2]
  connect_bd_net -net DATAPATH_MCDMA_3_interrupt  [get_bd_pins DATAPATH_MCDMA_3/interrupt] \
  [get_bd_pins interrupt3]
  connect_bd_net -net DATAPATH_MCDMA_3_m_ptp_cf_offset_0  [get_bd_pins DATAPATH_MCDMA_3/m_ptp_cf_offset_0] \
  [get_bd_pins m_ptp_cf_offset_0_2]
  connect_bd_net -net DATAPATH_MCDMA_3_m_ptp_upd_chcksum_0  [get_bd_pins DATAPATH_MCDMA_3/m_ptp_upd_chcksum_0] \
  [get_bd_pins m_ptp_upd_chcksum_0_0]
  connect_bd_net -net DATAPATH_MCDMA_3_mm2s_ch1_introut  [get_bd_pins DATAPATH_MCDMA_3/mm2s_ch1_introut] \
  [get_bd_pins mm2s_ch1_introut3]
  connect_bd_net -net DATAPATH_MCDMA_3_s2mm_ch1_introut  [get_bd_pins DATAPATH_MCDMA_3/s2mm_ch1_introut] \
  [get_bd_pins s2mm_ch1_introut3]
  connect_bd_net -net DATAPATH_MCDMA_3_tx_axis_tdata0  [get_bd_pins DATAPATH_MCDMA_3/tx_axis_tdata0] \
  [get_bd_pins tx_axis_tdata6]
  connect_bd_net -net DATAPATH_MCDMA_3_tx_axis_tkeep_user0  [get_bd_pins DATAPATH_MCDMA_3/tx_axis_tkeep_user0] \
  [get_bd_pins tx_axis_tkeep_user6]
  connect_bd_net -net DATAPATH_MCDMA_3_tx_axis_tlast_0  [get_bd_pins DATAPATH_MCDMA_3/tx_axis_tlast_0] \
  [get_bd_pins tx_axis_tlast_3]
  connect_bd_net -net DATAPATH_MCDMA_3_tx_axis_tvalid_0  [get_bd_pins DATAPATH_MCDMA_3/tx_axis_tvalid_0] \
  [get_bd_pins tx_axis_tvalid_3]
  connect_bd_net -net DATAPATH_MCDMA_3_tx_ptp_1588op_in  [get_bd_pins DATAPATH_MCDMA_3/tx_ptp_1588op_in] \
  [get_bd_pins tx_ptp_1588op_in3]
  connect_bd_net -net DATAPATH_MCDMA_3_tx_ptp_tstamp_tag_out  [get_bd_pins DATAPATH_MCDMA_3/tx_ptp_tstamp_tag_out] \
  [get_bd_pins tx_ptp_tstamp_tag_out3]
  connect_bd_net -net Net  [get_bd_pins axi_gpio_0/gpio_io_o] \
  [get_bd_pins xlslice_0/Din] \
  [get_bd_pins xlslice_1/Din] \
  [get_bd_pins xlslice_2/Din] \
  [get_bd_pins xlslice_3/Din]
  connect_bd_net -net axi_mcdma_0_mm2s_ch1_introut  [get_bd_pins DATAPATH_MCDMA_0/mm2s_ch1_introut] \
  [get_bd_pins mm2s_ch1_introut]
  connect_bd_net -net axi_mcdma_0_s2mm_ch1_introut  [get_bd_pins DATAPATH_MCDMA_0/s2mm_ch1_introut] \
  [get_bd_pins s2mm_ch1_introut]
  connect_bd_net -net axis_data_fifo_0_m_axis_tdata  [get_bd_pins DATAPATH_MCDMA_0/tx_axis_tdata0] \
  [get_bd_pins tx_axis_tdata0]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins DATAPATH_MCDMA_0/tx_axis_tlast_0] \
  [get_bd_pins tx_axis_tlast_0]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins DATAPATH_MCDMA_0/tx_axis_tvalid_0] \
  [get_bd_pins tx_axis_tvalid_0]
  connect_bd_net -net clk_rst_slice_hier_ch1_rx_axis_rstn_out  [get_bd_pins clk_rst_slice_hier_ch1/rx_axis_rstn_out] \
  [get_bd_pins DATAPATH_MCDMA_1/axis_rx_rstn]
  connect_bd_net -net clk_rst_slice_hier_ch1_tx_axis_rstn_out  [get_bd_pins clk_rst_slice_hier_ch1/tx_axis_rstn_out] \
  [get_bd_pins DATAPATH_MCDMA_1/axis_tx_rstn]
  connect_bd_net -net clk_rst_slice_hier_ch2_rx_axis_rstn_out  [get_bd_pins clk_rst_slice_hier_ch2/rx_axis_rstn_out] \
  [get_bd_pins DATAPATH_MCDMA_2/axis_rx_rstn]
  connect_bd_net -net clk_rst_slice_hier_ch2_tx_axis_rstn_out  [get_bd_pins clk_rst_slice_hier_ch2/tx_axis_rstn_out] \
  [get_bd_pins DATAPATH_MCDMA_2/axis_tx_rstn]
  connect_bd_net -net clk_rst_slice_hier_ch3_rx_axis_rstn_out  [get_bd_pins clk_rst_slice_hier_ch3/rx_axis_rstn_out] \
  [get_bd_pins DATAPATH_MCDMA_3/axis_rx_rstn]
  connect_bd_net -net clk_rst_slice_hier_ch3_tx_axis_rstn_out  [get_bd_pins clk_rst_slice_hier_ch3/tx_axis_rstn_out] \
  [get_bd_pins DATAPATH_MCDMA_3/axis_tx_rstn]
  connect_bd_net -net din_0_1  [get_bd_pins din_0] \
  [get_bd_pins DATAPATH_MCDMA_0/din_0]
  connect_bd_net -net din_1_1  [get_bd_pins din_1] \
  [get_bd_pins DATAPATH_MCDMA_1/din_0]
  connect_bd_net -net din_2_1  [get_bd_pins din_2] \
  [get_bd_pins DATAPATH_MCDMA_2/din_0]
  connect_bd_net -net din_3_1  [get_bd_pins din_3] \
  [get_bd_pins DATAPATH_MCDMA_3/din_0]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins mcdma_clk] \
  [get_bd_pins DATAPATH_MCDMA_0/mcdma_clk] \
  [get_bd_pins DATAPATH_MCDMA_1/mcdma_clk] \
  [get_bd_pins DATAPATH_MCDMA_2/mcdma_clk] \
  [get_bd_pins DATAPATH_MCDMA_3/mcdma_clk] \
  [get_bd_pins axi_register_slice_0/aclk] \
  [get_bd_pins axi_register_slice_10/aclk] \
  [get_bd_pins axi_register_slice_11/aclk] \
  [get_bd_pins axi_register_slice_1/aclk] \
  [get_bd_pins axi_register_slice_2/aclk] \
  [get_bd_pins axi_register_slice_3/aclk] \
  [get_bd_pins axi_register_slice_4/aclk] \
  [get_bd_pins axi_register_slice_5/aclk] \
  [get_bd_pins axi_register_slice_6/aclk] \
  [get_bd_pins axi_register_slice_7/aclk] \
  [get_bd_pins axi_register_slice_8/aclk] \
  [get_bd_pins axi_register_slice_9/aclk]
  connect_bd_net -net mcdma_resetn_1  [get_bd_pins mcdma_resetn] \
  [get_bd_pins DATAPATH_MCDMA_0/mcdma_resetn] \
  [get_bd_pins DATAPATH_MCDMA_1/mcdma_resetn] \
  [get_bd_pins DATAPATH_MCDMA_2/mcdma_resetn] \
  [get_bd_pins DATAPATH_MCDMA_3/mcdma_resetn] \
  [get_bd_pins axi_register_slice_0/aresetn] \
  [get_bd_pins axi_register_slice_10/aresetn] \
  [get_bd_pins axi_register_slice_11/aresetn] \
  [get_bd_pins axi_register_slice_1/aresetn] \
  [get_bd_pins axi_register_slice_2/aresetn] \
  [get_bd_pins axi_register_slice_3/aresetn] \
  [get_bd_pins axi_register_slice_4/aresetn] \
  [get_bd_pins axi_register_slice_5/aresetn] \
  [get_bd_pins axi_register_slice_6/aresetn] \
  [get_bd_pins axi_register_slice_7/aresetn] \
  [get_bd_pins axi_register_slice_8/aresetn] \
  [get_bd_pins axi_register_slice_9/aresetn]
  connect_bd_net -net mrmac_0_rx_axis_tdata0  [get_bd_pins rx_axis_tdata0] \
  [get_bd_pins DATAPATH_MCDMA_0/rx_axis_tdata0]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user0  [get_bd_pins rx_axis_tkeep_user0] \
  [get_bd_pins DATAPATH_MCDMA_0/rx_axis_tkeep_user0]
  connect_bd_net -net mrmac_0_rx_axis_tlast_0  [get_bd_pins rx_axis_tlast_0] \
  [get_bd_pins DATAPATH_MCDMA_0/rx_axis_tlast_0]
  connect_bd_net -net mrmac_0_rx_axis_tvalid_0  [get_bd_pins rx_axis_tvalid_0] \
  [get_bd_pins DATAPATH_MCDMA_0/rx_axis_tvalid_0]
  connect_bd_net -net mrmac_0_tx_axis_tready_0  [get_bd_pins tx_axis_tready_0] \
  [get_bd_pins DATAPATH_MCDMA_0/tx_axis_tready_0]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins clk_rst_slice_hier_ch0/tx_axis_rstn_out] \
  [get_bd_pins DATAPATH_MCDMA_0/axis_tx_rstn]
  connect_bd_net -net proc_sys_reset_rx_axis_clk_peripheral_aresetn  [get_bd_pins clk_rst_slice_hier_ch0/rx_axis_rstn_out] \
  [get_bd_pins DATAPATH_MCDMA_0/axis_rx_rstn]
  connect_bd_net -net rx_axis_tdata2_1  [get_bd_pins rx_axis_tdata2] \
  [get_bd_pins DATAPATH_MCDMA_1/rx_axis_tdata0]
  connect_bd_net -net rx_axis_tdata4_1  [get_bd_pins rx_axis_tdata4] \
  [get_bd_pins DATAPATH_MCDMA_2/rx_axis_tdata0]
  connect_bd_net -net rx_axis_tdata6_1  [get_bd_pins rx_axis_tdata6] \
  [get_bd_pins DATAPATH_MCDMA_3/rx_axis_tdata0]
  connect_bd_net -net rx_axis_tkeep_user2_1  [get_bd_pins rx_axis_tkeep_user2] \
  [get_bd_pins DATAPATH_MCDMA_1/rx_axis_tkeep_user0]
  connect_bd_net -net rx_axis_tkeep_user4_1  [get_bd_pins rx_axis_tkeep_user4] \
  [get_bd_pins DATAPATH_MCDMA_2/rx_axis_tkeep_user0]
  connect_bd_net -net rx_axis_tkeep_user6_1  [get_bd_pins rx_axis_tkeep_user6] \
  [get_bd_pins DATAPATH_MCDMA_3/rx_axis_tkeep_user0]
  connect_bd_net -net rx_axis_tlast_1_1  [get_bd_pins rx_axis_tlast_1] \
  [get_bd_pins DATAPATH_MCDMA_1/rx_axis_tlast_0]
  connect_bd_net -net rx_axis_tlast_2_1  [get_bd_pins rx_axis_tlast_2] \
  [get_bd_pins DATAPATH_MCDMA_2/rx_axis_tlast_0]
  connect_bd_net -net rx_axis_tlast_3_1  [get_bd_pins rx_axis_tlast_3] \
  [get_bd_pins DATAPATH_MCDMA_3/rx_axis_tlast_0]
  connect_bd_net -net rx_axis_tvalid_1_1  [get_bd_pins rx_axis_tvalid_1] \
  [get_bd_pins DATAPATH_MCDMA_1/rx_axis_tvalid_0]
  connect_bd_net -net rx_axis_tvalid_2_1  [get_bd_pins rx_axis_tvalid_2] \
  [get_bd_pins DATAPATH_MCDMA_2/rx_axis_tvalid_0]
  connect_bd_net -net rx_axis_tvalid_3_1  [get_bd_pins rx_axis_tvalid_3] \
  [get_bd_pins DATAPATH_MCDMA_3/rx_axis_tvalid_0]
  connect_bd_net -net rx_timestamp_tod1_1  [get_bd_pins rx_timestamp_tod1] \
  [get_bd_pins DATAPATH_MCDMA_1/rx_timestamp_tod]
  connect_bd_net -net rx_timestamp_tod2_1  [get_bd_pins rx_timestamp_tod2] \
  [get_bd_pins DATAPATH_MCDMA_2/rx_timestamp_tod]
  connect_bd_net -net rx_timestamp_tod3_1  [get_bd_pins rx_timestamp_tod3] \
  [get_bd_pins DATAPATH_MCDMA_3/rx_timestamp_tod]
  connect_bd_net -net rx_timestamp_tod_1  [get_bd_pins rx_timestamp_tod] \
  [get_bd_pins DATAPATH_MCDMA_0/rx_timestamp_tod]
  connect_bd_net -net rx_timestamp_tod_valid1_1  [get_bd_pins rx_timestamp_tod_valid1] \
  [get_bd_pins DATAPATH_MCDMA_1/rx_timestamp_tod_valid]
  connect_bd_net -net rx_timestamp_tod_valid2_1  [get_bd_pins rx_timestamp_tod_valid2] \
  [get_bd_pins DATAPATH_MCDMA_2/rx_timestamp_tod_valid]
  connect_bd_net -net rx_timestamp_tod_valid3_1  [get_bd_pins rx_timestamp_tod_valid3] \
  [get_bd_pins DATAPATH_MCDMA_3/rx_timestamp_tod_valid]
  connect_bd_net -net rx_timestamp_tod_valid_1  [get_bd_pins rx_timestamp_tod_valid] \
  [get_bd_pins DATAPATH_MCDMA_0/rx_timestamp_tod_valid]
  connect_bd_net -net s_axis_aresetn_1  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins DATAPATH_MCDMA_0/s_axis_aresetn] \
  [get_bd_pins DATAPATH_MCDMA_1/s_axis_aresetn] \
  [get_bd_pins DATAPATH_MCDMA_2/s_axis_aresetn] \
  [get_bd_pins DATAPATH_MCDMA_3/s_axis_aresetn] \
  [get_bd_pins axi_gpio_0/s_axi_aresetn]
  connect_bd_net -net tx_axis_tready_1_1  [get_bd_pins tx_axis_tready_1] \
  [get_bd_pins DATAPATH_MCDMA_1/tx_axis_tready_0]
  connect_bd_net -net tx_axis_tready_2_1  [get_bd_pins tx_axis_tready_2] \
  [get_bd_pins DATAPATH_MCDMA_2/tx_axis_tready_0]
  connect_bd_net -net tx_axis_tready_3_1  [get_bd_pins tx_axis_tready_3] \
  [get_bd_pins DATAPATH_MCDMA_3/tx_axis_tready_0]
  connect_bd_net -net tx_ptp_tstamp_tag_in1_1  [get_bd_pins tx_ptp_tstamp_tag_in1] \
  [get_bd_pins DATAPATH_MCDMA_1/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_ptp_tstamp_tag_in2_1  [get_bd_pins tx_ptp_tstamp_tag_in2] \
  [get_bd_pins DATAPATH_MCDMA_2/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_ptp_tstamp_tag_in3_1  [get_bd_pins tx_ptp_tstamp_tag_in3] \
  [get_bd_pins DATAPATH_MCDMA_3/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_ptp_tstamp_tag_in_1  [get_bd_pins tx_ptp_tstamp_tag_in] \
  [get_bd_pins DATAPATH_MCDMA_0/tx_ptp_tstamp_tag_in]
  connect_bd_net -net tx_timestamp_tod1_1  [get_bd_pins tx_timestamp_tod1] \
  [get_bd_pins DATAPATH_MCDMA_1/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod2_1  [get_bd_pins tx_timestamp_tod2] \
  [get_bd_pins DATAPATH_MCDMA_2/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod3_1  [get_bd_pins tx_timestamp_tod3] \
  [get_bd_pins DATAPATH_MCDMA_3/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_1  [get_bd_pins tx_timestamp_tod] \
  [get_bd_pins DATAPATH_MCDMA_0/tx_timestamp_tod]
  connect_bd_net -net tx_timestamp_tod_valid1_1  [get_bd_pins tx_timestamp_tod_valid1] \
  [get_bd_pins DATAPATH_MCDMA_1/tx_timestamp_tod_valid]
  connect_bd_net -net tx_timestamp_tod_valid2_1  [get_bd_pins tx_timestamp_tod_valid2] \
  [get_bd_pins DATAPATH_MCDMA_2/tx_timestamp_tod_valid]
  connect_bd_net -net tx_timestamp_tod_valid3_1  [get_bd_pins tx_timestamp_tod_valid3] \
  [get_bd_pins DATAPATH_MCDMA_3/tx_timestamp_tod_valid]
  connect_bd_net -net tx_timestamp_tod_valid_1  [get_bd_pins tx_timestamp_tod_valid] \
  [get_bd_pins DATAPATH_MCDMA_0/tx_timestamp_tod_valid]
  connect_bd_net -net tx_tod_ns_0_1  [get_bd_pins tx_tod_ns_0] \
  [get_bd_pins DATAPATH_MCDMA_0/tx_tod_ns_0]
  connect_bd_net -net tx_tod_ns_1_1  [get_bd_pins tx_tod_ns_1] \
  [get_bd_pins DATAPATH_MCDMA_1/tx_tod_ns_0]
  connect_bd_net -net tx_tod_ns_2_1  [get_bd_pins tx_tod_ns_2] \
  [get_bd_pins DATAPATH_MCDMA_2/tx_tod_ns_0]
  connect_bd_net -net tx_tod_ns_3_1  [get_bd_pins tx_tod_ns_3] \
  [get_bd_pins DATAPATH_MCDMA_3/tx_tod_ns_0]
  connect_bd_net -net tx_tod_sec_0_1  [get_bd_pins tx_tod_sec_0] \
  [get_bd_pins DATAPATH_MCDMA_0/tx_tod_sec_0]
  connect_bd_net -net tx_tod_sec_1_1  [get_bd_pins tx_tod_sec_1] \
  [get_bd_pins DATAPATH_MCDMA_1/tx_tod_sec_0]
  connect_bd_net -net tx_tod_sec_2_1  [get_bd_pins tx_tod_sec_2] \
  [get_bd_pins DATAPATH_MCDMA_2/tx_tod_sec_0]
  connect_bd_net -net tx_tod_sec_3_1  [get_bd_pins tx_tod_sec_3] \
  [get_bd_pins DATAPATH_MCDMA_3/tx_tod_sec_0]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_lite_aclk] \
  [get_bd_pins DATAPATH_MCDMA_0/s_axi_lite_aclk] \
  [get_bd_pins DATAPATH_MCDMA_1/s_axi_lite_aclk] \
  [get_bd_pins DATAPATH_MCDMA_2/s_axi_lite_aclk] \
  [get_bd_pins DATAPATH_MCDMA_3/s_axi_lite_aclk] \
  [get_bd_pins axi_gpio_0/s_axi_aclk]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins DATAPATH_MCDMA_0/tx_axis_tkeep_user0] \
  [get_bd_pins tx_axis_tkeep_user0]
  connect_bd_net -net xlslice_0_Dout  [get_bd_pins xlslice_0/Dout] \
  [get_bd_pins DATAPATH_MCDMA_0/sel_10g_mode]
  connect_bd_net -net xlslice_1_Dout  [get_bd_pins xlslice_1/Dout] \
  [get_bd_pins DATAPATH_MCDMA_1/sel_10g_mode]
  connect_bd_net -net xlslice_2_Dout  [get_bd_pins xlslice_2/Dout] \
  [get_bd_pins DATAPATH_MCDMA_2/sel_10g_mode]
  connect_bd_net -net xlslice_3_Dout  [get_bd_pins xlslice_3/Dout] \
  [get_bd_pins DATAPATH_MCDMA_3/sel_10g_mode]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: CLK_RST_WRAPPER
proc create_hier_cell_CLK_RST_WRAPPER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_CLK_RST_WRAPPER() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_1pps_clk


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 -type clk OBUF_DS_1PPS_OUT_N_0
  create_bd_pin -dir O -from 0 -to 0 -type clk OBUF_DS_1PPS_OUT_P_0
  create_bd_pin -dir O -from 0 -to 3 -type rst axi_lite_bus_struct_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst axi_lite_interconnect_resetn
  create_bd_pin -dir O -from 0 -to 0 -type rst axi_lite_perpheral_resetn
  create_bd_pin -dir O -from 3 -to 0 axis_clk_rx_out
  create_bd_pin -dir O -from 3 -to 0 axis_clk_tx_out
  create_bd_pin -dir O axis_tx_rx_clk
  create_bd_pin -dir I -type clk clk_in1
  create_bd_pin -dir O mcdma_clk
  create_bd_pin -dir O -from 0 -to 0 mcdma_resetn
  create_bd_pin -dir I -type rst pl0_resetn
  create_bd_pin -dir O -from 3 -to 0 rx_axis_rst
  create_bd_pin -dir O -from 3 -to 0 rx_axis_rstn
  create_bd_pin -dir I -from 3 -to 0 rx_mst_reset_done
  create_bd_pin -dir O -from 3 -to 0 rx_reset
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir O -from 3 -to 0 timestamp_clk
  create_bd_pin -dir O -from 0 -to 0 -type clk tod_1pps_in
  create_bd_pin -dir I -from 0 -to 0 -type clk tod_1pps_out
  create_bd_pin -dir O ts_clk
  create_bd_pin -dir O -from 3 -to 0 ts_reset
  create_bd_pin -dir O -from 3 -to 0 tx_axis_rst
  create_bd_pin -dir O -from 3 -to 0 tx_axis_rstn
  create_bd_pin -dir I -from 3 -to 0 tx_mst_reset_done
  create_bd_pin -dir O -from 3 -to 0 tx_reset

  # Create instance: clk_wizard_tod_clk, and set properties
  set clk_wizard_tod_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_tod_clk ]
  set_property -dict [list \
    CONFIG.AUTO_PRIMITIVE {DPLL} \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {250.000,100.000,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
    CONFIG.PRIMITIVE_TYPE {MMCM} \
    CONFIG.PRIM_IN_FREQ {322.265625} \
    CONFIG.PRIM_SOURCE {No_buffer} \
  ] $clk_wizard_tod_clk


  # Create instance: clk_wizard_tx_rx_axis, and set properties
  set clk_wizard_tx_rx_axis [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_tx_rx_axis ]
  set_property -dict [list \
    CONFIG.AUTO_PRIMITIVE {DPLL} \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {390.625,250.000,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
    CONFIG.PRIMITIVE_TYPE {MMCM} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_PHASE_ALIGNMENT {false} \
  ] $clk_wizard_tx_rx_axis


  # Create instance: mrmac_1pps_in_ibufds, and set properties
  set mrmac_1pps_in_ibufds [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mrmac_1pps_in_ibufds ]

  # Create instance: mrmac_1pps_out_obufds, and set properties
  set mrmac_1pps_out_obufds [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 mrmac_1pps_out_obufds ]
  set_property CONFIG.C_BUF_TYPE {OBUFDS} $mrmac_1pps_out_obufds


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_NUM_BUS_RST {4} \
    CONFIG.C_NUM_PERP_RST {1} \
  ] $proc_sys_reset_0


  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_NUM_BUS_RST {4} \
    CONFIG.C_NUM_PERP_RST {1} \
  ] $proc_sys_reset_2


  # Create instance: proc_sys_reset_3, and set properties
  set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3 ]
  set_property -dict [list \
    CONFIG.C_AUX_RESET_HIGH {0} \
    CONFIG.C_NUM_BUS_RST {4} \
    CONFIG.C_NUM_PERP_RST {1} \
  ] $proc_sys_reset_3


  # Create instance: util_vector_logic_rx_rst, and set properties
  set util_vector_logic_rx_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_rx_rst ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {4} \
  ] $util_vector_logic_rx_rst


  # Create instance: util_vector_logic_tx_rst, and set properties
  set util_vector_logic_tx_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_tx_rst ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {4} \
  ] $util_vector_logic_tx_rst


  # Create instance: xlconcat_ts_clk, and set properties
  set xlconcat_ts_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_ts_clk ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_ts_clk


  # Create instance: xlconcat_ts_reset, and set properties
  set xlconcat_ts_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_ts_reset ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_ts_reset


  # Create instance: xlconcat_tx_rx_axis_clk, and set properties
  set xlconcat_tx_rx_axis_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_tx_rx_axis_clk ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {1} \
    CONFIG.IN2_WIDTH {1} \
    CONFIG.IN3_WIDTH {1} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_tx_rx_axis_clk


  # Create instance: xlconcat_tx_rx_axis_rst, and set properties
  set xlconcat_tx_rx_axis_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_tx_rx_axis_rst ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {1} \
    CONFIG.IN2_WIDTH {1} \
    CONFIG.IN3_WIDTH {1} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_tx_rx_axis_rst


  # Create instance: xlconcat_tx_rx_axis_rstn, and set properties
  set xlconcat_tx_rx_axis_rstn [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_tx_rx_axis_rstn ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {1} \
    CONFIG.IN2_WIDTH {1} \
    CONFIG.IN3_WIDTH {1} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_tx_rx_axis_rstn


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_1pps_clk_n_1 [get_bd_intf_pins CLK_IN_D_1pps_clk] [get_bd_intf_pins mrmac_1pps_in_ibufds/CLK_IN_D]

  # Create port connections
  connect_bd_net -net GT_WRAPPER_rx_mst_reset_done_out  [get_bd_pins rx_mst_reset_done] \
  [get_bd_pins util_vector_logic_rx_rst/Op1]
  connect_bd_net -net GT_WRAPPER_tx_mst_reset_done_out  [get_bd_pins tx_mst_reset_done] \
  [get_bd_pins util_vector_logic_tx_rst/Op1]
  connect_bd_net -net Master_Timer_Wrapper_OBUF_DS_1PPS_OUT_N_0  [get_bd_pins mrmac_1pps_out_obufds/OBUF_DS_N] \
  [get_bd_pins OBUF_DS_1PPS_OUT_N_0]
  connect_bd_net -net Master_Timer_Wrapper_OBUF_DS_1PPS_OUT_P_0  [get_bd_pins mrmac_1pps_out_obufds/OBUF_DS_P] \
  [get_bd_pins OBUF_DS_1PPS_OUT_P_0]
  connect_bd_net -net clk_in1_1  [get_bd_pins clk_in1] \
  [get_bd_pins clk_wizard_tod_clk/clk_in1]
  connect_bd_net -net clk_wizard_tod_clk_clk_out1  [get_bd_pins clk_wizard_tod_clk/clk_out1] \
  [get_bd_pins ts_clk] \
  [get_bd_pins proc_sys_reset_2/slowest_sync_clk] \
  [get_bd_pins xlconcat_ts_clk/In0] \
  [get_bd_pins xlconcat_ts_clk/In1] \
  [get_bd_pins xlconcat_ts_clk/In2] \
  [get_bd_pins xlconcat_ts_clk/In3]
  connect_bd_net -net clk_wizard_tx_rx_axis_clk_out1  [get_bd_pins clk_wizard_tx_rx_axis/clk_out1] \
  [get_bd_pins axis_tx_rx_clk] \
  [get_bd_pins mcdma_clk] \
  [get_bd_pins proc_sys_reset_3/slowest_sync_clk] \
  [get_bd_pins xlconcat_tx_rx_axis_clk/In0] \
  [get_bd_pins xlconcat_tx_rx_axis_clk/In1] \
  [get_bd_pins xlconcat_tx_rx_axis_clk/In2] \
  [get_bd_pins xlconcat_tx_rx_axis_clk/In3]
  connect_bd_net -net mrmac_0_core_tod_1pps_out  [get_bd_pins tod_1pps_out] \
  [get_bd_pins mrmac_1pps_out_obufds/OBUF_IN]
  connect_bd_net -net mrmac_1pps_in_ibufds_IBUF_OUT  [get_bd_pins mrmac_1pps_in_ibufds/IBUF_OUT] \
  [get_bd_pins tod_1pps_in]
  connect_bd_net -net proc_sys_reset_0_bus_struct_reset  [get_bd_pins proc_sys_reset_0/bus_struct_reset] \
  [get_bd_pins axi_lite_bus_struct_reset]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn  [get_bd_pins proc_sys_reset_0/interconnect_aresetn] \
  [get_bd_pins axi_lite_interconnect_resetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins axi_lite_perpheral_resetn] \
  [get_bd_pins proc_sys_reset_2/ext_reset_in] \
  [get_bd_pins proc_sys_reset_3/ext_reset_in]
  connect_bd_net -net proc_sys_reset_2_peripheral_reset  [get_bd_pins proc_sys_reset_2/peripheral_reset] \
  [get_bd_pins xlconcat_ts_reset/In0] \
  [get_bd_pins xlconcat_ts_reset/In1] \
  [get_bd_pins xlconcat_ts_reset/In2] \
  [get_bd_pins xlconcat_ts_reset/In3]
  connect_bd_net -net proc_sys_reset_3_peripheral_aresetn  [get_bd_pins proc_sys_reset_3/peripheral_aresetn] \
  [get_bd_pins mcdma_resetn] \
  [get_bd_pins xlconcat_tx_rx_axis_rstn/In0] \
  [get_bd_pins xlconcat_tx_rx_axis_rstn/In1] \
  [get_bd_pins xlconcat_tx_rx_axis_rstn/In2] \
  [get_bd_pins xlconcat_tx_rx_axis_rstn/In3]
  connect_bd_net -net proc_sys_reset_3_peripheral_reset  [get_bd_pins proc_sys_reset_3/peripheral_reset] \
  [get_bd_pins xlconcat_tx_rx_axis_rst/In0] \
  [get_bd_pins xlconcat_tx_rx_axis_rst/In1] \
  [get_bd_pins xlconcat_tx_rx_axis_rst/In2] \
  [get_bd_pins xlconcat_tx_rx_axis_rst/In3]
  connect_bd_net -net util_vector_logic_rx_rst_Res  [get_bd_pins util_vector_logic_rx_rst/Res] \
  [get_bd_pins rx_reset]
  connect_bd_net -net util_vector_logic_tx_rst_Res  [get_bd_pins util_vector_logic_tx_rst/Res] \
  [get_bd_pins tx_reset]
  connect_bd_net -net versal_cips_0_pl_clk0  [get_bd_pins s_axi_lite_aclk] \
  [get_bd_pins clk_wizard_tx_rx_axis/clk_in1] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net versal_cips_0_pl_resetn0  [get_bd_pins pl0_resetn] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlconcat_ts_clk_dout  [get_bd_pins xlconcat_ts_clk/dout] \
  [get_bd_pins timestamp_clk]
  connect_bd_net -net xlconcat_ts_reset_dout  [get_bd_pins xlconcat_ts_reset/dout] \
  [get_bd_pins ts_reset]
  connect_bd_net -net xlconcat_tx_rx_axis_clk_dout  [get_bd_pins xlconcat_tx_rx_axis_clk/dout] \
  [get_bd_pins axis_clk_rx_out] \
  [get_bd_pins axis_clk_tx_out]
  connect_bd_net -net xlconcat_tx_rx_axis_rst_dout  [get_bd_pins xlconcat_tx_rx_axis_rst/dout] \
  [get_bd_pins rx_axis_rst] \
  [get_bd_pins tx_axis_rst]
  connect_bd_net -net xlconcat_tx_rx_axis_rstn_dout  [get_bd_pins xlconcat_tx_rx_axis_rstn/dout] \
  [get_bd_pins rx_axis_rstn] \
  [get_bd_pins tx_axis_rstn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CLK_IN_D [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   ] $CLK_IN_D

  set CLK_IN_D_1pps_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_1pps_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {1} \
   ] $CLK_IN_D_1pps_clk

  set ch0_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c0 ]

  set ch0_lpddr4_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c1 ]

  set ch1_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c0 ]

  set ch1_lpddr4_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c1 ]

  set lpddr4_sma_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $lpddr4_sma_clk1

  set lpddr4_sma_clk2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $lpddr4_sma_clk2


  # Create ports
  set OBUF_DS_1PPS_OUT_N_0 [ create_bd_port -dir O -from 0 -to 0 -type clk OBUF_DS_1PPS_OUT_N_0 ]
  set OBUF_DS_1PPS_OUT_P_0 [ create_bd_port -dir O -from 0 -to 0 -type clk OBUF_DS_1PPS_OUT_P_0 ]
  set RX_REC_CLK_out_n_0 [ create_bd_port -dir O -from 0 -to 0 RX_REC_CLK_out_n_0 ]
  set RX_REC_CLK_out_p_0 [ create_bd_port -dir O -from 0 -to 0 RX_REC_CLK_out_p_0 ]
  set gt_rxn_in_0 [ create_bd_port -dir I -from 3 -to 0 gt_rxn_in_0 ]
  set gt_rxp_in_0 [ create_bd_port -dir I -from 3 -to 0 gt_rxp_in_0 ]
  set gt_txn_out_0 [ create_bd_port -dir O -from 3 -to 0 gt_txn_out_0 ]
  set gt_txp_out_0 [ create_bd_port -dir O -from 3 -to 0 gt_txp_out_0 ]

  # Create instance: CLK_RST_WRAPPER
  create_hier_cell_CLK_RST_WRAPPER [current_bd_instance .] CLK_RST_WRAPPER

  # Create instance: DATAPATH_MCDMA_HIER
  create_hier_cell_DATAPATH_MCDMA_HIER [current_bd_instance .] DATAPATH_MCDMA_HIER

  # Create instance: GT_WRAPPER
  create_hier_cell_GT_WRAPPER [current_bd_instance .] GT_WRAPPER

  # Create instance: MRMAC_1588_HELPER_HIER
  create_hier_cell_MRMAC_1588_HELPER_HIER [current_bd_instance .] MRMAC_1588_HELPER_HIER

  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CH0_DDR4_0_BOARD_INTERFACE {Custom} \
    CONFIG.CH0_LPDDR4_0_BOARD_INTERFACE {ch0_lpddr4_c0} \
    CONFIG.CH0_LPDDR4_1_BOARD_INTERFACE {ch0_lpddr4_c1} \
    CONFIG.CH1_LPDDR4_0_BOARD_INTERFACE {ch1_lpddr4_c0} \
    CONFIG.CH1_LPDDR4_1_BOARD_INTERFACE {ch1_lpddr4_c1} \
    CONFIG.HBM_CHNL0_CONFIG {HBM_REORDER_EN FALSE HBM_MAINTAIN_COHERENCY TRUE HBM_Q_AGE_LIMIT 0x7f HBM_CLOSE_PAGE_REORDER FALSE HBM_LOOKAHEAD_PCH TRUE HBM_COMMAND_PARITY FALSE HBM_DQ_WR_PARITY FALSE HBM_DQ_RD_PARITY\
FALSE HBM_RD_DBI FALSE HBM_WR_DBI FALSE HBM_REFRESH_MODE ALL_BANK_REFRESH HBM_PC0_ADDRESS_MAP SID,RA14,RA13,RA12,RA11,RA10,RA9,RA8,RA7,RA6,RA5,RA4,RA3,RA2,RA1,RA0,BA3,BA2,BA1,BA0,CA5,CA4,CA3,CA2,CA1,NC,NA,NA,NA,NA\
HBM_PC1_ADDRESS_MAP SID,RA14,RA13,RA12,RA11,RA10,RA9,RA8,RA7,RA6,RA5,RA4,RA3,RA2,RA1,RA0,BA3,BA2,BA HBM_PC0_PRE_DEFINED_ADDRESS_MAP ROW_BANK_COLUMN HBM_PC1_PRE_DEFINED_ADDRESS_MAP ROW_BANK_COLUMN HBM_PC0_USER_DEFINED_ADDRESS_MAP\
NONE HBM_PC1_USER_DEFINED_ADDRESS_MAP NONE HBM_WRITE_BACK_CORRECTED_DATA TRUE} \
    CONFIG.MC2_CONFIG_NUM {config26} \
    CONFIG.MC3_CONFIG_NUM {config26} \
    CONFIG.MC_ADDR_WIDTH {6} \
    CONFIG.MC_BOARD_INTRF_EN {true} \
    CONFIG.MC_BURST_LENGTH {16} \
    CONFIG.MC_CASLATENCY {36} \
    CONFIG.MC_CASWRITELATENCY {18} \
    CONFIG.MC_CH0_LP4_CHA_ENABLE {true} \
    CONFIG.MC_CH0_LP4_CHB_ENABLE {true} \
    CONFIG.MC_CH1_LP4_CHA_ENABLE {true} \
    CONFIG.MC_CH1_LP4_CHB_ENABLE {true} \
    CONFIG.MC_CKE_WIDTH {0} \
    CONFIG.MC_CK_WIDTH {0} \
    CONFIG.MC_DM_WIDTH {4} \
    CONFIG.MC_DQS_WIDTH {4} \
    CONFIG.MC_DQ_WIDTH {32} \
    CONFIG.MC_ECC {false} \
    CONFIG.MC_ECC_SCRUB_SIZE {4096} \
    CONFIG.MC_F1_CASLATENCY {36} \
    CONFIG.MC_F1_CASWRITELATENCY {18} \
    CONFIG.MC_F1_LPDDR4_MR13 {0x00C0} \
    CONFIG.MC_F1_TCCD_L {0} \
    CONFIG.MC_F1_TCCD_L_MIN {0} \
    CONFIG.MC_F1_TFAW {40000} \
    CONFIG.MC_F1_TFAWMIN {40000} \
    CONFIG.MC_F1_TMOD {0} \
    CONFIG.MC_F1_TMOD_MIN {0} \
    CONFIG.MC_F1_TMRD {14000} \
    CONFIG.MC_F1_TMRDMIN {14000} \
    CONFIG.MC_F1_TMRW {10000} \
    CONFIG.MC_F1_TMRWMIN {10000} \
    CONFIG.MC_F1_TRAS {42000} \
    CONFIG.MC_F1_TRASMIN {42000} \
    CONFIG.MC_F1_TRCD {18000} \
    CONFIG.MC_F1_TRCDMIN {18000} \
    CONFIG.MC_F1_TRPAB {21000} \
    CONFIG.MC_F1_TRPABMIN {21000} \
    CONFIG.MC_F1_TRPPB {18000} \
    CONFIG.MC_F1_TRPPBMIN {18000} \
    CONFIG.MC_F1_TRRD {10000} \
    CONFIG.MC_F1_TRRDMIN {10000} \
    CONFIG.MC_F1_TRRD_L {0} \
    CONFIG.MC_F1_TRRD_L_MIN {0} \
    CONFIG.MC_F1_TRRD_S {0} \
    CONFIG.MC_F1_TRRD_S_MIN {0} \
    CONFIG.MC_F1_TWR {18000} \
    CONFIG.MC_F1_TWRMIN {18000} \
    CONFIG.MC_F1_TWTR {10000} \
    CONFIG.MC_F1_TWTRMIN {10000} \
    CONFIG.MC_F1_TWTR_L {0} \
    CONFIG.MC_F1_TWTR_L_MIN {0} \
    CONFIG.MC_F1_TWTR_S {0} \
    CONFIG.MC_F1_TWTR_S_MIN {0} \
    CONFIG.MC_F1_TZQLAT {30000} \
    CONFIG.MC_F1_TZQLATMIN {30000} \
    CONFIG.MC_INTERLEAVE_SIZE {2048} \
    CONFIG.MC_IP_TIMEPERIOD1 {512} \
    CONFIG.MC_LP4_CA_A_WIDTH {6} \
    CONFIG.MC_LP4_CA_B_WIDTH {6} \
    CONFIG.MC_LP4_CKE_A_WIDTH {1} \
    CONFIG.MC_LP4_CKE_B_WIDTH {1} \
    CONFIG.MC_LP4_CKT_A_WIDTH {1} \
    CONFIG.MC_LP4_CKT_B_WIDTH {1} \
    CONFIG.MC_LP4_CS_A_WIDTH {1} \
    CONFIG.MC_LP4_CS_B_WIDTH {1} \
    CONFIG.MC_LP4_DMI_A_WIDTH {2} \
    CONFIG.MC_LP4_DMI_B_WIDTH {2} \
    CONFIG.MC_LP4_DQS_A_WIDTH {2} \
    CONFIG.MC_LP4_DQS_B_WIDTH {2} \
    CONFIG.MC_LP4_DQ_A_WIDTH {16} \
    CONFIG.MC_LP4_DQ_B_WIDTH {16} \
    CONFIG.MC_LP4_RESETN_WIDTH {1} \
    CONFIG.MC_NETLIST_SIMULATION {true} \
    CONFIG.MC_ODTLon {6} \
    CONFIG.MC_ODT_WIDTH {0} \
    CONFIG.MC_PER_RD_INTVL {0} \
    CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_BANK_COLUMN} \
    CONFIG.MC_READ_BANDWIDTH {6400.0} \
    CONFIG.MC_SYSTEM_CLOCK {Differential} \
    CONFIG.MC_TCCD {8} \
    CONFIG.MC_TCCD_L {0} \
    CONFIG.MC_TCCD_L_MIN {0} \
    CONFIG.MC_TCKE {12} \
    CONFIG.MC_TCKEMIN {12} \
    CONFIG.MC_TDQS2DQ_MAX {800} \
    CONFIG.MC_TDQS2DQ_MIN {200} \
    CONFIG.MC_TDQSCK_MAX {3500} \
    CONFIG.MC_TFAW {40000} \
    CONFIG.MC_TFAWMIN {40000} \
    CONFIG.MC_TMOD {0} \
    CONFIG.MC_TMOD_MIN {0} \
    CONFIG.MC_TMRD {14000} \
    CONFIG.MC_TMRDMIN {14000} \
    CONFIG.MC_TMRD_div4 {10} \
    CONFIG.MC_TMRD_nCK {23} \
    CONFIG.MC_TMRW {10000} \
    CONFIG.MC_TMRWMIN {10000} \
    CONFIG.MC_TMRW_div4 {10} \
    CONFIG.MC_TMRW_nCK {16} \
    CONFIG.MC_TODTon_MIN {3} \
    CONFIG.MC_TOSCO {40000} \
    CONFIG.MC_TOSCOMIN {40000} \
    CONFIG.MC_TOSCO_nCK {64} \
    CONFIG.MC_TPBR2PBR {90000} \
    CONFIG.MC_TPBR2PBRMIN {90000} \
    CONFIG.MC_TRAS {42000} \
    CONFIG.MC_TRASMIN {42000} \
    CONFIG.MC_TRAS_nCK {68} \
    CONFIG.MC_TRC {63000} \
    CONFIG.MC_TRCD {18000} \
    CONFIG.MC_TRCDMIN {18000} \
    CONFIG.MC_TRCD_nCK {29} \
    CONFIG.MC_TRCMIN {0} \
    CONFIG.MC_TREFI {3904000} \
    CONFIG.MC_TREFIPB {488000} \
    CONFIG.MC_TRFC {0} \
    CONFIG.MC_TRFCAB {280000} \
    CONFIG.MC_TRFCABMIN {280000} \
    CONFIG.MC_TRFCMIN {0} \
    CONFIG.MC_TRFCPB {140000} \
    CONFIG.MC_TRFCPBMIN {140000} \
    CONFIG.MC_TRP {0} \
    CONFIG.MC_TRPAB {21000} \
    CONFIG.MC_TRPABMIN {21000} \
    CONFIG.MC_TRPAB_nCK {34} \
    CONFIG.MC_TRPMIN {0} \
    CONFIG.MC_TRPPB {18000} \
    CONFIG.MC_TRPPBMIN {18000} \
    CONFIG.MC_TRPPB_nCK {29} \
    CONFIG.MC_TRPRE {1.8} \
    CONFIG.MC_TRRD {10000} \
    CONFIG.MC_TRRDMIN {10000} \
    CONFIG.MC_TRRD_L {0} \
    CONFIG.MC_TRRD_L_MIN {0} \
    CONFIG.MC_TRRD_S {0} \
    CONFIG.MC_TRRD_S_MIN {0} \
    CONFIG.MC_TRRD_nCK {16} \
    CONFIG.MC_TWPRE {1.8} \
    CONFIG.MC_TWPST {0.4} \
    CONFIG.MC_TWR {18000} \
    CONFIG.MC_TWRMIN {18000} \
    CONFIG.MC_TWR_nCK {29} \
    CONFIG.MC_TWTR {10000} \
    CONFIG.MC_TWTRMIN {10000} \
    CONFIG.MC_TWTR_L {0} \
    CONFIG.MC_TWTR_S {0} \
    CONFIG.MC_TWTR_S_MIN {0} \
    CONFIG.MC_TWTR_nCK {16} \
    CONFIG.MC_TXP {12} \
    CONFIG.MC_TXPMIN {12} \
    CONFIG.MC_TXPR {0} \
    CONFIG.MC_TZQCAL {1000000} \
    CONFIG.MC_TZQCAL_div4 {400} \
    CONFIG.MC_TZQCS_ITVL {0} \
    CONFIG.MC_TZQLAT {30000} \
    CONFIG.MC_TZQLATMIN {30000} \
    CONFIG.MC_TZQLAT_div4 {12} \
    CONFIG.MC_TZQLAT_nCK {48} \
    CONFIG.MC_TZQ_START_ITVL {1000000000} \
    CONFIG.MC_USER_DEFINED_ADDRESS_MAP {16RA-3BA-10CA} \
    CONFIG.MC_WRITE_BANDWIDTH {6400.0} \
    CONFIG.MC_XPLL_CLKOUT1_PERIOD {1250} \
    CONFIG.MC_XPLL_CLKOUT1_PHASE {238.176} \
    CONFIG.NUM_CLKS {9} \
    CONFIG.NUM_MC {2} \
    CONFIG.NUM_MCP {3} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_SI {24} \
    CONFIG.sys_clk0_BOARD_INTERFACE {lpddr4_sma_clk1} \
    CONFIG.sys_clk1_BOARD_INTERFACE {lpddr4_sma_clk2} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {50} write_bw {50} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1250} write_bw {1250} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {3200} write_bw {50} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {50} write_bw {3200} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S09_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {750} write_bw {750} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S10_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {3200} write_bw {50} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S11_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {50} write_bw {3200} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S12_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {750} write_bw {750} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S13_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {3200} write_bw {50} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S14_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {50} write_bw {3200} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S15_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {750} write_bw {750} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S16_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {3200} write_bw {50} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S17_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {50} write_bw {3200} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S18_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {750} write_bw {750} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S19_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S20_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S21_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S22_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S23_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S08_AXI:S09_AXI:S10_AXI:S11_AXI:S12_AXI:S13_AXI:S14_AXI:S15_AXI:S16_AXI:S17_AXI:S18_AXI:S19_AXI:S20_AXI:S21_AXI:S22_AXI:S23_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk8]

  # Create instance: mrmac_0_core, and set properties
  set mrmac_0_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:mrmac:3.1 mrmac_0_core ]
  set_property -dict [list \
    CONFIG.FLEX_PORT1_MODE_C0 {N/A} \
    CONFIG.FLEX_PORT2_MODE_C0 {N/A} \
    CONFIG.FLEX_PORT3_MODE_C0 {N/A} \
    CONFIG.GT_REF_CLK_FREQ_C0 {322.265625} \
    CONFIG.MAC_PORT0_ENABLE_TIME_STAMPING_C0 {1} \
    CONFIG.MAC_PORT0_RATE_C0 {25GE} \
    CONFIG.MAC_PORT1_ENABLE_TIME_STAMPING_C0 {1} \
    CONFIG.MAC_PORT1_RATE_C0 {25GE} \
    CONFIG.MAC_PORT2_ENABLE_TIME_STAMPING_C0 {1} \
    CONFIG.MAC_PORT2_RATE_C0 {25GE} \
    CONFIG.MAC_PORT3_ENABLE_TIME_STAMPING_C0 {1} \
    CONFIG.MAC_PORT3_RATE_C0 {25GE} \
    CONFIG.MRMAC_CLIENTS_C0 {4} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_C1 {N/A} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT0_C0 {Independent 64b  Non-Segmented} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT1_C0 {Independent 64b  Non-Segmented} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT2_C0 {Independent 64b  Non-Segmented} \
    CONFIG.MRMAC_DATA_PATH_INTERFACE_PORT3_C0 {Independent 64b  Non-Segmented} \
    CONFIG.MRMAC_LOCATION_C0 {MRMAC_X0Y0} \
    CONFIG.MRMAC_PRESET_C0 {4x25GE Wide} \
    CONFIG.MRMAC_SPEED_C0 {4x25GE} \
  ] $mrmac_0_core


  # Create instance: mrmac_constant_drive_zero, and set properties
  set mrmac_constant_drive_zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_constant_drive_zero ]
  set_property CONFIG.CONST_VAL {0} $mrmac_constant_drive_zero


  # Create instance: mrmac_constant_drive_zero_16bit, and set properties
  set mrmac_constant_drive_zero_16bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_constant_drive_zero_16bit ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {16} \
  ] $mrmac_constant_drive_zero_16bit


  # Create instance: mrmac_constant_drive_zero_1bit, and set properties
  set mrmac_constant_drive_zero_1bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_constant_drive_zero_1bit ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {1} \
  ] $mrmac_constant_drive_zero_1bit


  # Create instance: mrmac_constant_drive_zero_1bit_flex, and set properties
  set mrmac_constant_drive_zero_1bit_flex [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_constant_drive_zero_1bit_flex ]
  set_property CONFIG.CONST_VAL {0} $mrmac_constant_drive_zero_1bit_flex


  # Create instance: mrmac_constant_drive_zero_2bit, and set properties
  set mrmac_constant_drive_zero_2bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_constant_drive_zero_2bit ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {2} \
  ] $mrmac_constant_drive_zero_2bit


  # Create instance: mrmac_constant_drive_zero_3bit, and set properties
  set mrmac_constant_drive_zero_3bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_constant_drive_zero_3bit ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {3} \
  ] $mrmac_constant_drive_zero_3bit


  # Create instance: mrmac_constant_drive_zero_66bit, and set properties
  set mrmac_constant_drive_zero_66bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_constant_drive_zero_66bit ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {66} \
  ] $mrmac_constant_drive_zero_66bit


  # Create instance: mrmac_constant_drive_zero_8bit, and set properties
  set mrmac_constant_drive_zero_8bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_constant_drive_zero_8bit ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {8} \
  ] $mrmac_constant_drive_zero_8bit


  # Create instance: mrmac_pm_tick_drive_zero, and set properties
  set mrmac_pm_tick_drive_zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_pm_tick_drive_zero ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {4} \
  ] $mrmac_pm_tick_drive_zero


  # Create instance: mrmac_tx_preamble_value, and set properties
  set mrmac_tx_preamble_value [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mrmac_tx_preamble_value ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x555555555555d5} \
    CONFIG.CONST_WIDTH {56} \
  ] $mrmac_tx_preamble_value


  # Create instance: subsys_axi_ctl_smartconnect, and set properties
  set subsys_axi_ctl_smartconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 subsys_axi_ctl_smartconnect ]
  set_property -dict [list \
    CONFIG.NUM_MI {8} \
    CONFIG.NUM_SI {1} \
  ] $subsys_axi_ctl_smartconnect


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_0


  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_1


  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_2


  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_3


  # Create instance: xlconcat_4, and set properties
  set xlconcat_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_4 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_4


  # Create instance: xlconcat_5, and set properties
  set xlconcat_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_5 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat_5


  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property -dict [list \
    CONFIG.CLOCK_MODE {Custom} \
    CONFIG.DDR_MEMORY_MODE {Custom} \
    CONFIG.DEBUG_MODE {JTAG} \
    CONFIG.DESIGN_MODE {1} \
    CONFIG.PS_BOARD_INTERFACE {Custom} \
    CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      CLOCK_MODE {Custom} \
      DDR_MEMORY_MODE {Custom} \
      DEBUG_MODE {JTAG} \
      DESIGN_MODE {1} \
      PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
      PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}} \
      PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_OSPI_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 11}} {MODE Single}} \
      PMC_QSPI_COHERENCY {0} \
      PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}} \
      PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_REF_CLK_FREQMHZ {33.3333} \
      PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
      PMC_SD1_COHERENCY {0} \
      PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
      PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x3} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x36} {CLK_50_DDR_OTAP_DLY 0x3} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO\
{PMC_MIO 26 .. 36}}} \
      PMC_SD1_SLOT_TYPE {SD 3.0} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PS_BOARD_INTERFACE {Custom} \
      PS_CAN1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 40 .. 41}}} \
      PS_CRL_CAN1_REF_CTRL_FREQMHZ {160} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
      PS_ENET1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 12 .. 23}}} \
      PS_GEN_IPI0_ENABLE {1} \
      PS_GEN_IPI0_MASTER {A72} \
      PS_GEN_IPI1_ENABLE {1} \
      PS_GEN_IPI2_ENABLE {1} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_HSDP_EGRESS_TRAFFIC {JTAG} \
      PS_HSDP_INGRESS_TRAFFIC {JTAG} \
      PS_HSDP_MODE {NONE} \
      PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
      PS_IRQ_USAGE {{CH0 1} {CH1 1} {CH10 1} {CH11 1} {CH12 1} {CH13 0} {CH14 0} {CH15 0} {CH2 1} {CH3 1} {CH4 1} {CH5 1} {CH6 1} {CH7 1} {CH8 1} {CH9 1}} \
      PS_MIO19 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO21 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_PCIE_EP_RESET1_IO {PMC_MIO 38} \
      PS_PCIE_EP_RESET2_IO {PMC_MIO 39} \
      PS_PCIE_RESET {ENABLE 1} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USE_FPD_AXI_NOC0 {1} \
      PS_USE_FPD_AXI_NOC1 {1} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_M_AXI_FPD {1} \
      PS_USE_M_AXI_LPD {1} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_PMCPL_CLK0 {1} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
    } \
  ] $versal_cips_0


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_ports CLK_IN_D] [get_bd_intf_pins GT_WRAPPER/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_1pps_clk_1 [get_bd_intf_ports CLK_IN_D_1pps_clk] [get_bd_intf_pins CLK_RST_WRAPPER/CLK_IN_D_1pps_clk]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_MM2S [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_MM2S] [get_bd_intf_pins axi_noc_0/S08_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_MM2S1 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_MM2S1] [get_bd_intf_pins axi_noc_0/S11_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_MM2S2 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_MM2S2] [get_bd_intf_pins axi_noc_0/S14_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_MM2S3 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_MM2S3] [get_bd_intf_pins axi_noc_0/S17_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_S2MM [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_S2MM] [get_bd_intf_pins axi_noc_0/S09_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_S2MM1 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_S2MM1] [get_bd_intf_pins axi_noc_0/S12_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_S2MM2 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_S2MM2] [get_bd_intf_pins axi_noc_0/S15_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_S2MM3 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_S2MM3] [get_bd_intf_pins axi_noc_0/S18_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_SG [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_SG] [get_bd_intf_pins axi_noc_0/S10_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_SG1 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_SG1] [get_bd_intf_pins axi_noc_0/S13_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_SG2 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_SG2] [get_bd_intf_pins axi_noc_0/S16_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_M_AXI_SG3 [get_bd_intf_pins DATAPATH_MCDMA_HIER/M_AXI_SG3] [get_bd_intf_pins axi_noc_0/S19_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_m00_axi [get_bd_intf_pins DATAPATH_MCDMA_HIER/m00_axi] [get_bd_intf_pins axi_noc_0/S20_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_m00_axi1 [get_bd_intf_pins DATAPATH_MCDMA_HIER/m00_axi1] [get_bd_intf_pins axi_noc_0/S21_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_m00_axi2 [get_bd_intf_pins DATAPATH_MCDMA_HIER/m00_axi2] [get_bd_intf_pins axi_noc_0/S22_AXI]
  connect_bd_intf_net -intf_net DATAPATH_MCDMA_HIER_m00_axi3 [get_bd_intf_pins DATAPATH_MCDMA_HIER/m00_axi3] [get_bd_intf_pins axi_noc_0/S23_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins GT_WRAPPER/S00_AXI] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M02_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_0 [get_bd_intf_ports ch0_lpddr4_c0] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_1 [get_bd_intf_ports ch0_lpddr4_c1] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_0 [get_bd_intf_ports ch1_lpddr4_c0] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_1 [get_bd_intf_ports ch1_lpddr4_c1] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_1]
  connect_bd_intf_net -intf_net lpddr4_sma_clk1_1 [get_bd_intf_ports lpddr4_sma_clk1] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net lpddr4_sma_clk2_1 [get_bd_intf_ports lpddr4_sma_clk2] [get_bd_intf_pins axi_noc_0/sys_clk1]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_0 [get_bd_intf_pins GT_WRAPPER/RX0_GT_IP_Interface] [get_bd_intf_pins mrmac_0_core/gt_rx_serdes_interface_0]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_1 [get_bd_intf_pins GT_WRAPPER/RX1_GT_IP_Interface] [get_bd_intf_pins mrmac_0_core/gt_rx_serdes_interface_1]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_2 [get_bd_intf_pins GT_WRAPPER/RX2_GT_IP_Interface] [get_bd_intf_pins mrmac_0_core/gt_rx_serdes_interface_2]
  connect_bd_intf_net -intf_net mrmac_0_gt_rx_serdes_interface_3 [get_bd_intf_pins GT_WRAPPER/RX3_GT_IP_Interface] [get_bd_intf_pins mrmac_0_core/gt_rx_serdes_interface_3]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_0 [get_bd_intf_pins GT_WRAPPER/TX0_GT_IP_Interface] [get_bd_intf_pins mrmac_0_core/gt_tx_serdes_interface_0]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_1 [get_bd_intf_pins GT_WRAPPER/TX1_GT_IP_Interface] [get_bd_intf_pins mrmac_0_core/gt_tx_serdes_interface_1]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_2 [get_bd_intf_pins GT_WRAPPER/TX2_GT_IP_Interface] [get_bd_intf_pins mrmac_0_core/gt_tx_serdes_interface_2]
  connect_bd_intf_net -intf_net mrmac_0_gt_tx_serdes_interface_3 [get_bd_intf_pins GT_WRAPPER/TX3_GT_IP_Interface] [get_bd_intf_pins mrmac_0_core/gt_tx_serdes_interface_3]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins mrmac_0_core/s_axi] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins GT_WRAPPER/AXI4_LITE] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M01_AXI]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M03_AXI [get_bd_intf_pins DATAPATH_MCDMA_HIER/S_AXI_LITE] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M03_AXI]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M04_AXI [get_bd_intf_pins DATAPATH_MCDMA_HIER/S_AXI_LITE1] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M04_AXI]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M05_AXI [get_bd_intf_pins DATAPATH_MCDMA_HIER/S_AXI_LITE2] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M05_AXI]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M06_AXI [get_bd_intf_pins DATAPATH_MCDMA_HIER/S_AXI_LITE3] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M06_AXI]
  connect_bd_intf_net -intf_net subsys_axi_ctl_smartconnect_M07_AXI [get_bd_intf_pins DATAPATH_MCDMA_HIER/S_AXI] [get_bd_intf_pins subsys_axi_ctl_smartconnect/M07_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_0 [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S05_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_1 [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_1] [get_bd_intf_pins axi_noc_0/S06_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0] [get_bd_intf_pins axi_noc_0/S01_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1] [get_bd_intf_pins axi_noc_0/S02_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2] [get_bd_intf_pins axi_noc_0/S03_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3] [get_bd_intf_pins axi_noc_0/S04_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_LPD_AXI_NOC_0 [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S07_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins subsys_axi_ctl_smartconnect/S00_AXI] [get_bd_intf_pins versal_cips_0/M_AXI_FPD]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_LPD [get_bd_intf_pins versal_cips_0/M_AXI_LPD] [get_bd_intf_pins MRMAC_1588_HELPER_HIER/S00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S00_AXI]

  # Create port connections
  connect_bd_net -net CLK_RST_WRAPPER_OBUF_DS_1PPS_OUT_N_0  [get_bd_pins CLK_RST_WRAPPER/OBUF_DS_1PPS_OUT_N_0] \
  [get_bd_ports OBUF_DS_1PPS_OUT_N_0]
  connect_bd_net -net CLK_RST_WRAPPER_OBUF_DS_1PPS_OUT_P_0  [get_bd_pins CLK_RST_WRAPPER/OBUF_DS_1PPS_OUT_P_0] \
  [get_bd_ports OBUF_DS_1PPS_OUT_P_0]
  connect_bd_net -net CLK_RST_WRAPPER_axi_lite_bus_struct_reset  [get_bd_pins CLK_RST_WRAPPER/axi_lite_bus_struct_reset] \
  [get_bd_pins mrmac_0_core/rx_flexif_reset]
  connect_bd_net -net CLK_RST_WRAPPER_dout  [get_bd_pins CLK_RST_WRAPPER/rx_axis_rst] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_rst]
  connect_bd_net -net CLK_RST_WRAPPER_dout1  [get_bd_pins CLK_RST_WRAPPER/tx_axis_rst] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_axis_rst]
  connect_bd_net -net CLK_RST_WRAPPER_dout2  [get_bd_pins CLK_RST_WRAPPER/tx_axis_rstn] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_rstn] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_axis_rstn]
  connect_bd_net -net CLK_RST_WRAPPER_dout3  [get_bd_pins CLK_RST_WRAPPER/rx_axis_rstn] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_rstn] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_rstn]
  connect_bd_net -net CLK_RST_WRAPPER_mcdma_resetn  [get_bd_pins CLK_RST_WRAPPER/mcdma_resetn] \
  [get_bd_pins DATAPATH_MCDMA_HIER/mcdma_resetn]
  connect_bd_net -net CLK_RST_WRAPPER_tod_1pps_in  [get_bd_pins CLK_RST_WRAPPER/tod_1pps_in] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tod_1pps_in]
  connect_bd_net -net CLK_RST_WRAPPER_ts_reset  [get_bd_pins CLK_RST_WRAPPER/ts_reset] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/ts_rst_0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_interrupt  [get_bd_pins DATAPATH_MCDMA_HIER/interrupt] \
  [get_bd_pins versal_cips_0/pl_ps_irq0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_interrupt1  [get_bd_pins DATAPATH_MCDMA_HIER/interrupt1] \
  [get_bd_pins versal_cips_0/pl_ps_irq1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_interrupt2  [get_bd_pins DATAPATH_MCDMA_HIER/interrupt2] \
  [get_bd_pins versal_cips_0/pl_ps_irq2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_interrupt3  [get_bd_pins DATAPATH_MCDMA_HIER/interrupt3] \
  [get_bd_pins versal_cips_0/pl_ps_irq3]
  connect_bd_net -net DATAPATH_MCDMA_HIER_m_ptp_cf_offset_0  [get_bd_pins DATAPATH_MCDMA_HIER/m_ptp_cf_offset_0] \
  [get_bd_pins mrmac_0_core/tx_ptp_cf_offset_in_0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_m_ptp_cf_offset_0_0  [get_bd_pins DATAPATH_MCDMA_HIER/m_ptp_cf_offset_0_0] \
  [get_bd_pins mrmac_0_core/tx_ptp_cf_offset_in_2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_m_ptp_cf_offset_0_1  [get_bd_pins DATAPATH_MCDMA_HIER/m_ptp_cf_offset_0_1] \
  [get_bd_pins mrmac_0_core/tx_ptp_cf_offset_in_1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_m_ptp_cf_offset_0_2  [get_bd_pins DATAPATH_MCDMA_HIER/m_ptp_cf_offset_0_2] \
  [get_bd_pins mrmac_0_core/tx_ptp_cf_offset_in_3]
  connect_bd_net -net DATAPATH_MCDMA_HIER_m_ptp_upd_chcksum_0  [get_bd_pins DATAPATH_MCDMA_HIER/m_ptp_upd_chcksum_0] \
  [get_bd_pins mrmac_0_core/tx_ptp_upd_chksum_in_0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_m_ptp_upd_chcksum_0_0  [get_bd_pins DATAPATH_MCDMA_HIER/m_ptp_upd_chcksum_0_0] \
  [get_bd_pins mrmac_0_core/tx_ptp_upd_chksum_in_3]
  connect_bd_net -net DATAPATH_MCDMA_HIER_m_ptp_upd_chcksum_0_1  [get_bd_pins DATAPATH_MCDMA_HIER/m_ptp_upd_chcksum_0_1] \
  [get_bd_pins mrmac_0_core/tx_ptp_upd_chksum_in_2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_m_ptp_upd_chcksum_0_2  [get_bd_pins DATAPATH_MCDMA_HIER/m_ptp_upd_chcksum_0_2] \
  [get_bd_pins mrmac_0_core/tx_ptp_upd_chksum_in_1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_mm2s_ch1_introut  [get_bd_pins DATAPATH_MCDMA_HIER/mm2s_ch1_introut] \
  [get_bd_pins versal_cips_0/pl_ps_irq4]
  connect_bd_net -net DATAPATH_MCDMA_HIER_mm2s_ch1_introut1  [get_bd_pins DATAPATH_MCDMA_HIER/mm2s_ch1_introut1] \
  [get_bd_pins versal_cips_0/pl_ps_irq5]
  connect_bd_net -net DATAPATH_MCDMA_HIER_mm2s_ch1_introut2  [get_bd_pins DATAPATH_MCDMA_HIER/mm2s_ch1_introut2] \
  [get_bd_pins versal_cips_0/pl_ps_irq6]
  connect_bd_net -net DATAPATH_MCDMA_HIER_mm2s_ch1_introut3  [get_bd_pins DATAPATH_MCDMA_HIER/mm2s_ch1_introut3] \
  [get_bd_pins versal_cips_0/pl_ps_irq8]
  connect_bd_net -net DATAPATH_MCDMA_HIER_s2mm_ch1_introut  [get_bd_pins DATAPATH_MCDMA_HIER/s2mm_ch1_introut] \
  [get_bd_pins versal_cips_0/pl_ps_irq7]
  connect_bd_net -net DATAPATH_MCDMA_HIER_s2mm_ch1_introut1  [get_bd_pins DATAPATH_MCDMA_HIER/s2mm_ch1_introut1] \
  [get_bd_pins versal_cips_0/pl_ps_irq9]
  connect_bd_net -net DATAPATH_MCDMA_HIER_s2mm_ch1_introut2  [get_bd_pins DATAPATH_MCDMA_HIER/s2mm_ch1_introut2] \
  [get_bd_pins versal_cips_0/pl_ps_irq10]
  connect_bd_net -net DATAPATH_MCDMA_HIER_s2mm_ch1_introut3  [get_bd_pins DATAPATH_MCDMA_HIER/s2mm_ch1_introut3] \
  [get_bd_pins versal_cips_0/pl_ps_irq11]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata2  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata2] \
  [get_bd_pins mrmac_0_core/tx_axis_tdata2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata4  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata4] \
  [get_bd_pins mrmac_0_core/tx_axis_tdata4]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tdata6  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata6] \
  [get_bd_pins mrmac_0_core/tx_axis_tdata6]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user2  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user2] \
  [get_bd_pins mrmac_0_core/tx_axis_tkeep_user2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user4  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user4] \
  [get_bd_pins mrmac_0_core/tx_axis_tkeep_user4]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tkeep_user6  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user6] \
  [get_bd_pins mrmac_0_core/tx_axis_tkeep_user6]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tlast_1  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tlast_1] \
  [get_bd_pins mrmac_0_core/tx_axis_tlast_1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tlast_2  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tlast_2] \
  [get_bd_pins mrmac_0_core/tx_axis_tlast_2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tlast_3  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tlast_3] \
  [get_bd_pins mrmac_0_core/tx_axis_tlast_3]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tvalid_1  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tvalid_1] \
  [get_bd_pins mrmac_0_core/tx_axis_tvalid_1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tvalid_2  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tvalid_2] \
  [get_bd_pins mrmac_0_core/tx_axis_tvalid_2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_axis_tvalid_3  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tvalid_3] \
  [get_bd_pins mrmac_0_core/tx_axis_tvalid_3]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_ptp_1588op_in  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_1588op_in] \
  [get_bd_pins mrmac_0_core/tx_ptp_1588op_in_0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_ptp_1588op_in1  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_1588op_in1] \
  [get_bd_pins mrmac_0_core/tx_ptp_1588op_in_1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_ptp_1588op_in2  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_1588op_in2] \
  [get_bd_pins mrmac_0_core/tx_ptp_1588op_in_2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_ptp_1588op_in3  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_1588op_in3] \
  [get_bd_pins mrmac_0_core/tx_ptp_1588op_in_3]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_ptp_tstamp_tag_out  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_tstamp_tag_out] \
  [get_bd_pins mrmac_0_core/tx_ptp_tag_field_in_0]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_ptp_tstamp_tag_out1  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_tstamp_tag_out1] \
  [get_bd_pins mrmac_0_core/tx_ptp_tag_field_in_1]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_ptp_tstamp_tag_out2  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_tstamp_tag_out2] \
  [get_bd_pins mrmac_0_core/tx_ptp_tag_field_in_2]
  connect_bd_net -net DATAPATH_MCDMA_HIER_tx_ptp_tstamp_tag_out3  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_tstamp_tag_out3] \
  [get_bd_pins mrmac_0_core/tx_ptp_tag_field_in_3]
  connect_bd_net -net GT_WRAPPER_ch0_rxmstresetdone  [get_bd_pins GT_WRAPPER/ch0_rxmstresetdone] \
  [get_bd_pins mrmac_0_core/mst_rx_resetdone_in_0]
  connect_bd_net -net GT_WRAPPER_ch0_rxpmaresetdone  [get_bd_pins GT_WRAPPER/ch0_rxpmaresetdone] \
  [get_bd_pins mrmac_0_core/rx_pma_resetdone_in_0]
  connect_bd_net -net GT_WRAPPER_ch0_txmstresetdone  [get_bd_pins GT_WRAPPER/ch0_txmstresetdone] \
  [get_bd_pins mrmac_0_core/mst_tx_resetdone_in_0]
  connect_bd_net -net GT_WRAPPER_ch0_txpmaresetdone  [get_bd_pins GT_WRAPPER/ch0_txpmaresetdone] \
  [get_bd_pins mrmac_0_core/tx_pma_resetdone_in_2]
  connect_bd_net -net GT_WRAPPER_ch1_rxmstresetdone  [get_bd_pins GT_WRAPPER/ch1_rxmstresetdone] \
  [get_bd_pins mrmac_0_core/mst_rx_resetdone_in_1]
  connect_bd_net -net GT_WRAPPER_ch1_rxpmaresetdone  [get_bd_pins GT_WRAPPER/ch1_rxpmaresetdone] \
  [get_bd_pins mrmac_0_core/rx_pma_resetdone_in_1]
  connect_bd_net -net GT_WRAPPER_ch1_txmstresetdone  [get_bd_pins GT_WRAPPER/ch1_txmstresetdone] \
  [get_bd_pins mrmac_0_core/mst_tx_resetdone_in_1]
  connect_bd_net -net GT_WRAPPER_ch1_txpmaresetdone  [get_bd_pins GT_WRAPPER/ch1_txpmaresetdone] \
  [get_bd_pins mrmac_0_core/tx_pma_resetdone_in_1]
  connect_bd_net -net GT_WRAPPER_ch2_rxmstresetdone  [get_bd_pins GT_WRAPPER/ch2_rxmstresetdone] \
  [get_bd_pins mrmac_0_core/mst_rx_resetdone_in_2]
  connect_bd_net -net GT_WRAPPER_ch2_rxpmaresetdone  [get_bd_pins GT_WRAPPER/ch2_rxpmaresetdone] \
  [get_bd_pins mrmac_0_core/rx_pma_resetdone_in_2]
  connect_bd_net -net GT_WRAPPER_ch2_txmstresetdone  [get_bd_pins GT_WRAPPER/ch2_txmstresetdone] \
  [get_bd_pins mrmac_0_core/mst_tx_resetdone_in_2]
  connect_bd_net -net GT_WRAPPER_ch2_txpmaresetdone  [get_bd_pins GT_WRAPPER/ch2_txpmaresetdone] \
  [get_bd_pins mrmac_0_core/tx_pma_resetdone_in_0]
  connect_bd_net -net GT_WRAPPER_ch3_rxmstresetdone  [get_bd_pins GT_WRAPPER/ch3_rxmstresetdone] \
  [get_bd_pins mrmac_0_core/mst_rx_resetdone_in_3]
  connect_bd_net -net GT_WRAPPER_ch3_rxpmaresetdone  [get_bd_pins GT_WRAPPER/ch3_rxpmaresetdone] \
  [get_bd_pins mrmac_0_core/rx_pma_resetdone_in_3]
  connect_bd_net -net GT_WRAPPER_ch3_txmstresetdone  [get_bd_pins GT_WRAPPER/ch3_txmstresetdone] \
  [get_bd_pins mrmac_0_core/mst_tx_resetdone_in_3]
  connect_bd_net -net GT_WRAPPER_ch3_txpmaresetdone  [get_bd_pins GT_WRAPPER/ch3_txpmaresetdone] \
  [get_bd_pins mrmac_0_core/tx_pma_resetdone_in_3]
  connect_bd_net -net GT_WRAPPER_gt_refclk_div2_fwd  [get_bd_pins GT_WRAPPER/gt_refclk_div2_fwd] \
  [get_bd_pins CLK_RST_WRAPPER/clk_in1]
  connect_bd_net -net GT_WRAPPER_gt_reset_all  [get_bd_pins GT_WRAPPER/gt_reset_all] \
  [get_bd_pins mrmac_0_core/gt_reset_all_in]
  connect_bd_net -net GT_WRAPPER_gt_reset_rx_datapath  [get_bd_pins GT_WRAPPER/gt_reset_rx_datapath] \
  [get_bd_pins mrmac_0_core/gt_reset_rx_datapath_in]
  connect_bd_net -net GT_WRAPPER_gt_reset_tx_datapath  [get_bd_pins GT_WRAPPER/gt_reset_tx_datapath] \
  [get_bd_pins mrmac_0_core/gt_reset_tx_datapath_in]
  connect_bd_net -net GT_WRAPPER_gtpowergood  [get_bd_pins GT_WRAPPER/gtpowergood] \
  [get_bd_pins mrmac_0_core/gtpowergood_in]
  connect_bd_net -net GT_WRAPPER_old_tx_usr_clk1  [get_bd_pins GT_WRAPPER/tx_usr_clk] \
  [get_bd_pins mrmac_0_core/tx_core_clk]
  connect_bd_net -net GT_WRAPPER_rx_usr_clk2  [get_bd_pins GT_WRAPPER/rx_usr_clk2] \
  [get_bd_pins mrmac_0_core/rx_alt_serdes_clk] \
  [get_bd_pins mrmac_0_core/rx_flexif_clk]
  connect_bd_net -net GT_WRAPPER_tx_usr_clk2  [get_bd_pins GT_WRAPPER/tx_usr_clk2] \
  [get_bd_pins mrmac_0_core/tx_alt_serdes_clk] \
  [get_bd_pins mrmac_0_core/tx_flexif_clk]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_ctl_rx_ptp_st_overwrite_ch1  [get_bd_pins MRMAC_1588_HELPER_HIER/ctl_rx_ptp_st_overwrite_ch1] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_st_overwrite_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_ctl_rx_ptp_st_overwrite_ch2  [get_bd_pins MRMAC_1588_HELPER_HIER/ctl_rx_ptp_st_overwrite_ch2] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_st_overwrite_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_ctl_rx_ptp_st_overwrite_ch3  [get_bd_pins MRMAC_1588_HELPER_HIER/ctl_rx_ptp_st_overwrite_ch3] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_st_overwrite_3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_ctl_tx_ptp_st_overwrite_ch1  [get_bd_pins MRMAC_1588_HELPER_HIER/ctl_tx_ptp_st_overwrite_ch1] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_st_overwrite_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_ctl_tx_ptp_st_overwrite_ch2  [get_bd_pins MRMAC_1588_HELPER_HIER/ctl_tx_ptp_st_overwrite_ch2] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_st_overwrite_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_ctl_tx_ptp_st_overwrite_ch3  [get_bd_pins MRMAC_1588_HELPER_HIER/ctl_tx_ptp_st_overwrite_ch3] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_st_overwrite_3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_rx_ptp_st_sync_0  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_rx_ptp_st_sync_0] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_st_sync_0]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_rx_ptp_st_sync_1  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_rx_ptp_st_sync_1] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_st_sync_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_rx_ptp_st_sync_2  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_rx_ptp_st_sync_2] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_st_sync_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_rx_ptp_st_sync_3  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_rx_ptp_st_sync_3] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_st_sync_3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_rx_ptp_systimer_0  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_rx_ptp_systimer_0] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_systemtimer_0]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_rx_ptp_systimer_1  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_rx_ptp_systimer_1] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_systemtimer_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_rx_ptp_systimer_2  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_rx_ptp_systimer_2] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_systemtimer_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_rx_ptp_systimer_3  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_rx_ptp_systimer_3] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_systemtimer_3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_tx_ptp_st_sync_0  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_tx_ptp_st_sync_0] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_st_sync_0]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_tx_ptp_st_sync_1  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_tx_ptp_st_sync_1] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_st_sync_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_tx_ptp_st_sync_2  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_tx_ptp_st_sync_2] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_st_sync_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_tx_ptp_st_sync_3  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_tx_ptp_st_sync_3] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_st_sync_3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_tx_ptp_systimer_0  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_tx_ptp_systimer_0] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_systemtimer_0]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_tx_ptp_systimer_1  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_tx_ptp_systimer_1] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_systemtimer_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_tx_ptp_systimer_2  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_tx_ptp_systimer_2] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_systemtimer_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_mrmac_tx_ptp_systimer_3  [get_bd_pins MRMAC_1588_HELPER_HIER/mrmac_tx_ptp_systimer_3] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_systemtimer_3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_rx_timestamp_tod_0  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_timestamp_tod_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_timestamp_tod]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_rx_timestamp_tod_1  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_timestamp_tod_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_timestamp_tod1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_rx_timestamp_tod_2  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_timestamp_tod_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_timestamp_tod2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_rx_timestamp_tod_3  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_timestamp_tod_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_timestamp_tod3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_rx_timestamp_tod_valid_0  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_timestamp_tod_valid_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_timestamp_tod_valid]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_rx_timestamp_tod_valid_1  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_timestamp_tod_valid_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_timestamp_tod_valid1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_rx_timestamp_tod_valid_2  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_timestamp_tod_valid_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_timestamp_tod_valid2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_rx_timestamp_tod_valid_3  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_timestamp_tod_valid_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_timestamp_tod_valid3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tod_intr  [get_bd_pins MRMAC_1588_HELPER_HIER/tod_intr] \
  [get_bd_pins versal_cips_0/pl_ps_irq12]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_timestamp_tod_0  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_timestamp_tod_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_timestamp_tod]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_timestamp_tod_1  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_timestamp_tod_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_timestamp_tod1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_timestamp_tod_2  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_timestamp_tod_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_timestamp_tod2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_timestamp_tod_3  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_timestamp_tod_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_timestamp_tod3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_timestamp_tod_valid_0  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_timestamp_tod_valid_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_timestamp_tod_valid]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_timestamp_tod_valid_1  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_timestamp_tod_valid_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_timestamp_tod_valid1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_timestamp_tod_valid_2  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_timestamp_tod_valid_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_timestamp_tod_valid2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_timestamp_tod_valid_3  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_timestamp_tod_valid_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_timestamp_tod_valid3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_corr_1  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_corr_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/din_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_corr_2  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_corr_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/din_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_corr_3  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_corr_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/din_3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_ns_0  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_ns_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_tod_ns_0]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_ns_1  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_ns_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_tod_ns_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_ns_2  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_ns_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_tod_ns_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_ns_3  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_ns_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_tod_ns_3]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_sec_1  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_sec_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_tod_sec_1]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_sec_2  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_sec_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_tod_sec_2]
  connect_bd_net -net MRMAC_1588_HELPER_HIER_tx_tod_sec_3  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_sec_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_tod_sec_3]
  connect_bd_net -net Net  [get_bd_pins versal_cips_0/pl0_ref_clk] \
  [get_bd_pins versal_cips_0/m_axi_fpd_aclk] \
  [get_bd_pins versal_cips_0/m_axi_lpd_aclk] \
  [get_bd_pins CLK_RST_WRAPPER/s_axi_lite_aclk] \
  [get_bd_pins DATAPATH_MCDMA_HIER/s_axi_lite_aclk] \
  [get_bd_pins GT_WRAPPER/s_axi_aclk] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/s_axi_rx_timer_aclk] \
  [get_bd_pins mrmac_0_core/s_axi_aclk] \
  [get_bd_pins subsys_axi_ctl_smartconnect/aclk]
  connect_bd_net -net RX_MST_DP_RESET_1  [get_bd_pins xlconcat_3/dout] \
  [get_bd_pins GT_WRAPPER/RX_MST_DP_RESET]
  connect_bd_net -net axis_data_fifo_0_m_axis_tdata  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tdata0] \
  [get_bd_pins mrmac_0_core/tx_axis_tdata0]
  connect_bd_net -net axis_data_fifo_0_m_axis_tlast  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tlast_0] \
  [get_bd_pins mrmac_0_core/tx_axis_tlast_0]
  connect_bd_net -net axis_data_fifo_0_m_axis_tvalid  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tvalid_0] \
  [get_bd_pins mrmac_0_core/tx_axis_tvalid_0]
  connect_bd_net -net axis_tx_rx_clk_1  [get_bd_pins CLK_RST_WRAPPER/axis_tx_rx_clk] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/axis_tx_rx_clk]
  connect_bd_net -net din_0_1  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_corr_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/din_0]
  connect_bd_net -net gt_quad_base_txn  [get_bd_pins GT_WRAPPER/gt_txn_out_0] \
  [get_bd_ports gt_txn_out_0]
  connect_bd_net -net gt_quad_base_txp  [get_bd_pins GT_WRAPPER/gt_txp_out_0] \
  [get_bd_ports gt_txp_out_0]
  connect_bd_net -net gt_rxn_in_0_1  [get_bd_ports gt_rxn_in_0] \
  [get_bd_pins GT_WRAPPER/gt_rxn_in_0]
  connect_bd_net -net gt_rxp_in_0_1  [get_bd_ports gt_rxp_in_0] \
  [get_bd_pins GT_WRAPPER/gt_rxp_in_0]
  connect_bd_net -net mcdma_clk_1  [get_bd_pins CLK_RST_WRAPPER/mcdma_clk] \
  [get_bd_pins DATAPATH_MCDMA_HIER/mcdma_clk] \
  [get_bd_pins axi_noc_0/aclk8]
  connect_bd_net -net mrmac_0_core_mst_rx_dp_reset_out_0  [get_bd_pins mrmac_0_core/mst_rx_dp_reset_out_0] \
  [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net mrmac_0_core_mst_rx_dp_reset_out_1  [get_bd_pins mrmac_0_core/mst_rx_dp_reset_out_1] \
  [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net mrmac_0_core_mst_rx_dp_reset_out_2  [get_bd_pins mrmac_0_core/mst_rx_dp_reset_out_2] \
  [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net mrmac_0_core_mst_rx_dp_reset_out_3  [get_bd_pins mrmac_0_core/mst_rx_dp_reset_out_3] \
  [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net mrmac_0_core_mst_rx_reset_out_0  [get_bd_pins mrmac_0_core/mst_rx_reset_out_0] \
  [get_bd_pins xlconcat_4/In0]
  connect_bd_net -net mrmac_0_core_mst_rx_reset_out_1  [get_bd_pins mrmac_0_core/mst_rx_reset_out_1] \
  [get_bd_pins xlconcat_4/In1]
  connect_bd_net -net mrmac_0_core_mst_rx_reset_out_2  [get_bd_pins mrmac_0_core/mst_rx_reset_out_2] \
  [get_bd_pins xlconcat_4/In2]
  connect_bd_net -net mrmac_0_core_mst_rx_reset_out_3  [get_bd_pins mrmac_0_core/mst_rx_reset_out_3] \
  [get_bd_pins xlconcat_4/In3]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out  [get_bd_pins xlconcat_0/dout] \
  [get_bd_pins GT_WRAPPER/TX_MST_DP_RESET]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out_0  [get_bd_pins mrmac_0_core/mst_tx_dp_reset_out_0] \
  [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out_1  [get_bd_pins mrmac_0_core/mst_tx_dp_reset_out_1] \
  [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out_2  [get_bd_pins mrmac_0_core/mst_tx_dp_reset_out_2] \
  [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net mrmac_0_core_mst_tx_dp_reset_out_3  [get_bd_pins mrmac_0_core/mst_tx_dp_reset_out_3] \
  [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out  [get_bd_pins xlconcat_1/dout] \
  [get_bd_pins GT_WRAPPER/tx_mst_reset_in]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out_0  [get_bd_pins mrmac_0_core/mst_tx_reset_out_0] \
  [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out_1  [get_bd_pins mrmac_0_core/mst_tx_reset_out_1] \
  [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out_2  [get_bd_pins mrmac_0_core/mst_tx_reset_out_2] \
  [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net mrmac_0_core_mst_tx_reset_out_3  [get_bd_pins mrmac_0_core/mst_tx_reset_out_3] \
  [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net mrmac_0_core_rx_axis_tdata2  [get_bd_pins mrmac_0_core/rx_axis_tdata2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata2]
  connect_bd_net -net mrmac_0_core_rx_axis_tdata4  [get_bd_pins mrmac_0_core/rx_axis_tdata4] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata4]
  connect_bd_net -net mrmac_0_core_rx_axis_tkeep_user4  [get_bd_pins mrmac_0_core/rx_axis_tkeep_user4] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user4]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_1  [get_bd_pins mrmac_0_core/rx_axis_tlast_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tlast_1] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_tlast_1]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_2  [get_bd_pins mrmac_0_core/rx_axis_tlast_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tlast_2] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_tlast_2]
  connect_bd_net -net mrmac_0_core_rx_axis_tlast_3  [get_bd_pins mrmac_0_core/rx_axis_tlast_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tlast_3] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_tlast_3]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_1  [get_bd_pins mrmac_0_core/rx_axis_tvalid_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tvalid_1] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_tvalid_1]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_2  [get_bd_pins mrmac_0_core/rx_axis_tvalid_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tvalid_2] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_tvalid_2]
  connect_bd_net -net mrmac_0_core_rx_axis_tvalid_3  [get_bd_pins mrmac_0_core/rx_axis_tvalid_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tvalid_3] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_tvalid_3]
  connect_bd_net -net mrmac_0_core_rx_ptp_tstamp_out_0  [get_bd_pins mrmac_0_core/rx_ptp_tstamp_out_0] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_ptp_tstamp_0]
  connect_bd_net -net mrmac_0_core_rx_ptp_tstamp_out_1  [get_bd_pins mrmac_0_core/rx_ptp_tstamp_out_1] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_ptp_tstamp_1]
  connect_bd_net -net mrmac_0_core_rx_ptp_tstamp_out_2  [get_bd_pins mrmac_0_core/rx_ptp_tstamp_out_2] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_ptp_tstamp_2]
  connect_bd_net -net mrmac_0_core_rx_ptp_tstamp_out_3  [get_bd_pins mrmac_0_core/rx_ptp_tstamp_out_3] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_ptp_tstamp_3]
  connect_bd_net -net mrmac_0_core_rxuserrdy_out_0  [get_bd_pins mrmac_0_core/rxuserrdy_out_0] \
  [get_bd_pins xlconcat_5/In0]
  connect_bd_net -net mrmac_0_core_rxuserrdy_out_1  [get_bd_pins mrmac_0_core/rxuserrdy_out_1] \
  [get_bd_pins xlconcat_5/In1]
  connect_bd_net -net mrmac_0_core_rxuserrdy_out_2  [get_bd_pins mrmac_0_core/rxuserrdy_out_2] \
  [get_bd_pins xlconcat_5/In2]
  connect_bd_net -net mrmac_0_core_rxuserrdy_out_3  [get_bd_pins mrmac_0_core/rxuserrdy_out_3] \
  [get_bd_pins xlconcat_5/In3]
  connect_bd_net -net mrmac_0_core_tod_1pps_out  [get_bd_pins MRMAC_1588_HELPER_HIER/tod_1pps_out] \
  [get_bd_pins CLK_RST_WRAPPER/tod_1pps_out]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_1  [get_bd_pins mrmac_0_core/tx_axis_tready_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tready_1]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_2  [get_bd_pins mrmac_0_core/tx_axis_tready_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tready_2]
  connect_bd_net -net mrmac_0_core_tx_axis_tready_3  [get_bd_pins mrmac_0_core/tx_axis_tready_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tready_3]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_out_0  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_out_0] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_0]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_out_1  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_out_1] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_1]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_out_2  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_out_2] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_2]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_out_3  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_out_3] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_3]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_tag_out_0  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_tag_out_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_tstamp_tag_in] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_tag_0]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_tag_out_1  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_tag_out_1] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_tstamp_tag_in1] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_tag_1]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_tag_out_2  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_tag_out_2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_tstamp_tag_in2] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_tag_2]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_tag_out_3  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_tag_out_3] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_ptp_tstamp_tag_in3] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_tag_3]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_valid_out_0  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_valid_out_0] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_valid_0]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_valid_out_1  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_valid_out_1] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_valid_1]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_valid_out_2  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_valid_out_2] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_valid_2]
  connect_bd_net -net mrmac_0_core_tx_ptp_tstamp_valid_out_3  [get_bd_pins mrmac_0_core/tx_ptp_tstamp_valid_out_3] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_ptp_tstamp_valid_3]
  connect_bd_net -net mrmac_0_core_txuserrdy_out  [get_bd_pins xlconcat_2/dout] \
  [get_bd_pins GT_WRAPPER/tx_userrdy_in]
  connect_bd_net -net mrmac_0_core_txuserrdy_out_0  [get_bd_pins mrmac_0_core/txuserrdy_out_0] \
  [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net mrmac_0_core_txuserrdy_out_1  [get_bd_pins mrmac_0_core/txuserrdy_out_1] \
  [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net mrmac_0_core_txuserrdy_out_2  [get_bd_pins mrmac_0_core/txuserrdy_out_2] \
  [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net mrmac_0_core_txuserrdy_out_3  [get_bd_pins mrmac_0_core/txuserrdy_out_3] \
  [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net mrmac_0_rx_axis_tdata0  [get_bd_pins mrmac_0_core/rx_axis_tdata0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata0]
  connect_bd_net -net mrmac_0_rx_axis_tkeep_user0  [get_bd_pins mrmac_0_core/rx_axis_tkeep_user0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user0]
  connect_bd_net -net mrmac_0_rx_axis_tlast_0  [get_bd_pins mrmac_0_core/rx_axis_tlast_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tlast_0] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_tlast_0]
  connect_bd_net -net mrmac_0_rx_axis_tvalid_0  [get_bd_pins mrmac_0_core/rx_axis_tvalid_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tvalid_0] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/rx_axis_tvalid_0]
  connect_bd_net -net mrmac_0_tx_axis_tready_0  [get_bd_pins mrmac_0_core/tx_axis_tready_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tready_0]
  connect_bd_net -net mrmac_1588_helper_0_ctl_rx_ptp_st_overwrite  [get_bd_pins MRMAC_1588_HELPER_HIER/ctl_rx_ptp_st_overwrite_ch0] \
  [get_bd_pins mrmac_0_core/ctl_rx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_1588_helper_0_ctl_tx_ptp_st_overwrite  [get_bd_pins MRMAC_1588_HELPER_HIER/ctl_tx_ptp_st_overwrite_ch0] \
  [get_bd_pins mrmac_0_core/ctl_tx_ptp_st_overwrite_0]
  connect_bd_net -net mrmac_constant_drive_zero_3bit_dout  [get_bd_pins mrmac_constant_drive_zero_3bit/dout] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_1588loc_in_0]
  connect_bd_net -net mrmac_obuf_ds_gre5_0_RX_REC_CLK_out_n  [get_bd_pins GT_WRAPPER/RX_REC_CLK_out_n_0] \
  [get_bd_ports RX_REC_CLK_out_n_0]
  connect_bd_net -net mrmac_obuf_ds_gre5_0_RX_REC_CLK_out_p  [get_bd_pins GT_WRAPPER/RX_REC_CLK_out_p_0] \
  [get_bd_ports RX_REC_CLK_out_p_0]
  connect_bd_net -net mrmac_pm_tick_drive_zero  [get_bd_pins mrmac_pm_tick_drive_zero/dout] \
  [get_bd_pins mrmac_0_core/pm_tick]
  connect_bd_net -net mrmac_tx_preamble_value  [get_bd_pins mrmac_tx_preamble_value/dout] \
  [get_bd_pins mrmac_0_core/tx_preamblein_0] \
  [get_bd_pins mrmac_0_core/tx_preamblein_1] \
  [get_bd_pins mrmac_0_core/tx_preamblein_2] \
  [get_bd_pins mrmac_0_core/tx_preamblein_3]
  connect_bd_net -net pl0_resetn_1  [get_bd_pins versal_cips_0/pl0_resetn] \
  [get_bd_pins CLK_RST_WRAPPER/pl0_resetn]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn  [get_bd_pins CLK_RST_WRAPPER/axi_lite_interconnect_resetn] \
  [get_bd_pins GT_WRAPPER/aresetn] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/s_axi_rx_timer_aresetn_sc] \
  [get_bd_pins subsys_axi_ctl_smartconnect/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins CLK_RST_WRAPPER/axi_lite_perpheral_resetn] \
  [get_bd_pins DATAPATH_MCDMA_HIER/s_axis_aresetn] \
  [get_bd_pins GT_WRAPPER/s_axi_aresetn] \
  [get_bd_pins mrmac_0_core/s_axi_aresetn]
  connect_bd_net -net rx_axis_tdata6_1  [get_bd_pins mrmac_0_core/rx_axis_tdata6] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tdata6]
  connect_bd_net -net rx_axis_tkeep_user2_1  [get_bd_pins mrmac_0_core/rx_axis_tkeep_user2] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user2]
  connect_bd_net -net rx_axis_tkeep_user6_1  [get_bd_pins mrmac_0_core/rx_axis_tkeep_user6] \
  [get_bd_pins DATAPATH_MCDMA_HIER/rx_axis_tkeep_user6]
  connect_bd_net -net rx_mst_reset_done_1  [get_bd_pins mrmac_0_core/gt_rx_reset_done_out] \
  [get_bd_pins CLK_RST_WRAPPER/rx_mst_reset_done]
  connect_bd_net -net rx_userrdy_in_1  [get_bd_pins xlconcat_5/dout] \
  [get_bd_pins GT_WRAPPER/rx_userrdy_in]
  connect_bd_net -net rx_usr_clk_1  [get_bd_pins GT_WRAPPER/rx_usr_clk1] \
  [get_bd_pins mrmac_0_core/rx_core_clk] \
  [get_bd_pins mrmac_0_core/rx_serdes_clk]
  connect_bd_net -net ts_clk_1  [get_bd_pins CLK_RST_WRAPPER/ts_clk] \
  [get_bd_pins MRMAC_1588_HELPER_HIER/ts_clk]
  connect_bd_net -net tx_axis_clk_1  [get_bd_pins CLK_RST_WRAPPER/axis_clk_tx_out] \
  [get_bd_pins mrmac_0_core/tx_axi_clk]
  connect_bd_net -net tx_mst_reset_done_1  [get_bd_pins mrmac_0_core/gt_tx_reset_done_out] \
  [get_bd_pins CLK_RST_WRAPPER/tx_mst_reset_done]
  connect_bd_net -net tx_tod_sec_0_1  [get_bd_pins MRMAC_1588_HELPER_HIER/tx_tod_sec_0] \
  [get_bd_pins DATAPATH_MCDMA_HIER/tx_tod_sec_0]
  connect_bd_net -net util_vector_logic_rx_rst_Res  [get_bd_pins CLK_RST_WRAPPER/rx_reset] \
  [get_bd_pins mrmac_0_core/rx_core_reset] \
  [get_bd_pins mrmac_0_core/rx_serdes_reset]
  connect_bd_net -net util_vector_logic_tx_rst_Res  [get_bd_pins CLK_RST_WRAPPER/tx_reset] \
  [get_bd_pins mrmac_0_core/tx_core_reset] \
  [get_bd_pins mrmac_0_core/tx_serdes_reset]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi0_clk  [get_bd_pins versal_cips_0/fpd_axi_noc_axi0_clk] \
  [get_bd_pins axi_noc_0/aclk4]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi1_clk  [get_bd_pins versal_cips_0/fpd_axi_noc_axi1_clk] \
  [get_bd_pins axi_noc_0/aclk5]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk  [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk] \
  [get_bd_pins axi_noc_0/aclk0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk  [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk] \
  [get_bd_pins axi_noc_0/aclk1]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk  [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk] \
  [get_bd_pins axi_noc_0/aclk2]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk  [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk] \
  [get_bd_pins axi_noc_0/aclk3]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk  [get_bd_pins versal_cips_0/lpd_axi_noc_clk] \
  [get_bd_pins axi_noc_0/aclk6]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk  [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] \
  [get_bd_pins axi_noc_0/aclk7]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins DATAPATH_MCDMA_HIER/tx_axis_tkeep_user0] \
  [get_bd_pins mrmac_0_core/tx_axis_tkeep_user0]
  connect_bd_net -net xlconcat_0_dout1  [get_bd_pins CLK_RST_WRAPPER/axis_clk_rx_out] \
  [get_bd_pins mrmac_0_core/rx_axi_clk]
  connect_bd_net -net xlconcat_4_dout  [get_bd_pins xlconcat_4/dout] \
  [get_bd_pins GT_WRAPPER/rx_mst_reset_in]
  connect_bd_net -net xlconcat_ts_clk_dout  [get_bd_pins CLK_RST_WRAPPER/timestamp_clk] \
  [get_bd_pins mrmac_0_core/rx_ts_clk] \
  [get_bd_pins mrmac_0_core/tx_ts_clk]
  connect_bd_net -net xlconstant_2_dout  [get_bd_pins mrmac_constant_drive_zero_1bit_flex/dout] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_1588op_in_0] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_1588op_in_1] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_1588op_in_2] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_1588op_in_3]
  connect_bd_net -net xlconstant_3_dout  [get_bd_pins mrmac_constant_drive_zero_16bit/dout] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_tag_field_in_0] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_tag_field_in_1] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_tag_field_in_2] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_tag_field_in_3]
  connect_bd_net -net xlconstant_4_dout  [get_bd_pins mrmac_constant_drive_zero_2bit/dout] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_1588loc_in_1] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_1588loc_in_2] \
  [get_bd_pins mrmac_0_core/tx_ptp_flex_1588loc_in_3]
  connect_bd_net -net xlconstant_5_dout  [get_bd_pins mrmac_constant_drive_zero_66bit/dout] \
  [get_bd_pins mrmac_0_core/rx_flex_cm_data0] \
  [get_bd_pins mrmac_0_core/tx_flex_data0]
  connect_bd_net -net xlconstant_6_dout  [get_bd_pins mrmac_constant_drive_zero_1bit/dout] \
  [get_bd_pins mrmac_0_core/rx_flex_cm_ena_0] \
  [get_bd_pins mrmac_0_core/rx_flex_cm_ena_1] \
  [get_bd_pins mrmac_0_core/rx_flex_cm_ena_2] \
  [get_bd_pins mrmac_0_core/rx_flex_cm_ena_3] \
  [get_bd_pins mrmac_0_core/tx_flex_almarker0] \
  [get_bd_pins mrmac_0_core/tx_flex_almarker1] \
  [get_bd_pins mrmac_0_core/tx_flex_almarker2] \
  [get_bd_pins mrmac_0_core/tx_flex_almarker3] \
  [get_bd_pins mrmac_0_core/tx_flex_almarker4] \
  [get_bd_pins mrmac_0_core/tx_flex_almarker5] \
  [get_bd_pins mrmac_0_core/tx_flex_almarker6] \
  [get_bd_pins mrmac_0_core/tx_flex_almarker7] \
  [get_bd_pins mrmac_0_core/tx_flex_ena_0] \
  [get_bd_pins mrmac_0_core/tx_flex_ena_1] \
  [get_bd_pins mrmac_0_core/tx_flex_ena_2] \
  [get_bd_pins mrmac_0_core/tx_flex_ena_3]
  connect_bd_net -net xlconstant_7_dout  [get_bd_pins mrmac_constant_drive_zero/dout] \
  [get_bd_pins mrmac_0_core/ctl_tx_lane0_vlm_bip7_override_01] \
  [get_bd_pins mrmac_0_core/ctl_tx_lane0_vlm_bip7_override_23] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_idle_in_0] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_idle_in_1] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_idle_in_2] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_idle_in_3] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_lfi_in_0] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_lfi_in_1] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_lfi_in_2] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_lfi_in_3] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_rfi_in_0] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_rfi_in_1] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_rfi_in_2] \
  [get_bd_pins mrmac_0_core/ctl_tx_send_rfi_in_3]
  connect_bd_net -net xlconstant_8_dout  [get_bd_pins mrmac_constant_drive_zero_8bit/dout] \
  [get_bd_pins mrmac_0_core/ctl_tx_lane0_vlm_bip7_override_value_01] \
  [get_bd_pins mrmac_0_core/ctl_tx_lane0_vlm_bip7_override_value_23]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs axi_noc_0/S06_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S01_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S03_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S07_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0xA4060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs DATAPATH_MCDMA_HIER/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/axi_gpio_gt_rate_reset_ctl_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/axi_gpio_gt_rate_reset_ctl_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/axi_gpio_gt_rate_reset_ctl_2/S_AXI/Reg] -force
  assign_bd_address -offset 0xA40A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/axi_gpio_gt_rate_reset_ctl_3/S_AXI/Reg] -force
  assign_bd_address -offset 0xA40B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/axi_gpio_gt_reset_mask/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_2/axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4030000 -range 0x00010000 -with_name SEG_axi_mcdma_0_Reg_1 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_1/axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4050000 -range 0x00010000 -with_name SEG_axi_mcdma_0_Reg_2 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_3/axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4020000 -range 0x00010000 -with_name SEG_axi_mcdma_0_Reg_3 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_0/axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs GT_WRAPPER/gt_quad_base/APB3_INTF/Reg] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs mrmac_0_core/s_axi/Reg] -force
  assign_bd_address -offset 0x80020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_LPD] [get_bd_addr_segs MRMAC_1588_HELPER_HIER/SYS_TIMER_2/ptp_1588_timer_syncer_0/s_axi/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -with_name SEG_ptp_1588_timer_syncer_0_Reg_1 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_LPD] [get_bd_addr_segs MRMAC_1588_HELPER_HIER/SYS_TIMER_0/ptp_1588_timer_syncer_0/s_axi/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00010000 -with_name SEG_ptp_1588_timer_syncer_0_Reg_2 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_LPD] [get_bd_addr_segs MRMAC_1588_HELPER_HIER/SYS_TIMER_1/ptp_1588_timer_syncer_0/s_axi/Reg] -force
  assign_bd_address -offset 0x80030000 -range 0x00010000 -with_name SEG_ptp_1588_timer_syncer_0_Reg_3 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_LPD] [get_bd_addr_segs MRMAC_1588_HELPER_HIER/SYS_TIMER_3/ptp_1588_timer_syncer_0/s_axi/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_0/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S08_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_0/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S09_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_0/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S10_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_1/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S11_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_1/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S12_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_1/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S13_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_2/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S14_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_2/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S15_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_2/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S16_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_3/axi_mcdma_0/Data_MM2S] [get_bd_addr_segs axi_noc_0/S17_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_3/axi_mcdma_0/Data_S2MM] [get_bd_addr_segs axi_noc_0/S18_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_3/axi_mcdma_0/Data_SG] [get_bd_addr_segs axi_noc_0/S19_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_0/ptp_logic/hw_master_top_0/m00_axi] [get_bd_addr_segs axi_noc_0/S20_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_1/ptp_logic/hw_master_top_0/m00_axi] [get_bd_addr_segs axi_noc_0/S21_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_2/ptp_logic/hw_master_top_0/m00_axi] [get_bd_addr_segs axi_noc_0/S22_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces DATAPATH_MCDMA_HIER/DATAPATH_MCDMA_3/ptp_logic/hw_master_top_0/m00_axi] [get_bd_addr_segs axi_noc_0/S23_AXI/C0_DDR_LOW0x2] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


