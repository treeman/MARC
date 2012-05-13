
;name Cleaner
;description A core cleaner. Will split bomb then dat bomb the whole memory except ourselves

size    EQU     -9

start   MOV     #size, target   ; setup bomb ptr
infect  MOV     split, <target  ; split bomb
        JMN     infect, target

        MOV     #size, target   ; setup bomb ptr
kill    MOV     bomb, <target   ; dat bomb
        JMN     kill, target
        JMP     start, 0        ; do everything over again

split   SPL     0, 0
bomb    DAT     10, 10
target  DAT     0, 0

end

