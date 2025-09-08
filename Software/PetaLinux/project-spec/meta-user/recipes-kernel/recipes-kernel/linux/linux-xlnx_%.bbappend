FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg file://jakobs-2025.1-ptp.patch"
KERNEL_FEATURES:append = " bsp.cfg"
