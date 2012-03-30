SIMFILES=fbart.vhd fbart_rx.vhd fbart_tx.vhd test_fbart.vhd test_rx.vhd test_tx.vhd

simfiles:  
	vlib work;for i in $(SIMFILES); do if ! vcom +acc $$i; then exit 1;fi;done

sim	: simfiles
	vsim -t 1ps test_fbart_vhd

