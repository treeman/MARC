onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /marc_test/clk
add wave -noupdate /marc_test/reset_a
add wave -noupdate /marc_test/uut/reset
add wave -noupdate -color Yellow -radix hexadecimal /marc_test/uut/micro/uPC
add wave -noupdate -radix hexadecimal /marc_test/uut/ADR1
add wave -noupdate -radix hexadecimal /marc_test/uut/ADR2
add wave -noupdate -radix hexadecimal /marc_test/uut/PC
add wave -noupdate -radix hexadecimal /marc_test/uut/micro/uCount_limit
add wave -noupdate -radix hexadecimal /marc_test/uut/micro/uCounter
add wave -noupdate -radix hexadecimal /marc_test/uut/micro/IR
add wave -noupdate -radix hexadecimal /marc_test/uut/OP
add wave -noupdate -radix hexadecimal /marc_test/uut/M1
add wave -noupdate -radix hexadecimal /marc_test/uut/M2
add wave -noupdate -radix hexadecimal /marc_test/uut/IN_reg
add wave -noupdate -color Aquamarine -radix hexadecimal /marc_test/uut/alus/alu1_register
add wave -noupdate -color Aquamarine -radix hexadecimal /marc_test/uut/alus/alu2_register
add wave -noupdate -radix hexadecimal /marc_test/uut/main_buss
add wave -noupdate -color Orchid /marc_test/uut/memory_addr_code
add wave -noupdate -color Orchid /marc_test/uut/micro/uPC_code
add wave -noupdate /marc_test/uut/micro/uCount_code
add wave -noupdate -color Orchid /marc_test/uut/PC_code
add wave -noupdate -color Orchid /marc_test/uut/M1_code
add wave -noupdate -color Orchid /marc_test/uut/M2_code
add wave -noupdate -color Orchid /marc_test/uut/OP_code
add wave -noupdate -color Orchid /marc_test/uut/ADR1_code
add wave -noupdate -color Orchid /marc_test/uut/ADR2_code
add wave -noupdate -color Orchid /marc_test/uut/ALU1_code
add wave -noupdate -color Orchid /marc_test/uut/ALU2_code
add wave -noupdate -color Orchid /marc_test/uut/ALU_code
add wave -noupdate /marc_test/uut/micro/signals
add wave -noupdate /marc_test/uut/Z
add wave -noupdate /marc_test/uut/new_IN
add wave -noupdate /marc_test/uut/game_started
add wave -noupdate /marc_test/uut/alus/alu1_zeroFlag
add wave -noupdate -radix hexadecimal /marc_test/uut/memory_address_in
add wave -noupdate -expand -group mem1 -radix hexadecimal /marc_test/uut/memory1_data_in
add wave -noupdate -expand -group mem1 -radix hexadecimal /marc_test/uut/memory1_data_out
add wave -noupdate -expand -group mem1 /marc_test/uut/memory1_read
add wave -noupdate -expand -group mem1 /marc_test/uut/memory1_write
add wave -noupdate -expand -group mem2 -radix hexadecimal /marc_test/uut/memory2_data_in
add wave -noupdate -expand -group mem2 -radix hexadecimal /marc_test/uut/memory2_data_out
add wave -noupdate -expand -group mem2 /marc_test/uut/memory2_read
add wave -noupdate -expand -group mem2 /marc_test/uut/memory2_write
add wave -noupdate -expand -group mem3 -radix hexadecimal /marc_test/uut/memory3_data_in
add wave -noupdate -expand -group mem3 -radix hexadecimal /marc_test/uut/memory3_data_out
add wave -noupdate -expand -group mem3 /marc_test/uut/memory3_read
add wave -noupdate -expand -group mem3 /marc_test/uut/memory3_write
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20259 ns} 0}
configure wave -namecolwidth 252
configure wave -valuecolwidth 101
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
WaveRestoreZoom {0 ns} {21019 ns}
