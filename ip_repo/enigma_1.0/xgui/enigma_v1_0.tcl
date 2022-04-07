# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "rotor1_type"
  ipgui::add_param $IPINST -name "rotor2_type"
  ipgui::add_param $IPINST -name "rotor3_type"
  ipgui::add_param $IPINST -name "rotor4_type"
  ipgui::add_param $IPINST -name "reflector_type"

}

proc update_PARAM_VALUE.reflector_type { PARAM_VALUE.reflector_type } {
	# Procedure called to update reflector_type when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.reflector_type { PARAM_VALUE.reflector_type } {
	# Procedure called to validate reflector_type
	return true
}

proc update_PARAM_VALUE.rotor1_type { PARAM_VALUE.rotor1_type } {
	# Procedure called to update rotor1_type when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.rotor1_type { PARAM_VALUE.rotor1_type } {
	# Procedure called to validate rotor1_type
	return true
}

proc update_PARAM_VALUE.rotor2_type { PARAM_VALUE.rotor2_type } {
	# Procedure called to update rotor2_type when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.rotor2_type { PARAM_VALUE.rotor2_type } {
	# Procedure called to validate rotor2_type
	return true
}

proc update_PARAM_VALUE.rotor3_type { PARAM_VALUE.rotor3_type } {
	# Procedure called to update rotor3_type when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.rotor3_type { PARAM_VALUE.rotor3_type } {
	# Procedure called to validate rotor3_type
	return true
}

proc update_PARAM_VALUE.rotor4_type { PARAM_VALUE.rotor4_type } {
	# Procedure called to update rotor4_type when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.rotor4_type { PARAM_VALUE.rotor4_type } {
	# Procedure called to validate rotor4_type
	return true
}


proc update_MODELPARAM_VALUE.rotor1_type { MODELPARAM_VALUE.rotor1_type PARAM_VALUE.rotor1_type } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.rotor1_type}] ${MODELPARAM_VALUE.rotor1_type}
}

proc update_MODELPARAM_VALUE.rotor2_type { MODELPARAM_VALUE.rotor2_type PARAM_VALUE.rotor2_type } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.rotor2_type}] ${MODELPARAM_VALUE.rotor2_type}
}

proc update_MODELPARAM_VALUE.rotor3_type { MODELPARAM_VALUE.rotor3_type PARAM_VALUE.rotor3_type } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.rotor3_type}] ${MODELPARAM_VALUE.rotor3_type}
}

proc update_MODELPARAM_VALUE.rotor4_type { MODELPARAM_VALUE.rotor4_type PARAM_VALUE.rotor4_type } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.rotor4_type}] ${MODELPARAM_VALUE.rotor4_type}
}

proc update_MODELPARAM_VALUE.reflector_type { MODELPARAM_VALUE.reflector_type PARAM_VALUE.reflector_type } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.reflector_type}] ${MODELPARAM_VALUE.reflector_type}
}

