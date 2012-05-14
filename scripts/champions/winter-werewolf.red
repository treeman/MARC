step equ 153
init equ 152
n equ ((12*8)-2)

        JMP boot
data    DAT <-4-n, #0
split   SPL 0, <-3-step-n
main    MOV jump, @3
        MOV split, <2
        ADD #step, 1
        JMP main, init
        MOV @-4, <n
jump    JMP -1, 1
boot    MOV main+5, -500+5
        MOV main+4, <boot
        MOV main+3, <boot
        MOV main+2, <boot
        MOV main+1, <boot
        MOV main,   <boot
        MOV main-1, <boot
        MOV data, boot-500-3-n
        JMP boot-500
end boot

