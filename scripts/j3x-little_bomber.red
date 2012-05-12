;name Little bomber
;author Jesper Tingvall
;description Bombs the memory backwards with DAT 0, 0. Smaller than a dwarf

JMP  LOOP,     0
BOMB DAT 0,    0
LOOP MOV BOMB, <BOMB
     DJN LOOP, BOMB
