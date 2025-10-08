# Versal MRMAC Ethernet TRD 

## Design Summary

This project utilizes Versal Devices Integrated 100G Multirate Ethernet MAC Subsystem. This design provides 4 ethernet interfaces routed to QSFP a VCK190 board WITH PTP Support. 


## Required Hardware
- VCK190
- QSFP DAC
- 10G/25G capable link partner

## Build Instructions
### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **PetaLinux:**

Enter the 'Software/PetaLinux/' directory. From the command line run the following:
1. Create a sdt.tcl file:
   ```
   # sdt.tcl
   set xsa [lindex $argv 0]
   set outdir [lindex $argv 1]
   exec rm -rf $outdir
   sdtgen set_dt_param -xsa $xsa -dir $outdir -board_dts versal-vck190-reva-x-ebm-01-reva
   sdtgen generate_sdt
   ``` 
2. Create a output directory; for example sdt_outdir
3. Run xsct to generate hw description for Petalinux
   ```
   xsct sdt.tcl design1_wrapper.xsa sdt_outdir
   ```
4.`petalinux-config --get-hw-description <PATH_TO_SDT_OUTDIR> --silentconfig`

followed by:

Enable `iperf3` under user packages in `petalinux-config -c rootfs`

followed by:

`petalinux-build`

The PetaLinux project will be rebuilt using the configurations in the PetaLinux directory. To reduce repo size, the project is shipped pre-configured, but un-built.

Once the build is complete, the built images can be found in the PetaLinux/images/linux/ directory. To package these images for SD boot, run the following from the PetaLinux directory:

`petalinux-package --boot --u-boot --force`

Once packaged, the `boot.scr`, `BOOT.bin` and `image.ub` files (in the PetaLinux/images/linux directory) can be copied to an SD card, and used to boot.

## **Validation**

### Kernel:
**NOTE:** The interfaces are assigned as follows:

- eth0 -> 25G
- eth1 -> 25G
- eth2 -> 25G
- eth3 -> 25G
- end0 -> 1G (PS-GEM)
- end1 -> 1G (PS-GEM)



```
xilinx-vck190-20232:/home/petalinux# ifconfig
eth0      Link encap:Ethernet  HWaddr 00:0A:35:00:00:00  
          inet addr:192.168.1.1  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:0/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:332374 errors:0 dropped:0 overruns:0 frame:0
          TX packets:332387 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:32742642 (31.2 MiB)  TX bytes:32745948 (31.2 MiB)

eth1      Link encap:Ethernet  HWaddr 00:0A:35:00:00:01  
          inet addr:192.168.4.2  Bcast:192.168.4.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:1/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:68121 errors:0 dropped:0 overruns:0 frame:0
          TX packets:68122 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:6687620 (6.3 MiB)  TX bytes:6688564 (6.3 MiB)
 
eth2      Link encap:Ethernet  HWaddr 00:0A:35:00:00:02  
          inet addr:192.168.3.2  Bcast:192.168.3.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:2/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:96594 errors:0 dropped:0 overruns:0 frame:0
          TX packets:96595 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:9478608 (9.0 MiB)  TX bytes:9479552 (9.0 MiB)

eth3      Link encap:Ethernet  HWaddr 00:0A:35:00:00:03  
          inet addr:192.168.2.101  Bcast:192.168.2.255  Mask:255.255.255.0
          inet6 addr: fe80::20a:35ff:fe00:3/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:88269 errors:0 dropped:0 overruns:0 frame:0
          TX packets:88263 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:8675104 (8.2 MiB)  TX bytes:8675668 (8.2 MiB)
 
eth0 
xilinx-vck190-20232:/home/petalinux# ping -A -q 192.168.1.1
PING 192.168.1.1 (192.168.1.1): 56 data bytes
^C
--- 192.168.1.1 ping statistics ---
34523 packets transmitted, 34522 packets received, 0% packet loss
round-trip min/avg/max = 0.032/0.036/0.254 ms

eth1
xilinx-vck190-20232:/home/petalinux# ping -A -q 192.168.4.2
PING 192.168.4.2 (192.168.4.2): 56 data bytes
^C
--- 192.168.4.2 ping statistics ---
32355 packets transmitted, 32354 packets received, 0% packet loss
round-trip min/avg/max = 0.035/0.044/0.346 ms

eth2
xilinx-vck190-20232:/home/petalinux# ping -A -q 192.168.3.2  
PING 192.168.3.2 (192.168.3.2): 56 data bytes
^C
--- 192.168.3.2 ping statistics ---
40183 packets transmitted, 40182 packets received, 0% packet loss
round-trip min/avg/max = 0.034/0.043/0.160 ms

eth3
xilinx-vck190-20232:/home/petalinux# ping -A -q 192.168.2.101
PING 192.168.2.101 (192.168.2.101): 56 data bytes
^C
--- 192.168.2.101 ping statistics ---
46858 packets transmitted, 46857 packets received, 0% packet loss
round-trip min/avg/max = 0.034/0.044/0.163 ms

```
### Performance:
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.
```
xilinx-vck190-20232:/home/petalinux# iperf3 -c 192.168.3.1
Connecting to host 192.168.3.1, port 5201
[  5] local 192.168.3.2 port 44644 connected to 192.168.3.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   247 MBytes  2.07 Gbits/sec  2417    139 KBytes       
[  5]   1.00-2.00   sec   239 MBytes  2.00 Gbits/sec  2790    106 KBytes       
[  5]   2.00-3.00   sec   240 MBytes  2.01 Gbits/sec  2454    117 KBytes       
[  5]   3.00-4.00   sec   240 MBytes  2.01 Gbits/sec  2448    123 KBytes       
[  5]   4.00-5.00   sec   238 MBytes  1.99 Gbits/sec  2877    112 KBytes       
[  5]   5.00-6.00   sec   240 MBytes  2.01 Gbits/sec  2194    126 KBytes       
[  5]   6.00-7.00   sec   233 MBytes  1.95 Gbits/sec  2943    129 KBytes       
[  5]   7.00-8.00   sec   239 MBytes  2.00 Gbits/sec  2917    109 KBytes       
[  5]   8.00-9.00   sec   239 MBytes  2.00 Gbits/sec  2660    126 KBytes       
[  5]   9.00-10.00  sec   240 MBytes  2.01 Gbits/sec  3203    129 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  2.34 GBytes  2.01 Gbits/sec  26903             sender
[  5]   0.00-10.00  sec  2.33 GBytes  2.01 Gbits/sec                  receiver
iperf Done.
```

