; Shoud not die if CMP works!!
START	CMP A,B
	DAT 0,0
JMP	START, 0
A	DAT 1,1
B	DAT 1,1
