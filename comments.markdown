NOTE: COREWAR, Get it @ http://www.koth.org/pmars/

- (Jonas)
    Angående styrsignaler och skit


    * memory source address är samma för alla minnen
        Vi behöver aldrig broadcasta då alla minnen har samma address pekare.
    * ALU sätter alltid Z
    * Du byggde ihop ALU och memory management? Och hanterar ej PC?
        Det är väldigt opraktiskt att dra memory source address från bussen om det var det du hade tänkt?
        Vi saknar PC + ADR. ADR är nödvändig! Då vi måste spara den address vi vill använda mellan olika mikrorader.

        Jag tror att det är väldigt dumt att försöka kombinera ALU + primärminne, det är lättare att kombinera alla olika signaler i en stor modul istället.

        Vi vill minimera antalet styrsignaler?

        Jag tänkte mig dessa styrsignaler till bussen:

        buss_in
            PC
            OP (-> IR)
            AR B (+ PC)
            FIFO
            I/O
            3 bit

        buss_out
            nothing
            PC
            M1
            M2
            OP
            ALU B (-> PC)
            IR
            FIFO
            4 bit

        Du har nu:

        buss_in
            3 x 2 bit bara memory source data (behöver inte skicka till bussen dock, eventuellt OP)
            3 bit buss_output

            och då saknar vi FIFO, I/O

        buss_out
            3 x 2 bit samma?
                eller
            3 bit buss_output

            saknar FIFO, IR

        Så jag anser att vi inte kör som du gör nu, utan vi försöker definiera globala styrsignaler liknande jag gjort i filen styrsignaler.


    * Saknade styrsignaler:
        ALU action

    * Jag föreslår att du bryter ut ALU och minneshanteringen i separata moduler.

        Man skulle kanske tänka sig såhär:

        ALU:n kommer vara jätteenkel med signaler:

            ALU A in 13 bit
            ALU B in 13 bit

            Styrsignal
            ALU action in 3? bit

            skriver alltid ut
            AR A out 13 bit
            AR B out 13 bit

            Z out 1 bit

        Och minneshanteringen kan göra:

            OP in/ut 8 bit
            M1 in/ut 13 bit
            M2 in/ut 13 bit

            ADR in 13 bit

            Styrsignaler
            OP action in 2 bit (läs in, skriv ut, gör inget)
            M1 action in 2 bit
            M2 action in 2 bit

            mem1 read/write in 2 bit
            mem2 read/write in 2 bit
            mem3 read/write in 2 bit

            1 bit grafik reset?

        Resterande d v s i stort sett alla muxar styrs från main module. Jag tror att detta blir mycket lättare därför att

        1. Vi styr hela bussen därifrån
        2. Vi styr i stort sett alla muxar från ett ställe
           Vilket gör att vi kan ha lite if satser och gör typ
               if styr_buss_in = "0001" then
                   buss = OP

               if styr_buss_ut = "0100" then
                   IR = buss

               o s v

           För muxarna sitter alltid före/efter store moduler så vår main module får som uppgift att läsa styrsignaler och rerouta signaler vars de ska. Blir mycket renare och lättare att hålla reda på.

    Eller vad anser du?
