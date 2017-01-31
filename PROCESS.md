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

## DAY 10 // 20-01

- Ontdekt dat heel vaak .childByAutoId gebruikt moet worden, om ervoor te zorgen dat alleen data wordt getoond voor specifieke bedrijven, formulieren, etc. Dit is nu op veel plaatsen geïmplementeerd.
- Lastig om verschillende karakters in een String te laten filteren. Dit doe ik nu in meerdere stappen, iedere keer een nieuwe string maken waarin één type karakter is vervangen, maar dat zou ik liever in één stap willen doen.

## DAY 11 // 23-01

- Nu nog steeds een probleem dat vaak (niet altijd) twee keer achter elkaar wordt ingelogd, waardoor mainMenu twee keer verschijnt (en er dus ook twee keer uitgelogd moet worden). Mogelijk is <a href="http://stackoverflow.com/questions/40874825/viewcontroller-is-appearing-2-5-times-on-push-login-screen-using-firebase-vide">dit het probleem</a>, maar hoe dat op te lossen?
  - Overigens ook nog steeds het probleem, dat wanneer wordt uitgelogd en de app wordt afgesloten (cmd+shft+H, dan simulator stoppen en weer runnen) er bij opnieuw openen automatisch weer wordt ingelogd bij de vorige gebruiker.
  - <a href="https://forums.raywenderlich.com/t/firebase-tutorial-getting-started/19964/55">Hier de oplossing kunnen vinden.</a>
- Soms, op ogenschijnlijk willekeurige momenten, crashte de app bij het opslaan van een nieuwe review. Bij debuggen kwam deze situatie op een gegeven moment echter niet meer voor; ik weet echte rniet of dat betekent dat het nu is opgelost...
- Moet er voor zorgen dat een organisatienaam maar één keer gekozen kan worden, zodat er geen schijnorganisaties kunnen komen.
- Problemen met het opslaan van locaties: het lukt nu niet om een nieuwe locatie op te slaan (er wordt overschreven, bij verwijderen van een eerder crasht de app). Het lijkt hierbij vooral een probleem dat het geheel als array wordt opgeslagen en dynamisch moet zijn (geen vooraf bepaalde keys heeft).

## DAY 12 // 24-01

- Vandaag de kwestie 'locaties toevoegen' (waarschijnlijk) opgelost. Veel lopen stoeien met de correcte vorm voor het opslaan van deze data en hoe dit dan gelinkt moest worden aan alle gebruikers. Daarnaast op een paar plaatsen met autoID's in plaats van namen gaan werken, wat nog een behoorlijke klus opleverde om dit op alle plaatsen goed door te werken.

## DAY 13 // 25-01

- Eigenlijk zou het fijn zijn, als de functionaliteit wordt ingevoerd waarmee admins alleen de medewerkers van hun eigen vestiging kunnen inzien en beoordelen. Dit brengt echter wel de toevoeging mee, dat er ook masteraccounts moeten zijn die wél (een groter deel van) alle gebruikers kunnen inzien. Rolverdeling wordt hier een nog groter issue.

- Ik ben wat aan het testen en opeens lijkt het alsof bepaalde tekens toch wel ingevoerd mogen worden, terwijl ik eerst een error van Firebase kreeg dat ze juist niet toegestaan waren. Na weghalen van de code die het probleem eerst verhielp, doet de app het nu echter evengoed...
  - Toch weer teruggezet, omdat ik heb achterhaald waarom dit erin moet. Deze karakters kunnen namelijk wel als 'value' worden opgeslagen, maar niet als 'key'. Voor de reviews is dat echter wel het geval en daarom moeten ze er uit worden gefilterd. 

```Swift
// let replaceString = ".#$[]"
let deleteDot = text?.replacingOccurrences(of: ".", with: "")
let deleteHash = deleteDot?.replacingOccurrences(of: "#", with: "")
let deleteDollar = deleteHash?.replacingOccurrences(of: "$", with: "")
let deleteBracket = deleteDollar?.replacingOccurrences(of: "[", with: "")
let newText = deleteBracket?.replacingOccurrences(of: "]", with: "")
```

## DAY 14 // 26-01

