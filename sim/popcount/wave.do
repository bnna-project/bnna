onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group popcnt /popcount_tb/pcnt/clk
add wave -noupdate -group popcnt /popcount_tb/pcnt/i_val
add wave -noupdate -group popcnt /popcount_tb/pcnt/rst
add wave -noupdate -group popcnt -radix hexadecimal /popcount_tb/pcnt/stream_i
add wave -noupdate -group popcnt /popcount_tb/pcnt/o_val
add wave -noupdate -group popcnt -radix hexadecimal /popcount_tb/pcnt/stream_o
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem32_i
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem32_o
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem16_i
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem16_o
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem8_i
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem8_o
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem4_i
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem4_o
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem2_i
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem2_o
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem1_i
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/mem1_o
add wave -noupdate -group popcnt -radix unsigned /popcount_tb/pcnt/dff_2p
add wave -noupdate -group popcnt -radix decimal /popcount_tb/pcnt/dff_substr
add wave -noupdate -group popcnt /popcount_tb/pcnt/dff_stream
add wave -noupdate -group popcnt /popcount_tb/pcnt/delay_val
add wave -noupdate /popcount_tb/rst
add wave -noupdate /popcount_tb/stream_i
add wave -noupdate /popcount_tb/stream_o
add wave -noupdate /popcount_tb/i_val
add wave -noupdate /popcount_tb/o_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {267 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2231 ns}
