MARC - Memory Array Redcode Computer
====================================

This is our project for TSEA43 at Linköpings University.

We made an implementation in VHDL of the [Core Wars 88 standard (pdf)][corewars88] running on a FPGA board. Core Wars is basically a computer game where two programs compete and try to destroy each other. Read [the wiki][corewarswiki] for more info.

The processor is a microprogrammed processor with a Redcode assembler for it.

![](http://raw.github.com/treeman/Digital-konstruktion/master/Report%20&%20presentation/huvudblockschema.png)  
*Main block schema for processor*


Scripts
-------

* `assembler` Assemble redcode warriors for our architecture.
* `sender` Hacky script to send a binary file to FPGA through usb.
* `control_codes` Easy way to make microcode.


Warriors
--------

Check out `*.red` in scripts for our warriors.


Authors
-------

* Jesper Tingvall
* Jizhi Li
* Jonas Hietala

----

Apologies for any disorganization.