- Gisteravond heb ik de app op m'n telefoon gezet om aan anderen te laten zien, maar toen ik een review wilde opslaan crashte de app. Ik kon nu dus alleen niet in de console zien wat er precies misging - iets om nog uit te zoeken...

## DAY 15 // 30-01

Volgens mij de oplossing voor het dubbel inloggen probleem gevonden! In eerste instantie leek de oplossing te zijn om de StateDidChangelistener en de accpeted check om te draaien. Dit hield in:

```Swift
FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
    if user != nil {
        self.ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let userData = User(snapshot: item as! FIRDataSnapshot)
                if userData.accepted == true {
                    self.performSegue(withIdentifier: "loginUser", sender: nil)
                    self.mail.text! = ""
                    self.password.text! = ""
                }
            }
        })
    }
}
```
Veranderde in:
```Swift
ref.observe(.value, with: { snapshot in
    for item in snapshot.children {
        let userData = User(snapshot: item as! FIRDataSnapshot)
        if userData.accepted == true {
            FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
                if user != nil {
                    self.performSegue(withIdentifier: "loginUser", sender: nil)
                    self.mail.text! = ""
                    self.password.text! = ""
                }
            }
        }
    }
})
```

Ik kon alleen niet begrijpen waarom dit zou werken. Eerst dacht ik dat het halen van de data uit Firebase te lang duurde, waardoor de segue alvast werd uitgevoerd en dan voor een tweede keer als de juiste data was gevonden in Firebase. Dit kon ik echter niet geloven, omdat dit de logica zou tegenspreken. Opeens realiseerde ik mij echter waar het probleem waarschijnlijk zat: ik checkte niet of de **huidige gebruiker** al was geaccepteerd, maar deed dit simpelweg voor iedere gebruiker in de database. Hierdoor kon het voorkomen dat voor meerdere geaccepteerde gebruikers een segue werd uitgevoerd. De nieuwe code die nu wel lijkt te werk ziet er daarom als volgt uit: 

```Swift
FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
    if user != nil {
        self.ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let userData = User(snapshot: item as! FIRDataSnapshot)
                if userData.uid == user?.uid {
                    if userData.accepted == true {
                        self.performSegue(withIdentifier: "loginUser", sender: nil)
                        self.mail.text! = ""
                        self.password.text! = ""
                    }
                }
            }
        })
    }
}
```
Het zijn nu misschien ietwat veel for- en if-statements, maar deze oplossing lijkt in ieder geval te werken!

**UPDATE:** Lijkt toch niet te werken...

## DAY 16 // 31-01

**INLOG UPDATE:** Met de hulp van Dax, lijk ik het nu toch werkend gekregen te hebben. Op zijn aanraden de addStateDidChangeListener de deur uitgedaan en in plaats daarvan FIRAuth.auth()?.currentUser?.uid gaan gebruiken om te bepalen of de gebruiker al ingelogd is (als er geen current uid is, dan is er ook geen gebruiker ingelogd). Het lijkt nu alsof er geen 'dubbele dingen' gebeuren, dus ik heb goede hoop dat dit de oplossing is!

- Keyboardfunctions in een extension gezet, waardoor een aantal viewcontrollers (loginVC, registerVC, registerEmployeeVC, addEmployeeVC) nu substantieel 'schoner' zijn geworden.
- Menu's worden op iPhone 6 nu allemaal goed weergegeven. Enige probleem is nu dat er bij settingsVC een waarde gehardcode staat, omdat deze anders verschuift tussen viewDidLoad en viewDidAppear.
- Eén van de menu's wil nog niet in portrait mode blijven staan.

**Dit is de TODO lijst die ik nu nog heb staan:**

- [ ] Statische menu’s vastzetten in portrait
- [x] Menu goede constraints geven: ook bij draaien scherm vullen
- [x] Menu’s goede hoogte meegeven
- [ ] Switch goed in cel plaatsen
- [ ] Nieuwsfoto niet tonen wanneer niet bestaat
- [ ] Nieuwsfoto niet in geheugen zetten
- [ ] State restoration
- [ ] Gerelateerde data gebruiker verwijderen
- [ ] Huidige gebruiker niet tonen in lijsten
- [ ] Code netjes maken
- [ ] Comments
- [ ] Final Report schrijven
- [ ] PROCESS updaten —> Overal een oplossing voor gevonden?
- [ ] README updaten
