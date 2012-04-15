
Todo
====

Prio 1
-----

* Skriva ut en fyrkant genom VGA
* Hämta någon input genom UART

Rest
----

* Uppdatera blockschemat med
    * Räknare till mikropragrammet för att styra snabbheten
    * Ingen output till fbart
    * Uppdelad 8bit -> 16 bit input
    * Saknad mikrohopp styrsignal
    * Insignal färg (skriva från vad?) till grafikminnet.  
        Ett nät med indata:  
        * T (vems tur) 1 bit
        * OP kod 8 bit
        * Reset mode 1 bit

* Dela upp schemat i block och definiera in- och utsignaler. Dessa kan vi sedan göra var för sig.  
    Förslagsvis:
    * Fifo  
        In:  
        * Set 13 bit
        * Who's turn? 1 bit (T ->)
        * Read 1 bit
        * Write 1 bit
        * Reset (clear both queues) 1 bit

        Ut:  
        * Read 13 bit
        * Game over player 1, 1 bit (-> P1)
        * Game over player 2, 1 bit (-> P2)
        * Queue full player 1, 1 bit (-> F1)
        * Queue full player 2, 1 bit (-> F2)

    * Primärminnet  
        In:  
        * Adress 13 bit
        * Graphic adress 13 bit
        * Read graphics 1 bit
        * Write graphics 1 bit
        * Graphics color in 8 bit
        * Read 1 bit
        * Write 1 bit

        Ut:  
        * Graphics color 8 bit

        In/Ut:  
        * OP 8 bit
        * Mem1 13 bit
        * Mem2 13 bit

    * Minneshantering runt om primärminnet
    * ALU
    * Mikrominnesdelen
    * I/O med FBART  
        Vi behöver endast input
    * Grafikdel  
        In:  
        * Graphics clock 1 bit
        * Output color 8 bit (eller så många vi behöver)

        Ut:  
        * Color adress 13 bit
        * hsync 1 bit
        * vsync 1 bit
        * red 3 bit
        * green 3 bit
        * blue 2 bit

    * Bussen  
        In:  
        * Active 1 bit

        Massa till/från...  

* Hur ska vi hantera reset/start?
    Vi borde kunna detektera reset knappen från FPGA:n. Därefter kan vi i början av mikrokoden kolla om vi har reset och sen hoppa till en uppstartskodsnutt som ska göra:

    1. Fyll minnet med DAT instruktioner
    2. Rensa PC köerna
    3. Hämta och lägg in PC player 1
    4. Fyll i player 1 program
    5. Hämta och lägg in PC player 2
    6. Fyll i player 2 program
    7. Reset status (Game over etc)

    Borde fungera ganska bra?

* Hur allokerar vi det fysiska minnet i FPGA:n med kod i VHDL?

Schema
------

## v12
- bestämma projekt  
    DONE
- skriva en kravspec (KS)  
    DONE
- Olle godkänner KS  
    DONE
- pdf -> Olle senast fredag 1700  
    DONE

## v13
- skriva designskiss (DS)  
    DONE
- träffa handledaren  
    DONE
- handledaren godkänner DS  
    DONE
- pdf -> Olle senast fredag 1700  
    DONE
- delta i en lab till  
    DONE

## v14-15
- Påsk + omtentaP  
    DONE

## v16
- skriva VHDL, 1:a byggveckan

## v17
- skriva VHDL, 2:a byggveckan
- ungefär mitt i projektet finns en milstolpe, till vilken hör beslutspunkt 1. Vi kollar om ni har klarat av milstolpen.  
  fredag 27/4 15-17  
  måndag 30/4 15-17

## v18
- skriva VHDL, 3:e byggveckan

## v19
- skriva VHDL, 4:e byggveckan
- strax före redovisningen finns beslutspunkt 2, där vi kollar att ert bygge uppfyller kravspecen

## v20
- Redovisning
- demonstrera apparaten
- hålla en muntlig presentation
- skriva en teknisk rapport
- lämna tillbaka alla komponenter

