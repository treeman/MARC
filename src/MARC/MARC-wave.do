onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /marc_test/clk
add wave -noupdate /marc_test/reset_a
add wave -noupdate -radix hexadecimal /marc_test/uut/ADR1
add wave -noupdate -radix hexadecimal /marc_test/uut/ADR2
add wave -noupdate -radix hexadecimal /marc_test/uut/PC
add wave -noupdate -radix hexadecimal /marc_test/uut/micro/uPC
add wave -noupdate -radix hexadecimal /marc_test/uut/micro/IR
add wave -noupdate -color {Blue Violet} -radix hexadecimal /marc_test/uut/alus/alu1_register
add wave -noupdate -color {Blue Violet} -radix hexadecimal /marc_test/uut/alus/alu2_register
add wave -noupdate -radix hexadecimal /marc_test/uut/main_buss
add wave -noupdate -radix hexadecimal /marc_test/uut/memory1_data_out
add wave -noupdate -radix hexadecimal /marc_test/uut/memory2_data_out
add wave -noupdate -radix hexadecimal /marc_test/uut/memory3_data_out
add wave -noupdate /marc_test/uut/memory_address_code
add wave -noupdate /marc_test/uut/micro/uPC_code
add wave -noupdate /marc_test/uut/PC_code
add wave -noupdate /marc_test/uut/M1_code
add wave -noupdate /marc_test/uut/M2_code
add wave -noupdate /marc_test/uut/OP_code
add wave -noupdate /marc_test/uut/ALU1_src_code
add wave -noupdate /marc_test/uut/ALU2_src_code
add wave -noupdate -color {Slate Blue} /marc_test/uut/ALU_code
add wave -noupdate -radix hexadecimal /marc_test/uut/alu1_operand
add wave -noupdate -radix hexadecimal /marc_test/uut/alu2_operand
add wave -noupdate /marc_test/uut/ALU_operation
add wave -noupdate /marc_test/uut/alus/alu1_zeroFlag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20717 ns} 0}
configure wave -namecolwidth 226
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {21 us}
