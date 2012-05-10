; This one should be 2/3 faster than a dwarf! :D

scanA	ADD 	#5,	ptrA
ptrA	JMZ	scanA,	100	; scan 1 location every 2 cycles
BOMB	dat	100,100
