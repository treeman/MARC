
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

* Dela upp schemat i block och definiera in- och utsignaler. Dessa kan vi sedan göra var för sig.
    Förslagsvis:
    * Fifo
    * Primärminnet
    * Minneshantering runt om primärminnet
    * ALU
    * Mikrominnesdelen
    * I/O med FBART
        Vi behöver endast input
    * Grafikdel
    * Bussen
        Massa till/från
        Aktivera buss

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

