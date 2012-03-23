NOTE: COREWAR finns till linux, kolla i er favorit package manager!
      Dock använder man inte package managers! :p

# Ett awesomesauce namn till datorn!

Datorn i CoreWars heter MARS, vilket står för Memory Array Redcode Simulator.
Då detta ej är en simulator bör namnet vara något annat.

Den fick heta MARC, skjut mig om det inte är awesome nog!

# Dator!

- (Jonas) Apropå datordiagramet.
          Jag tror att det diagram vi ska göra nu handlar om användingen, inte implementationen.
          Nästa steg, designskissen, ska vi ha utförligt alla kopplingar dock.

          Sedan kanske vi kan direktmappa IO till memory för dumpning?
          Har ni funderat på att ha en FIFO, dvs en queue, per spelare? Annars kan man få problemet att den som spammar processer får ett övertag och snor alla platser i PC memory.
          Dessutom måste vi loopa igenom minnet tills vi hittar en valid PC till player 2 om player 1 har många PC.
          Om vi istället har två köer kommer båda få samma limit och vi slipper söka nästa PC, det är enkelt att beräkna den.
          Varför 2x ALU, SIMD?
          Vi kan inte köra båda PC samtidigt ändå då bussfördröjningen gör att vi inte tjänar nåt på det. Eller missar jag nåt?
          Då vi har t.ex. JMZ behöver vi SR, men koppla direkt till ALU så spelar det ingen roll egentligen.
          Vi behöver ett XR register om vi vill använda indexerad a-mod, vilket vi vill! Koppla den direkt till adressbussen med +1 så blir det bra.

- (Jesper) Kan dock inte skada inkludera båda diagrammen och säga att den ena är WIP.
        Jag försår inte varför du vill ha direktmappat IO i dumpningssyfte, enda skillnaden är att vi behöver kopiera
        en del av minnet till en annan (loopa igenom minnet, kopiera till en annan  minnescell)
        istället för att kopiera den till UARTEN. OBS: Om vi använder detta måste vi ha
        någon form av memory protection då våra Redcode program ej får komma åt IO delen av minnet.

        Vi har två köer utav PCs (implimenterad via 2 listor, minnet är delat i 2 via MSB som är kopplad till spelarvippan).
        Notera att endast en process kommer ha tillgång till CPUn i taget, spelarens processes om hans klockcykler.

        Det borde bli lättare och snabbare om vi har 2 st ALUs, speciellt om vi kopplar dessa till minnena (ALU1 -> minne 2,
        ALU2 -> minne 3), iaf enligt mina tankegångar.

        Då vi ej har ett ALU register (all data ligger i minnet, vi har ej ett akumulatorregister som lagrar vettig data)
        tror jag ej att ett SR behövs då detta räknas ut on the fly när kan kör en JMZ. (det kanske finns, fast det lagrar
        inte heller någon vettig data mellan instruktionerna).

        Se ovan; all data ligger i minnet, man har ej ett XR. (Sidenote, jag hittar ej indexerad A-mod i standarden)

- (Jonas)
        Direktmappad IO tänkte jag inte att kopiera till en buffer, men direkt ut från minnet.
        Vi skulle dock behöve en mer utarbetad I/O del och även behöva låsa minnet, om vi har en asynkron buss borde det fixa sig.
        Om vi skulle göra så att vi har en start/stop kan vi bara se till att aldrig mata in nya program medan vi kör.

        Två köer är bra, men vi kan lika väl implementera dem som två cirkulära köer med hårdvara! Behövs bara en read och en write
        pekare som man flyttar omkring. Dessutom behöver vi inte två PC, utan vi använder read pekaren som pekar ut nästa PC,
        vi behöver dock välja vilken av spelares köer vi ska köra. Blir mycket snabbare och lättare än att loopa runt i en lista och
        leta. Hur ska vi sortera om när vi lägger till en ny process? Eller tar bort en process? (Tror det går att ta bort en process?)

        Men vi kan inte mata data till 2 st ALUs då vi bara har en buss? De kommer stå tomma mycket då?
        Fast ja vi behöver ju såklart +1 lite varstans, men de räknar jag inte som en del i ALU:n där.

        Hmm ja det är nog sant, isåfall behövs nog inte SR.

        Sant vi hade inte indexerad!

- (Jesper) Jag tänkte att vi har 2 direktkanaler mellan minnena och ALUna. Vi får skissa lite på det och räkna klockcykler emot hårdvara.
        Har funderat lite på storkelen för minnena och kommit fram till följande:
 * Instruktionen måste minnst vara 8 bitar, 4 bitar för OP code och `2*2` bitar för adresseringsmoderna.
 * Antalet platser i minnet är vanligtvis 8000, 8192, eller 55440. Dessa behöver antingen 13 eller 16 bitar för att adresseras.

- (Jonas)
        Och hur skulle man bestämma vad varje ALU skulle göra? Men ja känns som att man borde skissa på det.

        Jag undrade lite på hur vi ska lagra adresseringsoperanden till de olika a-moderna?
        Stod i Redcode specen att varje instruktion endast upptog en rad, men det inkluderar väl knappast operanden som
        borde följas direkt efter instruktionen? Eller tänker jag helt helt fel? xD

        Storlekerna ser i övrigt bra ut. Jag har ingen aning hur mycket minne och så vi får tillgång till dock?

- (Jesper)
		Man styr ALUs via µKod som vanligt. Det är en instruktion per rad, inklusive operander. 
		EX: MOV 0, 1 (IMP-koden).
		Jag skulle lösa detta via att ha 3 parallella minnen med dessa innehåll:
		[ OP+ADDRModes: 8 bitar ] [ OPERAND1: 13-16 bitar ] [ OPERAND2: 13-16 bitar ]
		
		Det kan tillkomma 2 bitar till för ägande 'spelare' (visuellt)
		
		Jag hoppas att vi får tillgång till några hyfsat moderna minnen, alternativt att det finns minne på kortet.