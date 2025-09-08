# 0 "/tmp/tmppczvninu"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/tmp/tmppczvninu"
/dts-v1/;
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal.dtsi" 1
# 11 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal.dtsi"
/ {
 compatible = "xlnx,versal";
 #address-cells = <2>;
 #size-cells = <2>;
 model = "Xilinx Versal";

 options {
  u-boot {
   compatible = "u-boot,config";
   bootscr-address = /bits/ 64 <0x20000000>;
  };
 };

 cpus_a72: cpus-a72@0 {
  #address-cells = <1>;
  #size-cells = <0>;

  psv_cortexa72_0: cpu@0 {
   compatible = "arm,cortex-a72", "arm,armv8";
   device_type = "cpu";
   enable-method = "psci";
   operating-points-v2 = <&cpu_opp_table>;
   reg = <0>;
   cpu-idle-states = <&CPU_SLEEP_0>;
   power-domains = <&versal_firmware 0x18110003>;
  };

  psv_cortexa72_1: cpu@1 {
   compatible = "arm,cortex-a72", "arm,armv8";
   device_type = "cpu";
   enable-method = "psci";
   operating-points-v2 = <&cpu_opp_table>;
   reg = <1>;
   cpu-idle-states = <&CPU_SLEEP_0>;
   power-domains = <&versal_firmware 0x18110004>;
  };

  idle-states {
   entry-method = "psci";

   CPU_SLEEP_0: cpu-sleep-0 {
    compatible = "arm,idle-state";
    arm,psci-suspend-param = <0x40000000>;
    local-timer-stop;
    entry-latency-us = <300>;
    exit-latency-us = <600>;
    min-residency-us = <10000>;
   };
  };
 };

 cpus_microblaze_0: cpus_microblaze@0 {
  #address-cells = <1>;
  #size-cells = <0>;
  psv_pmc_0: cpu@0 {
   compatible = "pmc-microblaze";
   device_type = "cpu";
   reg = <0x0>;
   operating-points-v2 = <&cpu_opp_table>;
  };
 };

 cpus_microblaze_1: cpus_microblaze@1 {
  #address-cells = <1>;
  #size-cells = <0>;
  psv_psm_0: cpu@0 {
   compatible = "psm-microblaze";
   device_type = "cpu";
   reg = <0x1>;
   operating-points-v2 = <&cpu_opp_table>;
  };

 };

 cpus_r5_0: cpus-r5@0 {
  #address-cells = <1>;
  #size-cells = <0>;
  psv_cortexr5_0: cpu@0 {
   compatible = "arm,cortex-r5";
   device_type = "cpu";
   reg = <0x0>;
   operating-points-v2 = <&cpu_opp_table>;
   power-domains = <&versal_firmware 0x18110005>;
  };
 };

 cpus_r5_1: cpus-r5@1 {
  #address-cells = <1>;
  #size-cells = <0>;
  psv_cortexr5_1: cpu@1 {
   compatible = "arm,cortex-r5";
   device_type = "cpu";
   reg = <0x1>;
   operating-points-v2 = <&cpu_opp_table>;
   power-domains = <&versal_firmware 0x18110006>;
  };
 };

 cpu_opp_table: opp-table-cpu {
  compatible = "operating-points-v2";
  opp-shared;
  opp00 {
   opp-hz = /bits/ 64 <1199999988>;
   opp-microvolt = <1000000>;
   clock-latency-ns = <500000>;
  };
  opp01 {
   opp-hz = /bits/ 64 <599999994>;
   opp-microvolt = <1000000>;
   clock-latency-ns = <500000>;
  };
  opp02 {
   opp-hz = /bits/ 64 <399999996>;
   opp-microvolt = <1000000>;
   clock-latency-ns = <500000>;
  };
  opp03 {
   opp-hz = /bits/ 64 <299999997>;
   opp-microvolt = <1000000>;
   clock-latency-ns = <500000>;
  };
 };

 dcc: dcc {
  compatible = "arm,dcc";
  status = "disabled";
  bootph-all;
 };

 fpga: fpga-region {
  compatible = "fpga-region";
  fpga-mgr = <&versal_fpga>;
  #address-cells = <2>;
  #size-cells = <2>;
 };

 psci: psci {
  compatible = "arm,psci-0.2";
  method = "smc";
 };

 pmu {
  compatible = "arm,armv8-pmuv3";
  interrupt-parent = <&imux>;
  interrupts = <1 7 0x304>;
 };

 timer: timer {
  compatible = "arm,armv8-timer";
  interrupt-parent = <&imux>;
  interrupts = <1 13 4>,
               <1 14 4>,
               <1 11 4>,
               <1 10 4>;
 };

 versal_fpga: versal-fpga {
  compatible = "xlnx,versal-fpga";
 };

 sensor0: versal-thermal-sensor {
  compatible = "xlnx,versal-thermal";
  #thermal-sensor-cells = <0>;
  io-channels = <&sysmon0>;
  io-channel-names = "sysmon-temp-channel";
 };

 thermal-zones {
  versal_thermal: versal-thermal {
   polling-delay-passive = <250>;
   polling-delay = <1000>;
   thermal-sensors = <&sensor0>;

   trips {
    temp_alert: temp-alert {
     temperature = <70000>;
     hysteresis = <0>;
     type = "passive";
    };

    ot_crit: ot-crit {
     temperature = <125000>;
     hysteresis = <0>;
     type = "critical";
    };
   };

  };
 };

 amba_apu: apu-bus {
  compatible = "simple-bus";
  #address-cells = <2>;
  #size-cells = <2>;
  ranges;
  interrupt-parent = <&gic_a72>;
  bootph-all;

  gic_a72: interrupt-controller@f9000000 {
   compatible = "arm,gic-v3";
   #interrupt-cells = <3>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;
   reg = <0 0xf9000000 0 0x80000>,
         <0 0xf9080000 0 0x80000>;
   interrupt-controller;
   interrupt-parent = <&gic_a72>;
   interrupts = <1 9 4>;
   status = "disabled";

   gic_its: msi-controller@f9020000 {
    compatible = "arm,gic-v3-its";
    status = "disabled";
    msi-controller;
    #msi-cells = <1>;
    reg = <0 0xf9020000 0 0x20000>;
   };
  };
 };

 amba_rpu: rpu-bus {
  compatible = "indirect-bus";
  #address-cells = <0x2>;
  #size-cells = <0x2>;
  ranges;
  interrupt-parent = <&gic_r5>;
  bootph-all;

  gic_r5: interrupt-controller@f9000000 {
   compatible = "arm,pl390";
   #interrupt-cells = <3>;
   interrupt-controller;
   status = "disabled";
   reg = <0x0 0xf9000000 0x0 0x1000 0x0 0xf9001000 0x0 0x1000>;
  };
 };

 amba: axi {
  compatible = "simple-bus";
  #address-cells = <2>;
  #size-cells = <2>;
  ranges;
  interrupt-parent = <&imux>;
  bootph-all;


  imux: interrupt-multiplex {
   compatible = "interrupt-multiplex";
   #address-cells = <0x0>;
   #interrupt-cells = <3>;
   interrupt-controller;
   interrupt-parent = <&gic_a72>, <&gic_r5>;

   interrupt-map-mask = <0x0 0xffff 0x0>;


   interrupt-map = <0x0 0x14 0x0 &gic_a72 0x0 0x14 0x1>,
    <0x0 0x15 0x0 &gic_a72 0x0 0x15 0x1>,
    <0x0 0x6a 0x0 &gic_a72 0x0 0x6a 0x4>,
    <0x0 0x3c 0x0 &gic_a72 0x0 0x3c 0x4>,
    <0x0 0x3d 0x0 &gic_a72 0x0 0x3d 0x4>,
    <0x0 0x3e 0x0 &gic_a72 0x0 0x3e 0x4>,
    <0x0 0x3f 0x0 &gic_a72 0x0 0x3f 0x4>,
    <0x0 0x40 0x0 &gic_a72 0x0 0x40 0x4>,
    <0x0 0x41 0x0 &gic_a72 0x0 0x41 0x4>,
    <0x0 0x42 0x0 &gic_a72 0x0 0x42 0x4>,
    <0x0 0x43 0x0 &gic_a72 0x0 0x43 0x4>,
    <0x0 0x38 0x0 &gic_a72 0x0 0x38 0x4>,
    <0x0 0x3a 0x0 &gic_a72 0x0 0x3a 0x4>,
    <0x0 0xd 0x0 &gic_a72 0x0 0xd 0x4>,
    <0x0 0x7a 0x0 &gic_a72 0x0 0x7a 0x4>,
    <0x0 0xe 0x0 &gic_a72 0x0 0xe 0x4>,
    <0x0 0xf 0x0 &gic_a72 0x0 0xf 0x4>,
    <0x0 0x8e 0x0 &gic_a72 0x0 0x8e 0x4>,
    <0x0 0x8f 0x0 &gic_a72 0x0 0x8f 0x4>,
    <0x0 0x7e 0x0 &gic_a72 0x0 0x7e 0x4>,
    <0x0 0x80 0x0 &gic_a72 0x0 0x80 0x4>,
    <0x0 0x12 0x0 &gic_a72 0x0 0x12 0x4>,
    <0x0 0x13 0x0 &gic_a72 0x0 0x13 0x4>,
    <0x0 0x6b 0x0 &gic_a72 0x0 0x6b 0x4>,
    <0x0 0x7c 0x0 &gic_a72 0x0 0x7c 0x4>,
    <0x0 0x7d 0x0 &gic_a72 0x0 0x7d 0x4>,
    <0x0 0x10 0x0 &gic_a72 0x0 0x10 0x4>,
    <0x0 0x11 0x0 &gic_a72 0x0 0x11 0x4>,
    <0x0 0x16 0x0 &gic_a72 0x0 0x16 0x4>,
    <0x0 0x1a 0x0 &gic_a72 0x0 0x1a 0x4>,
    <0x0 0x4a 0x0 &gic_a72 0x0 0x4a 0x4>,
    <0x0 0x48 0x0 &gic_a72 0x0 0x48 0x4>,
    <0x0 0x1e 0x0 &gic_a72 0x0 0x1e 0x4>,
    <0x0 0x1f 0x0 &gic_a72 0x0 0x1f 0x4>,
    <0x0 0x83 0x0 &gic_a72 0x0 0x83 0x4>,
    <0x0 0x84 0x0 &gic_a72 0x0 0x84 0x4>,
    <0x0 0x14 0x0 &gic_r5 0x0 0x14 0x1>,
    <0x0 0x15 0x0 &gic_r5 0x0 0x15 0x1>,
    <0x0 0x6a 0x0 &gic_r5 0x0 0x6a 0x4>,
    <0x0 0x3c 0x0 &gic_r5 0x0 0x3c 0x4>,
    <0x0 0x3d 0x0 &gic_r5 0x0 0x3d 0x4>,
    <0x0 0x3e 0x0 &gic_r5 0x0 0x3e 0x4>,
    <0x0 0x3f 0x0 &gic_r5 0x0 0x3f 0x4>,
    <0x0 0x40 0x0 &gic_r5 0x0 0x40 0x4>,
    <0x0 0x41 0x0 &gic_r5 0x0 0x41 0x4>,
    <0x0 0x42 0x0 &gic_r5 0x0 0x42 0x4>,
    <0x0 0x43 0x0 &gic_r5 0x0 0x43 0x4>,
    <0x0 0x38 0x0 &gic_r5 0x0 0x38 0x4>,
    <0x0 0x3a 0x0 &gic_r5 0x0 0x3a 0x4>,
    <0x0 0xd 0x0 &gic_r5 0x0 0xd 0x4>,
    <0x0 0x7a 0x0 &gic_r5 0x0 0x7a 0x4>,
    <0x0 0xe 0x0 &gic_r5 0x0 0xe 0x4>,
    <0x0 0xf 0x0 &gic_r5 0x0 0xf 0x4>,
    <0x0 0x8e 0x0 &gic_r5 0x0 0x8e 0x4>,
    <0x0 0x8f 0x0 &gic_r5 0x0 0x8f 0x4>,
    <0x0 0x7e 0x0 &gic_r5 0x0 0x7e 0x4>,
    <0x0 0x80 0x0 &gic_r5 0x0 0x80 0x4>,
    <0x0 0x12 0x0 &gic_r5 0x0 0x12 0x4>,
    <0x0 0x13 0x0 &gic_r5 0x0 0x13 0x4>,
    <0x0 0x6b 0x0 &gic_r5 0x0 0x6b 0x4>,
    <0x0 0x7c 0x0 &gic_r5 0x0 0x7c 0x4>,
    <0x0 0x7d 0x0 &gic_r5 0x0 0x7d 0x4>,
    <0x0 0x10 0x0 &gic_r5 0x0 0x10 0x4>,
    <0x0 0x11 0x0 &gic_r5 0x0 0x11 0x4>,
    <0x0 0x16 0x0 &gic_r5 0x0 0x16 0x4>,
    <0x0 0x1a 0x0 &gic_r5 0x0 0x1a 0x4>,
    <0x0 0x4a 0x0 &gic_r5 0x0 0x4a 0x4>,
    <0x0 0x48 0x0 &gic_r5 0x0 0x48 0x4>,
    <0x0 0x1e 0x0 &gic_r5 0x0 0x1e 0x4>,
    <0x0 0x1f 0x0 &gic_r5 0x0 0x1f 0x4>,
    <0x0 0x83 0x0 &gic_r5 0x0 0x83 0x4>,
    <0x0 0x84 0x0 &gic_r5 0x0 0x84 0x4>;
  };

  can0: can@ff060000 {
   compatible = "xlnx,canfd-2.0";
   status = "disabled";
   reg = <0 0xff060000 0 0x6000>;
   interrupts = <0 20 4>;
   interrupt-parent = <&imux>;
   clock-names = "can_clk", "s_axi_aclk";
   rx-fifo-depth = <0x40>;
   tx-mailbox-count = <0x20>;
  };

  can1: can@ff070000 {
   compatible = "xlnx,canfd-2.0";
   status = "disabled";
   reg = <0 0xff070000 0 0x6000>;
   interrupts = <0 21 4>;
   interrupt-parent = <&imux>;
   clock-names = "can_clk", "s_axi_aclk";
   rx-fifo-depth = <0x40>;
   tx-mailbox-count = <0x20>;
  };

  cci: cci@fd000000 {
   compatible = "arm,cci-500";
   status = "disabled";
   reg = <0 0xfd000000 0 0x10000>;
   ranges = <0 0 0xfd000000 0xa0000>;
   #address-cells = <1>;
   #size-cells = <1>;
   cci_pmu: pmu@10000 {
    compatible = "arm,cci-500-pmu,r0";
    reg = <0x10000 0x90000>;
    interrupt-parent = <&imux>;
    interrupts = <0 106 4>,
                 <0 106 4>,
                 <0 106 4>,
                 <0 106 4>,
                 <0 106 4>,
                 <0 106 4>,
                 <0 106 4>,
                 <0 106 4>;
   };
  };

  lpd_dma_chan0: dma-controller@ffa80000 {
   compatible = "xlnx,zynqmp-dma-1.0";
   status = "disabled";
   reg = <0 0xffa80000 0 0x1000>;
   interrupts = <0 60 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_main", "clk_apb";

   xlnx,dma-type = <1>;

   #dma-cells = <1>;
   xlnx,bus-width = <64>;

  };

  lpd_dma_chan1: dma-controller@ffa90000 {
   compatible = "xlnx,zynqmp-dma-1.0";
   status = "disabled";
   reg = <0 0xffa90000 0 0x1000>;
   interrupts = <0 61 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_main", "clk_apb";

   xlnx,dma-type = <1>;

   #dma-cells = <1>;
   xlnx,bus-width = <64>;

  };

  lpd_dma_chan2: dma-controller@ffaa0000 {
   compatible = "xlnx,zynqmp-dma-1.0";
   status = "disabled";
   reg = <0 0xffaa0000 0 0x1000>;
   interrupts = <0 62 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_main", "clk_apb";

   xlnx,dma-type = <1>;

   #dma-cells = <1>;
   xlnx,bus-width = <64>;

  };


  lpd_dma_chan3: dma-controller@ffab0000 {
   compatible = "xlnx,zynqmp-dma-1.0";
   status = "disabled";
   reg = <0 0xffab0000 0 0x1000>;
   interrupts = <0 63 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_main", "clk_apb";

   xlnx,dma-type = <1>;

   #dma-cells = <1>;
   xlnx,bus-width = <64>;

  };

  lpd_dma_chan4: dma-controller@ffac0000 {
   compatible = "xlnx,zynqmp-dma-1.0";
   status = "disabled";
   reg = <0 0xffac0000 0 0x1000>;
   interrupts = <0 64 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_main", "clk_apb";

   xlnx,dma-type = <1>;

   #dma-cells = <1>;
   xlnx,bus-width = <64>;

  };

  lpd_dma_chan5: dma-controller@ffad0000 {
   compatible = "xlnx,zynqmp-dma-1.0";
   status = "disabled";
   reg = <0 0xffad0000 0 0x1000>;
   interrupts = <0 65 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_main", "clk_apb";

   xlnx,dma-type = <1>;

   #dma-cells = <1>;
   xlnx,bus-width = <64>;

  };

  lpd_dma_chan6: dma-controller@ffae0000 {
   compatible = "xlnx,zynqmp-dma-1.0";
   status = "disabled";
   reg = <0 0xffae0000 0 0x1000>;
   interrupts = <0 66 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_main", "clk_apb";

   xlnx,dma-type = <1>;

   #dma-cells = <1>;
   xlnx,bus-width = <64>;

  };

  lpd_dma_chan7: dma-controller@ffaf0000 {
   compatible = "xlnx,zynqmp-dma-1.0";
   status = "disabled";
   reg = <0 0xffaf0000 0 0x1000>;
   interrupts = <0 67 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_main", "clk_apb";

   xlnx,dma-type = <1>;

   #dma-cells = <1>;
   xlnx,bus-width = <64>;

  };

  gem0: ethernet@ff0c0000 {
   compatible = "xlnx,versal-gem", "cdns,gem";
   status = "disabled";
   reg = <0 0xff0c0000 0 0x1000>;
   interrupts = <0 56 4>, <0 56 4>;
   interrupt-parent = <&imux>;
   clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";


   #address-cells = <1>;
   #size-cells = <0>;
  };

  gem1: ethernet@ff0d0000 {
   compatible = "xlnx,versal-gem", "cdns,gem";
   status = "disabled";
   reg = <0 0xff0d0000 0 0x1000>;
   interrupts = <0 58 4>, <0 58 4>;
   interrupt-parent = <&imux>;
   clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";


   #address-cells = <1>;
   #size-cells = <0>;
  };


  gpio0: gpio@ff0b0000 {
   compatible = "xlnx,versal-gpio-1.0";
   status = "disabled";
   reg = <0 0xff0b0000 0 0x1000>;
   interrupts = <0 13 4>;
   interrupt-parent = <&imux>;
   #gpio-cells = <2>;
   gpio-controller;
   #interrupt-cells = <2>;
   interrupt-controller;
  };

  gpio1: gpio@f1020000 {
   compatible = "xlnx,pmc-gpio-1.0";
   status = "disabled";
   reg = <0 0xf1020000 0 0x1000>;
   interrupts = <0 122 4>;
   interrupt-parent = <&imux>;
   #gpio-cells = <2>;
   gpio-controller;
   #interrupt-cells = <2>;
   interrupt-controller;
  };

  i2c0: i2c@ff020000 {
   compatible = "cdns,i2c-r1p14";
   status = "disabled";
   reg = <0 0xff020000 0 0x1000>;
   interrupts = <0 14 4>;
   interrupt-parent = <&imux>;
   clock-frequency = <100000>;
   #address-cells = <1>;
   #size-cells = <0>;
  };

  i2c1: i2c@ff030000 {
   compatible = "cdns,i2c-r1p14";
   status = "disabled";
   reg = <0 0xff030000 0 0x1000>;
   interrupts = <0 15 4>;
   interrupt-parent = <&imux>;
   clock-frequency = <100000>;
   #address-cells = <1>;
   #size-cells = <0>;
  };

  i2c2: i2c@f1000000 {
   compatible = "cdns,i2c-r1p14";
   status = "disabled";
   reg = <0 0xf1000000 0 0x1000>;
   interrupts = <0 123 4>;
   interrupt-parent = <&imux>;
   clock-frequency = <100000>;
   #address-cells = <1>;
   #size-cells = <0>;
  };

  mc0: memory-controller@f6150000 {
   compatible = "xlnx,versal-ddrmc";
   status = "disabled";
   reg = <0x0 0xf6150000 0x0 0x2000>, <0x0 0xf6070000 0x0 0x20000>;
   reg-names = "base", "noc";
   interrupts = <0 147 4>;
   interrupt-parent = <&imux>;
  };

  mc1: memory-controller@f62c0000 {
   compatible = "xlnx,versal-ddrmc";
   status = "disabled";
   reg = <0x0 0xf62c0000 0x0 0x2000>, <0x0 0xf6210000 0x0 0x20000>;
   reg-names = "base", "noc";
   interrupts = <0 147 4>;
   interrupt-parent = <&imux>;
  };

  mc2: memory-controller@f6430000 {
   compatible = "xlnx,versal-ddrmc";
   status = "disabled";
   reg = <0x0 0xf6430000 0x0 0x2000>, <0x0 0xf6380000 0x0 0x20000>;
   reg-names = "base", "noc";
   interrupts = <0 147 4>;
   interrupt-parent = <&imux>;
  };

  mc3: memory-controller@f65a0000 {
   compatible = "xlnx,versal-ddrmc";
   status = "disabled";
   reg = <0x0 0xf65a0000 0x0 0x2000>, <0x0 0xf64f0000 0x0 0x20000>;
   reg-names = "base", "noc";
   interrupts = <0 147 4>;
   interrupt-parent = <&imux>;
  };

  ocm: memory-controller@ff960000 {
   compatible = "xlnx,zynqmp-ocmc-1.0";
   reg = <0x0 0xff960000 0x0 0x1000>;
   interrupts = <0 10 4>;
   interrupt-parent = <&imux>;
  };

  rtc: rtc@f12a0000 {
   compatible = "xlnx,zynqmp-rtc";
   status = "disabled";
   reg = <0 0xf12a0000 0 0x100>;
   interrupt-names = "alarm", "sec";
   interrupts = <0 142 4>, <0 143 4>;
   interrupt-parent = <&imux>;
   calibration = <0x7FFF>;
  };

  sdhci0: mmc@f1040000 {
   compatible = "xlnx,versal-8.9a", "arasan,sdhci-8.9a";
   status = "disabled";
   reg = <0 0xf1040000 0 0x10000>;
   interrupts = <0 126 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_xin", "clk_ahb", "gate";
   #clock-cells = <1>;
   clock-output-names = "clk_out_sd0", "clk_in_sd0";


  };

  sdhci1: mmc@f1050000 {
   compatible = "xlnx,versal-8.9a", "arasan,sdhci-8.9a";
   status = "disabled";
   reg = <0 0xf1050000 0 0x10000>;
   interrupts = <0 128 4>;
   interrupt-parent = <&imux>;
   clock-names = "clk_xin", "clk_ahb", "gate";
   #clock-cells = <1>;
   clock-output-names = "clk_out_sd1", "clk_in_sd1";


  };

  serial0: serial@ff000000 {
   compatible = "arm,pl011", "arm,primecell";
   status = "disabled";
   reg = <0 0xff000000 0 0x1000>;
   interrupts = <0 18 4>;
   interrupt-parent = <&imux>;
   reg-io-width = <4>;
   clock-names = "uartclk", "apb_pclk";
   bootph-all;
  };

  serial1: serial@ff010000 {
   compatible = "arm,pl011", "arm,primecell";
   status = "disabled";
   reg = <0 0xff010000 0 0x1000>;
   interrupts = <0 19 4>;
   interrupt-parent = <&imux>;
   reg-io-width = <4>;
   clock-names = "uartclk", "apb_pclk";
   bootph-all;
  };

  smmu: iommu@fd800000 {
   compatible = "arm,mmu-500";
   status = "disabled";
   reg = <0 0xfd800000 0 0x40000>;
   stream-match-mask = <0x7c00>;
   #iommu-cells = <1>;
   #global-interrupts = <1>;
   interrupts = <0 107 4>,
    <0 107 4>, <0 107 4>, <0 107 4>, <0 107 4>,
    <0 107 4>, <0 107 4>, <0 107 4>, <0 107 4>,
    <0 107 4>, <0 107 4>, <0 107 4>, <0 107 4>,
    <0 107 4>, <0 107 4>, <0 107 4>, <0 107 4>,
    <0 107 4>, <0 107 4>, <0 107 4>, <0 107 4>,
    <0 107 4>, <0 107 4>, <0 107 4>, <0 107 4>,
    <0 107 4>, <0 107 4>, <0 107 4>, <0 107 4>,
    <0 107 4>, <0 107 4>, <0 107 4>, <0 107 4>;
   interrupt-parent = <&imux>;
  };

  ospi: spi@f1010000 {
   compatible = "xlnx,versal-ospi-1.0", "cdns,qspi-nor";
   status = "disabled";
   reg = <0 0xf1010000 0 0x10000 0 0xc0000000 0 0x20000000>;
   interrupts = <0 124 4>;
   interrupt-parent = <&imux>;
   cdns,fifo-depth = <256>;
   cdns,fifo-width = <4>;
   cdns,is-dma = <1>;
   cdns,trigger-address = <0xC0000000>;
   #address-cells = <1>;
   #size-cells = <0>;
  };

  qspi: spi@f1030000 {
   compatible = "xlnx,versal-qspi-1.0";
   status = "disabled";
   reg = <0 0xf1030000 0 0x1000>;
   interrupts = <0 125 4>;
   interrupt-parent = <&imux>;
   clock-names = "ref_clk", "pclk";


   #address-cells = <1>;
   #size-cells = <0>;
  };


  spi0: spi@ff040000 {
   compatible = "cdns,spi-r1p6";
   status = "disabled";
   reg = <0 0xff040000 0 0x1000>;
   interrupts = <0 16 4>;
   interrupt-parent = <&imux>;
   clock-names = "ref_clk", "pclk";
   #address-cells = <1>;
   #size-cells = <0>;
  };

  spi1: spi@ff050000 {
   compatible = "cdns,spi-r1p6";
   status = "disabled";
   reg = <0 0xff050000 0 0x1000>;
   interrupts = <0 17 4>;
   interrupt-parent = <&imux>;
   clock-names = "ref_clk", "pclk";
   #address-cells = <1>;
   #size-cells = <0>;
  };

  sysmon0: sysmon@f1270000 {
   compatible = "xlnx,versal-sysmon";
   #io-channel-cells = <0>;
   reg = <0x0 0xf1270000 0x0 0x4000>;
   interrupts = <0 144 4>;
   xlnx,numchannels = /bits/8 <0>;
   #address-cells = <1>;
   #size-cells = <0>;
  };

  sysmon1: sysmon@109270000 {
   compatible = "xlnx,versal-sysmon";
   status = "disabled";
   reg = <0x1 0x09270000 0x0 0x4000>;
   xlnx,numchannels = /bits/8 <0>;
   #address-cells = <1>;
   #size-cells = <0>;
  };

  sysmon2: sysmon@111270000 {
   compatible = "xlnx,versal-sysmon";
   status = "disabled";
   reg = <0x1 0x11270000 0x0 0x4000>;
   xlnx,numchannels = /bits/8 <0>;
   #address-cells = <1>;
   #size-cells = <0>;
  };

  sysmon3: sysmon@119270000 {
   compatible = "xlnx,versal-sysmon";
   status = "disabled";
   reg = <0x1 0x19270000 0x0 0x4000>;
   xlnx,numchannels = /bits/8 <0>;
   #address-cells = <1>;
   #size-cells = <0>;
  };

  ttc0: timer@ff0e0000 {
   compatible = "cdns,ttc";
   status = "disabled";
   interrupts = <0 37 4>, <0 38 4>, <0 39 4>;
   interrupt-parent = <&imux>;
   reg = <0x0 0xff0e0000 0x0 0x1000>;
   timer-width = <32>;
  };

  ttc1: timer@ff0f0000 {
   compatible = "cdns,ttc";
   status = "disabled";
   interrupts = <0 40 4>, <0 41 4>, <0 42 4>;
   interrupt-parent = <&imux>;
   reg = <0x0 0xff0f0000 0x0 0x1000>;
   timer-width = <32>;
  };

  ttc2: timer@ff100000 {
   compatible = "cdns,ttc";
   status = "disabled";
   interrupts = <0 43 4>, <0 44 4>, <0 45 4>;
   interrupt-parent = <&imux>;
   reg = <0x0 0xff100000 0x0 0x1000>;
   timer-width = <32>;
  };

  ttc3: timer@ff110000 {
   compatible = "cdns,ttc";
   status = "disabled";
   interrupts = <0 46 4>, <0 47 4>, <0 48 4>;
   interrupt-parent = <&imux>;
   reg = <0x0 0xff110000 0x0 0x1000>;
   timer-width = <32>;
  };

  usb0: usb@ff9d0000 {
   compatible = "xlnx,versal-dwc3";
   status = "disabled";
   reg = <0 0xff9d0000 0 0x100>;
   clock-names = "bus_clk", "ref_clk";
   ranges;
   #address-cells = <2>;
   #size-cells = <2>;

   dwc3_0: usb@fe200000 {
    compatible = "snps,dwc3";
    status = "disabled";
    reg = <0 0xfe200000 0 0x10000>;
    interrupt-names = "host", "peripheral", "otg", "wakeup";
    interrupts = <0 0x16 4>, <0 0x16 4>, <0 0x1a 4>, <0x0 0x4a 0x4>;
    interrupt-parent = <&imux>;

    snps,dis_u2_susphy_quirk;
    snps,dis_u3_susphy_quirk;
    snps,quirk-frame-length-adjustment = <0x20>;
    clock-names = "ref";

   };
  };

  cpm_pciea: pci@fca10000 {
   device_type = "pci";
   #address-cells = <3>;
   #interrupt-cells = <1>;
   #size-cells = <2>;
   compatible = "xlnx,versal-cpm-host-1.00";
   status = "disabled";
   interrupt-map = <0 0 0 1 &pcie_intc_0 0>,
     <0 0 0 2 &pcie_intc_0 1>,
     <0 0 0 3 &pcie_intc_0 2>,
     <0 0 0 4 &pcie_intc_0 3>;
   interrupt-map-mask = <0 0 0 7>;
   interrupt-names = "misc";
   interrupts = <0 72 4>;
   xlnx,csr-slcr = <0x6 00000000>;
   xlnx,num-of-bars = <0x2>;
   xlnx,port-type = <0x1>;
   interrupt-parent = <&imux>;
   bus-range = <0x00 0xff>;
   ranges = <0x02000000 0x00000000 0xe0010000 0x0 0xe0010000 0x00000000 0x10000000>,
     <0x43000000 0x00000080 0x00000000 0x00000080 0x00000000 0x00000000 0x80000000>;
   msi-map = <0x0 &gic_its 0x0 0x10000>;
   reg = <0x6 0x00000000 0x0 0x1000000>,
         <0x0 0xfca10000 0x0 0x1000>,
         <0x0 0xfca00000 0x0 0x10000>;
   reg-names = "cfg", "cpm_slcr", "cpm_crx";
   pcie_intc_0: interrupt-controller {
    #address-cells = <0>;
    #interrupt-cells = <1>;
    interrupt-controller ;
   };
  };

  cpm5_pcie: pcie@fcdd0000 {
   device_type = "pci";
   #address-cells = <3>;
   #interrupt-cells = <1>;
   #size-cells = <2>;
   compatible = "xlnx,versal-cpm5-host";
   status = "disabled";
   interrupt-map = <0 0 0 1 &pcie_intc_2 0>,
     <0 0 0 2 &pcie_intc_2 1>,
     <0 0 0 3 &pcie_intc_2 2>,
     <0 0 0 4 &pcie_intc_2 3>;
   interrupt-map-mask = <0 0 0 7>;
   interrupt-names = "misc";
   interrupts = <0 72 4>;
   xlnx,csr-slcr = <0xfce20000>;
   xlnx,num-of-bars = <0x2>;
   xlnx,port-type = <0x1>;
   interrupt-parent = <&imux>;
   bus-range = <0x00 0xff>;
   ranges = <0x02000000 0x0 0xe0000000 0x0 0xe0000000 0x0 0x10000000>,
     <0x43000000 0x80 0x00000000 0x80 0x00000000 0x0 0x80000000>;
   msi-map = <0x0 &gic_its 0x0 0x10000>;
   reg = <0x06 0x00000000 0x00 0x1000000>,
         <0x00 0xfcdd0000 0x00 0x1000>,
         <0x00 0xfce20000 0x00 0x10000>,
         <0x00 0xfcdc0000 0x00 0x10000>;
   reg-names = "cfg", "cpm_slcr", "cpm_csr", "cpm_crx";
   pcie_intc_2: interrupt-controller {
    #address-cells = <0>;
    #interrupt-cells = <1>;
    interrupt-controller;
   };
  };

  watchdog: watchdog@fd4d0000 {
   compatible = "xlnx,versal-wwdt";
   status = "disabled";
   reg = <0 0xfd4d0000 0 0x10000>;
   interrupt-names = "wdt", "wwdt_reset_pending", "gwdt", "gwdt_reset_pending";
   interrupts = <0 0x64 1>, <0 0x6D 1>, <0 0x6C 1>, <0 0x6E 1>;
   interrupt-parent = <&imux>;
   timeout-sec = <30>;
  };

  watchdog1: watchdog@ff120000 {
   compatible = "xlnx,versal-wwdt";
   status = "disabled";
   reg = <0x0 0xff120000 0x0 0x10000>;
   interrupt-parent = <&imux>;
   interrupt-names = "wdt", "wwdt_reset_pending", "gwdt", "gwdt_reset_pending";
   interrupts = <0 49 1>, <0 69 1>, <0 70 4>, <0 71 4>;
   timeout-sec = <30>;
  };
  xilsem_edac: edac@f2014050 {
   compatible = "xlnx,versal-xilsem-edac";
   status = "disabled";
   reg = <0x0 0xf2014050 0x0 0xc4>;
  };

  dma0: pmcdma@f11c0000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-csudma-1.0";
   interrupt-parent = <&imux>;
   interrupts = <0 0x83 4>;
   reg = <0x0 0xf11c0000 0x0 0x10000>;
   xlnx,dma-type = <1>;
  };

  dma1: pmcdma@f11d0000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-csudma-1.0";
   interrupt-parent = <&imux>;
   interrupts = <0 0x84 4>;
   reg = <0x0 0xf11d0000 0x0 0x10000>;
   xlnx,dma-type = <2>;
  };

  iomodule0: iomodule@f0280000 {
   status = "disabled";
   compatible = "xlnx,iomodule-3.1";
   reg = <0x0 0xF0280000 0x0 0x1000>, <0xFFFFFFFF 0xFFFFFFFF 0x0 0xE0000>;
   xlnx,intc-has-fast = <0x0>;
   xlnx,intc-base-vectors = <0xF0240000U>;
   xlnx,intc-addr-width = <0x20>;
   xlnx,intc-level-edge = <0x7FFU>;
   xlnx,clock-freq = <100000000U>;
   xlnx,uart-baudrate = <115200U>;
   xlnx,pit-used = <01 01 01 01>;
   xlnx,pit-size = <0x20 0x20 0x20 0x20>;
   xlnx,pit-mask = <0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF>;
   xlnx,pit-prescaler = <0x9 0x0 0x9 0x0>;
   xlnx,pit-readable = <01 01 01 01>;
   xlnx,gpo-init = <00 00 00 00>;
   xlnx,options = <0x1>;
   xlnx,max-intr-size = <32>;
  };

  ipi_pmc: mailbox@ff320000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 27 4>;
   reg = <0x0 0xFF320000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x2>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <1>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi_pmc_nobuf: mailbox@ff390000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 28 4>;
   reg = <0x0 0xFF390000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x100>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xFFFF>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi_psm: mailbox@ff310000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 29 4>;
   reg = <0x0 0xFF310000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x1>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi0: mailbox@ff330000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 30 4>;
   reg = <0x0 0xFF330000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x4>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <2>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi1: mailbox@ff340000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 31 4>;
   reg = <0x0 0xFF340000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x8>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <3>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi2: mailbox@ff350000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 32 4>;
   reg = <0x0 0xFF350000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x10>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <4>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi3: mailbox@ff360000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 33 4>;
   reg = <0x0 0xFF360000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x20>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <5>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi4: mailbox@ff370000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 34 4>;
   reg = <0x0 0xFF370000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x40>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <6>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi5: mailbox@ff380000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 35 4>;
   reg = <0x0 0xFF380000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x80>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <7>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;

  };

  ipi6: mailbox@ff3a0000 {
   status = "disabled";
   compatible = "xlnx,zynqmp-ipi-mailbox";
   interrupt-parent = <&imux>;
   interrupts = <0 36 4>;
   reg = <0x0 0xFF3A0000U 0x0 0x20>;
   xlnx,ipi-bitmask = <0x200>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xFFFF>;
   #address-cells = <2>;
   #size-cells = <2>;
   ranges;
  };

  coresight: coresight@f0800000 {
   compatible = "xlnx,coresight-1.0";
   status = "disabled";
   reg = <0x0 0xf0800000 0x0 0x10000>;
  };
 };

 psv_r5_0_atcm_global: psv_r5_0_atcm_global@ffe00000 {
  compatible = "xlnx,psv-tcm-global-1.0" , "mmio-sram";
  power-domains = <&versal_firmware 0x1831800b>;
  reg = <0x0 0xffe00000 0x0 0x10000>;
 };

 psv_r5_0_btcm_global: psv_r5_0_btcm_global@ffe20000 {
  compatible = "xlnx,psv-tcm-global-1.0" , "mmio-sram";
  power-domains = <&versal_firmware 0x1831800c>;
  reg = <0x0 0xffe20000 0x0 0x10000>;
 };

 psv_r5_1_atcm_global: psv_r5_1_atcm_global@ffe90000 {
  compatible = "xlnx,psv-tcm-global-1.0" , "mmio-sram";
  power-domains = <&versal_firmware 0x1831800d>;
  reg = <0x0 0xffe90000 0x0 0x10000>;
 };

 psv_r5_1_btcm_global: psv_r5_1_btcm_global@ffeb0000 {
  compatible = "xlnx,psv-tcm-global-1.0" , "mmio-sram";
  power-domains = <&versal_firmware 0x1831800e>;
  reg = <0x0 0xffeb0000 0x0 0x10000>;
 };

 amba_xppu: indirect-bus@1 {
  compatible = "indirect-bus";
  #address-cells = <0x2>;
  #size-cells = <0x2>;

  lpd_xppu: xppu@ff990000 {
   compatible = "xlnx,xppu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xff990000 0x0 0x2000>;
   status = "disabled";
  };

  pmc_xppu: xppu@f1310000 {
   compatible = "xlnx,xppu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xf1310000 0x0 0x2000>;
   status = "disabled";
  };

  pmc_xppu_npi: xppu@f1300000 {
   compatible = "xlnx,xppu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xf1300000 0x0 0x2000>;
   status = "disabled";
  };
 };

 amba_xmpu: indirect-bus@2 {
  compatible = "indirect-bus";
  #address-cells = <0x2>;
  #size-cells = <0x2>;

  fpd_xmpu: xmpu@fd390000 {
   compatible = "xlnx,xmpu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xfd390000 0x0 0x1000>;
   status = "disabled";
  };

  pmc_xmpu: xmpu@f12f0000 {
   compatible = "xlnx,xmpu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xf12f0000 0x0 0x1000>;
   status = "disabled";
  };

  ocm_xmpu: xmpu@ff980000 {
   compatible = "xlnx,xmpu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xff980000 0x0 0x1000>;
   status = "disabled";
  };

  ddrmc_xmpu_0: xmpu@f6080000 {
   compatible = "xlnx,xmpu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xf6080000 0x0 0x1000>;
   status = "disabled";
  };

  ddrmc_xmpu_1: xmpu@f6220000 {
   compatible = "xlnx,xmpu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xf6220000 0x0 0x1000>;
   status = "disabled";
  };

  ddrmc_xmpu_2: xmpu@f6390000 {
   compatible = "xlnx,xmpu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xf6390000 0x0 0x1000>;
   status = "disabled";
  };

  ddrmc_xmpu_3: xmpu@f6500000 {
   compatible = "xlnx,xmpu";
   #firewall-cells = <0x0>;
   reg = <0x0 0xf6500000 0x0 0x1000>;
   status = "disabled";
  };
 };
};
# 3 "/tmp/tmppczvninu" 2
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-clk.dtsi" 1
# 11 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-clk.dtsi"
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/include/dt-bindings/power/xlnx-versal-power.h" 1
# 12 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-clk.dtsi" 2
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/include/dt-bindings/power/xlnx-versal-regnode.h" 1
# 13 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-clk.dtsi" 2
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/include/dt-bindings/clock/xlnx-versal-clk.h" 1
# 14 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-clk.dtsi" 2
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/include/dt-bindings/reset/xlnx-versal-resets.h" 1
# 15 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-clk.dtsi" 2

