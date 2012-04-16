NOTE: COREWAR, Get it @ http://www.koth.org/pmars/

- (Jesper)  Kommentarer till Blockschemat:
    *   Vår UART arbetar med 8 bitar och vi använder 13 bitar över allt annat i maskinen. Jag anser att vi bygger något som tar 2 st 8 bitars medelanden och bygger ihop dem till ett 16 bitars medelande där de 3 första kan vara kontroll bitar (kommandon, etc).
    *   Vi behöver en ränkade till µDatorn så vi kan ställa in hur lång tid det ska gå mellan varje instruktion (från möte med handledare).

- (Jonas)
    * Ja. Enklast vore att bara ha ett tvådelat register mellan input och bussen där vi fyller ena sidan, sen den andra och sen skickar ut på bussen. Kan skötas av mikrokod ganska simpelt?
    * Ja.

- (Jonas)
    * Har uppdaterat blockschemat. Har delat ut lite in/ut signaler till vissa saker.

      Jag tycker att det här ska vi klara av denna vecka:

      * Hämta ut vår FPGA
      * Rita ut en fyrkant med VGA
      * Hämta en 13 bit input genom uart
      * Dela upp ansvarsområden att implementera (tycker VGA + uart görs genemsamt, iaf VGA:n)
        Dela upp ut/in signaler i våra block.

      Eller vad sägs?

