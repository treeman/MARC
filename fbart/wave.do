onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /test_fbart_vhd/reset
add wave -noupdate -format Logic /test_fbart_vhd/bygel
add wave -noupdate -divider Write
add wave -noupdate -format Logic /test_fbart_vhd/clk
add wave -noupdate -format Logic /test_fbart_vhd/cs
add wave -noupdate -format Logic /test_fbart_vhd/txrdy
add wave -noupdate -format Logic /test_fbart_vhd/wr
add wave -noupdate -format Literal -radix hexadecimal /test_fbart_vhd/d
add wave -noupdate -divider Read
add wave -noupdate -format Logic /test_fbart_vhd/clk
add wave -noupdate -format Logic /test_fbart_vhd/cs
add wave -noupdate -format Logic /test_fbart_vhd/rd
add wave -noupdate -format Logic /test_fbart_vhd/rxrdy
add wave -noupdate -format Literal -radix hexadecimal /test_fbart_vhd/d
add wave -noupdate -divider Tx
add wave -noupdate -format Literal -radix unsigned /test_fbart_vhd/uut/u0/tws
add wave -noupdate -format Logic /test_fbart_vhd/uut/u0/load_tdr
add wave -noupdate -format Literal -radix hexadecimal /test_fbart_vhd/uut/u0/tdr
add wave -noupdate -format Logic /test_fbart_vhd/uut/u0/load_tsr
add wave -noupdate -format Literal -radix hexadecimal /test_fbart_vhd/uut/u0/tsr
add wave -noupdate -format Logic /test_fbart_vhd/uut/u0/wr
add wave -noupdate -format Literal -radix unsigned /test_fbart_vhd/uut/u0/tbg
add wave -noupdate -format Literal -radix unsigned /test_fbart_vhd/uut/u0/tbs
add wave -noupdate -format Literal -radix unsigned /test_fbart_vhd/uut/u0/tbc
add wave -noupdate -format Logic /test_fbart_vhd/uut/u0/shift_tsr
add wave -noupdate -format Logic /test_fbart_vhd/uut/u0/tdr_full
add wave -noupdate -format Logic /test_fbart_vhd/uut/u0/tsr_empty
add wave -noupdate -divider Rx
add wave -noupdate -format Logic /test_fbart_vhd/uut/u1/load_rdr
add wave -noupdate -format Literal -radix unsigned /test_fbart_vhd/uut/u1/rbg
add wave -noupdate -format Literal -radix unsigned /test_fbart_vhd/uut/u1/rbs
add wave -noupdate -format Literal -radix unsigned /test_fbart_vhd/uut/u1/rbc
add wave -noupdate -format Literal -radix hexadecimal /test_fbart_vhd/uut/u1/rsr
add wave -noupdate -format Literal -radix hexadecimal /test_fbart_vhd/uut/u1/rdr
add wave -noupdate -format Literal -radix unsigned /test_fbart_vhd/uut/u1/rrs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {329013540 ps} 0}
configure wave -namecolwidth 139
configure wave -valuecolwidth 93
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
configure wave -timelineunits us
update
WaveRestoreZoom {4514658 ps} {19563518 ps}
