FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg file://0001-VCK190-Ethernet-TRD-MRMAC-with-PTP-support-patch-for.patch"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2025-09-08-21-08-00.cfg"

