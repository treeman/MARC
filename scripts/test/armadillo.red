
bomb    SPL 0
loop    ADD #3039,ptr
ptr     MOV bomb, 81
        JMP loop
        MOV 1, <-1
end bomb

