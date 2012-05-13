
; Jump to start location
        jmp copy

begin   add 13,12
        add 11,10
        add 9,8
        jmp begin
old     dat #0

; Fast way to copy stuff
copy    mov <old,<new
        mov <old,<new
        mov <old,<new
        mov <old,<new
new     spl @0, old+1000

