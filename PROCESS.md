## Day 2 // 10-01-17

- Idee dieper uitgewerkt en alle views, met hun onderlinge relaties, uitgetekend. Hierbij ontdekt, dat mijn idee toch behoorlijk groot en complex kan worden. Daarom een prioriteitenlijst gemaakt, waarin de belangrijkste functionaliteit bovenaan staat en waarbij de app nog steeds functioneel zou zijn als onderdelen lager op de prioriteitenlijst niet uitgevoerd worden.
- Ontdekt dat push notifciaties waarschijnlijk erg lastig te implementeren zijn (bepaalde key/betaalde developer account nodig). Deze fuctionaliteit is echter niet essentieel voor de werking van de app, dus kan eventueel achterwege gelaten worden.
- Kalender View in het rooster bestaat geen standaard view in Xcode voor, maar heb goede hoop dat het wel gaat lukken met een op Cocoapods gevonden framework.

<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/AdvancedSketches.jpg" width="200px"></br>
Afbeelding van schetsen van alle views. <a href="https://github.com/jasperscholten/programmeerproject/blob/master/doc/AdvancedSketches.jpg">Klik hier voor de originele grootte.</a>

## Day 3 // 11-01-17

- Winkel ID toevoegen, zodat met meerdere vestigingen gewerkt kan worden.
- Organisatie ID toevoegen, zodat de app door meerdere bedrijven gebruikt kan worden.
- Zelfde mainmenu gebruiken voor zowel leidnggevenden als medewerkers, alleen onderscheid maken in de cellen (opties) die zij te zien krijgen.
- Je moet kunnen verdergaan met een beoordeling die je hebt stopgezet.

## Day 4 // 12-01-17

- Ontdekt dat afbeeldingen op een iets andere manier moeten worden opgeslagen in Firebase, dan bijvoorbeeld gewone tekst. https://firebase.google.com/docs/storage/ios/start
- Manier om placeholder te maken in text view: http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
- Foto maken om toe te voegen aan nieuwitem kan nog lastig worden. https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift

## Day 5 // 13-01-17

- Toon een melding wanneer ervoor wordt gekozen een admin te registreren (weet je het zeker?). Vervolgens, wanneer op registreren wordt geklikt, automatisch een e-mail sturen naar de geregistreerde medewerker met daarin gebruikersnaam en wachtwoord. **Deze moet hij dan eigenlijk zelf nog kunnen aanpassen.** Gebruik voor sturen mails MessageUI framework. https://www.hackingwithswift.com/example-code/uikit/how-to-send-an-email
