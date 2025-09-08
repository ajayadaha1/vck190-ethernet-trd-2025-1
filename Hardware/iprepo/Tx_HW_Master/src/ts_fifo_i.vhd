
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
--Date        : Wed May  5 23:49:36 2021
--Host        : xhdlc210290 running 64-bit Red Hat Enterprise Linux Workstation release 7.7 (Maipo)
--Command     : generate_target ts_fifo_i.bd
--Design      : ts_fifo_i
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ts_fifo_i is
  port (
    FIFO_READ_0_almost_empty : out STD_LOGIC;
    FIFO_READ_0_empty : out STD_LOGIC;
    FIFO_READ_0_rd_data : out STD_LOGIC_VECTOR ( 159 downto 0 );
    FIFO_READ_0_rd_en : in STD_LOGIC;
    FIFO_WRITE_0_almost_full : out STD_LOGIC;
    FIFO_WRITE_0_full : out STD_LOGIC;
    FIFO_WRITE_0_wr_data : in STD_LOGIC_VECTOR ( 159 downto 0 );
    FIFO_WRITE_0_wr_en : in STD_LOGIC;
    data_count_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    data_valid_0 : out STD_LOGIC;
    overflow_0 : out STD_LOGIC;
    prog_empty_0 : out STD_LOGIC;
    prog_full_0 : out STD_LOGIC;
    rd_data_count_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    rd_rst_busy_0 : out STD_LOGIC;
    rst_0 : in STD_LOGIC;
    underflow_0 : out STD_LOGIC;
    wr_ack_0 : out STD_LOGIC;
    wr_clk_0 : in STD_LOGIC;
    wr_data_count_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    wr_rst_busy_0 : out STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of ts_fifo_i : entity is "ts_fifo_i,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=ts_fifo_i,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of ts_fifo_i : entity is "ts_fifo_i.hwdef";
end ts_fifo_i;

architecture STRUCTURE of ts_fifo_i is
  component ts_fifo_i_emb_fifo_gen_0_0 is
  port (
    rst : in STD_LOGIC;
    wr_clk : in STD_LOGIC;
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 159 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 159 downto 0 );
    wr_rst_busy : out STD_LOGIC;
    rd_rst_busy : out STD_LOGIC;
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    prog_full : out STD_LOGIC;
    data_count : out STD_LOGIC_VECTOR (7 downto 0 );
    wr_data_count : out STD_LOGIC_VECTOR ( 7 downto 0 );
    rd_data_count : out STD_LOGIC_VECTOR ( 0 to 0 );
    prog_empty : out STD_LOGIC;
    underflow : out STD_LOGIC;
    overflow : out STD_LOGIC;
    almost_full : out STD_LOGIC;
    almost_empty : out STD_LOGIC;
    wr_ack : out STD_LOGIC;
    data_valid : out STD_LOGIC
  );
  end component ts_fifo_i_emb_fifo_gen_0_0;
  signal FIFO_READ_0_1_ALMOST_EMPTY : STD_LOGIC;
  signal FIFO_READ_0_1_EMPTY : STD_LOGIC;
  signal FIFO_READ_0_1_RD_DATA : STD_LOGIC_VECTOR ( 159 downto 0 );
  signal FIFO_READ_0_1_RD_EN : STD_LOGIC;
  signal FIFO_WRITE_0_1_ALMOST_FULL : STD_LOGIC;
  signal FIFO_WRITE_0_1_FULL : STD_LOGIC;
  signal FIFO_WRITE_0_1_WR_DATA : STD_LOGIC_VECTOR ( 159 downto 0 );
  signal FIFO_WRITE_0_1_WR_EN : STD_LOGIC;
  signal emb_fifo_gen_0_data_count : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal emb_fifo_gen_0_data_valid : STD_LOGIC;
  signal emb_fifo_gen_0_overflow : STD_LOGIC;
  signal emb_fifo_gen_0_prog_empty : STD_LOGIC;
  signal emb_fifo_gen_0_prog_full : STD_LOGIC;
  signal emb_fifo_gen_0_rd_data_count : STD_LOGIC_VECTOR ( 0 to 0 );
  signal emb_fifo_gen_0_rd_rst_busy : STD_LOGIC;
  signal emb_fifo_gen_0_underflow : STD_LOGIC;
  signal emb_fifo_gen_0_wr_ack : STD_LOGIC;
  signal emb_fifo_gen_0_wr_data_count : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal emb_fifo_gen_0_wr_rst_busy : STD_LOGIC;
  signal rst_0_1 : STD_LOGIC;
  signal wr_clk_0_1 : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of FIFO_READ_0_almost_empty : signal is "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 ALMOST_EMPTY";
  attribute X_INTERFACE_INFO of FIFO_READ_0_empty : signal is "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 EMPTY";
  attribute X_INTERFACE_INFO of FIFO_READ_0_rd_en : signal is "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_EN";
  attribute X_INTERFACE_INFO of FIFO_WRITE_0_almost_full : signal is "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 ALMOST_FULL";
  attribute X_INTERFACE_INFO of FIFO_WRITE_0_full : signal is "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 FULL";
  attribute X_INTERFACE_INFO of FIFO_WRITE_0_wr_en : signal is "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_EN";
  attribute X_INTERFACE_INFO of wr_clk_0 : signal is "xilinx.com:signal:clock:1.0 CLK.WR_CLK_0 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of wr_clk_0 : signal is "XIL_INTERFACENAME CLK.WR_CLK_0, CLK_DOMAIN ts_fifo_i_wr_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000";
  attribute X_INTERFACE_INFO of FIFO_READ_0_rd_data : signal is "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_DATA";
  attribute X_INTERFACE_INFO of FIFO_WRITE_0_wr_data : signal is "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_DATA";
