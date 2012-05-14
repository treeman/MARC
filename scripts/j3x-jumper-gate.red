;name Jumper-gate
;author Jesper Tingvall
;description Proof of concept replicator, creates a copy of itself and becomes a gate after copying. Might work, might not...

START JMP CPY,  #0
SIZ   DAT  #13, #13
      ADD STEP, PTR
CPY   MOV <SIZ, <PTR
      JMN CPY,  SIZ
      ADD DAT7, @PTR
      ADD DAT1, PTR
      SPL @PTR, 0
      ADD STEP, PTR
      JMP 0,    <-2
PTR   DAT  #50, #50
STEP  DAT  #7,  #7
DAT1  DAT  #1,  #1
DAT7  DAT  #12, #12
