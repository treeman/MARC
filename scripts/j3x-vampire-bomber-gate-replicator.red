;name Vampire bomber gate replicator
;author Jesper Tingvall
;description Same as vampire bomber gate but this creates a replica of the vampire bomber part (srsly, this is getting silly - I call this code bloatware)

      SPL VAMP,      0
      SPL GATE,      0
      SPL CPY,       0
      JMP CAGE1,     0
SIZ   DAT #29,       #29
CPY   MOV <SIZ,      <PTR2
      JMN CPY,       SIZ
      ADD DAT7,      @PTR2
      ADD DAT1,      PTR2
      SPL @PTR2,     0          ; cage
      ADD DAT3,      PTR2
      SPL @PTR2,     0          ; vampire
	  
      ADD DATX,      PTR2
	  SPL @PTR2,     0
PTR2  DAT  #4000+8192, #4000+8192
STEP2 DAT  #21,      #21
DAT1  DAT  #14,      #14
DAT7  DAT  #12,      #12
      DAT -50,       -50
CAGE1 MOV -1,        <-1
CAGE2 DJN CAGE1,     -2
VAMP  ADD STEP,      PTR
      SUB STEP,      BOMB
      MOV BOMB,      @PTR
      JMP VAMP,      0
PTR   JMP 150,       150
STEP  DAT 5,         5
BOMB  JMP CAGE1-148, 0
      DAT 0,         0
DAT3  DAT 2,         2
DATX  DAT 76,        76
      DAT 0,         0
GATE  JMP 0,         <-2