begin
  FIFO_READ_0_1_RD_EN <= FIFO_READ_0_rd_en;
  FIFO_READ_0_almost_empty <= FIFO_READ_0_1_ALMOST_EMPTY;
  FIFO_READ_0_empty <= FIFO_READ_0_1_EMPTY;
  FIFO_READ_0_rd_data(159 downto 0) <= FIFO_READ_0_1_RD_DATA(159 downto 0);
  FIFO_WRITE_0_1_WR_DATA(159 downto 0) <= FIFO_WRITE_0_wr_data(159 downto 0);
  FIFO_WRITE_0_1_WR_EN <= FIFO_WRITE_0_wr_en;
  FIFO_WRITE_0_almost_full <= FIFO_WRITE_0_1_ALMOST_FULL;
  FIFO_WRITE_0_full <= FIFO_WRITE_0_1_FULL;
  data_count_0(7 downto 0) <= emb_fifo_gen_0_data_count(7 downto 0);
  data_valid_0 <= emb_fifo_gen_0_data_valid;
  overflow_0 <= emb_fifo_gen_0_overflow;
  prog_empty_0 <= emb_fifo_gen_0_prog_empty;
  prog_full_0 <= emb_fifo_gen_0_prog_full;
  rd_data_count_0(0) <= emb_fifo_gen_0_rd_data_count(0);
  rd_rst_busy_0 <= emb_fifo_gen_0_rd_rst_busy;
  rst_0_1 <= rst_0;
  underflow_0 <= emb_fifo_gen_0_underflow;
  wr_ack_0 <= emb_fifo_gen_0_wr_ack;
  wr_clk_0_1 <= wr_clk_0;
  wr_data_count_0(7 downto 0) <= emb_fifo_gen_0_wr_data_count(7 downto 0);
  wr_rst_busy_0 <= emb_fifo_gen_0_wr_rst_busy;
emb_fifo_gen_0: component ts_fifo_i_emb_fifo_gen_0_0
     port map (
      almost_empty => FIFO_READ_0_1_ALMOST_EMPTY,
      almost_full => FIFO_WRITE_0_1_ALMOST_FULL,
      data_count(7 downto 0) => emb_fifo_gen_0_data_count(7 downto 0),
      data_valid => emb_fifo_gen_0_data_valid,
      din(159 downto 0) => FIFO_WRITE_0_1_WR_DATA(159 downto 0),
      dout(159 downto 0) => FIFO_READ_0_1_RD_DATA(159 downto 0),
      empty => FIFO_READ_0_1_EMPTY,
      full => FIFO_WRITE_0_1_FULL,
      overflow => emb_fifo_gen_0_overflow,
      prog_empty => emb_fifo_gen_0_prog_empty,
      prog_full => emb_fifo_gen_0_prog_full,
      rd_data_count(0) => emb_fifo_gen_0_rd_data_count(0),
      rd_en => FIFO_READ_0_1_RD_EN,
      rd_rst_busy => emb_fifo_gen_0_rd_rst_busy,
      rst => rst_0_1,
      underflow => emb_fifo_gen_0_underflow,
      wr_ack => emb_fifo_gen_0_wr_ack,
      wr_clk => wr_clk_0_1,
      wr_data_count(7 downto 0) => emb_fifo_gen_0_wr_data_count(7 downto 0),
      wr_en => FIFO_WRITE_0_1_WR_EN,
      wr_rst_busy => emb_fifo_gen_0_wr_rst_busy
    );
end STRUCTURE;
