;name Stone of ages
;author Jonas Hietala
;description Will sparsely bomb the memory and then fall back to a core cleaner.

bombstep    EQU 37
size        EQU -15


;try for a quick kill
bomber      ADD #bombstep, dst
;            MOV bomb, @dst
            MOV split, @dst
            SLT dst, #2*bombstep
            JMP bomber
            JMP clean

clean       MOV #size, dst
infect      MOV split, <dst
            JMN infect, dst

bashmem     MOV #size, dst
kill        MOV bomb, <dst
            JMN kill, dst

            JMP bashmem

split       SPL 0, 0
bomb        DAT 10, 10
dst         DAT #bombstep, #bombstep

