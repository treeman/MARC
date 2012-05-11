;redcode-94b
;assert 1
;name <NEW_WARRIOR>
;kill <NEW_WARRIOR>
;author anonymous
;strategy kill_the_opponent
;date 2012-May-11
;version 1

	JMP	LOOP,	0
BOMB	DAT	0,	0
LOOP	MOV	BOMB,	<BOMB
	DJN	LOOP,	BOMB