/ {
 pl_alt_ref: pl-alt-ref {
  bootph-all;
  compatible = "fixed-clock";
  #clock-cells = <0>;
  clock-frequency = <33333333>;
  clock-output-names = "pl_alt_ref_clk";
 };

 ref: ref {
  bootph-all;
  compatible = "fixed-clock";
  #clock-cells = <0>;
  clock-frequency = <33333333>;
  clock-output-names = "ref_clk";
 };

 can0_clk: can0-clk {
  #clock-cells = <0>;
  compatible = "fixed-factor-clock";
  clocks = <&versal_clk 96>;
  clock-div = <2>;
  clock-mult = <1>;
  clock-output-names = "can0_clk";
 };

 can1_clk: can1-clk {
  #clock-cells = <0>;
  compatible = "fixed-factor-clock";
  clocks = <&versal_clk 97>;
  clock-div = <2>;
  clock-mult = <1>;
  clock-output-names = "can1_clk";
 };

 firmware {
  versal_firmware: versal-firmware {
   compatible = "xlnx,versal-firmware";
   interrupt-parent = <&imux>;
   bootph-all;
   method = "smc";
   #power-domain-cells = <1>;

   versal_clk: clock-controller {
    bootph-all;
    #clock-cells = <1>;
    compatible = "xlnx,versal-clk";
    clocks = <&ref>, <&pl_alt_ref>;
    clock-names = "ref", "pl_alt_ref";
   };

   zynqmp_power: power-management {
    compatible = "xlnx,zynqmp-power";
   };

   versal_reset: reset-controller {
    compatible = "xlnx,versal-reset";
    #reset-cells = <1>;
   };

   pinctrl0: pinctrl {
    compatible = "xlnx,versal-pinctrl";
   };

   versal_sec_cfg: versal-sec-cfg {
    compatible = "xlnx,versal-sec-cfg";
    #address-cells = <1>;
    #size-cells = <1>;
    nvmem-layout {
     compatible = "fixed-layout";
     #address-cells = <1>;
     #size-cells = <1>;

     bbram_zeroize: bbram-zeroize@4 {
      reg = <0x04 0x4>;
     };

     bbram_key: bbram-key@10 {
      reg = <0x10 0x20>;
     };

     bbram_usr: bbram-usr@30 {
      reg = <0x30 0x4>;
     };

     bbram_lock: bbram-lock@48 {
      reg = <0x48 0x4>;
     };

     user_key0: user-key@110 {
      reg = <0x110 0x20>;
     };

     user_key1: user-key@130 {
      reg = <0x130 0x20>;
     };

     user_key2: user-key@150 {
      reg = <0x150 0x20>;
     };

     user_key3: user-key@170 {
      reg = <0x170 0x20>;
     };

     user_key4: user-key@190 {
      reg = <0x190 0x20>;
     };

     user_key5: user-key@1b0 {
      reg = <0x1b0 0x20>;
     };

     user_key6: user-key@1d0 {
      reg = <0x1d0 0x20>;
     };

     user_key7: user-key@1f0 {
      reg = <0x1f0 0x20>;
     };
    };
   };
  };
 };
};

&psv_cortexa72_0 {
 clocks = <&versal_clk 77>;
};

&can0 {
 clocks = <&can0_clk>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x1822401fU)>;
};

&can1 {
 clocks = <&can1_clk>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224020U)>;
};

&gem0 {
 clocks = <&versal_clk 82>,
   <&versal_clk 88>, <&versal_clk 49>,
   <&versal_clk 48>, <&versal_clk 43>;
 power-domains = <&versal_firmware (0x18224019U)>;
};

&gem1 {
 clocks = <&versal_clk 82>,
   <&versal_clk 89>, <&versal_clk 51>,
   <&versal_clk 50>, <&versal_clk 43>;
 power-domains = <&versal_firmware (0x1822401aU)>;
};

&gpio0 {
 clocks = <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224023U)>;
};

&gpio1 {
 clocks = <&versal_clk 61>;
 power-domains = <&versal_firmware (0x1822402cU)>;
};

&i2c0 {
 clocks = <&versal_clk 98>;
 power-domains = <&versal_firmware (0x1822401dU)>;
};

&i2c1 {
 clocks = <&versal_clk 99>;
 power-domains = <&versal_firmware (0x1822401eU)>;
};

&i2c2 {
 clocks = <&versal_clk 62>;
 power-domains = <&versal_firmware (0x1822402dU)>;
};

&lpd_dma_chan0 {
 clocks = <&versal_clk 81>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224035U)>;
};

&lpd_dma_chan1 {
 clocks = <&versal_clk 81>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224036U)>;
};

&lpd_dma_chan2 {
 clocks = <&versal_clk 81>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224037U)>;
};

&lpd_dma_chan3 {
 clocks = <&versal_clk 81>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224038U)>;
};

&lpd_dma_chan4 {
 clocks = <&versal_clk 81>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224039U)>;
};

&lpd_dma_chan5 {
 clocks = <&versal_clk 81>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x1822403aU)>;
};

&lpd_dma_chan6 {
 clocks = <&versal_clk 81>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x1822403bU)>;
};

&lpd_dma_chan7 {
 clocks = <&versal_clk 81>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x1822403cU)>;
};

&qspi {
 clocks = <&versal_clk 57>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x1822402bU)>;
};

&ospi {
 clocks = <&versal_clk 58>;
 power-domains = <&versal_firmware (0x1822402aU)>;
 reset-names = "qspi";
 resets = <&versal_reset (0xc10402eU)>;
};

&rtc {
 power-domains = <&versal_firmware (0x18224034U)>;
};

&serial0 {
 clocks = <&versal_clk 92>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224021U)>;
};

&serial1 {
 clocks = <&versal_clk 93>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224022U)>;
};

&sdhci0 {
 clocks = <&versal_clk 59>, <&versal_clk 82>,
  <&versal_clk 74>;
 power-domains = <&versal_firmware (0x1822402eU)>;
};

&sdhci1 {
 clocks = <&versal_clk 60>, <&versal_clk 82>,
  <&versal_clk 74>;
 power-domains = <&versal_firmware (0x1822402fU)>;
};

&spi0 {
 clocks = <&versal_clk 94>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x1822401bU)>;
};

&spi1 {
 clocks = <&versal_clk 95>, <&versal_clk 82>;
 power-domains = <&versal_firmware (0x1822401cU)>;
};

&ttc0 {
 clocks = <&versal_clk 39>;
 power-domains = <&versal_firmware (0x18224024U)>;
};

&ttc1 {
 clocks = <&versal_clk 40>;
 power-domains = <&versal_firmware (0x18224025U)>;
};

&ttc2 {
 clocks = <&versal_clk 41>;
 power-domains = <&versal_firmware (0x18224026U)>;
};

&ttc3 {
 clocks = <&versal_clk 42>;
 power-domains = <&versal_firmware (0x18224027U)>;
};

&usb0 {
 clocks = <&versal_clk 91>, <&versal_clk 104>;
 power-domains = <&versal_firmware (0x18224018U)>;
 resets = <&versal_reset (0xc104036U)>;
};

&dwc3_0 {
 clocks = <&versal_clk 91>;
};

&watchdog {
 clocks = <&versal_clk 76>;
 power-domains = <&versal_firmware (0x18224029U)>;
};

&watchdog1 {
 clocks = <&versal_clk 82>;
 power-domains = <&versal_firmware (0x18224028U)>;
};

&sysmon0 {
 xlnx,nodeid = <(0x18224055U)>;
};

&sysmon1 {
 xlnx,nodeid = <(0x18225055U)>;
};

&sysmon2 {
 xlnx,nodeid = <(0x18226055U)>;
};

