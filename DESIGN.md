#Design Document
###Jasper Scholten, 11157887

## Modules or classes

## Sketches of your UI
<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/AdvancedSketches.jpg"></br>

## APIs and frameworks or plugins
- UIKit
- Firebase

## Database tables and fields

***gebruiker***
- gebruiker ID (uniek)
- e-mailadres (uniek)
- wachtwoord
- personeelsnummer
- naam
- rol (medewerker/leidinggevende)

***formulierregel***
- beoordelingsformulier ID (uniek)
- Vraag

***beoordeling***
- beoordeling ID (uniek)
- beoordelingsformulier ID
- medewerker ID (gebruiker ID medewerker)
- observator ID (gebruiker ID leidinggevende)
- datum en tijd
- vraag statussen (true/false)
- opmerkingen

***rooster-item***
- medewerker ID (gebruiker ID medewerker)
- Datum en Tijd
- Koppelen aan kalender framework?

***nieuws-item:***
- item ID
- item titel
- item afbeelding
- item tekst
