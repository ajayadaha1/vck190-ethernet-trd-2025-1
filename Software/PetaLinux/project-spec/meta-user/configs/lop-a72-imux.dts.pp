# 0 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/tool/petalinux-v2025.1-final/sysroots/x86_64-petalinux-linux/usr/lib/python3.12/site-packages/lopper/lops/lop-a72-imux.dts"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/tool/petalinux-v2025.1-final/sysroots/x86_64-petalinux-linux/usr/lib/python3.12/site-packages/lopper/lops/lop-a72-imux.dts"
# 10 "/proj/petalinux/2025.1/petalinux-v2025.1_05180714/tool/petalinux-v2025.1-final/sysroots/x86_64-petalinux-linux/usr/lib/python3.12/site-packages/lopper/lops/lop-a72-imux.dts"
/dts-v1/;

/ {
        compatible = "system-device-tree-v1,lop";
        lops {
                compatible = "system-device-tree-v1,lop";
                lop_a72_0 {
                        compatible = "system-device-tree-v1,lop,assist-v1";
                        node = "/axi/imux";
                        id = "imux,imux-v1";
                        noexec;
                };

                lop_a72_1 {
                        compatible = "system-device-tree-v1,lop,modify";

                        modify = "/apu-bus/interrupt-controller@f9000000::/axi/interrupt-controller@f9000000";
                };

                lop_a72_2 {
                        compatible = "system-device-tree-v1,lop,modify";

                        modify = "/apu-bus/::";
                };

                lop_a72_3 {
                        compatible = "system-device-tree-v1,lop,select-v1";

                        select_1;
                        select_2 = "/axi/interrupt-controller.*";
                };

                lop_a72_4 {
                      compatible = "system-device-tree-v1,lop,code-v1";
                      code = "
                                if tree.nodes('/__symbols__', strict=True):
                                        tree['/__symbols__']['gic'] = str(tree.deref('gic_a72'))
                                        tree['/__symbols__'].delete('gic_a72')
                            ";
                };

                lop_a72_5 {
                      compatible = "system-device-tree-v1,lop,code-v1";
                      code = "
                                for s in __selected__:
                                    if s.label == 'gic_a72':
                                        s.label = 'gic'
                                        break
                            ";
                };

                lop_a72_6 {
                      compatible = "system-device-tree-v1,lop,select-v1";

                      select_1;
                      select_2 = "/.*:interrupt-parent:&imux";
                };

                lop_a72_7 {
                      compatible = "system-device-tree-v1,lop,modify";

                      flags = "strict";
                      modify = ":interrupt-parent:&gic";
                };

                lop_a72_8 {
                        compatible = "system-device-tree-v1,lop,modify";

                        modify = "/axi/interrupt-multiplex::";
                };
        };
};