&sysmon3 {
 xlnx,nodeid = <(0x18227055U)>;
};
# 4 "/tmp/tmppczvninu" 2
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/pl.dtsi" 1
/ {
 amba_pl: amba_pl {
  ranges;
  compatible = "simple-bus";
  #address-cells = <2>;
  #size-cells = <2>;
  firmware-name = "vpl_gen_fixed.pdi";
  misc_clk_0: misc_clk_0 {
   compatible = "fixed-clock";
   clock-frequency = <100000000>;
   #clock-cells = <0>;
  };
  axi_intc_cascaded_1: interrupt-controller@a4000000 {
   #interrupt-cells = <2>;
   interrupts = < 31 2 >;
   xlnx,sense-of-irq-edge-type = "Rising";
   xlnx,edk-special = "INTR_CTRL";
   xlnx,kind-of-intr = <0xffffffff>;
   xlnx,kind-of-edge = <0xffffffff>;
   xlnx,irq-is-level = <1>;
   xlnx,has-ivr = <1>;
   compatible = "xlnx,axi-intc-4.1" , "xlnx,xps-intc-1.00.a";
   xlnx,disable-synchronizers = <0>;
   xlnx,kind-of-lvl = <0xffffffff>;
   xlnx,ivar-reset-value = <0x10>;
   xlnx,irq-active = <0x1>;
   interrupt-parent = <&axi_intc_parent>;
   xlnx,en-cascade-mode = <0>;
   xlnx,ip-name = "axi_intc";
   xlnx,has-ilr = <0>;
   reg = <0x0 0xa4000000 0x0 0x10000>;
   xlnx,addr-width = <0x20>;
   clocks = <&misc_clk_0>;
   xlnx,s-axi-aclk-freq-mhz = <100>;
   xlnx,num-sw-intr = <0>;
   xlnx,irq-connection = <1>;
   xlnx,num-intr-inputs = <0x20>;
   xlnx,has-sie = <1>;
   xlnx,enable-async = <0>;
   xlnx,has-cie = <1>;
   xlnx,num-sync-ff = <2>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,mb-clk-not-connected = <1>;
   xlnx,has-ipr = <1>;
   xlnx,sense-of-irq-level-type = "Active_High";
   xlnx,cascade-master = <0>;
   xlnx,processor-clk-freq-mhz = <100>;
   status = "okay";
   xlnx,is-fast = <0x0>;
   clock-names = "s_axi_aclk";
   xlnx,has-fast = <0>;
   xlnx,ivar-rst-val = <0x10>;
   interrupt-controller;
   interrupt-names = "irq";
   xlnx,async-intr = <0xffffffff>;
   xlnx,name = "axi_intc_cascaded_1";
  };
  axi_intc_parent: interrupt-controller@a5000000 {
   #interrupt-cells = <2>;
   interrupts = < 0 84 4 >;
   xlnx,sense-of-irq-edge-type = "Rising";
   xlnx,edk-special = "INTR_CTRL";
   xlnx,kind-of-intr = <0x7fffffff>;
   xlnx,kind-of-edge = <0xffffffff>;
   xlnx,irq-is-level = <1>;
   xlnx,has-ivr = <1>;
   compatible = "xlnx,axi-intc-4.1" , "xlnx,xps-intc-1.00.a";
   xlnx,disable-synchronizers = <0>;
   xlnx,kind-of-lvl = <0xffffffff>;
   xlnx,ivar-reset-value = <0x10>;
   xlnx,irq-active = <0x1>;
   interrupt-parent = <&imux>;
   xlnx,en-cascade-mode = <0>;
   xlnx,ip-name = "axi_intc";
   xlnx,has-ilr = <0>;
   reg = <0x0 0xa5000000 0x0 0x10000>;
   xlnx,addr-width = <0x20>;
   clocks = <&misc_clk_0>;
   xlnx,s-axi-aclk-freq-mhz = <100>;
   xlnx,num-sw-intr = <0>;
   xlnx,irq-connection = <1>;
   xlnx,num-intr-inputs = <0x20>;
   xlnx,has-sie = <1>;
   xlnx,enable-async = <0>;
   xlnx,has-cie = <1>;
   xlnx,num-sync-ff = <2>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,mb-clk-not-connected = <1>;
   xlnx,has-ipr = <1>;
   xlnx,sense-of-irq-level-type = "Active_High";
   xlnx,cascade-master = <0>;
   xlnx,processor-clk-freq-mhz = <100>;
   status = "okay";
   xlnx,is-fast = <0x0>;
   clock-names = "s_axi_aclk";
   xlnx,has-fast = <0>;
   xlnx,ivar-rst-val = <0x10>;
   interrupt-controller;
   interrupt-names = "irq";
   xlnx,async-intr = <0xffffffff>;
   xlnx,name = "axi_intc_parent";
  };
  ai_engine_0: ai_engine@20000000000 {
   xlnx,num-mi-axi = <4>;
   compatible = "xlnx,ai-engine-2.0" , "xlnx,ai-engine-v2.0";
   xlnx,aie-ref-clk-freqmhz = <0x1fc9f08>;
   xlnx,aie-col-dict = "col00 0x20000000000 col01 0x20000800000 col02 0x20001000000 col03 0x20001800000 col04 0x20002000000 col05 0x20002800000 col06 0x20003000000 col07 0x20003800000 col08 0x20004000000 col09 0x20004800000 col10 0x20005000000 col11 0x20005800000 col12 0x20006000000 col13 0x20006800000 col14 0x20007000000 col15 0x20007800000 col16 0x20008000000 col17 0x20008800000 col18 0x20009000000 col19 0x20009800000 col20 0x2000A000000 col21 0x2000A800000 col22 0x2000B000000 col23 0x2000B800000 col24 0x2000C000000 col25 0x2000C800000 col26 0x2000D000000 col27 0x2000D800000 col28 0x2000E000000 col29 0x2000E800000 col30 0x2000F000000 col31 0x2000F800000 col32 0x20010000000 col33 0x20010800000 col34 0x20011000000 col35 0x20011800000 col36 0x20012000000 col37 0x20012800000 col38 0x20013000000 col39 0x20013800000 col40 0x20014000000 col41 0x20014800000 col42 0x20015000000 col43 0x20015800000 col44 0x20016000000 col45 0x20016800000 col46 0x20017000000 col47 0x20017800000 col48 0x20018000000 col49 0x20018800000";
   xlnx,num-mi-axis = <0>;
   xlnx,aie-max-freq = <1250>;
   xlnx,en-addr-virtualization = <0>;
   xlnx,aie-gen = /bits/ 8 <0x1>;
   xlnx,mem-rows = /bits/ 8 <0 0>;
   xlnx,mi-destid-pins;
   xlnx,ip-name = "ai_engine";
   #size-cells = <2>;
   xlnx,num-si-axi = <1>;
   xlnx,fast-pm-write;
   reg = <0x00000200 0x00000000 0x00000001 0x00000000>;
   clocks = <&aie_core_ref_clk_0>;
   xlnx,num-noc-axis-clks = <0>;
   ranges;
   xlnx,num-clks = <0>;
   xlnx,partition-enabled = <0>;
   #address-cells = <2>;
   xlnx,num-si-axis = <0>;
   xlnx,num-column = <1>;
   xlnx,aie-core-ref-ctrl-freqmhz = <1250>;
   xlnx,fast-dm-write;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,selected-nsu = <0>;
   xlnx,available-nsu = "NOC_NSU128_X1Y6 0x20000000000 NOC_NSU128_X2Y6 0x20001000000 NOC_NSU128_X3Y6 0x20001800000 NOC_NSU128_X4Y6 0x20002800000 NOC_NSU128_X5Y6 0x20003800000 NOC_NSU128_X6Y6 0x20005000000 NOC_NSU128_X7Y6 0x20008800000 NOC_NSU128_X8Y6 0x20009800000 NOC_NSU128_X9Y6 0x2000D800000 NOC_NSU128_X10Y6 0x2000E800000 NOC_NSU128_X11Y6 0x20012800000 NOC_NSU128_X12Y6 0x20013800000 NOC_NSU128_X13Y6 0x20017000000 NOC_NSU128_X14Y6 0x20017800000 NOC_NSU128_X15Y6 0x20018000000 NOC_NSU128_X16Y6 0x20018800000";
   status = "okay";
   clock-names = "aclk0";
   power-domains = <&versal_firmware 0x18224072>;
   xlnx,num-trig-in = <0>;
   xlnx,nsu-dict = "NOC_NSU128_X1Y6 0x20000000000 NOC_NSU128_X2Y6 0x20001000000 NOC_NSU128_X3Y6 0x20001800000 NOC_NSU128_X4Y6 0x20002800000 NOC_NSU128_X5Y6 0x20003800000 NOC_NSU128_X6Y6 0x20005000000 NOC_NSU128_X7Y6 0x20008800000 NOC_NSU128_X8Y6 0x20009800000 NOC_NSU128_X9Y6 0x2000D800000 NOC_NSU128_X10Y6 0x2000E800000 NOC_NSU128_X11Y6 0x20012800000 NOC_NSU128_X12Y6 0x20013800000 NOC_NSU128_X13Y6 0x20017000000 NOC_NSU128_X14Y6 0x20017800000 NOC_NSU128_X15Y6 0x20018000000 NOC_NSU128_X16Y6 0x20018800000";
   xlnx,en-ext-rst = <1>;
   xlnx,num-trig-out = <0>;
   xlnx,core-rows = /bits/ 8 <1 8>;
   xlnx,shim-rows = /bits/ 8 <0 1>;
   xlnx,name-si-axi = "S00_AXI,";
   xlnx,start-column = <0>;
   xlnx,name = "ai_engine_0";
   xlnx,aie-site = "AIE";
   aie_aperture_0: aie_aperture@20000000000 {
    xlnx,device-name = <0>;
    interrupt-parent = <&imux>;
    interrupts = <0x0 0x94 0x4>, <0x0 0x95 0x4>, <0x0 0x96 0x4>;
    #address-cells = <2>;
    power-domains = <&versal_firmware 0x18224072>;
    xlnx,node-id = <0x18800000>;
    #size-cells = <2>;
    interrupt-names = "interrupt1" , "interrupt2" , "interrupt3";
    reg = <0x00000200 0x00000000 0x00000001 0x00000000>;
    xlnx,columns = < 0 50 >;
   };
  };
  dummy_slave_0: axi_vip@a4010000 {
   xlnx,axi-has-cache = <1>;
   xlnx,has-user-bits-per-byte = <1>;
   xlnx,has-prot = <1>;
   xlnx,ip-name = "axi_vip";
   xlnx,has-aclken = <0>;
   reg = <0x0 0xa4010000 0x0 0x10000>;
   xlnx,axi-has-burst = <1>;
   xlnx,axi-rdata-width = <32>;
   xlnx,axi-has-lock = <1>;
   xlnx,has-wstrb = <1>;
   xlnx,has-qos = <1>;
   xlnx,has-size = <0>;
   xlnx,axi-buser-width = <0>;
   xlnx,aruser-width = <16>;
   xlnx,data-width = <32>;
   compatible = "xlnx,axi-vip-1.1";
   xlnx,axi-has-aresetn = <1>;
   xlnx,axi-has-wstrb = <1>;
   xlnx,axi-awuser-width = <16>;
   xlnx,axi-rid-width = <0>;
   xlnx,axi-has-prot = <1>;
   xlnx,has-bresp = <1>;
   xlnx,buser-width = <0>;
   xlnx,axi-wid-width = <0>;
   xlnx,axi-interface-mode = <2>;
   xlnx,has-aresetn = <1>;
   xlnx,axi-has-bresp = <1>;
   xlnx,axi-ruser-width = <0>;
   xlnx,axi-wdata-width = <32>;
   status = "okay";
   xlnx,name = "dummy_slave_0";
   xlnx,axi-has-qos = <1>;
   xlnx,awuser-width = <16>;
   xlnx,ruser-bits-per-byte = <0>;
   xlnx,has-rresp = <1>;
   xlnx,supports-narrow = <0>;
   xlnx,slave-seg-type = "REG";
   xlnx,ruser-width = <0>;
   xlnx,read-write-mode = "READ_WRITE";
   xlnx,axi-addr-width = <32>;
   xlnx,addr-width = <32>;
   clocks = <&misc_clk_0>;
   xlnx,id-width = <0>;
   xlnx,axi-has-rresp = <1>;
   xlnx,edk-iptype = "PERIPHERAL";
   clock-names = "aclk";
   xlnx,protocol = "AXI4";
   xlnx,axi-wuser-width = <0>;
   xlnx,vip-pkg-name = <0>;
   xlnx,wuser-bits-per-byte = <0>;
   xlnx,has-lock = <1>;
   xlnx,wuser-width = <0>;
   xlnx,interface-mode = "SLAVE";
   xlnx,axi-has-region = <0>;
   xlnx,axi-supports-narrow = <0>;
   xlnx,has-cache = <1>;
   xlnx,has-region = <0>;
   xlnx,axi-aruser-width = <16>;
   xlnx,axi-protocol = <0>;
   xlnx,has-burst = <1>;
  };
  dummy_slave_1: axi_vip@a4020000 {
   xlnx,axi-has-cache = <1>;
   xlnx,has-user-bits-per-byte = <1>;
   xlnx,has-prot = <1>;
   xlnx,ip-name = "axi_vip";
   xlnx,has-aclken = <0>;
   reg = <0x0 0xa4020000 0x0 0x10000>;
   xlnx,axi-has-burst = <1>;
   xlnx,axi-rdata-width = <32>;
   xlnx,axi-has-lock = <1>;
   xlnx,has-wstrb = <1>;
   xlnx,has-qos = <1>;
   xlnx,has-size = <0>;
   xlnx,axi-buser-width = <0>;
   xlnx,aruser-width = <16>;
   xlnx,data-width = <32>;
   compatible = "xlnx,axi-vip-1.1";
   xlnx,axi-has-aresetn = <1>;
   xlnx,axi-has-wstrb = <1>;
   xlnx,axi-awuser-width = <16>;
   xlnx,axi-rid-width = <0>;
   xlnx,axi-has-prot = <1>;
   xlnx,has-bresp = <1>;
   xlnx,buser-width = <0>;
   xlnx,axi-wid-width = <0>;
   xlnx,axi-interface-mode = <2>;
   xlnx,has-aresetn = <1>;
   xlnx,axi-has-bresp = <1>;
   xlnx,axi-ruser-width = <0>;
   xlnx,axi-wdata-width = <32>;
   status = "okay";
   xlnx,name = "dummy_slave_1";
   xlnx,axi-has-qos = <1>;
   xlnx,awuser-width = <16>;
   xlnx,ruser-bits-per-byte = <0>;
   xlnx,has-rresp = <1>;
   xlnx,supports-narrow = <0>;
   xlnx,slave-seg-type = "REG";
   xlnx,ruser-width = <0>;
   xlnx,read-write-mode = "READ_WRITE";
   xlnx,axi-addr-width = <32>;
   xlnx,addr-width = <32>;
   clocks = <&misc_clk_0>;
   xlnx,id-width = <0>;
   xlnx,axi-has-rresp = <1>;
   xlnx,edk-iptype = "PERIPHERAL";
   clock-names = "aclk";
   xlnx,protocol = "AXI4";
   xlnx,axi-wuser-width = <0>;
   xlnx,vip-pkg-name = <0>;
   xlnx,wuser-bits-per-byte = <0>;
   xlnx,has-lock = <1>;
   xlnx,wuser-width = <0>;
   xlnx,interface-mode = "SLAVE";
   xlnx,axi-has-region = <0>;
   xlnx,axi-supports-narrow = <0>;
   xlnx,has-cache = <1>;
   xlnx,has-region = <0>;
   xlnx,axi-aruser-width = <16>;
   xlnx,axi-protocol = <0>;
   xlnx,has-burst = <1>;
  };
  dummy_slave_2: axi_vip@a4030000 {
   xlnx,axi-has-cache = <1>;
   xlnx,has-user-bits-per-byte = <1>;
   xlnx,has-prot = <1>;
   xlnx,ip-name = "axi_vip";
   xlnx,has-aclken = <0>;
   reg = <0x0 0xa4030000 0x0 0x10000>;
   xlnx,axi-has-burst = <1>;
   xlnx,axi-rdata-width = <32>;
   xlnx,axi-has-lock = <1>;
   xlnx,has-wstrb = <1>;
   xlnx,has-qos = <1>;
   xlnx,has-size = <0>;
   xlnx,axi-buser-width = <0>;
   xlnx,aruser-width = <16>;
   xlnx,data-width = <32>;
   compatible = "xlnx,axi-vip-1.1";
   xlnx,axi-has-aresetn = <1>;
   xlnx,axi-has-wstrb = <1>;
   xlnx,axi-awuser-width = <16>;
   xlnx,axi-rid-width = <0>;
   xlnx,axi-has-prot = <1>;
   xlnx,has-bresp = <1>;
   xlnx,buser-width = <0>;
   xlnx,axi-wid-width = <0>;
   xlnx,axi-interface-mode = <2>;
   xlnx,has-aresetn = <1>;
   xlnx,axi-has-bresp = <1>;
   xlnx,axi-ruser-width = <0>;
   xlnx,axi-wdata-width = <32>;
   status = "okay";
   xlnx,name = "dummy_slave_2";
   xlnx,axi-has-qos = <1>;
   xlnx,awuser-width = <16>;
   xlnx,ruser-bits-per-byte = <0>;
   xlnx,has-rresp = <1>;
   xlnx,supports-narrow = <0>;
   xlnx,slave-seg-type = "REG";
   xlnx,ruser-width = <0>;
   xlnx,read-write-mode = "READ_WRITE";
   xlnx,axi-addr-width = <32>;
   xlnx,addr-width = <32>;
   clocks = <&misc_clk_0>;
   xlnx,id-width = <0>;
   xlnx,axi-has-rresp = <1>;
   xlnx,edk-iptype = "PERIPHERAL";
   clock-names = "aclk";
   xlnx,protocol = "AXI4";
   xlnx,axi-wuser-width = <0>;
   xlnx,vip-pkg-name = <0>;
   xlnx,wuser-bits-per-byte = <0>;
   xlnx,has-lock = <1>;
   xlnx,wuser-width = <0>;
   xlnx,interface-mode = "SLAVE";
   xlnx,axi-has-region = <0>;
   xlnx,axi-supports-narrow = <0>;
   xlnx,has-cache = <1>;
   xlnx,has-region = <0>;
   xlnx,axi-aruser-width = <16>;
   xlnx,axi-protocol = <0>;
   xlnx,has-burst = <1>;
  };
  dummy_slave_3: axi_vip@a4040000 {
   xlnx,axi-has-cache = <1>;
   xlnx,has-user-bits-per-byte = <1>;
   xlnx,has-prot = <1>;
   xlnx,ip-name = "axi_vip";
   xlnx,has-aclken = <0>;
   reg = <0x0 0xa4040000 0x0 0x10000>;
   xlnx,axi-has-burst = <1>;
   xlnx,axi-rdata-width = <32>;
   xlnx,axi-has-lock = <1>;
   xlnx,has-wstrb = <1>;
   xlnx,has-qos = <1>;
   xlnx,has-size = <0>;
   xlnx,axi-buser-width = <0>;
   xlnx,aruser-width = <16>;
   xlnx,data-width = <32>;
   compatible = "xlnx,axi-vip-1.1";
   xlnx,axi-has-aresetn = <1>;
   xlnx,axi-has-wstrb = <1>;
   xlnx,axi-awuser-width = <16>;
   xlnx,axi-rid-width = <0>;
   xlnx,axi-has-prot = <1>;
   xlnx,has-bresp = <1>;
   xlnx,buser-width = <0>;
   xlnx,axi-wid-width = <0>;
   xlnx,axi-interface-mode = <2>;
   xlnx,has-aresetn = <1>;
   xlnx,axi-has-bresp = <1>;
   xlnx,axi-ruser-width = <0>;
   xlnx,axi-wdata-width = <32>;
   status = "okay";
   xlnx,name = "dummy_slave_3";
   xlnx,axi-has-qos = <1>;
   xlnx,awuser-width = <16>;
   xlnx,ruser-bits-per-byte = <0>;
   xlnx,has-rresp = <1>;
   xlnx,supports-narrow = <0>;
   xlnx,slave-seg-type = "REG";
   xlnx,ruser-width = <0>;
   xlnx,read-write-mode = "READ_WRITE";
   xlnx,axi-addr-width = <32>;
   xlnx,addr-width = <32>;
   clocks = <&misc_clk_0>;
   xlnx,id-width = <0>;
   xlnx,axi-has-rresp = <1>;
   xlnx,edk-iptype = "PERIPHERAL";
   clock-names = "aclk";
   xlnx,protocol = "AXI4";
   xlnx,axi-wuser-width = <0>;
   xlnx,vip-pkg-name = <0>;
   xlnx,wuser-bits-per-byte = <0>;
   xlnx,has-lock = <1>;
   xlnx,wuser-width = <0>;
   xlnx,interface-mode = "SLAVE";
   xlnx,axi-has-region = <0>;
   xlnx,axi-supports-narrow = <0>;
   xlnx,has-cache = <1>;
   xlnx,has-region = <0>;
   xlnx,axi-aruser-width = <16>;
   xlnx,axi-protocol = <0>;
   xlnx,has-burst = <1>;
  };
  aie_core_ref_clk_0: aie_core_ref_clk_0 {
   compatible = "fixed-clock";
   clock-frequency = <1250000000>;
   #clock-cells = <0>;
  };
 };
};
# 5 "/tmp/tmppczvninu" 2
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/pcw.dtsi" 1
 &psv_cortexa72_0 {
  xlnx,timestamp-clk-freq = <99999908>;
  xlnx,pss-ref-clk-freq = <33333300>;
  stamp-frequency = <99999908>;
  xlnx,ip-name = "psv_cortexa72";
  xlnx,cpu-clk-freq-hz = <1349998657>;
  cpu-frequency = <1349998657>;
  bus-handle = <&amba>;
 };
 &psv_cortexa72_1 {
  xlnx,timestamp-clk-freq = <99999908>;
  xlnx,pss-ref-clk-freq = <33333300>;
  stamp-frequency = <99999908>;
  xlnx,ip-name = "psv_cortexa72";
  xlnx,cpu-clk-freq-hz = <1349998657>;
  cpu-frequency = <1349998657>;
  bus-handle = <&amba>;
 };
 &amba {
  CIPS_0_pspmc_0_psv_apu_0: CIPS_0_pspmc_0_psv_apu_0@fd5c0000 {
   compatible = "xlnx,psv-apu-1.0";
   status = "okay";
   xlnx,ip-name = "psv_apu";
   reg = <0x0 0xfd5c0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_apu_0";
  };
  CIPS_0_pspmc_0_psv_coresight_a720_cti: CIPS_0_pspmc_0_psv_coresight_a720_cti@f0d10000 {
   compatible = "xlnx,psv-coresight-a720-cti-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_a720_cti";
   reg = <0x0 0xf0d10000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_a720_cti";
  };
  CIPS_0_pspmc_0_psv_coresight_a720_dbg: CIPS_0_pspmc_0_psv_coresight_a720_dbg@f0d00000 {
   compatible = "xlnx,psv-coresight-a720-dbg-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_a720_dbg";
   reg = <0x0 0xf0d00000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_a720_dbg";
  };
  CIPS_0_pspmc_0_psv_coresight_a720_etm: CIPS_0_pspmc_0_psv_coresight_a720_etm@f0d30000 {
   compatible = "xlnx,psv-coresight-a720-etm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_a720_etm";
   reg = <0x0 0xf0d30000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_a720_etm";
  };
  CIPS_0_pspmc_0_psv_coresight_a720_pmu: CIPS_0_pspmc_0_psv_coresight_a720_pmu@f0d20000 {
   compatible = "xlnx,psv-coresight-a720-pmu-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_a720_pmu";
   reg = <0x0 0xf0d20000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_a720_pmu";
  };
  CIPS_0_pspmc_0_psv_coresight_a721_cti: CIPS_0_pspmc_0_psv_coresight_a721_cti@f0d50000 {
   compatible = "xlnx,psv-coresight-a721-cti-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_a721_cti";
   reg = <0x0 0xf0d50000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_a721_cti";
  };
  CIPS_0_pspmc_0_psv_coresight_a721_dbg: CIPS_0_pspmc_0_psv_coresight_a721_dbg@f0d40000 {
   compatible = "xlnx,psv-coresight-a721-dbg-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_a721_dbg";
   reg = <0x0 0xf0d40000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_a721_dbg";
  };
  CIPS_0_pspmc_0_psv_coresight_a721_etm: CIPS_0_pspmc_0_psv_coresight_a721_etm@f0d70000 {
   compatible = "xlnx,psv-coresight-a721-etm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_a721_etm";
   reg = <0x0 0xf0d70000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_a721_etm";
  };
  CIPS_0_pspmc_0_psv_coresight_a721_pmu: CIPS_0_pspmc_0_psv_coresight_a721_pmu@f0d60000 {
   compatible = "xlnx,psv-coresight-a721-pmu-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_a721_pmu";
   reg = <0x0 0xf0d60000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_a721_pmu";
  };
  CIPS_0_pspmc_0_psv_coresight_apu_cti: CIPS_0_pspmc_0_psv_coresight_apu_cti@f0ca0000 {
   compatible = "xlnx,psv-coresight-apu-cti-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_apu_cti";
   reg = <0x0 0xf0ca0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_apu_cti";
  };
  CIPS_0_pspmc_0_psv_coresight_apu_ela: CIPS_0_pspmc_0_psv_coresight_apu_ela@f0c60000 {
   compatible = "xlnx,psv-coresight-apu-ela-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_apu_ela";
   reg = <0x0 0xf0c60000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_apu_ela";
  };
  CIPS_0_pspmc_0_psv_coresight_apu_etf: CIPS_0_pspmc_0_psv_coresight_apu_etf@f0c30000 {
   compatible = "xlnx,psv-coresight-apu-etf-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_apu_etf";
   reg = <0x0 0xf0c30000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_apu_etf";
  };
  CIPS_0_pspmc_0_psv_coresight_apu_fun: CIPS_0_pspmc_0_psv_coresight_apu_fun@f0c20000 {
   compatible = "xlnx,psv-coresight-apu-fun-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_apu_fun";
   reg = <0x0 0xf0c20000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_apu_fun";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_atm: CIPS_0_pspmc_0_psv_coresight_cpm_atm@f0f80000 {
   compatible = "xlnx,psv-coresight-cpm-atm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_atm";
   reg = <0x0 0xf0f80000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_atm";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_cti2a: CIPS_0_pspmc_0_psv_coresight_cpm_cti2a@f0fa0000 {
   compatible = "xlnx,psv-coresight-cpm-cti2a-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_cti2a";
   reg = <0x0 0xf0fa0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_cti2a";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_cti2d: CIPS_0_pspmc_0_psv_coresight_cpm_cti2d@f0fd0000 {
   compatible = "xlnx,psv-coresight-cpm-cti2d-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_cti2d";
   reg = <0x0 0xf0fd0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_cti2d";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_ela2a: CIPS_0_pspmc_0_psv_coresight_cpm_ela2a@f0f40000 {
   compatible = "xlnx,psv-coresight-cpm-ela2a-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_ela2a";
   reg = <0x0 0xf0f40000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_ela2a";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_ela2b: CIPS_0_pspmc_0_psv_coresight_cpm_ela2b@f0f50000 {
   compatible = "xlnx,psv-coresight-cpm-ela2b-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_ela2b";
   reg = <0x0 0xf0f50000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_ela2b";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_ela2c: CIPS_0_pspmc_0_psv_coresight_cpm_ela2c@f0f60000 {
   compatible = "xlnx,psv-coresight-cpm-ela2c-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_ela2c";
   reg = <0x0 0xf0f60000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_ela2c";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_ela2d: CIPS_0_pspmc_0_psv_coresight_cpm_ela2d@f0f70000 {
   compatible = "xlnx,psv-coresight-cpm-ela2d-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_ela2d";
   reg = <0x0 0xf0f70000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_ela2d";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_fun: CIPS_0_pspmc_0_psv_coresight_cpm_fun@f0f20000 {
   compatible = "xlnx,psv-coresight-cpm-fun-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_fun";
   reg = <0x0 0xf0f20000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_fun";
  };
  CIPS_0_pspmc_0_psv_coresight_cpm_rom: CIPS_0_pspmc_0_psv_coresight_cpm_rom@f0f00000 {
   compatible = "xlnx,psv-coresight-cpm-rom-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_cpm_rom";
   reg = <0x0 0xf0f00000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_cpm_rom";
  };
  CIPS_0_pspmc_0_psv_coresight_fpd_atm: CIPS_0_pspmc_0_psv_coresight_fpd_atm@f0b80000 {
   compatible = "xlnx,psv-coresight-fpd-atm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_fpd_atm";
   reg = <0x0 0xf0b80000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_fpd_atm";
  };
  CIPS_0_pspmc_0_psv_coresight_fpd_cti1b: CIPS_0_pspmc_0_psv_coresight_fpd_cti1b@f0bb0000 {
   compatible = "xlnx,psv-coresight-fpd-cti1b-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_fpd_cti1b";
   reg = <0x0 0xf0bb0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_fpd_cti1b";
  };
  CIPS_0_pspmc_0_psv_coresight_fpd_cti1c: CIPS_0_pspmc_0_psv_coresight_fpd_cti1c@f0bc0000 {
   compatible = "xlnx,psv-coresight-fpd-cti1c-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_fpd_cti1c";
   reg = <0x0 0xf0bc0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_fpd_cti1c";
  };
  CIPS_0_pspmc_0_psv_coresight_fpd_cti1d: CIPS_0_pspmc_0_psv_coresight_fpd_cti1d@f0bd0000 {
   compatible = "xlnx,psv-coresight-fpd-cti1d-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_fpd_cti1d";
   reg = <0x0 0xf0bd0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_fpd_cti1d";
  };
  CIPS_0_pspmc_0_psv_coresight_fpd_stm: CIPS_0_pspmc_0_psv_coresight_fpd_stm@f0b70000 {
   compatible = "xlnx,psv-coresight-fpd-stm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_fpd_stm";
   reg = <0x0 0xf0b70000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_fpd_stm";
  };
  CIPS_0_pspmc_0_psv_coresight_lpd_atm: CIPS_0_pspmc_0_psv_coresight_lpd_atm@f0980000 {
   compatible = "xlnx,psv-coresight-lpd-atm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_lpd_atm";
   reg = <0x0 0xf0980000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_lpd_atm";
  };
  CIPS_0_pspmc_0_psv_coresight_lpd_cti: CIPS_0_pspmc_0_psv_coresight_lpd_cti@f09d0000 {
   compatible = "xlnx,psv-coresight-lpd-cti-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_lpd_cti";
   reg = <0x0 0xf09d0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_lpd_cti";
  };
  CIPS_0_pspmc_0_psv_coresight_pmc_cti: CIPS_0_pspmc_0_psv_coresight_pmc_cti@f08d0000 {
   compatible = "xlnx,psv-coresight-pmc-cti-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_pmc_cti";
   reg = <0x0 0xf08d0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_pmc_cti";
  };
  CIPS_0_pspmc_0_psv_coresight_r50_cti: CIPS_0_pspmc_0_psv_coresight_r50_cti@f0a10000 {
   compatible = "xlnx,psv-coresight-r50-cti-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_r50_cti";
   reg = <0x0 0xf0a10000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_r50_cti";
  };
  CIPS_0_pspmc_0_psv_coresight_r51_cti: CIPS_0_pspmc_0_psv_coresight_r51_cti@f0a50000 {
   compatible = "xlnx,psv-coresight-r51-cti-1.0";
   status = "okay";
   xlnx,ip-name = "psv_coresight_r51_cti";
   reg = <0x0 0xf0a50000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_coresight_r51_cti";
  };
  CIPS_0_pspmc_0_psv_cpm: CIPS_0_pspmc_0_psv_cpm@0 {
   xlnx,cpm5-slcr-addr = <0xfcdd0000>;
   compatible = "xlnx,psv-cpm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_cpm";
   reg = <0x0 0xfc000000 0x0 0x1000000>;
   xlnx,cpm-slcr = <0xfca10000>;
   xlnx,cpm5-dma0-csr-addr = <0xfce20000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_cpm";
  };
  CIPS_0_pspmc_0_psv_crf_0: CIPS_0_pspmc_0_psv_crf_0@fd1a0000 {
   compatible = "xlnx,psv-crf-1.0";
   status = "okay";
   xlnx,ip-name = "psv_crf";
   reg = <0x0 0xfd1a0000 0x0 0x140000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_crf_0";
  };
  CIPS_0_pspmc_0_psv_crl_0: CIPS_0_pspmc_0_psv_crl_0@ff5e0000 {
   compatible = "xlnx,psv-crl-1.0";
   status = "okay";
   xlnx,ip-name = "psv_crl";
   reg = <0x0 0xff5e0000 0x0 0x300000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_crl_0";
  };
  CIPS_0_pspmc_0_psv_crp_0: CIPS_0_pspmc_0_psv_crp_0@f1260000 {
   compatible = "xlnx,psv-crp-1.0";
   status = "okay";
   xlnx,ip-name = "psv_crp";
   reg = <0x0 0xf1260000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_crp_0";
  };
  CIPS_0_pspmc_0_psv_fpd_afi_0: CIPS_0_pspmc_0_psv_fpd_afi_0@fd360000 {
   compatible = "xlnx,psv-fpd-afi-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_afi";
   reg = <0x0 0xfd360000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_afi_0";
  };
  CIPS_0_pspmc_0_psv_fpd_afi_2: CIPS_0_pspmc_0_psv_fpd_afi_2@fd380000 {
   compatible = "xlnx,psv-fpd-afi-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_afi";
   reg = <0x0 0xfd380000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_afi_2";
  };
  CIPS_0_pspmc_0_psv_fpd_afi_mem_0: CIPS_0_pspmc_0_psv_fpd_afi_mem_0@a4000000 {
   compatible = "xlnx,psv-fpd-afi-mem-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_afi_mem";
   xlnx,is-hierarchy;
   reg = <0x0 0xa4000000 0x0 0xc000000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_afi_mem_0";
  };
  CIPS_0_pspmc_0_psv_fpd_afi_mem_2: CIPS_0_pspmc_0_psv_fpd_afi_mem_2@b0000000 {
   compatible = "xlnx,psv-fpd-afi-mem-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_afi_mem";
   xlnx,is-hierarchy;
   reg = <0x0 0xb0000000 0x0 0x10000000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_afi_mem_2";
  };
  CIPS_0_pspmc_0_psv_fpd_cci_0: CIPS_0_pspmc_0_psv_fpd_cci_0@fd5e0000 {
   compatible = "xlnx,psv-fpd-cci-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_cci";
   reg = <0x0 0xfd5e0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_cci_0";
  };
  CIPS_0_pspmc_0_psv_fpd_gpv_0: CIPS_0_pspmc_0_psv_fpd_gpv_0@fd700000 {
   compatible = "xlnx,psv-fpd-gpv-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_gpv";
   reg = <0x0 0xfd700000 0x0 0x100000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_gpv_0";
  };
  CIPS_0_pspmc_0_psv_fpd_slcr_0: CIPS_0_pspmc_0_psv_fpd_slcr_0@fd610000 {
   compatible = "xlnx,psv-fpd-slcr-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_slcr";
   reg = <0x0 0xfd610000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_slcr_0";
  };
  CIPS_0_pspmc_0_psv_fpd_slcr_secure_0: CIPS_0_pspmc_0_psv_fpd_slcr_secure_0@fd690000 {
   compatible = "xlnx,psv-fpd-slcr-secure-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_slcr_secure";
   reg = <0x0 0xfd690000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_slcr_secure_0";
  };
  CIPS_0_pspmc_0_psv_fpd_smmu_0: CIPS_0_pspmc_0_psv_fpd_smmu_0@fd5f0000 {
   compatible = "xlnx,psv-fpd-smmu-1.0";
   status = "okay";
   xlnx,ip-name = "psv_fpd_smmu";
   reg = <0x0 0xfd5f0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_fpd_smmu_0";
  };
  CIPS_0_pspmc_0_psv_ipi_buffer: CIPS_0_pspmc_0_psv_ipi_buffer@ff3f0000 {
   compatible = "xlnx,psv-ipi-buffer-1.0";
   status = "okay";
   xlnx,ip-name = "psv_ipi_buffer";
   reg = <0x0 0xff3f0000 0x0 0x1000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_ipi_buffer";
  };
  CIPS_0_pspmc_0_psv_lpd_afi_0: CIPS_0_pspmc_0_psv_lpd_afi_0@ff9b0000 {
   compatible = "xlnx,psv-lpd-afi-1.0";
   status = "okay";
   xlnx,ip-name = "psv_lpd_afi";
   reg = <0x0 0xff9b0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_lpd_afi_0";
  };
  CIPS_0_pspmc_0_psv_lpd_afi_mem_0: CIPS_0_pspmc_0_psv_lpd_afi_mem_0@80000000 {
   compatible = "xlnx,psv-lpd-afi-mem-1.0";
   status = "okay";
   xlnx,ip-name = "psv_lpd_afi_mem";
   xlnx,is-hierarchy;
   reg = <0x0 0x80000000 0x0 0x20000000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_lpd_afi_mem_0";
  };
  CIPS_0_pspmc_0_psv_lpd_iou_secure_slcr_0: CIPS_0_pspmc_0_psv_lpd_iou_secure_slcr_0@ff0a0000 {
   compatible = "xlnx,psv-lpd-iou-secure-slcr-1.0";
   status = "okay";
   xlnx,ip-name = "psv_lpd_iou_secure_slcr";
   reg = <0x0 0xff0a0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_lpd_iou_secure_slcr_0";
  };
  CIPS_0_pspmc_0_psv_lpd_iou_slcr_0: CIPS_0_pspmc_0_psv_lpd_iou_slcr_0@ff080000 {
   compatible = "xlnx,psv-lpd-iou-slcr-1.0";
   status = "okay";
   xlnx,ip-name = "psv_lpd_iou_slcr";
   reg = <0x0 0xff080000 0x0 0x20000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_lpd_iou_slcr_0";
  };
  CIPS_0_pspmc_0_psv_lpd_slcr_0: CIPS_0_pspmc_0_psv_lpd_slcr_0@ff410000 {
   compatible = "xlnx,psv-lpd-slcr-1.0";
   status = "okay";
   xlnx,ip-name = "psv_lpd_slcr";
   reg = <0x0 0xff410000 0x0 0x100000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_lpd_slcr_0";
  };
  CIPS_0_pspmc_0_psv_lpd_slcr_secure_0: CIPS_0_pspmc_0_psv_lpd_slcr_secure_0@ff510000 {
   compatible = "xlnx,psv-lpd-slcr-secure-1.0";
   status = "okay";
   xlnx,ip-name = "psv_lpd_slcr_secure";
   reg = <0x0 0xff510000 0x0 0x40000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_lpd_slcr_secure_0";
  };
  CIPS_0_pspmc_0_psv_ocm_ctrl: CIPS_0_pspmc_0_psv_ocm_ctrl@ff960000 {
   compatible = "xlnx,psv-ocm-1.0";
   status = "okay";
   power-domains = <&versal_firmware 0x18314007>;
   xlnx,ip-name = "psv_ocm";
   reg = <0x0 0xff960000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_ocm_ctrl";
  };
  CIPS_0_pspmc_0_psv_pmc_aes: CIPS_0_pspmc_0_psv_pmc_aes@f11e0000 {
   compatible = "xlnx,psv-pmc-aes-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_aes";
   reg = <0x0 0xf11e0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_aes";
  };
  CIPS_0_pspmc_0_psv_pmc_bbram_ctrl: CIPS_0_pspmc_0_psv_pmc_bbram_ctrl@f11f0000 {
   compatible = "xlnx,psv-pmc-bbram-ctrl-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_bbram_ctrl";
   reg = <0x0 0xf11f0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_bbram_ctrl";
  };
  CIPS_0_pspmc_0_psv_pmc_cfi_cframe_0: CIPS_0_pspmc_0_psv_pmc_cfi_cframe_0@f12d0000 {
   compatible = "xlnx,psv-pmc-cfi-cframe-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_cfi_cframe";
   reg = <0x0 0xf12d0000 0x0 0x1000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_cfi_cframe_0";
  };
  CIPS_0_pspmc_0_psv_pmc_cfu_apb_0: CIPS_0_pspmc_0_psv_pmc_cfu_apb_0@f12b0000 {
   compatible = "xlnx,psv-pmc-cfu-apb-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_cfu_apb";
   reg = <0x0 0xf12b0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_cfu_apb_0";
  };
  CIPS_0_pspmc_0_psv_pmc_efuse_cache: CIPS_0_pspmc_0_psv_pmc_efuse_cache@f1250000 {
   compatible = "xlnx,psv-pmc-efuse-cache-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_efuse_cache";
   reg = <0x0 0xf1250000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_efuse_cache";
  };
  CIPS_0_pspmc_0_psv_pmc_efuse_ctrl: CIPS_0_pspmc_0_psv_pmc_efuse_ctrl@f1240000 {
   compatible = "xlnx,psv-pmc-efuse-ctrl-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_efuse_ctrl";
   reg = <0x0 0xf1240000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_efuse_ctrl";
  };
  CIPS_0_pspmc_0_psv_pmc_global_0: CIPS_0_pspmc_0_psv_pmc_global_0@f1110000 {
   compatible = "xlnx,psv-pmc-global-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_global";
   reg = <0x0 0xf1110000 0x0 0x50000>;
   xlnx,npi-scan = <0>;
   xlnx,event-log = <0>;
   xlnx,cram-scan = <0>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_global_0";
  };
  CIPS_0_pspmc_0_psv_pmc_ppu1_mdm_0: CIPS_0_pspmc_0_psv_pmc_ppu1_mdm_0@f0310000 {
   compatible = "xlnx,psv-pmc-ppu1-mdm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_ppu1_mdm";
   reg = <0x0 0xf0310000 0x0 0x8000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_ppu1_mdm_0";
  };
  CIPS_0_pspmc_0_psv_pmc_ram: CIPS_0_pspmc_0_psv_pmc_ram@f2000000 {
   compatible = "xlnx,psv-pmc-ram-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_ram";
   reg = <0x0 0xf2000000 0x0 0x20000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_ram";
  };
  CIPS_0_pspmc_0_psv_pmc_ram_data_cntlr: CIPS_0_pspmc_0_psv_pmc_ram_data_cntlr@f0240000 {
   xlnx,edk-special = "BRAM_CTRL";
   xlnx,write-access = <2>;
   compatible = "xlnx,ram-data-cntlr-1.0";
   xlnx,ecc-onoff-register = <1>;
   xlnx,ecc-onoff-reset-value = <1>;
   xlnx,s-axi-ctrl-protocol = "AXI4LITE";
   xlnx,mask = <0xffffffff 0xffffe000>;
   xlnx,mask1 = <0xffffffff 0xffffe000>;
   xlnx,s-axi-ctrl-aclk-freq-hz = <100000000>;
   xlnx,mask2 = <0x800000>;
   xlnx,fault-inject = <1>;
   xlnx,mask3 = <0x800000>;
   xlnx,ip-name = "ram_data_cntlr";
   xlnx,num-lmb = <2>;
   reg = <0x0 0xf0240000 0x0 0x20000>;
   xlnx,s-axi-ctrl-addr-width = <32>;
   xlnx,ecc-status-registers = <1>;
   xlnx,ce-counter-width = <16>;
   xlnx,ecc = <1>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,lmb-dwidth = <32>;
   xlnx,interconnect = <2>;
   xlnx,ce-failing-registers = <1>;
   xlnx,ue-failing-registers = <1>;
   status = "okay";
   xlnx,s-axi-ctrl-data-width = <32>;
   xlnx,bram-awidth = <32>;
   xlnx,lmb-awidth = <32>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_ram_data_cntlr";
  };
  CIPS_0_pspmc_0_psv_pmc_ram_instr_cntlr: CIPS_0_pspmc_0_psv_pmc_ram_instr_cntlr@f0200000 {
   xlnx,edk-special = "BRAM_CTRL";
   xlnx,write-access = <2>;
   compatible = "xlnx,ram-instr-cntlr-1.0";
   xlnx,ecc-onoff-register = <1>;
   xlnx,ecc-onoff-reset-value = <1>;
   xlnx,s-axi-ctrl-protocol = "AXI4LITE";
   xlnx,mask = <0xfffe0000>;
   xlnx,mask1 = <0xfffe0000>;
   xlnx,s-axi-ctrl-aclk-freq-hz = <100000000>;
   xlnx,mask2 = <0x800000>;
   xlnx,fault-inject = <1>;
   xlnx,mask3 = <0x800000>;
   xlnx,ip-name = "ram_instr_cntlr";
   xlnx,num-lmb = <2>;
   reg = <0x0 0xf0200000 0x0 0x40000>;
   xlnx,s-axi-ctrl-addr-width = <32>;
   xlnx,ecc-status-registers = <1>;
   xlnx,ce-counter-width = <16>;
   xlnx,ecc = <1>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,lmb-dwidth = <32>;
   xlnx,interconnect = <2>;
   xlnx,ce-failing-registers = <1>;
   xlnx,ue-failing-registers = <1>;
   status = "okay";
   xlnx,s-axi-ctrl-data-width = <32>;
   xlnx,bram-awidth = <32>;
   xlnx,lmb-awidth = <32>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_ram_instr_cntlr";
  };
  CIPS_0_pspmc_0_psv_pmc_ram_npi: CIPS_0_pspmc_0_psv_pmc_ram_npi@f6000000 {
   compatible = "xlnx,psv-pmc-ram-npi-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_ram_npi";
   reg = <0x0 0xf6000000 0x0 0x2000000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_ram_npi";
  };
  CIPS_0_pspmc_0_psv_pmc_rsa: CIPS_0_pspmc_0_psv_pmc_rsa@f1200000 {
   compatible = "xlnx,psv-pmc-rsa-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_rsa";
   reg = <0x0 0xf1200000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_rsa";
  };
  CIPS_0_pspmc_0_psv_pmc_sha: CIPS_0_pspmc_0_psv_pmc_sha@f1210000 {
   compatible = "xlnx,psv-pmc-sha-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_sha";
   reg = <0x0 0xf1210000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_sha";
  };
  CIPS_0_pspmc_0_psv_pmc_slave_boot: CIPS_0_pspmc_0_psv_pmc_slave_boot@f1220000 {
   xlnx,device-id = <0>;
   compatible = "xlnx,psv-pmc-slave-boot-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_slave_boot";
   reg = <0x0 0xf1220000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_slave_boot";
  };
  CIPS_0_pspmc_0_psv_pmc_slave_boot_stream: CIPS_0_pspmc_0_psv_pmc_slave_boot_stream@f2100000 {
   xlnx,device-id = <0>;
   compatible = "xlnx,psv-pmc-slave-boot-stream-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_slave_boot_stream";
   reg = <0x0 0xf2100000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_slave_boot_stream";
  };
  CIPS_0_pspmc_0_psv_pmc_tmr_inject_0: CIPS_0_pspmc_0_psv_pmc_tmr_inject_0@f0083000 {
   compatible = "xlnx,tmr-inject-1.0";
   xlnx,cpu-id = <1>;
   xlnx,edk-special = "tmr_inject";
   xlnx,mask = <0x84000>;
   xlnx,ip-name = "tmr_inject";
   reg = <0x0 0xf0083000 0x0 0x1000>;
   xlnx,magic = <0x27>;
   xlnx,lmb-dwidth = <32>;
   xlnx,edk-iptype = "PROCESSOR";
   status = "okay";
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_tmr_inject_0";
   xlnx,lmb-awidth = <32>;
  };
  CIPS_0_pspmc_0_psv_pmc_tmr_manager_0: CIPS_0_pspmc_0_psv_pmc_tmr_manager_0@f0283000 {
   xlnx,edk-special = "BRAM_CTRL";
   xlnx,use-debug-disable = <0>;
   xlnx,sem-interface-type = <1>;
   compatible = "xlnx,tmr-manager-1.0";
   xlnx,magic1 = <0x0>;
   xlnx,tmr = <1>;
   xlnx,magic2 = <0x0>;
   xlnx,brk-delay-rst-value = <0x0>;
   xlnx,mask = <0x83000>;
   xlnx,sem-heartbeat-watchdog-width = <10>;
   xlnx,watchdog-width = <30>;
   xlnx,use-tmr-disable = <0>;
   xlnx,ue-width = <3>;
   xlnx,ip-name = "tmr_manager";
   xlnx,async-ff = <2>;
   xlnx,ue-is-fatal = <0>;
   xlnx,sem-heartbeat-watchdog = <0>;
   reg = <0x0 0xf0283000 0x0 0x1000>;
   xlnx,brk-delay-width = <0>;
   xlnx,watchdog = <0>;
   xlnx,sem-interface = <0>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,mask-rst-value = <0xffffffff 0xffffffff>;
   xlnx,comparators-mask = <0>;
   xlnx,lmb-dwidth = <32>;
   xlnx,test-comparator = <0>;
   xlnx,strict-miscompare = <0>;
   status = "okay";
   xlnx,no-of-comparators = <1>;
   xlnx,sem-async = <0>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_tmr_manager_0";
   xlnx,lmb-awidth = <32>;
  };
  CIPS_0_pspmc_0_psv_pmc_trng: CIPS_0_pspmc_0_psv_pmc_trng@f1230000 {
   xlnx,device-id = <0>;
   compatible = "xlnx,psv-pmc-trng-1.0";
   status = "okay";
   xlnx,ip-name = "psv_pmc_trng";
   reg = <0x0 0xf1230000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_pmc_trng";
  };
  CIPS_0_pspmc_0_psv_psm_global_reg: CIPS_0_pspmc_0_psv_psm_global_reg@ffc90000 {
   compatible = "xlnx,psv-psm-global-reg-1.0";
   status = "okay";
   xlnx,ip-name = "psv_psm_global_reg";
   reg = <0x0 0xffc90000 0x0 0xf000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_psm_global_reg";
  };
  CIPS_0_pspmc_0_psv_psm_iomodule_0: CIPS_0_pspmc_0_psv_psm_iomodule_0@ffc80000 {
   xlnx,gpo4-size = <32>;
   xlnx,tmr = <0>;
   xlnx,pit1-readable = <1>;
   xlnx,mask = <0xffff8000>;
   xlnx,pit-size = < 32 32 32 32 >;
   xlnx,pit2-prescaler = <0>;
   xlnx,gpi3-interrupt = <0>;
   xlnx,intc-level-edge = <0x7fff>;
   xlnx,intc-positive = <0xffff>;
   xlnx,ip-name = "iomodule";
   xlnx,gpo1-size = <3>;
   xlnx,max-intr-size = <32>;
   xlnx,pit3-size = <32>;
   xlnx,fit3-interrupt = <0>;
   reg = <0x0 0xffc80000 0x0 0x8000>;
   xlnx,fit1-no-clocks = <6216>;
   xlnx,gpi2-size = <32>;
   xlnx,pit2-readable = <1>;
   xlnx,intc-irq-connection = <0>;
   xlnx,uart-tx-interrupt = <1>;
   xlnx,use-config-reset = <0>;
   xlnx,pit2-interrupt = <1>;
   xlnx,intc-base-vectors = <0xffc00000>;
   compatible = "xlnx,iomodule-1.0" , "xlnx,iomodule-3.1";
   xlnx,gpo4-init = <0x0>;
   xlnx,pit3-readable = <1>;
   xlnx,pit3-prescaler = <9>;
   xlnx,gpi4-interrupt = <0>;
   xlnx,gpo1-init = <0x0>;
   xlnx,use-io-bus = <0>;
   xlnx,use-gpo1 = <1>;
   xlnx,uart-baudrate = <115200>;
   xlnx,fit4-interrupt = <0>;
   xlnx,gpo3-size = <32>;
   xlnx,use-gpo2 = <0>;
   xlnx,uart-data-bits = <8>;
   xlnx,pit-prescaler = < 9 0 9 0 >;
   xlnx,gpio1-board-interface = "Custom";
   xlnx,use-gpo3 = <0>;
   xlnx,fit2-no-clocks = <6216>;
   xlnx,options = <1>;
   xlnx,gpio2-board-interface = "Custom";
   xlnx,use-gpo4 = <0>;
   xlnx,gpi4-size = <32>;
   xlnx,gpio3-board-interface = "Custom";
   xlnx,uart-rx-interrupt = <1>;
   xlnx,uart-error-interrupt = <1>;
   xlnx,gpio4-board-interface = "Custom";
   xlnx,pit4-readable = <1>;
   status = "okay";
   xlnx,intc-use-irq-out = <0>;
   xlnx,clock-freq = <100000000>;
   xlnx,gpo-init = < 0 0 0 0 >;
   xlnx,use-board-flow;
   xlnx,pit2-size = <32>;
   xlnx,intc-intr-size = <16>;
   xlnx,intc-use-ext-intr = <1>;
   xlnx,name = "CIPS_0_pspmc_0_psv_psm_iomodule_0";
   xlnx,gpi1-size = <32>;
   xlnx,edk-special = "INTR_CTRL";
   xlnx,pit3-interrupt = <1>;
   xlnx,intc-has-fast = <0>;
   xlnx,pit-used = < 1 1 1 1 >;
   xlnx,use-gpi1 = <0>;
   xlnx,gpi1-interrupt = <0>;
   xlnx,use-gpi2 = <0>;
   xlnx,use-gpi3 = <0>;
   xlnx,use-gpi4 = <0>;
   xlnx,fit1-interrupt = <0>;
   xlnx,pit4-prescaler = <0>;
   xlnx,gpo3-init = <0x0>;
   xlnx,intc-addr-width = <32>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,fit3-no-clocks = <6216>;
   xlnx,use-uart-rx = <1>;
   xlnx,instance = "iomodule_0";
   xlnx,pit-mask = <0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF>;
   xlnx,uart-prog-baudrate = <1>;
   xlnx,use-pit1 = <1>;
   xlnx,gpo2-size = <32>;
   xlnx,use-pit2 = <1>;
   xlnx,pit4-size = <32>;
   xlnx,pit-readable = < 1 1 1 1 >;
   xlnx,use-pit3 = <1>;
   xlnx,use-pit4 = <1>;
   xlnx,pit4-interrupt = <1>;
   xlnx,gpi3-size = <32>;
   xlnx,intc-async-intr = <0xffff>;
   xlnx,pit1-prescaler = <9>;
   xlnx,avoid-primitives = <0>;
   xlnx,gpi2-interrupt = <0>;
   xlnx,use-tmr-disable = <0>;
   xlnx,use-fit1 = <0>;
   xlnx,pit1-size = <32>;
   xlnx,intc-num-sync-ff = <2>;
   xlnx,uart-board-interface = "rs232_uart";
   xlnx,use-fit2 = <0>;
   xlnx,fit2-interrupt = <0>;
   xlnx,use-fit3 = <0>;
   xlnx,use-fit4 = <0>;
   xlnx,uart-use-parity = <0>;
   xlnx,lmb-dwidth = <32>;
   xlnx,fit4-no-clocks = <6216>;
   xlnx,uart-odd-parity = <0>;
   xlnx,freq = <100000000>;
   xlnx,use-uart-tx = <1>;
   xlnx,pit1-interrupt = <1>;
   xlnx,gpo2-init = <0x0>;
   xlnx,io-mask = <0xfffe0000>;
   xlnx,lmb-awidth = <32>;
  };
  CIPS_0_pspmc_0_psv_psm_ram_data_cntlr: CIPS_0_pspmc_0_psv_psm_ram_data_cntlr@ffc20000 {
   xlnx,edk-special = "BRAM_CTRL";
   xlnx,write-access = <2>;
   compatible = "xlnx,PSM-PPU-1.0";
   xlnx,ecc-onoff-register = <1>;
   xlnx,ecc-onoff-reset-value = <1>;
   xlnx,s-axi-ctrl-protocol = "AXI4LITE";
   xlnx,mask = <0xffffffff 0xffffe000>;
   xlnx,mask1 = <0xffffffff 0xffffe000>;
   xlnx,s-axi-ctrl-aclk-freq-hz = <100000000>;
   xlnx,mask2 = <0x800000>;
   xlnx,fault-inject = <1>;
   xlnx,mask3 = <0x800000>;
   xlnx,ip-name = "PSM_PPU";
   xlnx,num-lmb = <2>;
   reg = <0x0 0xffc20000 0x0 0x20000>;
   xlnx,s-axi-ctrl-addr-width = <32>;
   xlnx,ecc-status-registers = <1>;
   xlnx,ce-counter-width = <16>;
   xlnx,ecc = <1>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,lmb-dwidth = <32>;
   xlnx,interconnect = <2>;
   xlnx,ce-failing-registers = <1>;
   xlnx,ue-failing-registers = <1>;
   status = "okay";
   xlnx,s-axi-ctrl-data-width = <32>;
   xlnx,bram-awidth = <32>;
   xlnx,lmb-awidth = <32>;
   xlnx,name = "CIPS_0_pspmc_0_psv_psm_ram_data_cntlr";
  };
  CIPS_0_pspmc_0_psv_psm_ram_instr_cntlr: CIPS_0_pspmc_0_psv_psm_ram_instr_cntlr@ffc00000 {
   xlnx,edk-special = "BRAM_CTRL";
   xlnx,write-access = <2>;
   compatible = "xlnx,ram-instr-cntlr-1.0";
   xlnx,ecc-onoff-register = <1>;
   xlnx,ecc-onoff-reset-value = <1>;
   xlnx,s-axi-ctrl-protocol = "AXI4LITE";
   xlnx,mask = <0xffffffff 0xfffe0000>;
   xlnx,mask1 = <0xffffffff 0xfffe0000>;
   xlnx,s-axi-ctrl-aclk-freq-hz = <100000000>;
   xlnx,mask2 = <0x800000>;
   xlnx,fault-inject = <1>;
   xlnx,mask3 = <0x800000>;
   xlnx,ip-name = "ram_instr_cntlr";
   xlnx,num-lmb = <2>;
   reg = <0x0 0xffc00000 0x0 0x20000>;
   xlnx,s-axi-ctrl-addr-width = <32>;
   xlnx,ecc-status-registers = <1>;
   xlnx,ce-counter-width = <16>;
   xlnx,ecc = <1>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,lmb-dwidth = <32>;
   xlnx,interconnect = <2>;
   xlnx,ce-failing-registers = <1>;
   xlnx,ue-failing-registers = <1>;
   status = "okay";
   xlnx,s-axi-ctrl-data-width = <32>;
   xlnx,bram-awidth = <32>;
   xlnx,lmb-awidth = <32>;
   xlnx,name = "CIPS_0_pspmc_0_psv_psm_ram_instr_cntlr";
  };
  CIPS_0_pspmc_0_psv_psm_tmr_inject_0: CIPS_0_pspmc_0_psv_psm_tmr_inject_0@ffcd0000 {
   compatible = "xlnx,tmr-inject-1.0";
   xlnx,cpu-id = <1>;
   xlnx,edk-special = "tmr_inject";
   xlnx,mask = <0x50000>;
   xlnx,ip-name = "tmr_inject";
   reg = <0x0 0xffcd0000 0x0 0x10000>;
   xlnx,magic = <0x27>;
   xlnx,lmb-dwidth = <32>;
   xlnx,edk-iptype = "PROCESSOR";
   status = "okay";
   xlnx,name = "CIPS_0_pspmc_0_psv_psm_tmr_inject_0";
   xlnx,lmb-awidth = <32>;
  };
  CIPS_0_pspmc_0_psv_psm_tmr_manager_0: CIPS_0_pspmc_0_psv_psm_tmr_manager_0@ffcc0000 {
   xlnx,edk-special = "BRAM_CTRL";
   xlnx,use-debug-disable = <0>;
   xlnx,sem-interface-type = <1>;
   compatible = "xlnx,tmr-manager-1.0";
   xlnx,magic1 = <0x0>;
   xlnx,tmr = <1>;
   xlnx,magic2 = <0x0>;
   xlnx,brk-delay-rst-value = <0x0>;
   xlnx,mask = <0x50000>;
   xlnx,sem-heartbeat-watchdog-width = <10>;
   xlnx,watchdog-width = <30>;
   xlnx,use-tmr-disable = <0>;
   xlnx,ue-width = <3>;
   xlnx,ip-name = "tmr_manager";
   xlnx,async-ff = <2>;
   xlnx,ue-is-fatal = <0>;
   xlnx,sem-heartbeat-watchdog = <0>;
   reg = <0x0 0xffcc0000 0x0 0x10000>;
   xlnx,brk-delay-width = <0>;
   xlnx,watchdog = <0>;
   xlnx,sem-interface = <0>;
   xlnx,edk-iptype = "PERIPHERAL";
   xlnx,mask-rst-value = <0xffffffff 0xffffffff>;
   xlnx,comparators-mask = <0>;
   xlnx,lmb-dwidth = <32>;
   xlnx,test-comparator = <0>;
   xlnx,strict-miscompare = <0>;
   status = "okay";
   xlnx,no-of-comparators = <1>;
   xlnx,sem-async = <0>;
   xlnx,name = "CIPS_0_pspmc_0_psv_psm_tmr_manager_0";
   xlnx,lmb-awidth = <32>;
  };
  CIPS_0_pspmc_0_psv_r5_0_atcm: CIPS_0_pspmc_0_psv_r5_0_atcm@0 {
   xlnx,power-domain = <0x1831800b>;
   compatible = "xlnx,psv-r5-tcm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_tcm";
   xlnx,bank-size = <0x10000>;
   reg = <0x0 0x0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_0_atcm";
  };
  CIPS_0_pspmc_0_psv_r5_0_atcm_lockstep: CIPS_0_pspmc_0_psv_r5_0_atcm_lockstep@ffe10000 {
   compatible = "xlnx,psv-r5-0-atcm-lockstep-1.0" , "mmio-sram";
   status = "okay";
   power-domains = <&versal_firmware 0x1831800b>;
   xlnx,ip-name = "psv_r5_0_atcm_lockstep";
   xlnx,is-hierarchy;
   reg = <0x0 0xffe10000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_0_atcm_lockstep";
  };
  CIPS_0_pspmc_0_psv_r5_0_btcm: CIPS_0_pspmc_0_psv_r5_0_btcm@20000 {
   xlnx,power-domain = <0x1831800c>;
   compatible = "xlnx,psv-r5-tcm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_tcm";
   xlnx,bank-size = <0x10000>;
   reg = <0x0 0x20000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_0_btcm";
  };
  CIPS_0_pspmc_0_psv_r5_0_btcm_lockstep: CIPS_0_pspmc_0_psv_r5_0_btcm_lockstep@ffe30000 {
   compatible = "xlnx,psv-r5-0-btcm-lockstep-1.0" , "mmio-sram";
   status = "okay";
   power-domains = <&versal_firmware 0x1831800c>;
   xlnx,ip-name = "psv_r5_0_btcm_lockstep";
   xlnx,is-hierarchy;
   reg = <0x0 0xffe30000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_0_btcm_lockstep";
  };
  CIPS_0_pspmc_0_psv_r5_0_data_cache: CIPS_0_pspmc_0_psv_r5_0_data_cache@ffe50000 {
   compatible = "xlnx,psv-r5-0-data-cache-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_0_data_cache";
   reg = <0x0 0xffe50000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_0_data_cache";
  };
  CIPS_0_pspmc_0_psv_r5_0_instruction_cache: CIPS_0_pspmc_0_psv_r5_0_instruction_cache@ffe40000 {
   compatible = "xlnx,psv-r5-0-instruction-cache-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_0_instruction_cache";
   reg = <0x0 0xffe40000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_0_instruction_cache";
  };
  CIPS_0_pspmc_0_psv_r5_1_atcm: CIPS_0_pspmc_0_psv_r5_1_atcm@0 {
   xlnx,power-domain = <0x1831800d>;
   compatible = "xlnx,psv-r5-tcm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_tcm";
   xlnx,bank-size = <0x10000>;
   reg = <0x0 0x0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_1_atcm";
  };
  CIPS_0_pspmc_0_psv_r5_1_btcm: CIPS_0_pspmc_0_psv_r5_1_btcm@20000 {
   xlnx,power-domain = <0x1831800e>;
   compatible = "xlnx,psv-r5-tcm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_tcm";
   xlnx,bank-size = <0x10000>;
   reg = <0x0 0x20000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_1_btcm";
  };
  CIPS_0_pspmc_0_psv_r5_1_data_cache: CIPS_0_pspmc_0_psv_r5_1_data_cache@ffed0000 {
   compatible = "xlnx,psv-r5-1-data-cache-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_1_data_cache";
   reg = <0x0 0xffed0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_1_data_cache";
  };
  CIPS_0_pspmc_0_psv_r5_1_instruction_cache: CIPS_0_pspmc_0_psv_r5_1_instruction_cache@ffec0000 {
   compatible = "xlnx,psv-r5-1-instruction-cache-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_1_instruction_cache";
   reg = <0x0 0xffec0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_1_instruction_cache";
  };
  CIPS_0_pspmc_0_psv_r5_tcm_ram_0: CIPS_0_pspmc_0_psv_r5_tcm_ram_0@0 {
   compatible = "xlnx,psv-r5-tcm-1.0";
   status = "okay";
   xlnx,ip-name = "psv_r5_tcm";
   reg = <0x0 0x00000 0x0 0x40000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_r5_tcm_ram_0";
  };
  CIPS_0_pspmc_0_psv_rpu_0: CIPS_0_pspmc_0_psv_rpu_0@ff9a0000 {
   compatible = "xlnx,psv-rpu-1.0";
   status = "okay";
   xlnx,ip-name = "psv_rpu";
   reg = <0x0 0xff9a0000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_rpu_0";
  };
  CIPS_0_pspmc_0_psv_scntr_0: CIPS_0_pspmc_0_psv_scntr_0@ff130000 {
   compatible = "xlnx,psv-scntr-1.0";
   status = "okay";
   xlnx,ip-name = "psv_scntr";
   reg = <0x0 0xff130000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_scntr_0";
  };
  CIPS_0_pspmc_0_psv_scntrs_0: CIPS_0_pspmc_0_psv_scntrs_0@ff140000 {
   compatible = "xlnx,psv-scntrs-1.0";
   status = "okay";
   xlnx,ip-name = "psv_scntrs";
   reg = <0x0 0xff140000 0x0 0x10000>;
   xlnx,name = "CIPS_0_pspmc_0_psv_scntrs_0";
  };
 };
 &psv_pmc_0 {
  xlnx,d-axi = <1>;
  xlnx,addr-tag-bits = <0>;
  xlnx,m-axi-dc-thread-id-width = <1>;
  xlnx,m0-axis-protocol = "GENERIC";
  xlnx,dcache-force-tag-lutram = <0>;
  xlnx,interrupt-is-edge = <0>;
  xlnx,use-mmu = <0>;
  xlnx,m-axi-dp-exclusive-access = <0>;
  xlnx,use-reorder-instr = <1>;
  xlnx,m14-axis-protocol = "GENERIC";
  xlnx,use-div = <1>;
  xlnx,dc-axi-mon = <0>;
  xlnx,m-axi-ic-user-signals = <0>;
  xlnx,use-config-reset = <0>;
  xlnx,s14-axis-protocol = "GENERIC";
  xlnx,mmu-zones = <16>;
  xlnx,enable-discrete-ports = <0>;
  xlnx,d-lmb = <1>;
  xlnx,m-axi-dc-exclusive-access = <0>;
  xlnx,debug-interface = <0>;
  xlnx,s9-axis-protocol = "GENERIC";
  xlnx,sco = <0>;
  xlnx,use-ext-brk = <0>;
  xlnx,debug-enabled = <1>;
  xlnx,daddr-size = <32>;
  xlnx,s0-axis-data-width = <32>;
  xlnx,use-extended-fsl-instr = <0>;
  xlnx,m-axi-dc-user-signals = <0>;
  xlnx,reset-msr = <0x0>;
  xlnx,branch-target-cache-size = <0>;
  xlnx,s2-axis-data-width = <32>;
  xlnx,cache-byte-size = <8192>;
  bus-handle = <&amba>;
  xlnx,mmu-tlb-access = <3>;
  xlnx,s4-axis-data-width = <32>;
  xlnx,m-axi-ic-awuser-width = <5>;
  xlnx,s6-axis-data-width = <32>;
  xlnx,s4-axis-protocol = "GENERIC";
  xlnx,s8-axis-data-width = <32>;
  xlnx,edk-special = "microblaze";
  xlnx,use-dcache = <0>;
  xlnx,m-axi-dp-addr-width = <32>;
  xlnx,m-axi-ic-wuser-width = <1>;
  xlnx,i-axi = <0>;
  xlnx,icache-streams = <0>;
  xlnx,m-axi-dc-awuser-width = <5>;
  xlnx,pss-ref-clk-freq = <33333300>;
  xlnx,use-stack-protection = <1>;
  xlnx,m6-axis-protocol = "GENERIC";
  xlnx,num-sync-ff-dbg-clk = <1>;
  xlnx,m-axi-ip-data-width = <32>;
  d-cache-size = <8192>;
  xlnx,use-pcmp-instr = <1>;
  xlnx,area-optimized = <0>;
  xlnx,avoid-primitives = <0>;
  xlnx,m1-axis-protocol = "GENERIC";
  xlnx,i-lmb = <1>;
  xlnx,lockstep-select = <0>;
  xlnx,dcache-data-width = <0>;
  xlnx,icache-force-tag-lutram = <0>;
  xlnx,m15-axis-protocol = "GENERIC";
  xlnx,use-branch-target-cache = <0>;
  xlnx,m-axi-ip-thread-id-width = <1>;
  xlnx,mmu-itlb-size = <2>;
  xlnx,number-of-pc-brk = <2>;
  xlnx,imprecise-exceptions = <0>;
  xlnx,m-axi-ic-buser-width = <1>;
  xlnx,m-axi-ic-addr-width = <32>;
  xlnx,s15-axis-protocol = "GENERIC";
  d-cache-highaddr = <0x3fffffff>;
  xlnx,m10-axis-protocol = "GENERIC";
  xlnx,optimization = <0>;
  xlnx,m-axi-ic-aruser-width = <5>;
  xlnx,d-lmb-mon = <0>;
  xlnx,s10-axis-protocol = "GENERIC";
  xlnx,m-axi-ic-ruser-width = <1>;
  xlnx,s5-axis-protocol = "GENERIC";
  xlnx,fault-tolerant = <1>;
  d-cache-line-size = <16>;
  xlnx,m-axi-dc-aruser-width = <5>;
  xlnx,mmu-privileged-instr = <0>;
  xlnx,m-axi-i-bus-exception = <0>;
  xlnx,reset-msr-eip = <0>;
  xlnx,endianness = <1>;
  xlnx,reset-msr-ice = <0>;
  xlnx,dp-axi-mon = <0>;
  xlnx,s10-axis-data-width = <32>;
  xlnx,s0-axis-protocol = "GENERIC";
  xlnx,s12-axis-data-width = <32>;
  xlnx,m7-axis-protocol = "GENERIC";
  xlnx,s14-axis-data-width = <32>;
  xlnx,m-axi-d-bus-exception = <1>;
  xlnx,reset-msr-bip = <1>;
  xlnx,debug-external-trace = <0>;
  xlnx,addr-size = <32>;
  xlnx,m-axi-ic-user-value = <31>;
  xlnx,m1-axis-data-width = <32>;
  xlnx,debug-event-counters = <5>;
  xlnx,m3-axis-data-width = <32>;
  xlnx,fpu-exception = <0>;
  xlnx,m2-axis-protocol = "GENERIC";
  xlnx,m5-axis-data-width = <32>;
  xlnx,m7-axis-data-width = <32>;
  xlnx,edk-iptype = "PROCESSOR";
  xlnx,debug-latency-counters = <1>;
  xlnx,interconnect = <2>;
  xlnx,m9-axis-data-width = <32>;
  xlnx,edge-is-positive = <1>;
  xlnx,use-icache = <0>;
  xlnx,async-wakeup = <3>;
  xlnx,m10-axis-data-width = <32>;
  xlnx,m12-axis-data-width = <32>;
  xlnx,use-ext-nm-brk = <0>;
  xlnx,m11-axis-protocol = "GENERIC";
  xlnx,m14-axis-data-width = <32>;
  xlnx,icache-always-used = <0>;
  xlnx,ic-axi-mon = <0>;
  xlnx,num-sync-ff-clk-irq = <1>;
  xlnx,freq = <320000000>;
  xlnx,lockstep-master = <0>;
  xlnx,s11-axis-protocol = "GENERIC";
  xlnx,use-msr-instr = <1>;
  xlnx,s6-axis-protocol = "GENERIC";
  xlnx,iaddr-size = <32>;
  xlnx,interrupt-mon = <0>;
  xlnx,m-axi-dc-data-width = <32>;
  xlnx,dynamic-bus-sizing = <0>;
  xlnx,number-of-wr-addr-brk = <1>;
  xlnx,use-interrupt = <1>;
  xlnx,m-axi-ip-addr-width = <32>;
  xlnx,async-interrupt = <1>;
  xlnx,pc-width = <32>;
  xlnx,icache-victims = <0>;
  xlnx,reset-msr-ee = <0>;
  xlnx,s1-axis-protocol = "GENERIC";
  xlnx,m8-axis-protocol = "GENERIC";
  i-cache-baseaddr = <0x0>;
  xlnx,i-lmb-mon = <0>;
  xlnx,dcache-byte-size = <8192>;
  xlnx,m-axi-dp-thread-id-width = <1>;
  xlnx,data-size = <32>;
  xlnx,m-axi-dc-wuser-width = <1>;
  xlnx,fsl-exception = <0>;
  xlnx,m3-axis-protocol = "GENERIC";
  xlnx,s1-axis-data-width = <32>;
  xlnx,dcache-use-writeback = <0>;
  xlnx,div-zero-exception = <1>;
  xlnx,s3-axis-data-width = <32>;
  xlnx,base-vectors = <0xf0240000>;
  xlnx,icache-line-len = <4>;
  xlnx,s5-axis-data-width = <32>;
  xlnx,s7-axis-data-width = <32>;
  xlnx,allow-dcache-wr = <1>;
  xlnx,s9-axis-data-width = <32>;
  xlnx,use-barrel = <1>;
  xlnx,g-use-exceptions = <1>;
  xlnx,dcache-line-len = <4>;
  xlnx,m12-axis-protocol = "GENERIC";
  xlnx,num-sync-ff-clk = <2>;
  i-cache-size = <8192>;
  xlnx,instance = "design_1_microblaze_0_0";
  xlnx,reset-msr-ie = <0>;
  xlnx,s12-axis-protocol = "GENERIC";
  xlnx,dcache-addr-tag = <0>;
  xlnx,m-axi-ic-thread-id-width = <1>;
  xlnx,number-of-rd-addr-brk = <1>;
  xlnx,m-axi-dc-buser-width = <1>;
  xlnx,s7-axis-protocol = "GENERIC";
  xlnx,lockstep-slave = <0>;
  xlnx,debug-profile-size = <0>;
  xlnx,s2-axis-protocol = "GENERIC";
  xlnx,m9-axis-protocol = "GENERIC";
  xlnx,debug-counter-width = <32>;
  xlnx,icache-data-width = <0>;
  xlnx,m-axi-dc-ruser-width = <1>;
  xlnx,reset-msr-dce = <0>;
  xlnx,ip-name = "psv_pmc";
  xlnx,ip-axi-mon = <0>;
  xlnx,m-axi-dp-data-width = <32>;
  xlnx,m4-axis-protocol = "GENERIC";
  xlnx,dcache-always-used = <0>;
  xlnx,ill-opcode-exception = <1>;
  xlnx,trace = <1>;
  xlnx,pvr = <2>;
  xlnx,debug-trace-size = <8192>;
  i-cache-line-size = <16>;
  xlnx,m13-axis-protocol = "GENERIC";
  xlnx,s11-axis-data-width = <32>;
  xlnx,m-axi-dc-addr-width = <32>;
  xlnx,s13-axis-data-width = <32>;
  xlnx,ecc-use-ce-exception = <0>;
  xlnx,opcode-0x0-illegal = <1>;
  xlnx,pvr-user2 = <0x0>;
  xlnx,s15-axis-data-width = <32>;
  xlnx,s13-axis-protocol = "GENERIC";
  xlnx,m0-axis-data-width = <32>;
  i-cache-highaddr = <0x3fffffff>;
  xlnx,s8-axis-protocol = "GENERIC";
  xlnx,m2-axis-data-width = <32>;
  xlnx,num-sync-ff-clk-debug = <2>;
  xlnx,allow-icache-wr = <1>;
  xlnx,m4-axis-data-width = <32>;
  xlnx,g-template-list = <0>;
  xlnx,m6-axis-data-width = <32>;
  xlnx,m-axi-ic-data-width = <32>;
  xlnx,m8-axis-data-width = <32>;
  xlnx,use-hw-mul = <2>;
  xlnx,use-fpu = <0>;
  xlnx,s3-axis-protocol = "GENERIC";
  xlnx,use-non-secure = <0>;
  d-cache-baseaddr = <0x0>;
  xlnx,m11-axis-data-width = <32>;
  xlnx,m13-axis-data-width = <32>;
  xlnx,instr-size = <32>;
  xlnx,m15-axis-data-width = <32>;
  xlnx,mmu-dtlb-size = <4>;
  xlnx,fsl-links = <0>;
  xlnx,m5-axis-protocol = "GENERIC";
  xlnx,dcache-victims = <0>;
  xlnx,m-axi-dc-user-value = <31>;
  xlnx,unaligned-exceptions = <1>;
 };
 &psv_psm_0 {
  xlnx,d-axi = <1>;
  xlnx,addr-tag-bits = <0>;
  xlnx,m-axi-dc-thread-id-width = <1>;
  xlnx,m0-axis-protocol = "GENERIC";
  xlnx,dcache-force-tag-lutram = <0>;
  xlnx,interrupt-is-edge = <0>;
  xlnx,use-mmu = <0>;
  xlnx,m-axi-dp-exclusive-access = <0>;
  xlnx,use-reorder-instr = <1>;
  xlnx,m14-axis-protocol = "GENERIC";
  xlnx,use-div = <1>;
  xlnx,dc-axi-mon = <0>;
  xlnx,m-axi-ic-user-signals = <0>;
  xlnx,use-config-reset = <0>;
  xlnx,s14-axis-protocol = "GENERIC";
  xlnx,mmu-zones = <16>;
  xlnx,enable-discrete-ports = <0>;
  xlnx,d-lmb = <1>;
  xlnx,m-axi-dc-exclusive-access = <0>;
  xlnx,debug-interface = <0>;
  xlnx,s9-axis-protocol = "GENERIC";
  xlnx,sco = <0>;
  xlnx,use-ext-brk = <0>;
  xlnx,debug-enabled = <1>;
  xlnx,daddr-size = <32>;
  xlnx,s0-axis-data-width = <32>;
  xlnx,use-extended-fsl-instr = <0>;
  xlnx,m-axi-dc-user-signals = <0>;
  xlnx,reset-msr = <0x0>;
  xlnx,branch-target-cache-size = <0>;
  xlnx,s2-axis-data-width = <32>;
  bus-handle = <&amba>;
  xlnx,cache-byte-size = <8192>;
  xlnx,mmu-tlb-access = <3>;
  xlnx,s4-axis-data-width = <32>;
  xlnx,m-axi-ic-awuser-width = <5>;
  xlnx,s6-axis-data-width = <32>;
  xlnx,s4-axis-protocol = "GENERIC";
  xlnx,s8-axis-data-width = <32>;
  xlnx,edk-special = "microblaze";
  xlnx,use-dcache = <0>;
  xlnx,m-axi-dp-addr-width = <32>;
  xlnx,m-axi-ic-wuser-width = <1>;
  xlnx,i-axi = <0>;
  xlnx,icache-streams = <0>;
  xlnx,m-axi-dc-awuser-width = <5>;
  xlnx,pss-ref-clk-freq = <33333300>;
  xlnx,use-stack-protection = <1>;
  xlnx,m6-axis-protocol = "GENERIC";
  xlnx,num-sync-ff-dbg-clk = <1>;
  xlnx,m-axi-ip-data-width = <32>;
  d-cache-size = <8192>;
  xlnx,use-pcmp-instr = <1>;
  xlnx,area-optimized = <0>;
  xlnx,avoid-primitives = <0>;
  xlnx,m1-axis-protocol = "GENERIC";
  xlnx,i-lmb = <1>;
  xlnx,lockstep-select = <0>;
  xlnx,dcache-data-width = <0>;
  xlnx,icache-force-tag-lutram = <0>;
  xlnx,m15-axis-protocol = "GENERIC";
  xlnx,use-branch-target-cache = <0>;
  xlnx,m-axi-ip-thread-id-width = <1>;
  xlnx,mmu-itlb-size = <2>;
  xlnx,number-of-pc-brk = <2>;
  xlnx,imprecise-exceptions = <0>;
  xlnx,m-axi-ic-buser-width = <1>;
  xlnx,m-axi-ic-addr-width = <32>;
  xlnx,s15-axis-protocol = "GENERIC";
  d-cache-highaddr = <0x3fffffff>;
  xlnx,m10-axis-protocol = "GENERIC";
  xlnx,optimization = <0>;
  xlnx,m-axi-ic-aruser-width = <5>;
  xlnx,d-lmb-mon = <0>;
  xlnx,s10-axis-protocol = "GENERIC";
  xlnx,m-axi-ic-ruser-width = <1>;
  xlnx,s5-axis-protocol = "GENERIC";
  xlnx,fault-tolerant = <1>;
  d-cache-line-size = <16>;
  xlnx,m-axi-dc-aruser-width = <5>;
  xlnx,mmu-privileged-instr = <0>;
  xlnx,m-axi-i-bus-exception = <0>;
  xlnx,reset-msr-eip = <0>;
  xlnx,endianness = <1>;
  xlnx,reset-msr-ice = <0>;
  xlnx,dp-axi-mon = <0>;
  xlnx,s10-axis-data-width = <32>;
  xlnx,s0-axis-protocol = "GENERIC";
  xlnx,s12-axis-data-width = <32>;
  xlnx,m7-axis-protocol = "GENERIC";
  xlnx,s14-axis-data-width = <32>;
  xlnx,m-axi-d-bus-exception = <1>;
  xlnx,reset-msr-bip = <1>;
  xlnx,debug-external-trace = <0>;
  xlnx,addr-size = <32>;
  xlnx,m-axi-ic-user-value = <31>;
  xlnx,m1-axis-data-width = <32>;
  xlnx,debug-event-counters = <5>;
  xlnx,m3-axis-data-width = <32>;
  xlnx,fpu-exception = <0>;
  xlnx,m2-axis-protocol = "GENERIC";
  xlnx,m5-axis-data-width = <32>;
  xlnx,m7-axis-data-width = <32>;
  xlnx,edk-iptype = "PROCESSOR";
  xlnx,debug-latency-counters = <1>;
  xlnx,interconnect = <2>;
  xlnx,m9-axis-data-width = <32>;
  xlnx,edge-is-positive = <1>;
  xlnx,use-icache = <0>;
  xlnx,async-wakeup = <3>;
  xlnx,m10-axis-data-width = <32>;
  xlnx,m12-axis-data-width = <32>;
  xlnx,use-ext-nm-brk = <0>;
  xlnx,m11-axis-protocol = "GENERIC";
  xlnx,m14-axis-data-width = <32>;
  xlnx,icache-always-used = <0>;
  xlnx,ic-axi-mon = <0>;
  xlnx,num-sync-ff-clk-irq = <1>;
  xlnx,freq = <100000000>;
  xlnx,lockstep-master = <0>;
  xlnx,s11-axis-protocol = "GENERIC";
  xlnx,use-msr-instr = <1>;
  xlnx,s6-axis-protocol = "GENERIC";
  xlnx,iaddr-size = <32>;
  xlnx,interrupt-mon = <0>;
  xlnx,m-axi-dc-data-width = <32>;
  xlnx,dynamic-bus-sizing = <0>;
  xlnx,number-of-wr-addr-brk = <1>;
  xlnx,use-interrupt = <1>;
  xlnx,m-axi-ip-addr-width = <32>;
  xlnx,async-interrupt = <1>;
  xlnx,pc-width = <32>;
  xlnx,icache-victims = <0>;
  xlnx,reset-msr-ee = <0>;
  xlnx,s1-axis-protocol = "GENERIC";
  xlnx,m8-axis-protocol = "GENERIC";
  i-cache-baseaddr = <0x0>;
  xlnx,i-lmb-mon = <0>;
  xlnx,dcache-byte-size = <8192>;
  xlnx,m-axi-dp-thread-id-width = <1>;
  xlnx,data-size = <32>;
  xlnx,m-axi-dc-wuser-width = <1>;
  xlnx,fsl-exception = <0>;
  xlnx,m3-axis-protocol = "GENERIC";
  xlnx,s1-axis-data-width = <32>;
  xlnx,dcache-use-writeback = <0>;
  xlnx,div-zero-exception = <1>;
  xlnx,s3-axis-data-width = <32>;
  xlnx,base-vectors = <0xffc00000>;
  xlnx,icache-line-len = <4>;
  xlnx,s5-axis-data-width = <32>;
  xlnx,s7-axis-data-width = <32>;
  xlnx,allow-dcache-wr = <1>;
  xlnx,s9-axis-data-width = <32>;
  xlnx,use-barrel = <1>;
  xlnx,g-use-exceptions = <1>;
  xlnx,dcache-line-len = <4>;
  xlnx,m12-axis-protocol = "GENERIC";
  xlnx,num-sync-ff-clk = <2>;
  i-cache-size = <8192>;
  xlnx,instance = "design_1_microblaze_0_0";
  xlnx,reset-msr-ie = <0>;
  xlnx,s12-axis-protocol = "GENERIC";
  xlnx,dcache-addr-tag = <0>;
  xlnx,m-axi-ic-thread-id-width = <1>;
  xlnx,number-of-rd-addr-brk = <1>;
  xlnx,m-axi-dc-buser-width = <1>;
  xlnx,s7-axis-protocol = "GENERIC";
  xlnx,lockstep-slave = <0>;
  xlnx,debug-profile-size = <0>;
  xlnx,s2-axis-protocol = "GENERIC";
  xlnx,m9-axis-protocol = "GENERIC";
  xlnx,debug-counter-width = <32>;
  xlnx,icache-data-width = <0>;
  xlnx,m-axi-dc-ruser-width = <1>;
  xlnx,reset-msr-dce = <0>;
  xlnx,ip-name = "psv_psm";
  xlnx,ip-axi-mon = <0>;
  xlnx,m-axi-dp-data-width = <32>;
  xlnx,m4-axis-protocol = "GENERIC";
  xlnx,dcache-always-used = <0>;
  xlnx,ill-opcode-exception = <1>;
  xlnx,trace = <1>;
  xlnx,pvr = <2>;
  xlnx,debug-trace-size = <8192>;
  i-cache-line-size = <16>;
  xlnx,m13-axis-protocol = "GENERIC";
  xlnx,s11-axis-data-width = <32>;
  xlnx,m-axi-dc-addr-width = <32>;
  xlnx,s13-axis-data-width = <32>;
  xlnx,ecc-use-ce-exception = <0>;
  xlnx,opcode-0x0-illegal = <1>;
  xlnx,pvr-user2 = <0x0>;
  xlnx,s15-axis-data-width = <32>;
  xlnx,s13-axis-protocol = "GENERIC";
  xlnx,m0-axis-data-width = <32>;
  i-cache-highaddr = <0x3fffffff>;
  xlnx,s8-axis-protocol = "GENERIC";
  xlnx,m2-axis-data-width = <32>;
  xlnx,num-sync-ff-clk-debug = <2>;
  xlnx,allow-icache-wr = <1>;
  xlnx,m4-axis-data-width = <32>;
  xlnx,g-template-list = <0>;
  xlnx,m6-axis-data-width = <32>;
  xlnx,m-axi-ic-data-width = <32>;
  xlnx,m8-axis-data-width = <32>;
  xlnx,use-hw-mul = <2>;
  xlnx,use-fpu = <0>;
  xlnx,s3-axis-protocol = "GENERIC";
  xlnx,use-non-secure = <0>;
  d-cache-baseaddr = <0x0>;
  xlnx,m11-axis-data-width = <32>;
  xlnx,m13-axis-data-width = <32>;
  xlnx,instr-size = <32>;
  xlnx,m15-axis-data-width = <32>;
  xlnx,mmu-dtlb-size = <4>;
  xlnx,fsl-links = <0>;
  xlnx,m5-axis-protocol = "GENERIC";
  xlnx,dcache-victims = <0>;
  xlnx,m-axi-dc-user-value = <31>;
  xlnx,unaligned-exceptions = <1>;
 };
 &lpd_dma_chan0 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_adma";
  xlnx,dma-mode = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_adma_0";
 };
 &lpd_dma_chan1 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_adma";
  xlnx,dma-mode = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_adma_1";
 };
 &lpd_dma_chan2 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_adma";
  xlnx,dma-mode = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_adma_2";
 };
 &lpd_dma_chan3 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_adma";
  xlnx,dma-mode = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_adma_3";
 };
 &lpd_dma_chan4 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_adma";
  xlnx,dma-mode = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_adma_4";
 };
 &lpd_dma_chan5 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_adma";
  xlnx,dma-mode = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_adma_5";
 };
 &lpd_dma_chan6 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_adma";
  xlnx,dma-mode = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_adma_6";
 };
 &lpd_dma_chan7 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_adma";
  xlnx,dma-mode = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_adma_7";
 };
 &can1 {
  xlnx,can-rx-dpth = <64>;
  status = "okay";
  xlnx,num-of-rx-mb-buf = <48>;
  xlnx,can-clk-freq-hz = <159999847>;
  xlnx,ip-name = "psv_canfd";
  xlnx,rx-mode = <0>;
  xlnx,can-tx-dpth = <32>;
  xlnx,num-of-tx-buf = <32>;
  xlnx,can-board-interface = "custom";
  xlnx,name = "CIPS_0_pspmc_0_psv_canfd_1";
 };
 &coresight {
  status = "okay";
  xlnx,ip-name = "psv_coresight";
  xlnx,name = "CIPS_0_pspmc_0_psv_coresight_0";
 };
 &gem0 {
  xlnx,has-mdio = <1>;
  xlnx,is-cache-coherent = <0>;
  xlnx,gem-board-interface = "custom";
  phy-mode = "rgmii-id";
  xlnx,enet-slcr-1000mbps-div0 = <2>;
  xlnx,enet-slcr-10mbps-div0 = <100>;
  xlnx,enet-tsu-clk-freq-hz = <249999756>;
  xlnx,ip-name = "psv_ethernet";
  xlnx,eth-mode = <1>;
  xlnx,enet-clk-freq-hz = <124999878>;
  xlnx,enet-slcr-100mbps-div0 = <10>;
  status = "okay";
  xlnx,name = "CIPS_0_pspmc_0_psv_ethernet_0";
 };
 &gem1 {
  xlnx,has-mdio = <0>;
  xlnx,is-cache-coherent = <0>;
  xlnx,gem-board-interface = "custom";
  phy-mode = "rgmii-id";
  xlnx,enet-slcr-1000mbps-div0 = <2>;
  xlnx,enet-slcr-10mbps-div0 = <100>;
  xlnx,enet-tsu-clk-freq-hz = <249999756>;
  xlnx,ip-name = "psv_ethernet";
  xlnx,eth-mode = <1>;
  xlnx,enet-clk-freq-hz = <124999878>;
  xlnx,enet-slcr-100mbps-div0 = <10>;
  status = "okay";
  xlnx,name = "CIPS_0_pspmc_0_psv_ethernet_1";
 };
 &cci {
  status = "okay";
  xlnx,ip-name = "psv_fpd_maincci";
  xlnx,name = "CIPS_0_pspmc_0_psv_fpd_maincci_0";
 };
 &fpd_xmpu {
  status = "okay";
  xlnx,ip-name = "psv_fpd_slave_xmpu";
  xlnx,name = "CIPS_0_pspmc_0_psv_fpd_slave_xmpu_0";
 };
 &smmu {
  status = "okay";
  xlnx,ip-name = "psv_fpd_smmutcu";
  xlnx,name = "CIPS_0_pspmc_0_psv_fpd_smmutcu_0";
 };
 &i2c0 {
  status = "okay";
  xlnx,clock-freq = <99999908>;
  xlnx,i2c-clk-freq-hz = <99999908>;
  xlnx,ip-name = "psv_i2c";
  xlnx,iic-board-interface = "custom";
  xlnx,name = "CIPS_0_pspmc_0_psv_i2c_0";
 };
 &i2c1 {
  status = "okay";
  xlnx,clock-freq = <99999908>;
  xlnx,i2c-clk-freq-hz = <99999908>;
  xlnx,ip-name = "psv_i2c";
  xlnx,iic-board-interface = "custom";
  xlnx,name = "CIPS_0_pspmc_0_psv_i2c_1";
 };
 &ipi0 {
  xlnx,cpu-name = "A72";
  xlnx,buffer-base = <0xff3f0400>;
  status = "okay";
  xlnx,buffer-index = <0x2>;
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <62>;
  xlnx,bit-position = <2>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_0";
  CIPS_0_pspmc_0_psv_ipi_0_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-rsp-msg-buf = <0xff3f04a0>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
   xlnx,ipi-req-msg-buf = <0xff3f0480>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-rsp-msg-buf = <0xff3f04e0>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
   xlnx,ipi-req-msg-buf = <0xff3f04c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0520>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
   xlnx,ipi-req-msg-buf = <0xff3f0500>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0560>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
   xlnx,ipi-req-msg-buf = <0xff3f0540>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-rsp-msg-buf = <0xff3f05a0>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
   xlnx,ipi-req-msg-buf = <0xff3f0580>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-rsp-msg-buf = <0xff3f05e0>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
   xlnx,ipi-req-msg-buf = <0xff3f05c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0460>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
   xlnx,ipi-req-msg-buf = <0xff3f0440>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_0_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0420>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
   xlnx,ipi-req-msg-buf = <0xff3f0400>;
  };
 };
 &ipi1 {
  xlnx,cpu-name = "R5_0";
  xlnx,buffer-base = <0xff3f0600>;
  status = "okay";
  xlnx,buffer-index = <0x3>;
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <63>;
  xlnx,bit-position = <3>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_1";
  CIPS_0_pspmc_0_psv_ipi_1_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-rsp-msg-buf = <0xff3f06a0>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
   xlnx,ipi-req-msg-buf = <0xff3f0680>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-rsp-msg-buf = <0xff3f06e0>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
   xlnx,ipi-req-msg-buf = <0xff3f06c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0720>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
   xlnx,ipi-req-msg-buf = <0xff3f0700>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0760>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
   xlnx,ipi-req-msg-buf = <0xff3f0740>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-rsp-msg-buf = <0xff3f07a0>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
   xlnx,ipi-req-msg-buf = <0xff3f0780>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-rsp-msg-buf = <0xff3f07e0>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
   xlnx,ipi-req-msg-buf = <0xff3f07c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0660>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
   xlnx,ipi-req-msg-buf = <0xff3f0640>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_1_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0620>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
   xlnx,ipi-req-msg-buf = <0xff3f0600>;
  };
 };
 &ipi2 {
  xlnx,cpu-name = "R5_1";
  xlnx,buffer-base = <0xff3f0800>;
  status = "okay";
  xlnx,buffer-index = <0x4>;
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <64>;
  xlnx,bit-position = <4>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_2";
  CIPS_0_pspmc_0_psv_ipi_2_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-rsp-msg-buf = <0xff3f08a0>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
   xlnx,ipi-req-msg-buf = <0xff3f0880>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-rsp-msg-buf = <0xff3f08e0>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
   xlnx,ipi-req-msg-buf = <0xff3f08c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0920>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
   xlnx,ipi-req-msg-buf = <0xff3f0900>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0960>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
   xlnx,ipi-req-msg-buf = <0xff3f0940>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-rsp-msg-buf = <0xff3f09a0>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
   xlnx,ipi-req-msg-buf = <0xff3f0980>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-rsp-msg-buf = <0xff3f09e0>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
   xlnx,ipi-req-msg-buf = <0xff3f09c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0860>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
   xlnx,ipi-req-msg-buf = <0xff3f0840>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_2_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0820>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
   xlnx,ipi-req-msg-buf = <0xff3f0800>;
  };
 };
 &ipi3 {
  xlnx,cpu-name = "A72";
  xlnx,buffer-base = <0xff3f0a00>;
  status = "okay";
  xlnx,buffer-index = <0x5>;
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <65>;
  xlnx,bit-position = <5>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_3";
  CIPS_0_pspmc_0_psv_ipi_3_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0aa0>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
   xlnx,ipi-req-msg-buf = <0xff3f0a80>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0ae0>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
   xlnx,ipi-req-msg-buf = <0xff3f0ac0>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0b20>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
   xlnx,ipi-req-msg-buf = <0xff3f0b00>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0b60>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
   xlnx,ipi-req-msg-buf = <0xff3f0b40>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0ba0>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
   xlnx,ipi-req-msg-buf = <0xff3f0b80>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0be0>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
   xlnx,ipi-req-msg-buf = <0xff3f0bc0>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0a60>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
   xlnx,ipi-req-msg-buf = <0xff3f0a40>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_3_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0a20>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
   xlnx,ipi-req-msg-buf = <0xff3f0a00>;
  };
 };
 &ipi4 {
  xlnx,cpu-name = "A72";
  xlnx,buffer-base = <0xff3f0c00>;
  status = "okay";
  xlnx,buffer-index = <0x6>;
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <66>;
  xlnx,bit-position = <6>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_4";
  CIPS_0_pspmc_0_psv_ipi_4_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0ca0>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
   xlnx,ipi-req-msg-buf = <0xff3f0c80>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0ce0>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
   xlnx,ipi-req-msg-buf = <0xff3f0cc0>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0d20>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
   xlnx,ipi-req-msg-buf = <0xff3f0d00>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0d60>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
   xlnx,ipi-req-msg-buf = <0xff3f0d40>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0da0>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
   xlnx,ipi-req-msg-buf = <0xff3f0d80>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0de0>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
   xlnx,ipi-req-msg-buf = <0xff3f0dc0>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0c60>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
   xlnx,ipi-req-msg-buf = <0xff3f0c40>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_4_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0c20>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
   xlnx,ipi-req-msg-buf = <0xff3f0c00>;
  };
 };
 &ipi5 {
  xlnx,cpu-name = "A72";
  xlnx,buffer-base = <0xff3f0e00>;
  status = "okay";
  xlnx,buffer-index = <0x7>;
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <67>;
  xlnx,bit-position = <7>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_5";
  CIPS_0_pspmc_0_psv_ipi_5_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0ea0>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
   xlnx,ipi-req-msg-buf = <0xff3f0e80>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0ee0>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
   xlnx,ipi-req-msg-buf = <0xff3f0ec0>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0f20>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
   xlnx,ipi-req-msg-buf = <0xff3f0f00>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0f60>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
   xlnx,ipi-req-msg-buf = <0xff3f0f40>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0fa0>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
   xlnx,ipi-req-msg-buf = <0xff3f0f80>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0fe0>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
   xlnx,ipi-req-msg-buf = <0xff3f0fc0>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0e60>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
   xlnx,ipi-req-msg-buf = <0xff3f0e40>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_5_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0e20>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
   xlnx,ipi-req-msg-buf = <0xff3f0e00>;
  };
 };
 &ipi6 {
  xlnx,cpu-name = "A72";
  xlnx,buffer-base = "NIL";
  status = "okay";
  xlnx,buffer-index = "NIL";
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <68>;
  xlnx,bit-position = <9>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_6";
  CIPS_0_pspmc_0_psv_ipi_6_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_6_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
  };
 };
 &ipi_pmc {
  xlnx,cpu-name = "PMC";
  xlnx,buffer-base = <0xff3f0200>;
  status = "okay";
  xlnx,buffer-index = <0x1>;
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <59>;
  xlnx,bit-position = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_pmc";
  CIPS_0_pspmc_0_psv_ipi_pmc_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-rsp-msg-buf = <0xff3f02a0>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
   xlnx,ipi-req-msg-buf = <0xff3f0280>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-rsp-msg-buf = <0xff3f02e0>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
   xlnx,ipi-req-msg-buf = <0xff3f02c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0320>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
   xlnx,ipi-req-msg-buf = <0xff3f0300>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0360>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
   xlnx,ipi-req-msg-buf = <0xff3f0340>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-rsp-msg-buf = <0xff3f03a0>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
   xlnx,ipi-req-msg-buf = <0xff3f0380>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-rsp-msg-buf = <0xff3f03e0>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
   xlnx,ipi-req-msg-buf = <0xff3f03c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0260>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
   xlnx,ipi-req-msg-buf = <0xff3f0240>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0220>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
   xlnx,ipi-req-msg-buf = <0xff3f0200>;
  };
 };
 &ipi_pmc_nobuf {
  xlnx,cpu-name = "PMC";
  xlnx,buffer-base = "NIL";
  status = "okay";
  xlnx,buffer-index = "NIL";
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <60>;
  xlnx,bit-position = <8>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_pmc_nobuf";
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_pmc_nobuf_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
  };
 };
 &ipi_psm {
  xlnx,cpu-name = "PSM";
  xlnx,buffer-base = <0xff3f0000>;
  status = "okay";
  xlnx,buffer-index = <0x0>;
  xlnx,ip-name = "psv_ipi";
  xlnx,ipi-target-count = <10>;
  xlnx,int-id = <61>;
  xlnx,bit-position = <0>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ipi_psm";
  CIPS_0_pspmc_0_psv_ipi_psm_0: child@0 {
   xlnx,ipi-bitmask = <4>;
   xlnx,ipi-rsp-msg-buf = <0xff3f00a0>;
   xlnx,ipi-id = <2>;
   xlnx,ipi-buf-index = <0x2>;
   xlnx,ipi-req-msg-buf = <0xff3f0080>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_1: child@1 {
   xlnx,ipi-bitmask = <8>;
   xlnx,ipi-rsp-msg-buf = <0xff3f00e0>;
   xlnx,ipi-id = <3>;
   xlnx,ipi-buf-index = <0x3>;
   xlnx,ipi-req-msg-buf = <0xff3f00c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_2: child@2 {
   xlnx,ipi-bitmask = <16>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0120>;
   xlnx,ipi-id = <4>;
   xlnx,ipi-buf-index = <0x4>;
   xlnx,ipi-req-msg-buf = <0xff3f0100>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_3: child@3 {
   xlnx,ipi-bitmask = <32>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0160>;
   xlnx,ipi-id = <5>;
   xlnx,ipi-buf-index = <0x5>;
   xlnx,ipi-req-msg-buf = <0xff3f0140>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_4: child@4 {
   xlnx,ipi-bitmask = <64>;
   xlnx,ipi-rsp-msg-buf = <0xff3f01a0>;
   xlnx,ipi-id = <6>;
   xlnx,ipi-buf-index = <0x6>;
   xlnx,ipi-req-msg-buf = <0xff3f0180>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_5: child@5 {
   xlnx,ipi-bitmask = <128>;
   xlnx,ipi-rsp-msg-buf = <0xff3f01e0>;
   xlnx,ipi-id = <7>;
   xlnx,ipi-buf-index = <0x7>;
   xlnx,ipi-req-msg-buf = <0xff3f01c0>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_6: child@6 {
   xlnx,ipi-bitmask = <512>;
   xlnx,ipi-id = <9>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_7: child@7 {
   xlnx,ipi-bitmask = <2>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0060>;
   xlnx,ipi-id = <1>;
   xlnx,ipi-buf-index = <0x1>;
   xlnx,ipi-req-msg-buf = <0xff3f0040>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_8: child@8 {
   xlnx,ipi-bitmask = <256>;
   xlnx,ipi-id = <8>;
   xlnx,ipi-buf-index = <0xffff>;
  };
  CIPS_0_pspmc_0_psv_ipi_psm_9: child@9 {
   xlnx,ipi-bitmask = <1>;
   xlnx,ipi-rsp-msg-buf = <0xff3f0020>;
   xlnx,ipi-id = <0>;
   xlnx,ipi-buf-index = <0x0>;
   xlnx,ipi-req-msg-buf = <0xff3f0000>;
  };
 };
 &lpd_xppu {
  status = "okay";
  xlnx,ip-name = "psv_lpd_xppu";
  xlnx,name = "CIPS_0_pspmc_0_psv_lpd_xppu_0";
 };
 &ocm_xmpu {
  status = "okay";
  xlnx,ip-name = "psv_ocm_xmpu";
  xlnx,name = "CIPS_0_pspmc_0_psv_ocm_xmpu_0";
 };
 &dma0 {
  status = "okay";
  xlnx,ip-name = "psv_pmc_dma";
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_dma_0";
 };
 &dma1 {
  status = "okay";
  xlnx,ip-name = "psv_pmc_dma";
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_dma_1";
 };
 &gpio1 {
  status = "okay";
  xlnx,ip-name = "psv_pmc_gpio";
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_gpio_0";
 };
 &iomodule0 {
  xlnx,gpo4-size = <32>;
  xlnx,tmr = <0>;
  xlnx,pit1-readable = <1>;
  xlnx,mask = <0xfffff000>;
  xlnx,pit-size = < 32 32 32 32 >;
  xlnx,pit2-prescaler = <0>;
  xlnx,gpi3-interrupt = <0>;
  xlnx,intc-level-edge = <0x7fff>;
  xlnx,intc-positive = <0xffff>;
  xlnx,ip-name = "iomodule";
  xlnx,gpo1-size = <3>;
  xlnx,max-intr-size = <32>;
  xlnx,pit3-size = <32>;
  xlnx,fit3-interrupt = <0>;
  xlnx,fit1-no-clocks = <6216>;
  xlnx,gpi2-size = <32>;
  xlnx,pit2-readable = <1>;
  xlnx,intc-irq-connection = <0>;
  xlnx,uart-tx-interrupt = <1>;
  xlnx,use-config-reset = <0>;
  xlnx,pit2-interrupt = <1>;
  xlnx,intc-base-vectors = <0xf0240000>;
  xlnx,gpo4-init = <0x0>;
  xlnx,pit3-readable = <1>;
  xlnx,pit3-prescaler = <9>;
  xlnx,gpi4-interrupt = <0>;
  xlnx,gpo1-init = <0x0>;
  xlnx,use-io-bus = <0>;
  xlnx,use-gpo1 = <1>;
  xlnx,uart-baudrate = <115200>;
  xlnx,fit4-interrupt = <0>;
  xlnx,gpo3-size = <32>;
  xlnx,use-gpo2 = <0>;
  xlnx,uart-data-bits = <8>;
  xlnx,pit-prescaler = < 9 0 9 0 >;
  xlnx,gpio1-board-interface = "Custom";
  xlnx,use-gpo3 = <0>;
  xlnx,fit2-no-clocks = <6216>;
  xlnx,options = <1>;
  xlnx,gpio2-board-interface = "Custom";
  xlnx,use-gpo4 = <0>;
  xlnx,gpi4-size = <32>;
  xlnx,gpio3-board-interface = "Custom";
  xlnx,uart-rx-interrupt = <1>;
  xlnx,uart-error-interrupt = <1>;
  xlnx,gpio4-board-interface = "Custom";
  xlnx,pit4-readable = <1>;
  status = "okay";
  xlnx,intc-use-irq-out = <0>;
  xlnx,clock-freq = <100000000>;
  xlnx,gpo-init = < 0 0 0 0 >;
  xlnx,use-board-flow;
  xlnx,pit2-size = <32>;
  xlnx,intc-intr-size = <16>;
  xlnx,intc-use-ext-intr = <1>;
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_iomodule_0";
  xlnx,gpi1-size = <32>;
  xlnx,edk-special = "INTR_CTRL";
  xlnx,pit3-interrupt = <1>;
  xlnx,intc-has-fast = <0>;
  xlnx,pit-used = < 1 1 1 1 >;
  xlnx,use-gpi1 = <0>;
  xlnx,gpi1-interrupt = <0>;
  xlnx,use-gpi2 = <0>;
  xlnx,use-gpi3 = <0>;
  xlnx,use-gpi4 = <0>;
  xlnx,fit1-interrupt = <0>;
  xlnx,pit4-prescaler = <0>;
  xlnx,gpo3-init = <0x0>;
  xlnx,intc-addr-width = <32>;
  xlnx,edk-iptype = "PERIPHERAL";
  xlnx,fit3-no-clocks = <6216>;
  xlnx,use-uart-rx = <1>;
  xlnx,instance = "iomodule_0";
  xlnx,pit-mask = <0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF>;
  xlnx,uart-prog-baudrate = <1>;
  xlnx,use-pit1 = <1>;
  xlnx,gpo2-size = <32>;
  xlnx,use-pit2 = <1>;
  xlnx,pit4-size = <32>;
  xlnx,pit-readable = < 1 1 1 1 >;
  xlnx,use-pit3 = <1>;
  xlnx,use-pit4 = <1>;
  xlnx,pit4-interrupt = <1>;
  xlnx,gpi3-size = <32>;
  xlnx,intc-async-intr = <0xffff>;
  xlnx,avoid-primitives = <0>;
  xlnx,gpi2-interrupt = <0>;
  xlnx,pit1-prescaler = <9>;
  xlnx,use-tmr-disable = <0>;
  xlnx,use-fit1 = <0>;
  xlnx,pit1-size = <32>;
  xlnx,intc-num-sync-ff = <2>;
  xlnx,uart-board-interface = "rs232_uart";
  xlnx,use-fit2 = <0>;
  xlnx,fit2-interrupt = <0>;
  xlnx,use-fit3 = <0>;
  xlnx,use-fit4 = <0>;
  xlnx,uart-use-parity = <0>;
  xlnx,lmb-dwidth = <32>;
  xlnx,fit4-no-clocks = <6216>;
  xlnx,uart-odd-parity = <0>;
  xlnx,freq = <100000000>;
  xlnx,use-uart-tx = <1>;
  xlnx,pit1-interrupt = <1>;
  xlnx,gpo2-init = <0x0>;
  xlnx,io-mask = <0xfffe0000>;
  xlnx,lmb-awidth = <32>;
 };
 &qspi {
  xlnx,is-cache-coherent = <0>;
  xlnx,qspi-fbclk = <1>;
  xlnx,baud-rate-div = <8>;
  num-cs = <2>;
  xlnx,qspi-clk-freq-hz = <299999725>;
  xlnx,bus-width = <2>;
  xlnx,ip-name = "psv_pmc_qspi";
  spi-rx-bus-width = <4>;
  xlnx,connection-mode = <2>;
  spi-tx-bus-width = <4>;
  status = "okay";
  xlnx,clock-freq = <299999725>;
  xlnx,qspi-baud-rate-div = <8>;
  xlnx,qspi-mode = <2>;
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_qspi_0";
  xlnx,qspi-bus-width = <2>;
  is-dual = <1>;
 };
 &rtc {
  status = "okay";
  xlnx,ip-name = "psv_pmc_rtc";
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_rtc_0";
 };
 &sdhci1 {
  xlnx,sd-board-interface = "custom";
  xlnx,is-cache-coherent = <0>;
  xlnx,clk-50-ddr-otap-dly = <0x3>;
  xlnx,clk-50-sdr-itap-dly = <0x2c>;
  xlnx,has-emio = <0>;
  clock-frequency = <0xbebc149>;
  xlnx,clk-100-sdr-otap-dly = <0x3>;
  xlnx,mio-bank = <0x1>;
  xlnx,ip-name = "psv_pmc_sd";
  xlnx,bus-width = <8>;
  xlnx,card-detect = <1>;
  xlnx,has-wp = <0>;
  xlnx,has-cd = <1>;
  xlnx,slot-type = <3>;
  xlnx,clk-50-sdr-otap-dly = <0x4>;
  xlnx,clk-50-ddr-itap-dly = <0x36>;
  xlnx,has-power = <1>;
  status = "okay";
  xlnx,clk-200-sdr-otap-dly = <0x2>;
  xlnx,sdio-clk-freq-hz = <199999817>;
  xlnx,write-protect = <0>;
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_sd_1";
 };
 &sysmon0 {
  xlnx,sat-63-desc = "PS , FPD , satellite";
  xlnx,sat-34-y = <13560>;
  xlnx,sat-17-x = <22594>;
  xlnx,sat-1-desc = "PMC , system , ADC";
  xlnx,sat-9-x = <18841>;
  xlnx,sat-17-y = <7620>;
  xlnx,sat-19-desc = "Clocking , column , satellite";
  xlnx,sat-20-desc = "Clocking , column , satellite";
  xlnx,sat-9-y = <9709>;
  xlnx,sat-38-x = <2793>;
  xlnx,sat-38-y = <12272>;
  xlnx,sat-32-desc = "VNOC , satellite";
  xlnx,sat-22-x = <14954>;
  xlnx,ip-name = "psv_pmc_sysmon";
  xlnx,sat-22-y = <6649>;
  #size-cells = <2>;
  xlnx,sat-16-desc = "Clocking , column , satellite";
  xlnx,sat-9-desc = "VNOC , satellite";
  xlnx,sat-26-x = <11067>;
  #address-cells = <2>;
  xlnx,sat-28-desc = "VNOC , satellite";
  xlnx,sat-26-y = <3590>;
  xlnx,sat-10-x = <18616>;
  xlnx,sat-64-x = <12>;
  xlnx,sat-2-x = <12>;
  xlnx,sat-10-y = <13560>;
  xlnx,sat-64-y = <2868>;
  xlnx,sat-2-y = <2868>;
  xlnx,sat-13-desc = "ME , satellite";
  xlnx,sat-41-desc = "Clocking , column , satellite";
  xlnx,sat-31-x = <7180>;
  xlnx,sat-6-desc = "XPIO , satellite";
  xlnx,sat-31-y = <3590>;
  xlnx,sat-14-x = <22594>;
  xlnx,sat-6-x = <22579>;
  xlnx,sat-25-desc = "ME , satellite";
  xlnx,sat-14-y = <12272>;
  xlnx,sat-6-y = <1535>;
  xlnx,sat-35-x = <4666>;
  xlnx,sat-10-desc = "ME , satellite";
  xlnx,sat-37-desc = "ME , satellite";
  xlnx,sat-35-y = <13560>;
  xlnx,sat-18-x = <22594>;
  xlnx,sat-3-desc = "XPIO , satellite";
  xlnx,sat-18-y = <6037>;
  xlnx,sat-22-desc = "VNOC , satellite";
  xlnx,sat-40-x = <2793>;
  xlnx,sat-39-x = <2793>;
  xlnx,sat-40-y = <9097>;
  xlnx,sat-39-y = <10679>;
  xlnx,sat-23-x = <14954>;
  xlnx,sat-34-desc = "ME , satellite";
  xlnx,sat-23-y = <9709>;
  xlnx,sat-18-desc = "Clocking , column , satellite";
  xlnx,sat-27-x = <11067>;
  xlnx,sat-27-y = <6649>;
  xlnx,sat-11-x = <16623>;
  xlnx,sat-3-x = <4435>;
  xlnx,sat-31-desc = "VNOC , satellite";
  xlnx,sat-11-y = <13560>;
  xlnx,sat-3-y = <1535>;
  status = "okay";
  xlnx,sat-32-x = <7180>;
  xlnx,sat-15-desc = "Clocking , column , satellite";
  xlnx,sat-32-y = <6649>;
  xlnx,sat-15-x = <22594>;
  xlnx,sat-8-desc = "VNOC , satellite";
  xlnx,sat-7-x = <18841>;
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_sysmon_0";
  xlnx,sat-15-y = <10679>;
  xlnx,sat-7-y = <3590>;
  xlnx,sat-27-desc = "VNOC , satellite";
  xlnx,sat-36-x = <2673>;
  xlnx,sat-36-y = <13560>;
  xlnx,sat-12-desc = "ME , satellite";
  xlnx,sat-19-x = <22594>;
  xlnx,sat-20-x = <22594>;
  xlnx,sat-40-desc = "Clocking , column , satellite";
  xlnx,sat-39-desc = "Clocking , column , satellite";
  xlnx,sat-19-y = <4560>;
  xlnx,sat-20-y = <2977>;
  xlnx,sat-5-desc = "XPIO , satellite";
  xlnx,sat-41-x = <2793>;
  xlnx,sat-24-desc = "ME , satellite";
  xlnx,sat-41-y = <7620>;
  xlnx,sat-24-x = <14630>;
  xlnx,sat-24-y = <13560>;
  xlnx,sat-36-desc = "ME , satellite";
  xlnx,sat-64-desc = "PS , LPD , satellite";
  xlnx,sat-2-desc = "PMC , user , ADC";
  xlnx,sat-28-x = <11067>;
  xlnx,sat-21-desc = "VNOC , satellite";
  xlnx,sat-28-y = <9709>;
  xlnx,sat-12-x = <20609>;
  xlnx,sat-4-x = <10483>;
  xlnx,sat-12-y = <13560>;
  xlnx,sat-4-y = <1535>;
  xlnx,sat-33-desc = "VNOC , satellite";
  xlnx,sat-33-x = <7180>;
  xlnx,sat-33-y = <9709>;
  xlnx,sat-16-x = <22594>;
  xlnx,sat-17-desc = "Clocking , column , satellite";
  xlnx,sat-8-x = <18841>;
  xlnx,sat-16-y = <9097>;
  xlnx,sat-8-y = <6649>;
  xlnx,sat-37-x = <680>;
  xlnx,sat-30-desc = "ME , satellite";
  xlnx,sat-29-desc = "ME , satellite";
  xlnx,sat-37-y = <13560>;
  xlnx,sat-21-x = <14954>;
  xlnx,sat-14-desc = "Clocking , column , satellite";
  xlnx,sat-21-y = <3590>;
  xlnx,sat-7-desc = "VNOC , satellite";
  xlnx,sat-26-desc = "VNOC , satellite";
  xlnx,sat-25-x = <12638>;
  xlnx,sat-25-y = <13560>;
  xlnx,sat-63-x = <12>;
  xlnx,sat-11-desc = "ME , satellite";
  xlnx,sat-1-x = <12>;
  xlnx,numchannels = /bits/8 <0>;
  xlnx,sat-63-y = <2868>;
  xlnx,sat-38-desc = "Clocking , column , satellite";
  xlnx,sat-1-y = <2868>;
  xlnx,sat-4-desc = "XPIO , satellite";
  xlnx,sat-30-x = <8652>;
  xlnx,sat-29-x = <10645>;
  xlnx,sat-30-y = <13560>;
  xlnx,sat-29-y = <13560>;
  xlnx,sat-13-x = <22602>;
  xlnx,sat-23-desc = "VNOC , satellite";
  xlnx,sat-5-x = <16531>;
  xlnx,sat-13-y = <13560>;
  xlnx,sat-5-y = <1535>;
  xlnx,sat-35-desc = "ME , satellite";
  xlnx,sat-34-x = <6659>;
 };
 &pmc_xmpu {
  status = "okay";
  xlnx,ip-name = "psv_pmc_xmpu";
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_xmpu_0";
 };
 &pmc_xppu {
  status = "okay";
  xlnx,ip-name = "psv_pmc_xppu";
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_xppu_0";
 };
 &pmc_xppu_npi {
  status = "okay";
  xlnx,ip-name = "psv_pmc_xppu_npi";
  xlnx,name = "CIPS_0_pspmc_0_psv_pmc_xppu_npi_0";
 };
 &psv_r5_0_btcm_global {
  status = "okay";
  power-domains = <&versal_firmware 0x1831800c>;
  xlnx,ip-name = "psv_tcm_global";
  xlnx,is-hierarchy;
  xlnx,name = "CIPS_0_pspmc_0_psv_r5_0_btcm_global";
 };
 &psv_r5_1_atcm_global {
  status = "okay";
  power-domains = <&versal_firmware 0x1831800d>;
  xlnx,ip-name = "psv_tcm_global";
  xlnx,name = "CIPS_0_pspmc_0_psv_r5_1_atcm_global";
 };
 &psv_r5_1_btcm_global {
  status = "okay";
  power-domains = <&versal_firmware 0x1831800e>;
  xlnx,ip-name = "psv_tcm_global";
  xlnx,name = "CIPS_0_pspmc_0_psv_r5_1_btcm_global";
 };
 &psv_r5_0_atcm_global {
  status = "okay";
  power-domains = <&versal_firmware 0x1831800b>;
  xlnx,ip-name = "psv_tcm_global";
  xlnx,is-hierarchy;
  xlnx,name = "CIPS_0_pspmc_0_psv_r5_0_atcm_global";
 };
 &gic_a72 {
  status = "okay";
  xlnx,apu-gic-its-ctl = <0xf9020000>;
  xlnx,ip-name = "psv_acpu_gic";
  xlnx,name = "CIPS_0_pspmc_0_psv_acpu_gic";
 };
 &gic_r5 {
  status = "okay";
  xlnx,ip-name = "psv_rcpu_gic";
  xlnx,name = "CIPS_0_pspmc_0_psv_rcpu_gic";
 };
 &serial0 {
  status = "okay";
  xlnx,clock-freq = <99999908>;
  u-boot,dm-pre-reloc;
  xlnx,uart-board-interface = "custom";
  xlnx,has-modem = <0>;
  xlnx,ip-name = "psv_sbsauart";
  xlnx,baudrate = <115200>;
  cts-override;
  port-number = <0>;
  xlnx,uart-clk-freq-hz = <99999908>;
  xlnx,name = "CIPS_0_pspmc_0_psv_sbsauart_0";
 };
 &ttc0 {
  xlnx,ttc-board-interface = "custom";
  xlnx,ttc-clk2-freq-hz = <149999863>;
  xlnx,ttc-clk1-clksrc = <0>;
  status = "okay";
  xlnx,clock-freq = <149999863>;
  xlnx,ttc-clk2-clksrc = <0>;
  xlnx,ip-name = "psv_ttc";
  xlnx,ttc-clk0-freq-hz = <149999863>;
  xlnx,ttc-clk1-freq-hz = <149999863>;
  xlnx,ttc-clk0-clksrc = <0>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ttc_0";
 };
 &ttc1 {
  xlnx,ttc-board-interface = "custom";
  xlnx,ttc-clk2-freq-hz = <149999863>;
  xlnx,ttc-clk1-clksrc = <0>;
  status = "okay";
  xlnx,clock-freq = <149999863>;
  xlnx,ttc-clk2-clksrc = <0>;
  xlnx,ip-name = "psv_ttc";
  xlnx,ttc-clk0-freq-hz = <149999863>;
  xlnx,ttc-clk1-freq-hz = <149999863>;
  xlnx,ttc-clk0-clksrc = <0>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ttc_1";
 };
 &ttc2 {
  xlnx,ttc-board-interface = "custom";
  xlnx,ttc-clk2-freq-hz = <149999863>;
  xlnx,ttc-clk1-clksrc = <0>;
  status = "okay";
  xlnx,clock-freq = <149999863>;
  xlnx,ttc-clk2-clksrc = <0>;
  xlnx,ip-name = "psv_ttc";
  xlnx,ttc-clk0-freq-hz = <149999863>;
  xlnx,ttc-clk1-freq-hz = <149999863>;
  xlnx,ttc-clk0-clksrc = <0>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ttc_2";
 };
 &ttc3 {
  xlnx,ttc-board-interface = "custom";
  xlnx,ttc-clk2-freq-hz = <149999863>;
  xlnx,ttc-clk1-clksrc = <0>;
  status = "okay";
  xlnx,clock-freq = <149999863>;
  xlnx,ttc-clk2-clksrc = <0>;
  xlnx,ip-name = "psv_ttc";
  xlnx,ttc-clk0-freq-hz = <149999863>;
  xlnx,ttc-clk1-freq-hz = <149999863>;
  xlnx,ttc-clk0-clksrc = <0>;
  xlnx,name = "CIPS_0_pspmc_0_psv_ttc_3";
 };
 &usb0 {
  status = "okay";
  xlnx,ip-name = "psv_usb";
  xlnx,name = "CIPS_0_pspmc_0_psv_usb_0";
 };
 &dwc3_0 {
  xlnx,is-cache-coherent = <0>;
  status = "okay";
  xlnx,ip-name = "psv_usb_xhci";
  xlnx,enable-superspeed = <0>;
  xlnx,name = "CIPS_0_pspmc_0_psv_usb_xhci_0";
 };
 &gic_its {
  status = "okay";
 };
 &ref {
  clock-frequency = <33333300>;
 };
 &cpu_opp_table {
  /delete-node/ opp01;
  /delete-node/ opp02;
  /delete-node/ opp03;
  /delete-node/ opp00;
  opp-1350000000 {
   opp-hz = /bits/ 64 <1350000000>;
   clock-latency-ns = <500000>;
   opp-microvolt = <1000000>;
  };
  opp-675000000 {
   opp-hz = /bits/ 64 <675000000>;
   clock-latency-ns = <500000>;
   opp-microvolt = <1000000>;
  };
  opp-450000000 {
   opp-hz = /bits/ 64 <450000000>;
   clock-latency-ns = <500000>;
   opp-microvolt = <1000000>;
  };
  opp-337500000 {
   opp-hz = /bits/ 64 <337500000>;
   clock-latency-ns = <500000>;
   opp-microvolt = <1000000>;
  };
 };
 &psv_cortexr5_0 {
  xlnx,is-cache-coherent = <0>;
  xlnx,pss-ref-clk-freq = <33333300>;
  xlnx,ip-name = "psv_cortexr5";
  access-val = <0xff>;
  bus-handle = <&amba>;
  xlnx,cpu-clk-freq-hz = <599999451>;
  cpu-frequency = <599999451>;
 };
 &psv_cortexr5_1 {
  xlnx,is-cache-coherent = <0>;
  xlnx,pss-ref-clk-freq = <33333300>;
  xlnx,ip-name = "psv_cortexr5";
  access-val = <0xff>;
  bus-handle = <&amba>;
  xlnx,cpu-clk-freq-hz = <599999451>;
  cpu-frequency = <599999451>;
 };
# 6 "/tmp/tmppczvninu" 2
/ {
 board = "vck190";
 device_id = "xcvc1902";
 slrcount = <1>;
 family = "Versal";
 speed_grade = "2MP";
 noc_ddr4_ddr_memory: memory@00000000 {
  compatible = "xlnx,axi-noc-1.1";
  xlnx,ip-name = "axi_noc";
  device_type = "memory";
  reg = <0x0 0x00000000 0x0 0x80000000>, <0x00000008 0x00000000 0x00000001 0x80000000>;
  memory_type = "memory";
 };
 noc_lpddr4_ddr_memory: memory@50000000000 {
  compatible = "xlnx,axi-noc-1.1";
  xlnx,ip-name = "axi_noc";
  device_type = "memory";
  reg = <0x00000500 0x00000000 0x00000002 0x00000000>;
  memory_type = "memory";
 };
 CIPS_0_pspmc_0_psv_ocm_ram_0_memory: memory@FFFC0000 {
  compatible = "xlnx,psv-ocm-ram-0-1.0" , "mmio-sram";
  xlnx,ip-name = "psv_ocm_ram_0";
  device_type = "memory";
  memory_type = "memory";
  reg = <0x0 0xFFFC0000 0x0 0x40000>;
 };
 chosen {
  stdout-path = "serial0:115200n8";
 };
 aliases {
  serial0 = &serial0;
  spi0 = &qspi;
  ethernet1 = &gem1;
  serial1 = &coresight;
  i2c0 = &i2c0;
  i2c1 = &i2c1;
  ethernet0 = &gem0;
 };
 cpus_a72: cpus-a72@0 {
  compatible = "cpus,cluster";
  address-map = <0x0 0xf0000000 &amba 0x0 0xf0000000 0x0 0x10000000>,
         <0x0 0xf9000000 &amba_apu 0x0 0xf9000000 0x0 0x80000>,
         <0x0 0x00000000 &noc_ddr4_ddr_memory 0x0 0x00000000 0x0 0x80000000>,
         <0x00000008 0x00000000 &noc_ddr4_ddr_memory 0x00000008 0x00000000 0x00000001 0x80000000>,
         <0x00000500 0x00000000 &noc_lpddr4_ddr_memory 0x00000500 0x00000000 0x00000002 0x00000000>,
         <0x0 0xf9020000 &gic_its 0x0 0xf9020000 0x0 0x20000>,
         <0x0 0xff330000 &ipi0 0x0 0xff330000 0x0 0x10000>,
         <0x0 0xff360000 &ipi3 0x0 0xff360000 0x0 0x10000>,
         <0x0 0xff370000 &ipi4 0x0 0xff370000 0x0 0x10000>,
         <0x0 0xff380000 &ipi5 0x0 0xff380000 0x0 0x10000>,
         <0x0 0xff3a0000 &ipi6 0x0 0xff3a0000 0x0 0x10000>,
         <0x0 0xFFFC0000 &CIPS_0_pspmc_0_psv_ocm_ram_0_memory 0x0 0xFFFC0000 0x0 0x40000>,
         <0x0 0xa4000000 &axi_intc_cascaded_1 0x0 0xa4000000 0x0 0x10000>,
         <0x0 0xa4010000 &dummy_slave_0 0x0 0xa4010000 0x0 0x10000>,
         <0x0 0xa4020000 &dummy_slave_1 0x0 0xa4020000 0x0 0x10000>,
         <0x0 0xa4030000 &dummy_slave_2 0x0 0xa4030000 0x0 0x10000>,
         <0x0 0xa4040000 &dummy_slave_3 0x0 0xa4040000 0x0 0x10000>,
         <0x0 0xa5000000 &axi_intc_parent 0x0 0xa5000000 0x0 0x10000>,
         <0x0 0xf0310000 &CIPS_0_pspmc_0_psv_pmc_ppu1_mdm_0 0x0 0xf0310000 0x0 0x8000>,
         <0x0 0xf0800000 &coresight 0x0 0xf0800000 0x0 0x10000>,
         <0x0 0xf08d0000 &CIPS_0_pspmc_0_psv_coresight_pmc_cti 0x0 0xf08d0000 0x0 0x10000>,
         <0x0 0xf0980000 &CIPS_0_pspmc_0_psv_coresight_lpd_atm 0x0 0xf0980000 0x0 0x10000>,
         <0x0 0xf09d0000 &CIPS_0_pspmc_0_psv_coresight_lpd_cti 0x0 0xf09d0000 0x0 0x10000>,
         <0x0 0xf0a10000 &CIPS_0_pspmc_0_psv_coresight_r50_cti 0x0 0xf0a10000 0x0 0x10000>,
         <0x0 0xf0a50000 &CIPS_0_pspmc_0_psv_coresight_r51_cti 0x0 0xf0a50000 0x0 0x10000>,
         <0x0 0xf0b70000 &CIPS_0_pspmc_0_psv_coresight_fpd_stm 0x0 0xf0b70000 0x0 0x10000>,
         <0x0 0xf0b80000 &CIPS_0_pspmc_0_psv_coresight_fpd_atm 0x0 0xf0b80000 0x0 0x10000>,
         <0x0 0xf0bb0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1b 0x0 0xf0bb0000 0x0 0x10000>,
         <0x0 0xf0bc0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1c 0x0 0xf0bc0000 0x0 0x10000>,
         <0x0 0xf0bd0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1d 0x0 0xf0bd0000 0x0 0x10000>,
         <0x0 0xf0c20000 &CIPS_0_pspmc_0_psv_coresight_apu_fun 0x0 0xf0c20000 0x0 0x10000>,
         <0x0 0xf0c30000 &CIPS_0_pspmc_0_psv_coresight_apu_etf 0x0 0xf0c30000 0x0 0x10000>,
         <0x0 0xf0c60000 &CIPS_0_pspmc_0_psv_coresight_apu_ela 0x0 0xf0c60000 0x0 0x10000>,
         <0x0 0xf0ca0000 &CIPS_0_pspmc_0_psv_coresight_apu_cti 0x0 0xf0ca0000 0x0 0x10000>,
         <0x0 0xf0d00000 &CIPS_0_pspmc_0_psv_coresight_a720_dbg 0x0 0xf0d00000 0x0 0x10000>,
         <0x0 0xf0d10000 &CIPS_0_pspmc_0_psv_coresight_a720_cti 0x0 0xf0d10000 0x0 0x10000>,
         <0x0 0xf0d20000 &CIPS_0_pspmc_0_psv_coresight_a720_pmu 0x0 0xf0d20000 0x0 0x10000>,
         <0x0 0xf0d30000 &CIPS_0_pspmc_0_psv_coresight_a720_etm 0x0 0xf0d30000 0x0 0x10000>,
         <0x0 0xf0d40000 &CIPS_0_pspmc_0_psv_coresight_a721_dbg 0x0 0xf0d40000 0x0 0x10000>,
         <0x0 0xf0d50000 &CIPS_0_pspmc_0_psv_coresight_a721_cti 0x0 0xf0d50000 0x0 0x10000>,
         <0x0 0xf0d60000 &CIPS_0_pspmc_0_psv_coresight_a721_pmu 0x0 0xf0d60000 0x0 0x10000>,
         <0x0 0xf0d70000 &CIPS_0_pspmc_0_psv_coresight_a721_etm 0x0 0xf0d70000 0x0 0x10000>,
         <0x0 0xf0f00000 &CIPS_0_pspmc_0_psv_coresight_cpm_rom 0x0 0xf0f00000 0x0 0x10000>,
         <0x0 0xf0f20000 &CIPS_0_pspmc_0_psv_coresight_cpm_fun 0x0 0xf0f20000 0x0 0x10000>,
         <0x0 0xf0f40000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2a 0x0 0xf0f40000 0x0 0x10000>,
         <0x0 0xf0f50000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2b 0x0 0xf0f50000 0x0 0x10000>,
         <0x0 0xf0f60000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2c 0x0 0xf0f60000 0x0 0x10000>,
         <0x0 0xf0f70000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2d 0x0 0xf0f70000 0x0 0x10000>,
         <0x0 0xf0f80000 &CIPS_0_pspmc_0_psv_coresight_cpm_atm 0x0 0xf0f80000 0x0 0x10000>,
         <0x0 0xf0fa0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2a 0x0 0xf0fa0000 0x0 0x10000>,
         <0x0 0xf0fd0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2d 0x0 0xf0fd0000 0x0 0x10000>,
         <0x0 0xf1020000 &gpio1 0x0 0xf1020000 0x0 0x10000>,
         <0x0 0xf1030000 &qspi 0x0 0xf1030000 0x0 0x10000>,
         <0x0 0xf1050000 &sdhci1 0x0 0xf1050000 0x0 0x10000>,
         <0x0 0xf1110000 &CIPS_0_pspmc_0_psv_pmc_global_0 0x0 0xf1110000 0x0 0x50000>,
         <0x0 0xf11c0000 &dma0 0x0 0xf11c0000 0x0 0x10000>,
         <0x0 0xf11d0000 &dma1 0x0 0xf11d0000 0x0 0x10000>,
         <0x0 0xf11e0000 &CIPS_0_pspmc_0_psv_pmc_aes 0x0 0xf11e0000 0x0 0x10000>,
         <0x0 0xf11f0000 &CIPS_0_pspmc_0_psv_pmc_bbram_ctrl 0x0 0xf11f0000 0x0 0x10000>,
         <0x0 0xf1200000 &CIPS_0_pspmc_0_psv_pmc_rsa 0x0 0xf1200000 0x0 0x10000>,
         <0x0 0xf1210000 &CIPS_0_pspmc_0_psv_pmc_sha 0x0 0xf1210000 0x0 0x10000>,
         <0x0 0xf1220000 &CIPS_0_pspmc_0_psv_pmc_slave_boot 0x0 0xf1220000 0x0 0x10000>,
         <0x0 0xf1230000 &CIPS_0_pspmc_0_psv_pmc_trng 0x0 0xf1230000 0x0 0x10000>,
         <0x0 0xf1240000 &CIPS_0_pspmc_0_psv_pmc_efuse_ctrl 0x0 0xf1240000 0x0 0x10000>,
         <0x0 0xf1250000 &CIPS_0_pspmc_0_psv_pmc_efuse_cache 0x0 0xf1250000 0x0 0x10000>,
         <0x0 0xf1260000 &CIPS_0_pspmc_0_psv_crp_0 0x0 0xf1260000 0x0 0x10000>,
         <0x0 0xf1270000 &sysmon0 0x0 0xf1270000 0x0 0x30000>,
         <0x0 0xf12a0000 &rtc 0x0 0xf12a0000 0x0 0x10000>,
         <0x0 0xf12b0000 &CIPS_0_pspmc_0_psv_pmc_cfu_apb_0 0x0 0xf12b0000 0x0 0x10000>,
         <0x0 0xf12d0000 &CIPS_0_pspmc_0_psv_pmc_cfi_cframe_0 0x0 0xf12d0000 0x0 0x1000>,
         <0x0 0xf12f0000 &pmc_xmpu 0x0 0xf12f0000 0x0 0x10000>,
         <0x0 0xf1300000 &pmc_xppu_npi 0x0 0xf1300000 0x0 0x10000>,
         <0x0 0xf1310000 &pmc_xppu 0x0 0xf1310000 0x0 0x10000>,
         <0x0 0xf2100000 &CIPS_0_pspmc_0_psv_pmc_slave_boot_stream 0x0 0xf2100000 0x0 0x10000>,
         <0x0 0xf6000000 &CIPS_0_pspmc_0_psv_pmc_ram_npi 0x0 0xf6000000 0x0 0x2000000>,
         <0x0 0xf9000000 &gic_a72 0x0 0xf9000000 0x0 0x70000>,
         <0x0 0 &CIPS_0_pspmc_0_psv_cpm 0x0 0 0x0 0xfd000000>,
         <0x0 0xfd000000 &cci 0x0 0xfd000000 0x0 0x100000>,
         <0x0 0xfd1a0000 &CIPS_0_pspmc_0_psv_crf_0 0x0 0xfd1a0000 0x0 0x140000>,
         <0x0 0xfd360000 &CIPS_0_pspmc_0_psv_fpd_afi_0 0x0 0xfd360000 0x0 0x10000>,
         <0x0 0xfd380000 &CIPS_0_pspmc_0_psv_fpd_afi_2 0x0 0xfd380000 0x0 0x10000>,
         <0x0 0xfd390000 &fpd_xmpu 0x0 0xfd390000 0x0 0x10000>,
         <0x0 0xfd5c0000 &CIPS_0_pspmc_0_psv_apu_0 0x0 0xfd5c0000 0x0 0x10000>,
         <0x0 0xfd5e0000 &CIPS_0_pspmc_0_psv_fpd_cci_0 0x0 0xfd5e0000 0x0 0x10000>,
         <0x0 0xfd5f0000 &CIPS_0_pspmc_0_psv_fpd_smmu_0 0x0 0xfd5f0000 0x0 0x10000>,
         <0x0 0xfd610000 &CIPS_0_pspmc_0_psv_fpd_slcr_0 0x0 0xfd610000 0x0 0x10000>,
         <0x0 0xfd690000 &CIPS_0_pspmc_0_psv_fpd_slcr_secure_0 0x0 0xfd690000 0x0 0x10000>,
         <0x0 0xfd700000 &CIPS_0_pspmc_0_psv_fpd_gpv_0 0x0 0xfd700000 0x0 0x100000>,
         <0x0 0xfd800000 &smmu 0x0 0xfd800000 0x0 0x800000>,
         <0x0 0xfe200000 &dwc3_0 0x0 0xfe200000 0x0 0x100000>,
         <0x0 0xff000000 &serial0 0x0 0xff000000 0x0 0x10000>,
         <0x0 0xff020000 &i2c0 0x0 0xff020000 0x0 0x10000>,
         <0x0 0xff030000 &i2c1 0x0 0xff030000 0x0 0x10000>,
         <0x0 0xff070000 &can1 0x0 0xff070000 0x0 0x10000>,
         <0x0 0xff080000 &CIPS_0_pspmc_0_psv_lpd_iou_slcr_0 0x0 0xff080000 0x0 0x20000>,
         <0x0 0xff0a0000 &CIPS_0_pspmc_0_psv_lpd_iou_secure_slcr_0 0x0 0xff0a0000 0x0 0x10000>,
         <0x0 0xff0c0000 &gem0 0x0 0xff0c0000 0x0 0x10000>,
         <0x0 0xff0d0000 &gem1 0x0 0xff0d0000 0x0 0x10000>,
         <0x0 0xff0e0000 &ttc0 0x0 0xff0e0000 0x0 0x10000>,
         <0x0 0xff0f0000 &ttc1 0x0 0xff0f0000 0x0 0x10000>,
         <0x0 0xff100000 &ttc2 0x0 0xff100000 0x0 0x10000>,
         <0x0 0xff110000 &ttc3 0x0 0xff110000 0x0 0x10000>,
         <0x0 0xff130000 &CIPS_0_pspmc_0_psv_scntr_0 0x0 0xff130000 0x0 0x10000>,
         <0x0 0xff140000 &CIPS_0_pspmc_0_psv_scntrs_0 0x0 0xff140000 0x0 0x10000>,
         <0x0 0xff410000 &CIPS_0_pspmc_0_psv_lpd_slcr_0 0x0 0xff410000 0x0 0x100000>,
         <0x0 0xff510000 &CIPS_0_pspmc_0_psv_lpd_slcr_secure_0 0x0 0xff510000 0x0 0x40000>,
         <0x0 0xff5e0000 &CIPS_0_pspmc_0_psv_crl_0 0x0 0xff5e0000 0x0 0x300000>,
         <0x0 0xff960000 &CIPS_0_pspmc_0_psv_ocm_ctrl 0x0 0xff960000 0x0 0x10000>,
         <0x0 0xff980000 &ocm_xmpu 0x0 0xff980000 0x0 0x10000>,
         <0x0 0xff990000 &lpd_xppu 0x0 0xff990000 0x0 0x10000>,
         <0x0 0xff9a0000 &CIPS_0_pspmc_0_psv_rpu_0 0x0 0xff9a0000 0x0 0x10000>,
         <0x0 0xff9b0000 &CIPS_0_pspmc_0_psv_lpd_afi_0 0x0 0xff9b0000 0x0 0x10000>,
         <0x0 0xff9d0000 &usb0 0x0 0xff9d0000 0x0 0x10000>,
         <0x0 0xffa80000 &lpd_dma_chan0 0x0 0xffa80000 0x0 0x10000>,
         <0x0 0xffa90000 &lpd_dma_chan1 0x0 0xffa90000 0x0 0x10000>,
         <0x0 0xffaa0000 &lpd_dma_chan2 0x0 0xffaa0000 0x0 0x10000>,
         <0x0 0xffab0000 &lpd_dma_chan3 0x0 0xffab0000 0x0 0x10000>,
         <0x0 0xffac0000 &lpd_dma_chan4 0x0 0xffac0000 0x0 0x10000>,
         <0x0 0xffad0000 &lpd_dma_chan5 0x0 0xffad0000 0x0 0x10000>,
         <0x0 0xffae0000 &lpd_dma_chan6 0x0 0xffae0000 0x0 0x10000>,
         <0x0 0xffaf0000 &lpd_dma_chan7 0x0 0xffaf0000 0x0 0x10000>,
         <0x0 0xffc90000 &CIPS_0_pspmc_0_psv_psm_global_reg 0x0 0xffc90000 0x0 0xf000>,
         <0x0 0xffe00000 &psv_r5_0_atcm_global 0x0 0xffe00000 0x0 0x40000>,
         <0x0 0xffe90000 &psv_r5_1_atcm_global 0x0 0xffe90000 0x0 0x10000>,
         <0x0 0xffeb0000 &psv_r5_1_btcm_global 0x0 0xffeb0000 0x0 0x10000>,
         <0x00000200 0x00000000 &ai_engine_0 0x00000200 0x00000000 0x00000001 0x00000000>;
  #ranges-address-cells = <0x2>;
  #ranges-size-cells = <0x2>;
 };
 cpus_r5_0: cpus-r5@0 {
  compatible = "cpus,cluster";
  address-map = <0xf0000000 &amba 0xf0000000 0x10000000>,
         <0xf9000000 &amba_rpu 0xf9000000 0x3000>,
         <0x40000 &noc_ddr4_ddr_memory 0x40000 0x7ffc0000>,
         <0xff340000 &ipi1 0xff340000 0x10000>,
         <0xFFFC0000 &CIPS_0_pspmc_0_psv_ocm_ram_0_memory 0xFFFC0000 0x40000>,
         <0xa4000000 &axi_intc_cascaded_1 0xa4000000 0x10000>,
         <0xa4010000 &dummy_slave_0 0xa4010000 0x10000>,
         <0xa4020000 &dummy_slave_1 0xa4020000 0x10000>,
         <0xa4030000 &dummy_slave_2 0xa4030000 0x10000>,
         <0xa4040000 &dummy_slave_3 0xa4040000 0x10000>,
         <0xa5000000 &axi_intc_parent 0xa5000000 0x10000>,
         <0xf0310000 &CIPS_0_pspmc_0_psv_pmc_ppu1_mdm_0 0xf0310000 0x8000>,
         <0xf0800000 &coresight 0xf0800000 0x10000>,
         <0xf08d0000 &CIPS_0_pspmc_0_psv_coresight_pmc_cti 0xf08d0000 0x10000>,
         <0xf0980000 &CIPS_0_pspmc_0_psv_coresight_lpd_atm 0xf0980000 0x10000>,
         <0xf09d0000 &CIPS_0_pspmc_0_psv_coresight_lpd_cti 0xf09d0000 0x10000>,
         <0xf0a10000 &CIPS_0_pspmc_0_psv_coresight_r50_cti 0xf0a10000 0x10000>,
         <0xf0a50000 &CIPS_0_pspmc_0_psv_coresight_r51_cti 0xf0a50000 0x10000>,
         <0xf0b70000 &CIPS_0_pspmc_0_psv_coresight_fpd_stm 0xf0b70000 0x10000>,
         <0xf0b80000 &CIPS_0_pspmc_0_psv_coresight_fpd_atm 0xf0b80000 0x10000>,
         <0xf0bb0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1b 0xf0bb0000 0x10000>,
         <0xf0bc0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1c 0xf0bc0000 0x10000>,
         <0xf0bd0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1d 0xf0bd0000 0x10000>,
         <0xf0c20000 &CIPS_0_pspmc_0_psv_coresight_apu_fun 0xf0c20000 0x10000>,
         <0xf0c30000 &CIPS_0_pspmc_0_psv_coresight_apu_etf 0xf0c30000 0x10000>,
         <0xf0c60000 &CIPS_0_pspmc_0_psv_coresight_apu_ela 0xf0c60000 0x10000>,
         <0xf0ca0000 &CIPS_0_pspmc_0_psv_coresight_apu_cti 0xf0ca0000 0x10000>,
         <0xf0d00000 &CIPS_0_pspmc_0_psv_coresight_a720_dbg 0xf0d00000 0x10000>,
         <0xf0d10000 &CIPS_0_pspmc_0_psv_coresight_a720_cti 0xf0d10000 0x10000>,
         <0xf0d20000 &CIPS_0_pspmc_0_psv_coresight_a720_pmu 0xf0d20000 0x10000>,
         <0xf0d30000 &CIPS_0_pspmc_0_psv_coresight_a720_etm 0xf0d30000 0x10000>,
         <0xf0d40000 &CIPS_0_pspmc_0_psv_coresight_a721_dbg 0xf0d40000 0x10000>,
         <0xf0d50000 &CIPS_0_pspmc_0_psv_coresight_a721_cti 0xf0d50000 0x10000>,
         <0xf0d60000 &CIPS_0_pspmc_0_psv_coresight_a721_pmu 0xf0d60000 0x10000>,
         <0xf0d70000 &CIPS_0_pspmc_0_psv_coresight_a721_etm 0xf0d70000 0x10000>,
         <0xf0f00000 &CIPS_0_pspmc_0_psv_coresight_cpm_rom 0xf0f00000 0x10000>,
         <0xf0f20000 &CIPS_0_pspmc_0_psv_coresight_cpm_fun 0xf0f20000 0x10000>,
         <0xf0f40000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2a 0xf0f40000 0x10000>,
         <0xf0f50000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2b 0xf0f50000 0x10000>,
         <0xf0f60000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2c 0xf0f60000 0x10000>,
         <0xf0f70000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2d 0xf0f70000 0x10000>,
         <0xf0f80000 &CIPS_0_pspmc_0_psv_coresight_cpm_atm 0xf0f80000 0x10000>,
         <0xf0fa0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2a 0xf0fa0000 0x10000>,
         <0xf0fd0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2d 0xf0fd0000 0x10000>,
         <0xf1020000 &gpio1 0xf1020000 0x10000>,
         <0xf1030000 &qspi 0xf1030000 0x10000>,
         <0xf1050000 &sdhci1 0xf1050000 0x10000>,
         <0xf1110000 &CIPS_0_pspmc_0_psv_pmc_global_0 0xf1110000 0x50000>,
         <0xf11c0000 &dma0 0xf11c0000 0x10000>,
         <0xf11d0000 &dma1 0xf11d0000 0x10000>,
         <0xf11e0000 &CIPS_0_pspmc_0_psv_pmc_aes 0xf11e0000 0x10000>,
         <0xf11f0000 &CIPS_0_pspmc_0_psv_pmc_bbram_ctrl 0xf11f0000 0x10000>,
         <0xf1200000 &CIPS_0_pspmc_0_psv_pmc_rsa 0xf1200000 0x10000>,
         <0xf1210000 &CIPS_0_pspmc_0_psv_pmc_sha 0xf1210000 0x10000>,
         <0xf1220000 &CIPS_0_pspmc_0_psv_pmc_slave_boot 0xf1220000 0x10000>,
         <0xf1230000 &CIPS_0_pspmc_0_psv_pmc_trng 0xf1230000 0x10000>,
         <0xf1240000 &CIPS_0_pspmc_0_psv_pmc_efuse_ctrl 0xf1240000 0x10000>,
         <0xf1250000 &CIPS_0_pspmc_0_psv_pmc_efuse_cache 0xf1250000 0x10000>,
         <0xf1260000 &CIPS_0_pspmc_0_psv_crp_0 0xf1260000 0x10000>,
         <0xf1270000 &sysmon0 0xf1270000 0x30000>,
         <0xf12a0000 &rtc 0xf12a0000 0x10000>,
         <0xf12b0000 &CIPS_0_pspmc_0_psv_pmc_cfu_apb_0 0xf12b0000 0x10000>,
         <0xf12d0000 &CIPS_0_pspmc_0_psv_pmc_cfi_cframe_0 0xf12d0000 0x1000>,
         <0xf12f0000 &pmc_xmpu 0xf12f0000 0x10000>,
         <0xf1300000 &pmc_xppu_npi 0xf1300000 0x10000>,
         <0xf1310000 &pmc_xppu 0xf1310000 0x10000>,
         <0xf2100000 &CIPS_0_pspmc_0_psv_pmc_slave_boot_stream 0xf2100000 0x10000>,
         <0xf6000000 &CIPS_0_pspmc_0_psv_pmc_ram_npi 0xf6000000 0x2000000>,
         <0xfd000000 &cci 0xfd000000 0x100000>,
         <0xfd1a0000 &CIPS_0_pspmc_0_psv_crf_0 0xfd1a0000 0x140000>,
         <0xfd360000 &CIPS_0_pspmc_0_psv_fpd_afi_0 0xfd360000 0x10000>,
         <0xfd380000 &CIPS_0_pspmc_0_psv_fpd_afi_2 0xfd380000 0x10000>,
         <0xfd390000 &fpd_xmpu 0xfd390000 0x10000>,
         <0xfd5c0000 &CIPS_0_pspmc_0_psv_apu_0 0xfd5c0000 0x10000>,
         <0xfd5e0000 &CIPS_0_pspmc_0_psv_fpd_cci_0 0xfd5e0000 0x10000>,
         <0xfd5f0000 &CIPS_0_pspmc_0_psv_fpd_smmu_0 0xfd5f0000 0x10000>,
         <0xfd610000 &CIPS_0_pspmc_0_psv_fpd_slcr_0 0xfd610000 0x10000>,
         <0xfd690000 &CIPS_0_pspmc_0_psv_fpd_slcr_secure_0 0xfd690000 0x10000>,
         <0xfd700000 &CIPS_0_pspmc_0_psv_fpd_gpv_0 0xfd700000 0x100000>,
         <0xfd800000 &smmu 0xfd800000 0x800000>,
         <0xfe200000 &dwc3_0 0xfe200000 0x100000>,
         <0xff000000 &serial0 0xff000000 0x10000>,
         <0xff020000 &i2c0 0xff020000 0x10000>,
         <0xff030000 &i2c1 0xff030000 0x10000>,
         <0xff070000 &can1 0xff070000 0x10000>,
         <0xff080000 &CIPS_0_pspmc_0_psv_lpd_iou_slcr_0 0xff080000 0x20000>,
         <0xff0a0000 &CIPS_0_pspmc_0_psv_lpd_iou_secure_slcr_0 0xff0a0000 0x10000>,
         <0xff0c0000 &gem0 0xff0c0000 0x10000>,
         <0xff0d0000 &gem1 0xff0d0000 0x10000>,
         <0xff0e0000 &ttc0 0xff0e0000 0x10000>,
         <0xff0f0000 &ttc1 0xff0f0000 0x10000>,
         <0xff100000 &ttc2 0xff100000 0x10000>,
         <0xff110000 &ttc3 0xff110000 0x10000>,
         <0xff130000 &CIPS_0_pspmc_0_psv_scntr_0 0xff130000 0x10000>,
         <0xff140000 &CIPS_0_pspmc_0_psv_scntrs_0 0xff140000 0x10000>,
         <0xff410000 &CIPS_0_pspmc_0_psv_lpd_slcr_0 0xff410000 0x100000>,
         <0xff510000 &CIPS_0_pspmc_0_psv_lpd_slcr_secure_0 0xff510000 0x40000>,
         <0xff5e0000 &CIPS_0_pspmc_0_psv_crl_0 0xff5e0000 0x300000>,
         <0xff960000 &CIPS_0_pspmc_0_psv_ocm_ctrl 0xff960000 0x10000>,
         <0xff980000 &ocm_xmpu 0xff980000 0x10000>,
         <0xff990000 &lpd_xppu 0xff990000 0x10000>,
         <0xff9a0000 &CIPS_0_pspmc_0_psv_rpu_0 0xff9a0000 0x10000>,
         <0xff9b0000 &CIPS_0_pspmc_0_psv_lpd_afi_0 0xff9b0000 0x10000>,
         <0xff9d0000 &usb0 0xff9d0000 0x10000>,
         <0xffa80000 &lpd_dma_chan0 0xffa80000 0x10000>,
         <0xffa90000 &lpd_dma_chan1 0xffa90000 0x10000>,
         <0xffaa0000 &lpd_dma_chan2 0xffaa0000 0x10000>,
         <0xffab0000 &lpd_dma_chan3 0xffab0000 0x10000>,
         <0xffac0000 &lpd_dma_chan4 0xffac0000 0x10000>,
         <0xffad0000 &lpd_dma_chan5 0xffad0000 0x10000>,
         <0xffae0000 &lpd_dma_chan6 0xffae0000 0x10000>,
         <0xffaf0000 &lpd_dma_chan7 0xffaf0000 0x10000>,
         <0xffc90000 &CIPS_0_pspmc_0_psv_psm_global_reg 0xffc90000 0xf000>,
         <0x0000 &CIPS_0_pspmc_0_psv_r5_0_atcm 0x0000 0x10000>,
         <0x00000 &CIPS_0_pspmc_0_psv_r5_tcm_ram_0 0x00000 0x40000>,
         <0x20000 &CIPS_0_pspmc_0_psv_r5_0_btcm 0x20000 0x10000>,
         <0xf9000000 &gic_r5 0xf9000000 0x3000>,
         <0xffe40000 &CIPS_0_pspmc_0_psv_r5_0_instruction_cache 0xffe40000 0x10000>,
         <0xffe50000 &CIPS_0_pspmc_0_psv_r5_0_data_cache 0xffe50000 0x10000>,
         <0xffec0000 &CIPS_0_pspmc_0_psv_r5_1_instruction_cache 0xffec0000 0x10000>,
         <0xffed0000 &CIPS_0_pspmc_0_psv_r5_1_data_cache 0xffed0000 0x10000>;
  #ranges-address-cells = <0x1>;
  #ranges-size-cells = <0x1>;
 };
 cpus_r5_1: cpus-r5@1 {
  compatible = "cpus,cluster";
  address-map = <0xf0000000 &amba 0xf0000000 0x10000000>,
         <0xf9000000 &amba_rpu 0xf9000000 0x3000>,
         <0x40000 &noc_ddr4_ddr_memory 0x40000 0x7ffc0000>,
         <0xff350000 &ipi2 0xff350000 0x10000>,
         <0xFFFC0000 &CIPS_0_pspmc_0_psv_ocm_ram_0_memory 0xFFFC0000 0x40000>,
         <0xa4000000 &axi_intc_cascaded_1 0xa4000000 0x10000>,
         <0xa4010000 &dummy_slave_0 0xa4010000 0x10000>,
         <0xa4020000 &dummy_slave_1 0xa4020000 0x10000>,
         <0xa4030000 &dummy_slave_2 0xa4030000 0x10000>,
         <0xa4040000 &dummy_slave_3 0xa4040000 0x10000>,
         <0xa5000000 &axi_intc_parent 0xa5000000 0x10000>,
         <0xf0310000 &CIPS_0_pspmc_0_psv_pmc_ppu1_mdm_0 0xf0310000 0x8000>,
         <0xf0800000 &coresight 0xf0800000 0x10000>,
         <0xf08d0000 &CIPS_0_pspmc_0_psv_coresight_pmc_cti 0xf08d0000 0x10000>,
         <0xf0980000 &CIPS_0_pspmc_0_psv_coresight_lpd_atm 0xf0980000 0x10000>,
         <0xf09d0000 &CIPS_0_pspmc_0_psv_coresight_lpd_cti 0xf09d0000 0x10000>,
         <0xf0a10000 &CIPS_0_pspmc_0_psv_coresight_r50_cti 0xf0a10000 0x10000>,
         <0xf0a50000 &CIPS_0_pspmc_0_psv_coresight_r51_cti 0xf0a50000 0x10000>,
         <0xf0b70000 &CIPS_0_pspmc_0_psv_coresight_fpd_stm 0xf0b70000 0x10000>,
         <0xf0b80000 &CIPS_0_pspmc_0_psv_coresight_fpd_atm 0xf0b80000 0x10000>,
         <0xf0bb0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1b 0xf0bb0000 0x10000>,
         <0xf0bc0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1c 0xf0bc0000 0x10000>,
         <0xf0bd0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1d 0xf0bd0000 0x10000>,
         <0xf0c20000 &CIPS_0_pspmc_0_psv_coresight_apu_fun 0xf0c20000 0x10000>,
         <0xf0c30000 &CIPS_0_pspmc_0_psv_coresight_apu_etf 0xf0c30000 0x10000>,
         <0xf0c60000 &CIPS_0_pspmc_0_psv_coresight_apu_ela 0xf0c60000 0x10000>,
         <0xf0ca0000 &CIPS_0_pspmc_0_psv_coresight_apu_cti 0xf0ca0000 0x10000>,
         <0xf0d00000 &CIPS_0_pspmc_0_psv_coresight_a720_dbg 0xf0d00000 0x10000>,
         <0xf0d10000 &CIPS_0_pspmc_0_psv_coresight_a720_cti 0xf0d10000 0x10000>,
         <0xf0d20000 &CIPS_0_pspmc_0_psv_coresight_a720_pmu 0xf0d20000 0x10000>,
         <0xf0d30000 &CIPS_0_pspmc_0_psv_coresight_a720_etm 0xf0d30000 0x10000>,
         <0xf0d40000 &CIPS_0_pspmc_0_psv_coresight_a721_dbg 0xf0d40000 0x10000>,
         <0xf0d50000 &CIPS_0_pspmc_0_psv_coresight_a721_cti 0xf0d50000 0x10000>,
         <0xf0d60000 &CIPS_0_pspmc_0_psv_coresight_a721_pmu 0xf0d60000 0x10000>,
         <0xf0d70000 &CIPS_0_pspmc_0_psv_coresight_a721_etm 0xf0d70000 0x10000>,
         <0xf0f00000 &CIPS_0_pspmc_0_psv_coresight_cpm_rom 0xf0f00000 0x10000>,
         <0xf0f20000 &CIPS_0_pspmc_0_psv_coresight_cpm_fun 0xf0f20000 0x10000>,
         <0xf0f40000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2a 0xf0f40000 0x10000>,
         <0xf0f50000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2b 0xf0f50000 0x10000>,
         <0xf0f60000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2c 0xf0f60000 0x10000>,
         <0xf0f70000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2d 0xf0f70000 0x10000>,
         <0xf0f80000 &CIPS_0_pspmc_0_psv_coresight_cpm_atm 0xf0f80000 0x10000>,
         <0xf0fa0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2a 0xf0fa0000 0x10000>,
         <0xf0fd0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2d 0xf0fd0000 0x10000>,
         <0xf1020000 &gpio1 0xf1020000 0x10000>,
         <0xf1030000 &qspi 0xf1030000 0x10000>,
         <0xf1050000 &sdhci1 0xf1050000 0x10000>,
         <0xf1110000 &CIPS_0_pspmc_0_psv_pmc_global_0 0xf1110000 0x50000>,
         <0xf11c0000 &dma0 0xf11c0000 0x10000>,
         <0xf11d0000 &dma1 0xf11d0000 0x10000>,
         <0xf11e0000 &CIPS_0_pspmc_0_psv_pmc_aes 0xf11e0000 0x10000>,
         <0xf11f0000 &CIPS_0_pspmc_0_psv_pmc_bbram_ctrl 0xf11f0000 0x10000>,
         <0xf1200000 &CIPS_0_pspmc_0_psv_pmc_rsa 0xf1200000 0x10000>,
         <0xf1210000 &CIPS_0_pspmc_0_psv_pmc_sha 0xf1210000 0x10000>,
         <0xf1220000 &CIPS_0_pspmc_0_psv_pmc_slave_boot 0xf1220000 0x10000>,
         <0xf1230000 &CIPS_0_pspmc_0_psv_pmc_trng 0xf1230000 0x10000>,
         <0xf1240000 &CIPS_0_pspmc_0_psv_pmc_efuse_ctrl 0xf1240000 0x10000>,
         <0xf1250000 &CIPS_0_pspmc_0_psv_pmc_efuse_cache 0xf1250000 0x10000>,
         <0xf1260000 &CIPS_0_pspmc_0_psv_crp_0 0xf1260000 0x10000>,
         <0xf1270000 &sysmon0 0xf1270000 0x30000>,
         <0xf12a0000 &rtc 0xf12a0000 0x10000>,
         <0xf12b0000 &CIPS_0_pspmc_0_psv_pmc_cfu_apb_0 0xf12b0000 0x10000>,
         <0xf12d0000 &CIPS_0_pspmc_0_psv_pmc_cfi_cframe_0 0xf12d0000 0x1000>,
         <0xf12f0000 &pmc_xmpu 0xf12f0000 0x10000>,
         <0xf1300000 &pmc_xppu_npi 0xf1300000 0x10000>,
         <0xf1310000 &pmc_xppu 0xf1310000 0x10000>,
         <0xf2100000 &CIPS_0_pspmc_0_psv_pmc_slave_boot_stream 0xf2100000 0x10000>,
         <0xf6000000 &CIPS_0_pspmc_0_psv_pmc_ram_npi 0xf6000000 0x2000000>,
         <0xfd000000 &cci 0xfd000000 0x100000>,
         <0xfd1a0000 &CIPS_0_pspmc_0_psv_crf_0 0xfd1a0000 0x140000>,
         <0xfd360000 &CIPS_0_pspmc_0_psv_fpd_afi_0 0xfd360000 0x10000>,
         <0xfd380000 &CIPS_0_pspmc_0_psv_fpd_afi_2 0xfd380000 0x10000>,
         <0xfd390000 &fpd_xmpu 0xfd390000 0x10000>,
         <0xfd5c0000 &CIPS_0_pspmc_0_psv_apu_0 0xfd5c0000 0x10000>,
         <0xfd5e0000 &CIPS_0_pspmc_0_psv_fpd_cci_0 0xfd5e0000 0x10000>,
         <0xfd5f0000 &CIPS_0_pspmc_0_psv_fpd_smmu_0 0xfd5f0000 0x10000>,
         <0xfd610000 &CIPS_0_pspmc_0_psv_fpd_slcr_0 0xfd610000 0x10000>,
         <0xfd690000 &CIPS_0_pspmc_0_psv_fpd_slcr_secure_0 0xfd690000 0x10000>,
         <0xfd700000 &CIPS_0_pspmc_0_psv_fpd_gpv_0 0xfd700000 0x100000>,
         <0xfd800000 &smmu 0xfd800000 0x800000>,
         <0xfe200000 &dwc3_0 0xfe200000 0x100000>,
         <0xff000000 &serial0 0xff000000 0x10000>,
         <0xff020000 &i2c0 0xff020000 0x10000>,
         <0xff030000 &i2c1 0xff030000 0x10000>,
         <0xff070000 &can1 0xff070000 0x10000>,
         <0xff080000 &CIPS_0_pspmc_0_psv_lpd_iou_slcr_0 0xff080000 0x20000>,
         <0xff0a0000 &CIPS_0_pspmc_0_psv_lpd_iou_secure_slcr_0 0xff0a0000 0x10000>,
         <0xff0c0000 &gem0 0xff0c0000 0x10000>,
         <0xff0d0000 &gem1 0xff0d0000 0x10000>,
         <0xff0e0000 &ttc0 0xff0e0000 0x10000>,
         <0xff0f0000 &ttc1 0xff0f0000 0x10000>,
         <0xff100000 &ttc2 0xff100000 0x10000>,
         <0xff110000 &ttc3 0xff110000 0x10000>,
         <0xff130000 &CIPS_0_pspmc_0_psv_scntr_0 0xff130000 0x10000>,
         <0xff140000 &CIPS_0_pspmc_0_psv_scntrs_0 0xff140000 0x10000>,
         <0xff410000 &CIPS_0_pspmc_0_psv_lpd_slcr_0 0xff410000 0x100000>,
         <0xff510000 &CIPS_0_pspmc_0_psv_lpd_slcr_secure_0 0xff510000 0x40000>,
         <0xff5e0000 &CIPS_0_pspmc_0_psv_crl_0 0xff5e0000 0x300000>,
         <0xff960000 &CIPS_0_pspmc_0_psv_ocm_ctrl 0xff960000 0x10000>,
         <0xff980000 &ocm_xmpu 0xff980000 0x10000>,
         <0xff990000 &lpd_xppu 0xff990000 0x10000>,
         <0xff9a0000 &CIPS_0_pspmc_0_psv_rpu_0 0xff9a0000 0x10000>,
         <0xff9b0000 &CIPS_0_pspmc_0_psv_lpd_afi_0 0xff9b0000 0x10000>,
         <0xff9d0000 &usb0 0xff9d0000 0x10000>,
         <0xffa80000 &lpd_dma_chan0 0xffa80000 0x10000>,
         <0xffa90000 &lpd_dma_chan1 0xffa90000 0x10000>,
         <0xffaa0000 &lpd_dma_chan2 0xffaa0000 0x10000>,
         <0xffab0000 &lpd_dma_chan3 0xffab0000 0x10000>,
         <0xffac0000 &lpd_dma_chan4 0xffac0000 0x10000>,
         <0xffad0000 &lpd_dma_chan5 0xffad0000 0x10000>,
         <0xffae0000 &lpd_dma_chan6 0xffae0000 0x10000>,
         <0xffaf0000 &lpd_dma_chan7 0xffaf0000 0x10000>,
         <0xffc90000 &CIPS_0_pspmc_0_psv_psm_global_reg 0xffc90000 0xf000>,
         <0x00000 &CIPS_0_pspmc_0_psv_r5_tcm_ram_0 0x00000 0x40000>,
         <0xf9000000 &gic_r5 0xf9000000 0x3000>,
         <0xffe40000 &CIPS_0_pspmc_0_psv_r5_0_instruction_cache 0xffe40000 0x10000>,
         <0xffe50000 &CIPS_0_pspmc_0_psv_r5_0_data_cache 0xffe50000 0x10000>,
         <0xffec0000 &CIPS_0_pspmc_0_psv_r5_1_instruction_cache 0xffec0000 0x10000>,
         <0xffed0000 &CIPS_0_pspmc_0_psv_r5_1_data_cache 0xffed0000 0x10000>,
         <0x0000 &CIPS_0_pspmc_0_psv_r5_1_atcm 0x0000 0x10000>,
         <0x20000 &CIPS_0_pspmc_0_psv_r5_1_btcm 0x20000 0x10000>;
  #ranges-address-cells = <0x1>;
  #ranges-size-cells = <0x1>;
 };
 cpus_microblaze_0: cpus_microblaze@0 {
  compatible = "cpus,cluster";
  address-map = <0xf0000000 &amba 0xf0000000 0x10000000>,
         <0x00000000 &noc_ddr4_ddr_memory 0x00000000 0x80000000>,
         <0xff320000 &ipi_pmc 0xff320000 0x10000>,
         <0xff390000 &ipi_pmc_nobuf 0xff390000 0x10000>,
         <0xFFFC0000 &CIPS_0_pspmc_0_psv_ocm_ram_0_memory 0xFFFC0000 0x40000>,
         <0xa4000000 &axi_intc_cascaded_1 0xa4000000 0x10000>,
         <0xa4010000 &dummy_slave_0 0xa4010000 0x10000>,
         <0xa4020000 &dummy_slave_1 0xa4020000 0x10000>,
         <0xa4030000 &dummy_slave_2 0xa4030000 0x10000>,
         <0xa4040000 &dummy_slave_3 0xa4040000 0x10000>,
         <0xa5000000 &axi_intc_parent 0xa5000000 0x10000>,
         <0xf0310000 &CIPS_0_pspmc_0_psv_pmc_ppu1_mdm_0 0xf0310000 0x8000>,
         <0xf08d0000 &CIPS_0_pspmc_0_psv_coresight_pmc_cti 0xf08d0000 0x10000>,
         <0xf0980000 &CIPS_0_pspmc_0_psv_coresight_lpd_atm 0xf0980000 0x10000>,
         <0xf09d0000 &CIPS_0_pspmc_0_psv_coresight_lpd_cti 0xf09d0000 0x10000>,
         <0xf0a10000 &CIPS_0_pspmc_0_psv_coresight_r50_cti 0xf0a10000 0x10000>,
         <0xf0a50000 &CIPS_0_pspmc_0_psv_coresight_r51_cti 0xf0a50000 0x10000>,
         <0xf0b70000 &CIPS_0_pspmc_0_psv_coresight_fpd_stm 0xf0b70000 0x10000>,
         <0xf0b80000 &CIPS_0_pspmc_0_psv_coresight_fpd_atm 0xf0b80000 0x10000>,
         <0xf0bb0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1b 0xf0bb0000 0x10000>,
         <0xf0bc0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1c 0xf0bc0000 0x10000>,
         <0xf0bd0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1d 0xf0bd0000 0x10000>,
         <0xf0c20000 &CIPS_0_pspmc_0_psv_coresight_apu_fun 0xf0c20000 0x10000>,
         <0xf0c30000 &CIPS_0_pspmc_0_psv_coresight_apu_etf 0xf0c30000 0x10000>,
         <0xf0c60000 &CIPS_0_pspmc_0_psv_coresight_apu_ela 0xf0c60000 0x10000>,
         <0xf0ca0000 &CIPS_0_pspmc_0_psv_coresight_apu_cti 0xf0ca0000 0x10000>,
         <0xf0d00000 &CIPS_0_pspmc_0_psv_coresight_a720_dbg 0xf0d00000 0x10000>,
         <0xf0d10000 &CIPS_0_pspmc_0_psv_coresight_a720_cti 0xf0d10000 0x10000>,
         <0xf0d20000 &CIPS_0_pspmc_0_psv_coresight_a720_pmu 0xf0d20000 0x10000>,
         <0xf0d30000 &CIPS_0_pspmc_0_psv_coresight_a720_etm 0xf0d30000 0x10000>,
         <0xf0d40000 &CIPS_0_pspmc_0_psv_coresight_a721_dbg 0xf0d40000 0x10000>,
         <0xf0d50000 &CIPS_0_pspmc_0_psv_coresight_a721_cti 0xf0d50000 0x10000>,
         <0xf0d60000 &CIPS_0_pspmc_0_psv_coresight_a721_pmu 0xf0d60000 0x10000>,
         <0xf0d70000 &CIPS_0_pspmc_0_psv_coresight_a721_etm 0xf0d70000 0x10000>,
         <0xf0f00000 &CIPS_0_pspmc_0_psv_coresight_cpm_rom 0xf0f00000 0x10000>,
         <0xf0f20000 &CIPS_0_pspmc_0_psv_coresight_cpm_fun 0xf0f20000 0x10000>,
         <0xf0f40000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2a 0xf0f40000 0x10000>,
         <0xf0f50000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2b 0xf0f50000 0x10000>,
         <0xf0f60000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2c 0xf0f60000 0x10000>,
         <0xf0f70000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2d 0xf0f70000 0x10000>,
         <0xf0f80000 &CIPS_0_pspmc_0_psv_coresight_cpm_atm 0xf0f80000 0x10000>,
         <0xf0fa0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2a 0xf0fa0000 0x10000>,
         <0xf0fd0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2d 0xf0fd0000 0x10000>,
         <0xf1020000 &gpio1 0xf1020000 0x10000>,
         <0xf1030000 &qspi 0xf1030000 0x10000>,
         <0xf1050000 &sdhci1 0xf1050000 0x10000>,
         <0xf1110000 &CIPS_0_pspmc_0_psv_pmc_global_0 0xf1110000 0x50000>,
         <0xf11c0000 &dma0 0xf11c0000 0x10000>,
         <0xf11d0000 &dma1 0xf11d0000 0x10000>,
         <0xf11e0000 &CIPS_0_pspmc_0_psv_pmc_aes 0xf11e0000 0x10000>,
         <0xf11f0000 &CIPS_0_pspmc_0_psv_pmc_bbram_ctrl 0xf11f0000 0x10000>,
         <0xf1200000 &CIPS_0_pspmc_0_psv_pmc_rsa 0xf1200000 0x10000>,
         <0xf1210000 &CIPS_0_pspmc_0_psv_pmc_sha 0xf1210000 0x10000>,
         <0xf1220000 &CIPS_0_pspmc_0_psv_pmc_slave_boot 0xf1220000 0x10000>,
         <0xf1230000 &CIPS_0_pspmc_0_psv_pmc_trng 0xf1230000 0x10000>,
         <0xf1240000 &CIPS_0_pspmc_0_psv_pmc_efuse_ctrl 0xf1240000 0x10000>,
         <0xf1250000 &CIPS_0_pspmc_0_psv_pmc_efuse_cache 0xf1250000 0x10000>,
         <0xf1260000 &CIPS_0_pspmc_0_psv_crp_0 0xf1260000 0x10000>,
         <0xf1270000 &sysmon0 0xf1270000 0x30000>,
         <0xf12a0000 &rtc 0xf12a0000 0x10000>,
         <0xf12b0000 &CIPS_0_pspmc_0_psv_pmc_cfu_apb_0 0xf12b0000 0x10000>,
         <0xf12d0000 &CIPS_0_pspmc_0_psv_pmc_cfi_cframe_0 0xf12d0000 0x1000>,
         <0xf12f0000 &pmc_xmpu 0xf12f0000 0x10000>,
         <0xf1300000 &pmc_xppu_npi 0xf1300000 0x10000>,
         <0xf1310000 &pmc_xppu 0xf1310000 0x10000>,
         <0xf2100000 &CIPS_0_pspmc_0_psv_pmc_slave_boot_stream 0xf2100000 0x10000>,
         <0xf6000000 &CIPS_0_pspmc_0_psv_pmc_ram_npi 0xf6000000 0x2000000>,
         <0 &CIPS_0_pspmc_0_psv_cpm 0 0xfd000000>,
         <0xfd000000 &cci 0xfd000000 0x100000>,
         <0xfd1a0000 &CIPS_0_pspmc_0_psv_crf_0 0xfd1a0000 0x140000>,
         <0xfd360000 &CIPS_0_pspmc_0_psv_fpd_afi_0 0xfd360000 0x10000>,
         <0xfd380000 &CIPS_0_pspmc_0_psv_fpd_afi_2 0xfd380000 0x10000>,
         <0xfd390000 &fpd_xmpu 0xfd390000 0x10000>,
         <0xfd5e0000 &CIPS_0_pspmc_0_psv_fpd_cci_0 0xfd5e0000 0x10000>,
         <0xfd5f0000 &CIPS_0_pspmc_0_psv_fpd_smmu_0 0xfd5f0000 0x10000>,
         <0xfd610000 &CIPS_0_pspmc_0_psv_fpd_slcr_0 0xfd610000 0x10000>,
         <0xfd690000 &CIPS_0_pspmc_0_psv_fpd_slcr_secure_0 0xfd690000 0x10000>,
         <0xfd700000 &CIPS_0_pspmc_0_psv_fpd_gpv_0 0xfd700000 0x100000>,
         <0xfd800000 &smmu 0xfd800000 0x800000>,
         <0xfe200000 &dwc3_0 0xfe200000 0x100000>,
         <0xff000000 &serial0 0xff000000 0x10000>,
         <0xff020000 &i2c0 0xff020000 0x10000>,
         <0xff030000 &i2c1 0xff030000 0x10000>,
         <0xff070000 &can1 0xff070000 0x10000>,
         <0xff080000 &CIPS_0_pspmc_0_psv_lpd_iou_slcr_0 0xff080000 0x20000>,
         <0xff0a0000 &CIPS_0_pspmc_0_psv_lpd_iou_secure_slcr_0 0xff0a0000 0x10000>,
         <0xff0c0000 &gem0 0xff0c0000 0x10000>,
         <0xff0d0000 &gem1 0xff0d0000 0x10000>,
         <0xff0e0000 &ttc0 0xff0e0000 0x10000>,
         <0xff0f0000 &ttc1 0xff0f0000 0x10000>,
         <0xff100000 &ttc2 0xff100000 0x10000>,
         <0xff110000 &ttc3 0xff110000 0x10000>,
         <0xff130000 &CIPS_0_pspmc_0_psv_scntr_0 0xff130000 0x10000>,
         <0xff140000 &CIPS_0_pspmc_0_psv_scntrs_0 0xff140000 0x10000>,
         <0xff410000 &CIPS_0_pspmc_0_psv_lpd_slcr_0 0xff410000 0x100000>,
         <0xff510000 &CIPS_0_pspmc_0_psv_lpd_slcr_secure_0 0xff510000 0x40000>,
         <0xff5e0000 &CIPS_0_pspmc_0_psv_crl_0 0xff5e0000 0x300000>,
         <0xff960000 &CIPS_0_pspmc_0_psv_ocm_ctrl 0xff960000 0x10000>,
         <0xff980000 &ocm_xmpu 0xff980000 0x10000>,
         <0xff990000 &lpd_xppu 0xff990000 0x10000>,
         <0xff9b0000 &CIPS_0_pspmc_0_psv_lpd_afi_0 0xff9b0000 0x10000>,
         <0xff9d0000 &usb0 0xff9d0000 0x10000>,
         <0xffa80000 &lpd_dma_chan0 0xffa80000 0x10000>,
         <0xffa90000 &lpd_dma_chan1 0xffa90000 0x10000>,
         <0xffaa0000 &lpd_dma_chan2 0xffaa0000 0x10000>,
         <0xffab0000 &lpd_dma_chan3 0xffab0000 0x10000>,
         <0xffac0000 &lpd_dma_chan4 0xffac0000 0x10000>,
         <0xffad0000 &lpd_dma_chan5 0xffad0000 0x10000>,
         <0xffae0000 &lpd_dma_chan6 0xffae0000 0x10000>,
         <0xffaf0000 &lpd_dma_chan7 0xffaf0000 0x10000>,
         <0xffc90000 &CIPS_0_pspmc_0_psv_psm_global_reg 0xffc90000 0xf000>,
         <0xffe00000 &psv_r5_0_atcm_global 0xffe00000 0x40000>,
         <0xffe90000 &psv_r5_1_atcm_global 0xffe90000 0x10000>,
         <0xffeb0000 &psv_r5_1_btcm_global 0xffeb0000 0x10000>,
         <0xf0083000 &CIPS_0_pspmc_0_psv_pmc_tmr_inject_0 0xf0083000 0x1000>,
         <0xf0200000 &CIPS_0_pspmc_0_psv_pmc_ram_instr_cntlr 0xf0200000 0x40000>,
         <0xf0240000 &CIPS_0_pspmc_0_psv_pmc_ram_data_cntlr 0xf0240000 0x20000>,
         <0xf0280000 &iomodule0 0xf0280000 0x1000>,
         <0xf0283000 &CIPS_0_pspmc_0_psv_pmc_tmr_manager_0 0xf0283000 0x1000>;
  #ranges-address-cells = <0x1>;
  #ranges-size-cells = <0x1>;
 };
 cpus_microblaze_1: cpus_microblaze@1 {
  compatible = "cpus,cluster";
  address-map = <0xf0000000 &amba 0xf0000000 0x10000000>,
         <0x00000000 &noc_ddr4_ddr_memory 0x00000000 0x80000000>,
         <0xff310000 &ipi_psm 0xff310000 0x10000>,
         <0xFFFC0000 &CIPS_0_pspmc_0_psv_ocm_ram_0_memory 0xFFFC0000 0x40000>,
         <0xa4000000 &axi_intc_cascaded_1 0xa4000000 0x10000>,
         <0xa4010000 &dummy_slave_0 0xa4010000 0x10000>,
         <0xa4020000 &dummy_slave_1 0xa4020000 0x10000>,
         <0xa4030000 &dummy_slave_2 0xa4030000 0x10000>,
         <0xa4040000 &dummy_slave_3 0xa4040000 0x10000>,
         <0xa5000000 &axi_intc_parent 0xa5000000 0x10000>,
         <0xf0310000 &CIPS_0_pspmc_0_psv_pmc_ppu1_mdm_0 0xf0310000 0x8000>,
         <0xf08d0000 &CIPS_0_pspmc_0_psv_coresight_pmc_cti 0xf08d0000 0x10000>,
         <0xf0980000 &CIPS_0_pspmc_0_psv_coresight_lpd_atm 0xf0980000 0x10000>,
         <0xf09d0000 &CIPS_0_pspmc_0_psv_coresight_lpd_cti 0xf09d0000 0x10000>,
         <0xf0a10000 &CIPS_0_pspmc_0_psv_coresight_r50_cti 0xf0a10000 0x10000>,
         <0xf0a50000 &CIPS_0_pspmc_0_psv_coresight_r51_cti 0xf0a50000 0x10000>,
         <0xf0b70000 &CIPS_0_pspmc_0_psv_coresight_fpd_stm 0xf0b70000 0x10000>,
         <0xf0b80000 &CIPS_0_pspmc_0_psv_coresight_fpd_atm 0xf0b80000 0x10000>,
         <0xf0bb0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1b 0xf0bb0000 0x10000>,
         <0xf0bc0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1c 0xf0bc0000 0x10000>,
         <0xf0bd0000 &CIPS_0_pspmc_0_psv_coresight_fpd_cti1d 0xf0bd0000 0x10000>,
         <0xf0c20000 &CIPS_0_pspmc_0_psv_coresight_apu_fun 0xf0c20000 0x10000>,
         <0xf0c30000 &CIPS_0_pspmc_0_psv_coresight_apu_etf 0xf0c30000 0x10000>,
         <0xf0c60000 &CIPS_0_pspmc_0_psv_coresight_apu_ela 0xf0c60000 0x10000>,
         <0xf0ca0000 &CIPS_0_pspmc_0_psv_coresight_apu_cti 0xf0ca0000 0x10000>,
         <0xf0d00000 &CIPS_0_pspmc_0_psv_coresight_a720_dbg 0xf0d00000 0x10000>,
         <0xf0d10000 &CIPS_0_pspmc_0_psv_coresight_a720_cti 0xf0d10000 0x10000>,
         <0xf0d20000 &CIPS_0_pspmc_0_psv_coresight_a720_pmu 0xf0d20000 0x10000>,
         <0xf0d30000 &CIPS_0_pspmc_0_psv_coresight_a720_etm 0xf0d30000 0x10000>,
         <0xf0d40000 &CIPS_0_pspmc_0_psv_coresight_a721_dbg 0xf0d40000 0x10000>,
         <0xf0d50000 &CIPS_0_pspmc_0_psv_coresight_a721_cti 0xf0d50000 0x10000>,
         <0xf0d60000 &CIPS_0_pspmc_0_psv_coresight_a721_pmu 0xf0d60000 0x10000>,
         <0xf0d70000 &CIPS_0_pspmc_0_psv_coresight_a721_etm 0xf0d70000 0x10000>,
         <0xf0f00000 &CIPS_0_pspmc_0_psv_coresight_cpm_rom 0xf0f00000 0x10000>,
         <0xf0f20000 &CIPS_0_pspmc_0_psv_coresight_cpm_fun 0xf0f20000 0x10000>,
         <0xf0f40000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2a 0xf0f40000 0x10000>,
         <0xf0f50000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2b 0xf0f50000 0x10000>,
         <0xf0f60000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2c 0xf0f60000 0x10000>,
         <0xf0f70000 &CIPS_0_pspmc_0_psv_coresight_cpm_ela2d 0xf0f70000 0x10000>,
         <0xf0f80000 &CIPS_0_pspmc_0_psv_coresight_cpm_atm 0xf0f80000 0x10000>,
         <0xf0fa0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2a 0xf0fa0000 0x10000>,
         <0xf0fd0000 &CIPS_0_pspmc_0_psv_coresight_cpm_cti2d 0xf0fd0000 0x10000>,
         <0xf1020000 &gpio1 0xf1020000 0x10000>,
         <0xf1030000 &qspi 0xf1030000 0x10000>,
         <0xf1050000 &sdhci1 0xf1050000 0x10000>,
         <0xf1110000 &CIPS_0_pspmc_0_psv_pmc_global_0 0xf1110000 0x50000>,
         <0xf11c0000 &dma0 0xf11c0000 0x10000>,
         <0xf11d0000 &dma1 0xf11d0000 0x10000>,
         <0xf11e0000 &CIPS_0_pspmc_0_psv_pmc_aes 0xf11e0000 0x10000>,
         <0xf11f0000 &CIPS_0_pspmc_0_psv_pmc_bbram_ctrl 0xf11f0000 0x10000>,
         <0xf1200000 &CIPS_0_pspmc_0_psv_pmc_rsa 0xf1200000 0x10000>,
         <0xf1210000 &CIPS_0_pspmc_0_psv_pmc_sha 0xf1210000 0x10000>,
         <0xf1220000 &CIPS_0_pspmc_0_psv_pmc_slave_boot 0xf1220000 0x10000>,
         <0xf1230000 &CIPS_0_pspmc_0_psv_pmc_trng 0xf1230000 0x10000>,
         <0xf1240000 &CIPS_0_pspmc_0_psv_pmc_efuse_ctrl 0xf1240000 0x10000>,
         <0xf1250000 &CIPS_0_pspmc_0_psv_pmc_efuse_cache 0xf1250000 0x10000>,
         <0xf1260000 &CIPS_0_pspmc_0_psv_crp_0 0xf1260000 0x10000>,
         <0xf1270000 &sysmon0 0xf1270000 0x30000>,
         <0xf12a0000 &rtc 0xf12a0000 0x10000>,
         <0xf12b0000 &CIPS_0_pspmc_0_psv_pmc_cfu_apb_0 0xf12b0000 0x10000>,
         <0xf12d0000 &CIPS_0_pspmc_0_psv_pmc_cfi_cframe_0 0xf12d0000 0x1000>,
         <0xf12f0000 &pmc_xmpu 0xf12f0000 0x10000>,
         <0xf1300000 &pmc_xppu_npi 0xf1300000 0x10000>,
         <0xf1310000 &pmc_xppu 0xf1310000 0x10000>,
         <0xf2100000 &CIPS_0_pspmc_0_psv_pmc_slave_boot_stream 0xf2100000 0x10000>,
         <0xf6000000 &CIPS_0_pspmc_0_psv_pmc_ram_npi 0xf6000000 0x2000000>,
         <0xfd000000 &cci 0xfd000000 0x100000>,
         <0xfd1a0000 &CIPS_0_pspmc_0_psv_crf_0 0xfd1a0000 0x140000>,
         <0xfd360000 &CIPS_0_pspmc_0_psv_fpd_afi_0 0xfd360000 0x10000>,
         <0xfd380000 &CIPS_0_pspmc_0_psv_fpd_afi_2 0xfd380000 0x10000>,
         <0xfd390000 &fpd_xmpu 0xfd390000 0x10000>,
         <0xfd5e0000 &CIPS_0_pspmc_0_psv_fpd_cci_0 0xfd5e0000 0x10000>,
         <0xfd5f0000 &CIPS_0_pspmc_0_psv_fpd_smmu_0 0xfd5f0000 0x10000>,
         <0xfd610000 &CIPS_0_pspmc_0_psv_fpd_slcr_0 0xfd610000 0x10000>,
         <0xfd690000 &CIPS_0_pspmc_0_psv_fpd_slcr_secure_0 0xfd690000 0x10000>,
         <0xfd700000 &CIPS_0_pspmc_0_psv_fpd_gpv_0 0xfd700000 0x100000>,
         <0xfd800000 &smmu 0xfd800000 0x800000>,
         <0xfe200000 &dwc3_0 0xfe200000 0x100000>,
         <0xff000000 &serial0 0xff000000 0x10000>,
         <0xff020000 &i2c0 0xff020000 0x10000>,
         <0xff030000 &i2c1 0xff030000 0x10000>,
         <0xff070000 &can1 0xff070000 0x10000>,
         <0xff080000 &CIPS_0_pspmc_0_psv_lpd_iou_slcr_0 0xff080000 0x20000>,
         <0xff0a0000 &CIPS_0_pspmc_0_psv_lpd_iou_secure_slcr_0 0xff0a0000 0x10000>,
         <0xff0c0000 &gem0 0xff0c0000 0x10000>,
         <0xff0d0000 &gem1 0xff0d0000 0x10000>,
         <0xff0e0000 &ttc0 0xff0e0000 0x10000>,
         <0xff0f0000 &ttc1 0xff0f0000 0x10000>,
         <0xff100000 &ttc2 0xff100000 0x10000>,
         <0xff110000 &ttc3 0xff110000 0x10000>,
         <0xff130000 &CIPS_0_pspmc_0_psv_scntr_0 0xff130000 0x10000>,
         <0xff140000 &CIPS_0_pspmc_0_psv_scntrs_0 0xff140000 0x10000>,
         <0xff410000 &CIPS_0_pspmc_0_psv_lpd_slcr_0 0xff410000 0x100000>,
         <0xff510000 &CIPS_0_pspmc_0_psv_lpd_slcr_secure_0 0xff510000 0x40000>,
         <0xff5e0000 &CIPS_0_pspmc_0_psv_crl_0 0xff5e0000 0x300000>,
         <0xff960000 &CIPS_0_pspmc_0_psv_ocm_ctrl 0xff960000 0x10000>,
         <0xff980000 &ocm_xmpu 0xff980000 0x10000>,
         <0xff990000 &lpd_xppu 0xff990000 0x10000>,
         <0xff9b0000 &CIPS_0_pspmc_0_psv_lpd_afi_0 0xff9b0000 0x10000>,
         <0xff9d0000 &usb0 0xff9d0000 0x10000>,
         <0xffa80000 &lpd_dma_chan0 0xffa80000 0x10000>,
         <0xffa90000 &lpd_dma_chan1 0xffa90000 0x10000>,
         <0xffaa0000 &lpd_dma_chan2 0xffaa0000 0x10000>,
         <0xffab0000 &lpd_dma_chan3 0xffab0000 0x10000>,
         <0xffac0000 &lpd_dma_chan4 0xffac0000 0x10000>,
         <0xffad0000 &lpd_dma_chan5 0xffad0000 0x10000>,
         <0xffae0000 &lpd_dma_chan6 0xffae0000 0x10000>,
         <0xffaf0000 &lpd_dma_chan7 0xffaf0000 0x10000>,
         <0xffc90000 &CIPS_0_pspmc_0_psv_psm_global_reg 0xffc90000 0xf000>,
         <0xffe00000 &psv_r5_0_atcm_global 0xffe00000 0x40000>,
         <0xffe90000 &psv_r5_1_atcm_global 0xffe90000 0x10000>,
         <0xffeb0000 &psv_r5_1_btcm_global 0xffeb0000 0x10000>,
         <0xffc00000 &CIPS_0_pspmc_0_psv_psm_ram_instr_cntlr 0xffc00000 0x20000>,
         <0xffc20000 &CIPS_0_pspmc_0_psv_psm_ram_data_cntlr 0xffc20000 0x20000>,
         <0xffc80000 &CIPS_0_pspmc_0_psv_psm_iomodule_0 0xffc80000 0x8000>,
         <0xffcc0000 &CIPS_0_pspmc_0_psv_psm_tmr_manager_0 0xffcc0000 0x10000>,
         <0xffcd0000 &CIPS_0_pspmc_0_psv_psm_tmr_inject_0 0xffcd0000 0x10000>;
  #ranges-address-cells = <0x1>;
  #ranges-size-cells = <0x1>;
 };
};
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vck190-rev1.1-x-ebm-01-reva.dtsi" 1
# 11 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vck190-rev1.1-x-ebm-01-reva.dtsi"
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-rev1.1-x-ebm-01-reva.dtsi" 1
# 11 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-rev1.1-x-ebm-01-reva.dtsi"
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-rev1.1.dtsi" 1
# 11 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-rev1.1.dtsi"
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-reva.dtsi" 1
# 11 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-reva.dtsi"
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/include/dt-bindings/gpio/gpio.h" 1
# 12 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-reva.dtsi" 2

/ {
 compatible = "xlnx,versal-vmk180-revA", "xlnx,versal";
 model = "Xilinx Versal vmk180 Eval board revA";


 chosen {
  bootargs = "console=ttyAMA0 earlycon=pl011,mmio32,0xFF000000,115200n8 clk_ignore_unused";
  stdout-path = "serial0:115200";
 };

 aliases {
  serial0 = &serial0;
  serial2 = &dcc;
  ethernet0 = &gem0;
  ethernet1 = &gem1;
  i2c0 = &i2c0;
  i2c1 = &i2c1;
  mmc0 = &sdhci1;
  spi0 = &qspi;
  usb0 = &usb0;
  rtc0 = &rtc;
 };
};



&cpm_pciea {
 reset-gpios = <&gpio1 38 1>;
};


&sdhci1 {
 xlnx,mio-bank = <1>;
 no-1-8-v;
};


&gem0 {
 phy-handle = <&phy1>;
 phy-mode = "rgmii-id";
 mdio: mdio {
  #address-cells = <1>;
  #size-cells = <0>;

  phy1: ethernet-phy@1 {
   #phy-cells = <1>;
   compatible = "ethernet-phy-id2000.a231";
   reg = <1>;
   ti,rx-internal-delay = <0xb>;
   ti,tx-internal-delay = <0xa>;
   ti,fifo-depth = <1>;
   ti,dp83867-rxctrl-strap-quirk;
   reset-assert-us = <100>;
   reset-deassert-us = <280>;
   reset-gpios = <&gpio1 48 1>;
  };
  phy2: ethernet-phy@2 {
   #phy-cells = <1>;
   compatible = "ethernet-phy-id2000.a231";
   reg = <2>;
   ti,rx-internal-delay = <0xb>;
   ti,tx-internal-delay = <0xa>;
   ti,fifo-depth = <1>;
   ti,dp83867-rxctrl-strap-quirk;
   reset-assert-us = <100>;
   reset-deassert-us = <280>;
   reset-gpios = <&gpio1 49 1>;
  };
 };
};

&gem1 {
 phy-handle = <&phy2>;
 phy-mode = "rgmii-id";
};


&dwc3_0 {
 dr_mode = "host";
 maximum-speed = "high-speed";
 snps,dis_u2_susphy_quirk;
 snps,dis_u3_susphy_quirk;
 snps,usb3_lpm_capable;
};
# 12 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-rev1.1.dtsi" 2

/ {
 compatible = "xlnx,versal-vmk180-rev1.1", "xlnx,versal";
 model = "Xilinx Versal vmk180 Eval board rev1.1";
};

&sdhci1 {
 clk-phase-sd-hs = <111>, <48>;
 clk-phase-uhs-sdr25 = <114>, <48>;
 clk-phase-uhs-ddr50 = <126>, <36>;
};
# 12 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-rev1.1-x-ebm-01-reva.dtsi" 2

/ {
 compatible = "xlnx,versal-vmk180-rev1.1-x-ebm-01-revA",
       "xlnx,versal-vmk180-rev1.1", "xlnx,versal";
 model = "Xilinx Versal vmk180 Eval board rev1.1 (QSPI)";
};

&qspi {
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-x-ebm-01-reva.dtsi" 1
# 11 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-x-ebm-01-reva.dtsi"
num-cs = <2>;
spi-tx-bus-width = <4>;
spi-rx-bus-width = <4>;
#address-cells = <1>;
#size-cells = <0>;
flash@0 {
 #address-cells = <1>;
 #size-cells = <1>;
 compatible = "m25p80", "jedec,spi-nor";
 reg = <0>, <1>;
 parallel-memories = /bits/ 64 <0x8000000 0x8000000>;
 spi-tx-bus-width = <4>;
 spi-rx-bus-width = <4>;
 spi-max-frequency = <150000000>;
 partition@0 {
  label = "spi0-flash0";
  reg = <0x0 0x10000000>;
 };
};
# 21 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vmk180-rev1.1-x-ebm-01-reva.dtsi" 2
};
# 12 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/logs/bsps/xilinx-vck190-2025.1/project-spec/hw-description/versal-vck190-rev1.1-x-ebm-01-reva.dtsi" 2

/ {
 compatible = "xlnx,versal-vck190-rev1.1-x-ebm-01-revA",
       "xlnx,versal-vck190-rev1.1", "xlnx,versal";
 model = "Xilinx Versal vck190 Eval board rev1.1 (QSPI)";
};
# 676 "/tmp/tmppczvninu" 2
