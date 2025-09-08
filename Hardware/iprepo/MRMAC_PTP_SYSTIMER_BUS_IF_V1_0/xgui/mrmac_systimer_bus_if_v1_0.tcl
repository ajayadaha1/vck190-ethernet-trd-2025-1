# (C) Copyright 2020 - 2021 Xilinx, Inc.
# SPDX-License-Identifier: Apache-2.0
# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_SELECT_SINGLE_CLOCK" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_SELECT_SINGLE_CLOCK { PARAM_VALUE.C_SELECT_SINGLE_CLOCK } {
	# Procedure called to update C_SELECT_SINGLE_CLOCK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SELECT_SINGLE_CLOCK { PARAM_VALUE.C_SELECT_SINGLE_CLOCK } {
	# Procedure called to validate C_SELECT_SINGLE_CLOCK
	return true
}


proc update_MODELPARAM_VALUE.C_SELECT_SINGLE_CLOCK { MODELPARAM_VALUE.C_SELECT_SINGLE_CLOCK PARAM_VALUE.C_SELECT_SINGLE_CLOCK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SELECT_SINGLE_CLOCK}] ${MODELPARAM_VALUE.C_SELECT_SINGLE_CLOCK}
}

