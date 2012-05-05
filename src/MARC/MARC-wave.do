onerror {resume}
virtual type { direct immediate indirect pre-decr} mod_type
virtual type { DAT MOV ADD SUB JMP JMPZ JMN CMP SLT DJN SPL} instr_type
quietly virtual signal -install /marc_test/uut/micro {/marc_test/uut/micro/A_field  } A_field_bus
quietly virtual function -install /marc_test/uut/micro -env /marc_test/uut/micro { (mod_type)A_field_bus} A_field_
quietly virtual signal -install /marc_test/uut/micro {/marc_test/uut/micro/B_field  } B_field_bus
quietly virtual function -install /marc_test/uut/micro -env /marc_test/uut/micro { (mod_type)B_field_bus} B_field_
quietly virtual signal -install /marc_test/uut/micro {/marc_test/uut/micro/OP_field  } instr_bus
quietly virtual function -install /marc_test/uut/micro -env /marc_test/uut/micro { (instr_type)instr_bus} instr
quietly WaveActivateNextPane {} 0
add wave -noupdate /marc_test/clk
add wave -noupdate /marc_test/reset_a
add wave -noupdate /marc_test/uut/reset
add wave -noupdate -color Brown -radix hexadecimal /marc_test/uut/PC
add wave -noupdate -color {Medium Orchid} /marc_test/uut/micro/instr
add wave -noupdate -color {Medium Aquamarine} -radix hexadecimal /marc_test/uut/micro/uPC
add wave -noupdate -group IR /marc_test/uut/micro/IR
add wave -noupdate -group IR /marc_test/uut/micro/instr
add wave -noupdate -group IR -color {Cadet Blue} -radix hexadecimal /marc_test/uut/micro/op_addr
add wave -noupdate -group IR /marc_test/uut/micro/A_field_
add wave -noupdate -group IR /marc_test/uut/micro/A_imm
add wave -noupdate -group IR /marc_test/uut/micro/A_dir
add wave -noupdate -group IR /marc_test/uut/micro/A_pre
add wave -noupdate -group IR /marc_test/uut/micro/B_field_
add wave -noupdate -group IR /marc_test/uut/micro/B_imm
add wave -noupdate -group IR /marc_test/uut/micro/B_dir
add wave -noupdate -group IR /marc_test/uut/micro/B_pre
add wave -noupdate -group IR -color {Cadet Blue} /marc_test/uut/micro/IR_code
add wave -noupdate -group uPC -color {Medium Aquamarine} -radix hexadecimal /marc_test/uut/micro/uPC
add wave -noupdate -group uPC /marc_test/uut/micro/uPC_addr
add wave -noupdate -group uPC -color Orchid /marc_test/uut/micro/uPC_code
add wave -noupdate -group uPC -radix hexadecimal /marc_test/uut/micro/uCounter
add wave -noupdate -group uPC -radix hexadecimal /marc_test/uut/micro/uCount_limit
add wave -noupdate -radix hexadecimal /marc_test/uut/memory_address
add wave -noupdate -radix hexadecimal /marc_test/uut/ADR1
add wave -noupdate -radix hexadecimal /marc_test/uut/ADR2
add wave -noupdate -radix hexadecimal /marc_test/uut/OP
add wave -noupdate -radix hexadecimal /marc_test/uut/M1
add wave -noupdate -radix hexadecimal /marc_test/uut/M2
add wave -noupdate -color Aquamarine -radix hexadecimal /marc_test/uut/alus/alu1_register
add wave -noupdate -color Aquamarine -radix hexadecimal /marc_test/uut/alus/alu2_register
add wave -noupdate -radix hexadecimal /marc_test/uut/IN_reg
add wave -noupdate -radix hexadecimal /marc_test/uut/main_buss
add wave -noupdate -color {Cadet Blue} /marc_test/uut/memory_addr_code
add wave -noupdate -color {Cadet Blue} /marc_test/uut/micro/uCount_code
add wave -noupdate -color {Cadet Blue} /marc_test/uut/PC_code
add wave -noupdate -color {Cadet Blue} /marc_test/uut/OP_code
add wave -noupdate -color {Cadet Blue} /marc_test/uut/M1_code
add wave -noupdate -color {Cadet Blue} /marc_test/uut/M2_code
add wave -noupdate -color {Cadet Blue} /marc_test/uut/ADR1_code
add wave -noupdate -color {Cadet Blue} /marc_test/uut/ADR2_code
add wave -noupdate /marc_test/uut/buss_code
add wave -noupdate /marc_test/uut/micro/signals
add wave -noupdate /marc_test/uut/Z
add wave -noupdate /marc_test/uut/new_IN
add wave -noupdate /marc_test/uut/game_started
add wave -noupdate -group ALU -color Aquamarine -radix hexadecimal /marc_test/uut/alus/alu1_register
add wave -noupdate -group ALU -color Aquamarine -radix hexadecimal /marc_test/uut/alus/alu2_register
add wave -noupdate -group ALU -radix hexadecimal /marc_test/uut/alus/alu1_operand
add wave -noupdate -group ALU -radix hexadecimal /marc_test/uut/alus/alu2_operand
add wave -noupdate -group ALU -color {Cadet Blue} /marc_test/uut/ALU1_code
add wave -noupdate -group ALU -color {Cadet Blue} /marc_test/uut/ALU2_code
add wave -noupdate -group ALU -color {Cadet Blue} /marc_test/uut/ALU_code
add wave -noupdate -group ALU /marc_test/uut/alus/alu1_zeroFlag
add wave -noupdate -group ALU /marc_test/uut/alus/alu2_zeroFlag
add wave -noupdate -group ALU /marc_test/uut/alus/comp
add wave -noupdate -group mem1 -radix hexadecimal /marc_test/uut/memory1_data_in
add wave -noupdate -group mem1 -radix hexadecimal /marc_test/uut/memory1/data_out
add wave -noupdate -group mem1 /marc_test/uut/memory1_read
add wave -noupdate -group mem1 /marc_test/uut/memory1_write
add wave -noupdate -group mem1 -radix hexadecimal /marc_test/uut/memory_address_in
add wave -noupdate -group mem1 -radix hexadecimal /marc_test/uut/memory1/address_out
add wave -noupdate -group mem2 -radix hexadecimal /marc_test/uut/memory2_data_in
add wave -noupdate -group mem2 -radix hexadecimal /marc_test/uut/memory2/data_out
add wave -noupdate -group mem2 /marc_test/uut/memory2_read
add wave -noupdate -group mem2 /marc_test/uut/memory2_write
add wave -noupdate -group mem2 -radix hexadecimal /marc_test/uut/memory_address_in
add wave -noupdate -group mem2 -radix hexadecimal /marc_test/uut/memory2/address_out
add wave -noupdate -group mem3 -radix hexadecimal /marc_test/uut/memory3_data_in
add wave -noupdate -group mem3 -radix hexadecimal /marc_test/uut/memory3/data_out
add wave -noupdate -group mem3 /marc_test/uut/memory3_read
add wave -noupdate -group mem3 /marc_test/uut/memory3_write
add wave -noupdate -group mem3 -radix hexadecimal /marc_test/uut/memory_address_in
add wave -noupdate -group mem3 -radix hexadecimal -childformat {{/marc_test/uut/memory3/address_out(12) -radix hexadecimal} {/marc_test/uut/memory3/address_out(11) -radix hexadecimal} {/marc_test/uut/memory3/address_out(10) -radix hexadecimal} {/marc_test/uut/memory3/address_out(9) -radix hexadecimal} {/marc_test/uut/memory3/address_out(8) -radix hexadecimal} {/marc_test/uut/memory3/address_out(7) -radix hexadecimal} {/marc_test/uut/memory3/address_out(6) -radix hexadecimal} {/marc_test/uut/memory3/address_out(5) -radix hexadecimal} {/marc_test/uut/memory3/address_out(4) -radix hexadecimal} {/marc_test/uut/memory3/address_out(3) -radix hexadecimal} {/marc_test/uut/memory3/address_out(2) -radix hexadecimal} {/marc_test/uut/memory3/address_out(1) -radix hexadecimal} {/marc_test/uut/memory3/address_out(0) -radix hexadecimal}} -subitemconfig {/marc_test/uut/memory3/address_out(12) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(11) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(10) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(9) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(8) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(7) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(6) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(5) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(4) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(3) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(2) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(1) {-height 15 -radix hexadecimal} /marc_test/uut/memory3/address_out(0) {-height 15 -radix hexadecimal}} /marc_test/uut/memory3/address_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25055 ns} 0}
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
WaveRestoreZoom {0 ns} {31500 ns}
