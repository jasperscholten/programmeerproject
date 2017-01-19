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
- Presentatie Feedback: Prioriteiten stellen - wat wil je echt hebben, wat is extra? Denk ook na over de toegevoegde waarde van exporteren.

## Day 6 // 16-01-17

- Voor iedere user wil ik een aantal elementen in de Firebase opslaan. Ik krijg nu echter een error: Return from inititalizer without initializing all stored properties. Dit komt waarschijnlijk doordat ik bij authData niet alle elementen initialiseer; het is alleen volgens mij helemaal niet de bedoeling om dat daar te doen, omdat ik niet alle onderdelen nodig zijn om als gebruiker in te loggen. Ik heb hoe dan ook (eisen aan) de structuur van dit bestand nog niet helemaal door. --> Gebruik Optionals

```Swift
struct User {
    
    let uid: String
    let email: String
    
    //let name: String
    //let role: Bool
    //let employeeNr: String
    //let organisationID: String
    //let locationID: String
    
    var name: String?
    var role: Bool?
    var employeeNr: String?
    var organisationID: String?
    var locationID: String?
    
   ...
}
```

- Nog niet uit hoe ik een datum en tijd wil gaan opslaan in Firebase, en dit ook goed wil communiceren tussen de app en de database. http://stackoverflow.com/questions/29243060/trying-to-convert-firebase-timestamp-to-nsdate-in-swift --> In overleg met Julian kwam naar voren, dat ik gewoon Swift de huidige tijd kan laten genereren en deze dan als string kan opslaan (hoef er later ook geen berekeningen meer op uit te voeren).

## Day 7 // 17-01-17

- Eigenlijk vooral problemen met het gebruikers laten aanmaken door andere gebruikers, omdat hierbij automatisch wordt ingelogd op de account van de nieuwe gebruiker. Dit is echter niet gewenst, maar ik kan nergens een oplossing vinden om dit te voorkomen. Mogelijk hier iets? --> https://firebase.google.com/docs/auth/ios/manage-users#re-authenticate_a_user
  - Misschien moet het proces omgegooid worden. Een admin kan medewerkers een toegangscode toesturen, waarmee zij kunnen een eigen account kunnen registreren. Vervolgens kan een admin de waarden van die accounts aanpassen (bv. bepaalde gebruikers admin maken).
  
## DAY 8 // 18-01-17

- Om het probleem van automatisch inloggen te verhelpen, met een nieuwe opzet van de registreer routine gekomen. Hierin krijgt de medewerker ook meer mogelijkheden om direct zijn eigen mail en wachtwoord te kiezen, omdat deze zichzelf moet inschrijven en daarmee een verzoek moet sturen aan zijn eigen organisatie. Vervolgens kan een admin deze verzoeken inzien en mensen accepteren.

<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/newSignupRoutine.jpg" width="600px"></br>
<a href="https://github.com/jasperscholten/programmeerproject/blob/master/doc/newSignupRoutine.jpg">Klik hier voor de originele grootte.</a>

## DAY 9 // 19-01

- Behoorlijk zitten knoeien met Firebase; hij vond steeds 'nil while unwrapping'. Uiteindelijk bleek o.a. dat de write and read rules nog niet op true stonden (tussendoor, onbewust, automatisch aangepast) en heb ik 'persistence enabled' verwijderd uit de AppDelegate. Vervolgens werd er alleen bij veranderingen (updateChildValues) steeds een nieuwe child node aangemaakt - dit heb ik opgelost door een kleine verandering aan te brengen:

```Swift
let ref = FIRDatabase.database().reference(withPath: "Users")

// ref.child("Users").child(user.uid).updateChildValues( /*...*/ )
ref.child(user.uid).updateChildValues( /*...*/ )
```


