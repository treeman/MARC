
; Clean asm syntax
        ADD # 4, @ 2
        SUB   1, < 3
        DAT   0,   0

; Case and spaces are ignored except between code and labels
        sub 1, @2
dang    spl 0,0

; Constants

LEVEL   equ 1337 ; T.T
val     equ 10*2
stuff   equ 2*val ; can be labels, numbers and +-*/
ONLYFIRSTEIGHT equ 0

; Evaluation of +-*/

scan    sub   dang, LEVEL-stuff/2 ; can be labels, numbers and +-*/
comp    cmp   val, stuff
        djn   scan,<LEVEL+2*val-3
ONLYREALLYFIRSTEIGHT add 1,2


; End
end

        add #1,@2

