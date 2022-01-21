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
vcom -2008 -explicit -work work "${RTL_DIR}/adder_1_2.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/dff_2_7.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/adder_2_7.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/substr_8.vhdl"
vcom -2008 -explicit -work work "${RTL_DIR}/popcount.vhdl"

vcom -2008 -explicit -work work "${TB_DIR}/popcount_tb.vhdl"

# If recompiling - recreate all libraries. Else - just restart
if { $flag_restart == 1 } {
  restart -all -force
} elseif { $flag_restart == 0} {
  vsim +initreg+0 +initmem+0 -novopt -voptargs="+acc" -L work work.popcount_tb -t 1ns
}
