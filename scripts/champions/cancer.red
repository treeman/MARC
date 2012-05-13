;       program CANCER
;       author  Thomas Gettys
;       copyright (C) 1987
;
;       The concept of this program  is quite simple;  force uncontrolled
;       growth in the opponent (hence the name) to cause at least partial
;       impotence, and then go back and kill the malignancy.
;
;       The uncontrolled growth is caused by putting an SPL 0 instruction
;       into every core word unoccupied by CANCER.  As a side-effect most
;       of core will be "sterilized"; to what extent is determined by the
;       "resilience" of the opponent.
;
;       After core has been infected with the SPL 0 germ a second pass is
;       made, this time dropping a DAT 1 instruction into every core word
;       unoccupied by CANCER in order to kill off the enemy processes  (a
;       DAT 1 instruction is used instead of a DAT 0 so as to  confuse an
;       enemy program that is looking for occupied core).
;
;       If CANCER has not won at this point (i.e. it is still running) it
;       starts all over again.
;
;                              -=(*)=-
;
;       The philosphy of the author with respect to COREWARS is reflected
;       in CANCER - a strong offense is the best defense.  CANCER is fast
;       and presents a small target.
;
;       The only explicit  defensive aspect of CANCER also happens to one
;       of its most interesting features.  CANCER immediately splits into
;       two processes which are identical and work in tandem to perform a
;       single  task.  Since they share and update a single variable (the
;       pointer to the next core word to bomb), one task has jurisdiction
;       over the odd words and the other task has  responsibility for the
;       even words.  The interesting point to note here is that if either
;       process is killed the other will immediately assume its brother's
;       task!  This redundancy provides some protection against DAT bombs
;       that are spaced eight or more words apart.
;
;                              -=(*)=-
;
        JMP     START
        JMP     -1,     0       ;"wall" to stop marching SPL 0
START   SPL     COPY2,  0       ;kick off second copy of self
;
;
COPY1   MOV     CNTR,   PTR     ;initialize bomb destination pointer
INFECT1 MOV     GERM,   <PTR    ;drop another SPL 0 bomb and update ptr
        JMN     INFECT1,PTR     ;continue until all memory has been hit
;
        MOV     CNTR,   PTR     ;reset bomb destination pointer
KILL1   MOV     POISON, <PTR    ;drop another DAT bomb and update ptr
        JMN     KILL1,  PTR     ;continue until all memory has been hit
        JMP     COPY1,  0       ;do it again if we haven't won yet
;
;
COPY2   MOV     CNTR,   PTR     ;initialize bomb destination pointer
INFECT2 MOV     GERM,   <PTR    ;drop another SPL 0 bomb and update ptr
        JMN     INFECT2,PTR     ;continue until all memory has been hit
;
        MOV     CNTR,   PTR     ;reset bomb destination pointer
KILL2   MOV     POISON, <PTR    ;drop another DAT bomb and update ptr
        JMN     KILL2,  PTR     ;continue until all memory has been hit
        JMP     COPY2,  0       ;do it again if we haven't won yet
;
GERM    SPL     0,      0       ;bomb to stimulate uncontrolled growth
POISON  DAT     0,      1       ;bomb to kill off enemy (and muddy core)
CNTR    DAT     0,      -20     ;# of core words "out there" (coresize-mysize)
PTR     DAT     0,      0       ;variable used to point to bomb targets
;
END

