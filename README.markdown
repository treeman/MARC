Idéer
=====

NOTE: COREWAR finns till linux, kolla i er favorit package manager!

* Brainfuck

Reply från Olle:
Ni kan få göra BF om

1. någon finess tillkommer
2. någon tydlig uppgift för datorn. Inte bara köra kod, som någon annan har gjort.

/Olle

---

* FukYorBrane

FukYorBrane är ett mellanting mellan Brainfuck och CoreWars. Specifikation finns här: <http://esoteric.voxelperfect.net/files/fyb/doc/fyb_spec.txt>

Kan bli svårt att hoppa över instuktioner snabbt, instruktionerna [] {} & :; bygger på det.
Man kan editera minne för att sedan 'commita' det till minnet, man kan även uncommita. Framgår ej exakt hur detta går till (går det bara på en cell i taget, eller finns det en orginal kopia av programmet någon stands?) Kan bli svårt beroende på hur de menar.

Programmen ser trevligt obskyra men ändå vettiga ut, ex: <http://esoteric.voxelperfect.net/files/fyb/src/retired/logicex-1.fyb>

---

 * ICWS-88 CoreWars

ICWS-88 Är den ursprungliga standarden till CoreWars, den har endast 10 instruktioner och 4 addressing modes (till skillnad från ICWS-94 som har 18 instuktioner, fuckload av addressingmodes och multiplikation, modulo som instuktioner). Specifikation finns här: <http://corewars.nihilists.de/redcode-icws-88.pdf>
Denna är i princip en µProgramerad Von Neumann dator med flera stycken PC:s.


Instruktionsformatet är: OP MEMMODE1 ADR1 MEMMODE2 ADR2. Detta ska få plats i en 'minnescell', det kan vara svårt att kunna blanda detta med data (som minnet kommer bestå som mest utav) utan att behöva kasta bort en massa minne.

---

Både FukYorBrane & ICWS-88 CoreWars har samma utmaning här; man ska kunna skapa och ta bort trådar. Detta borde lösas med två (fler!?) arrays av PCs, kanske finns någon mer vettig datastuktur som länkad lista.
Man skulle även vilja ha någon form av grafisk / terminal output av minnet i båda fallen.

---

* Pipelinad processor, CISC eller RISC (eller OISC FFS!), med en specific beräkningsuppgift

Vi skulle kunna göra en pipelinad processor med målet att göra den väldigt snabb. Kanske.. T.ex. en MAC som beräknar skalärprodukter supersnabbt. Eller beräkna fibonacciserien? Matrismultiplicationer? Implementera newton-rhapson eller runge-kutta's metod för att uppskatta derivatan? En krypterings/dekrypteringsmaskin?!

Då multiplikation ej kan utföras på en CP vet jag inte om vi tjänar så mycket på en frikking pipeline då denna borde behöva stallas hela tiden. Om vi vill ha komplexa instruktioner bör vi satsta på µProgramerad dator.

Newton & Runge borde behöva flyttal, vilket iof skulle vara intressant att implimentera.

Todo
====

## v12
- bestämma projekt
- skriva en kravspec (KS)
- Olle godkänner KS
- pdf -> Olle senast fredag 1700

## v13
- skriva designskiss (DS)
- träffa handledaren
- handledaren godkänner DS
- pdf -> Olle senast fredag 1700
- delta i en lab till

## v14-15
- Påsk + omtentaP

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

