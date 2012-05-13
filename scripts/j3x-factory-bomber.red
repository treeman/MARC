;name Factory bomber
;author Jesper Tingvall
;description Spawns a lot of 'little bombers' all over the memory.
;assert 1
START ADD STEP,  PTR
      MOV LOOPE, <PTR
      MOV LOOP,  <PTR
      SPL @PTR,  0
      JMP START, 0
LOOP  MOV -1,    <-1
LOOPE JMP -1,  0
STEP  DAT -501+8192,   -501+8192
PTR   DAT -151,   -151