###ptp4l
**NOTE:** When testing on board-to-board setup with two same boards running same Petalinux image with local HW addr coming from Device Tree, it's important to change the HW addr on one side before running ptp4l application.
```
Petalinux25:/home/petalinux# ifconfig eth0 down
Petalinux25:/home/petalinux# ifconfig eth0 hw ether 00:0A:35:00:00:01
Petalinux25:/home/petalinux# ifconfig eth0 up
```
Master side:
```
Petalinux25:/home/petalinux# ptp4l -i eth0 -m                  
ptp4l[3865.357]: selected /dev/ptp1 as PTP clock
ptp4l[3865.358]: port 1 (eth0): INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[3865.358]: port 0 (/var/run/ptp4l): INITIALIZING to LISTENING on INIT_COMP
ptp4l[3865.358]: port 0 (/var/run/ptp4lro): INITIALIZING to LISTENING on INIT_CO
ptp4l[3872.424]: port 1 (eth0): LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
ptp4l[3872.424]: selected local clock 000a35.fffe.000001 as best master
ptp4l[3872.424]: port 1 (eth0): assuming the grand master role
```
Slave side:
```
Petalinux25:/home/petalinux#  ptp4l -i eth0 -m -s                  
ptp4l[3868.202]: selected /dev/ptp1 as PTP clock
ptp4l[3868.203]: port 1 (eth0): INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[3868.203]: port 0 (/var/run/ptp4l): INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[3868.203]: port 0 (/var/run/ptp4lro): INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[3868.493]: port 1 (eth0): new foreign master 000a35.fffe.000001-1
ptp4l[3872.493]: selected best master clock 000a35.fffe.000001
ptp4l[3872.493]: port 1 (eth0): LISTENING to UNCALIBRATED on RS_SLAVE
ptp4l[3874.492]: master offset      -2413 s0 freq    +127 path delay        86
ptp4l[3875.492]: master offset      -2413 s2 freq    +127 path delay        87
ptp4l[3875.492]: port 1 (eth0): UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l[3876.492]: master offset      -2411 s2 freq   -2284 path delay        87
ptp4l[3877.492]: master offset          4 s2 freq    -592 path delay        86
ptp4l[3878.492]: master offset        724 s2 freq    +129 path delay        86
ptp4l[3879.492]: master offset        725 s2 freq    +347 path delay        86
ptp4l[3880.492]: master offset        506 s2 freq    +346 path delay        87
ptp4l[3881.492]: master offset        289 s2 freq    +280 path delay        87
ptp4l[3882.492]: master offset        137 s2 freq    +215 path delay        88
ptp4l[3883.492]: master offset         50 s2 freq    +169 path delay        88
ptp4l[3884.492]: master offset          4 s2 freq    +138 path delay        94
ptp4l[3885.492]: master offset         -6 s2 freq    +129 path delay        94
ptp4l[3886.492]: master offset         -8 s2 freq    +126 path delay        94
ptp4l[3887.492]: master offset         -5 s2 freq    +126 path delay        94
ptp4l[3888.492]: master offset         -4 s2 freq    +126 path delay        94
```
### Known Issues
 
