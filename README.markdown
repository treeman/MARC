# Idéer

* Brainfuck

Reply från Olle:
Ni kan få göra BF om
   1) någon finess tillkommer
   2) någon tydlig uppgift för datorn. Inte bara köra kod, som någon annan har gjort.
 /Olle

---

* FukYorBrane

FukYorBrane är ett mellanting mellan Brainfuck och CoreWars. Specifikation finns här: <http://esoteric.voxelperfect.net/files/fyb/doc/fyb_spec.txt>

Kan bli svårt att hoppa över instuktioner snabbt, instruktionerna [] {} & :; bygger på det.
Man kan editera minne för att sedan 'commita' det till minnet, man kan även uncommita. Framgår ej exakt hur detta går till (går det bara på en cell i taget, eller finns det en orginal kopia av programmet någon stands?) Kan bli svårt beroende på hur de menar.

Programmen ser trevligt obskyra men ändå vettiga ut, ex: <http://esoteric.voxelperfect.net/files/fyb/src/retired/logicex-1.fyb]>

---

 * ICWS-88 CoreWars

ICWS-88 Är den ursprungliga standarden till CoreWars, den har endast 10 instruktioner och 4 addressing modes (till skillnad från ICWS-94 som har 18 instuktioner, fuckload av addressingmodes och multiplikation, modulo som instuktioner). Specifikation finns här: <http://corewars.nihilists.de/redcode-icws-88.pdf>
Denna är i princip en µProgramerad Von Neumann dator med flera stycken PC:s.


Instruktionsformatet är: OP MEMMODE1 ADR1 MEMMODE2 ADR2. Detta ska få plats i en 'minnescell', det kan vara svårt att kunna blanda detta med data (som minnet kommer bestå som mest utav) utan att behöva kasta bort en massa minne.

---

Både FukYorBrane & ICWS-88 CoreWars har samma utmaning här; man ska kunna skapa och ta bort trådar. Detta borde lösas med två (fler!?) arrays av PCs, kanske finns någon mer vettig datastuktur som länkad lista.
Man skulle även vilja ha någon form av grafisk / terminal output av minnet i båda fallen.

