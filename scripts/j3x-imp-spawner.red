;name Imp spawner
;author Jesper Tingvall
;description Spawns a lot of imps all over the memory!

START ADD STEP,  PTR
      MOV IMP,   @PTR
      SPL @PTR,  0
      JMP START, 0
IMP   MOV 0,     1
PTR   DAT 50,    50
STEP  DAT 50,    50
