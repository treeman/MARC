NOTE: COREWAR, Get it @ http://www.koth.org/pmars/

Lite frågor om stuff

* Hur skriver vi färgdata i dualport mem?
* Vad gör address out i minnen?
    Borde vi inte antingen göra:
        sätt adress_in, data_in och write
        eller
        sätt adress_in, data_ut och read
        ?
    Eller är adressregistren inbyggda där?
        Hur väljer vi när vi ska uppdatera dem?

* alu source styrsignal kan vara 1 bit (in till ALU:na) och göra 0 = nothing 1 = read
  och nu har vi bara en insignal i main buss in, men vi behöver en för varje för att kunna göra beräkningar samtidigt?
  Så en data ingång till varje alu?

* Är data registren under minnena integrerade inne i memory?
    Hur uppdaterar vi dem isåfall?

* ALU 1 som hanterar PC och sätter Z?

