;name Inseminator
;author Jesper Tingvall
;description This one gets all lovey-dovey with the enemy warrior, inseminate that code with our PCs!

START ADD STEP,  PTR
      JMZ START, @PTR
      SPL @PTR,  #0
      JMP START, 0
PTR   DAT #5,    #5            ; Pointer
STEP  DAT #5,    #5            ; Data to add to pointer