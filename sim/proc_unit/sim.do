# Usage:
# do sim.do sim;         - libraries recompilation
# do sim.do; run X us;   - restart & run on X time

.main clear
quietly set flag_restart 1

quietly set RTL_DIR "./../../rtl"
quietly set TB_DIR "."

# Argument parsing
if { $argc < 1 } {
  puts "Restarting..."
} elseif { $1 == "sim" } {
  puts "Recompiling..."
  set flag_restart 0
}

vlib work
# Update local files
vcom -2008 -explicit -work work "${RTL_DIR}/parameters.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/bnn_adder.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/dff_2_7.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/substr_8.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/popcount.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/bnn_xnor.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/cache.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/comparator.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/processing_unit.vhdl"

vlog +incdir+$RTL_DIR -work work -sv $TB_DIR/pu_tb.sv

# If recompiling - recreate all libraries. Else - just restart
if { $flag_restart == 1 } {
  restart -all -force
} elseif { $flag_restart == 0} {
  vsim +initreg+0 +initmem+0 -novopt -voptargs="+acc" -L work work.pu_tb -t 1ns
}
