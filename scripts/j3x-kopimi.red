;name Kopimi
;author Jesper Tingvall
;description Scans the memory after code and creates a copy of it!
;              a 
;            a C a
;          a a a a a
;        a a a a a a a 
;      a a a a a a a a a

START SUB STEP,   PTR
      JMZ START,  @PTR
COPY  MOV @PTR,   <SPAWN
	  JMN COPY,   <PTR
      SPL @SPAWN, #2
      JMP START,  3
PTR	  DAT #-50,   #-50      ; Scan Pointer
SPAWN DAT #4000,  #4000	    ; Copy Pointer
STEP  DAT #1,     1