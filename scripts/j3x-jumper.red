
START JMP CPY, #0
SIZ   DAT  #12, #12
      ADD STEP, PTR
CPY   MOV <SIZ, <PTR
      JMN CPY, SIZ
      ADD DAT7, @PTR
      ADD DAT1, PTR
      SPL @PTR, 0
      ADD STEP, PTR
PTR   DAT  #50, #50
STEP  DAT  #8, #8
DAT1  DAT  #1, #1
DAT7  DAT  #12, #12
