;name Scanner 1 / Stealth Bomber
;author Jesper Tingvall
;description Scans the memory until it finds something != 0, then bomb it with DAT 100 100!

scanA ADD  #5,   ptrA
ptrA  JMZ scanA, 100    ; scan 1 location every 2 cycles
      MOV BOMB,  @ptrA  ; Attack
      JMP scanA, 0
BOMB  DAT 100,   100
