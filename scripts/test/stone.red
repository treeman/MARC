
; A more advanced bomber, won't DAT bomb but rather move around stuff in memory
; chances are that we're moving around DAT's though

start MOV <2, 3
      ADD d1, start
      JMP start
      DAT #0
d1    DAT #-5084, #5084
end

