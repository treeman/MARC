;name Factory bomber
;author Jesper Tingvall
;description Spawns a lot of 'little bombers' all over the memory.

START ADD STEP,  PTR
      MOV LOOPE, <PTR
      MOV LOOP,  <PTR
      SPL @PTR,  0
      JMP START, 0
LOOP  MOV -1,    <-1
LOOPE DJN LOOP,  -2
STEP  DAT 250,   250
PTR   DAT 151,   151
