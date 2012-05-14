;redcode-94b
;assert 1
;name <MegaBomb>
;kill <MegaBomb>
;author anonymous
;strategy kill_the_opponent
;date 2012-May-14
;version 1

imp	MOV	0,1
bomb  	DAT 	#0
dwarf  	ADD 	#4, bomb
       	MOV 	bomb, @bomb
       	JMP 	imp