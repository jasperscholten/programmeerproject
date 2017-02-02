<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/comcomLogo-83.5%402x.png">

# Final Report, Jasper Scholten 11157887

**COMCOM is een app die interne bedrijfscommunicatie kan vereenvoudigen voor zowel kleine als grote organisaties. Dit wordt gedaan door twee processen te faciliteren: het stroomlijnen van medewerker beoordelingsproces en het delen van (korte) nieuwsberichten binnen een vestiging. Leidinggevenden (admin gebruikers) kunnen hierbij medewerkers beoordelen en nieuwsberichten plaatsen, terwijl medewerkers alleen nieuwsberichten en hun eigen resultaten kunnen inzien.**

<p align="center">
<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/addReviewScreenshot.png" width="300">
<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/newsItemScreenshot.png" width="300"></br>
<i><b>Links:</b> uitvoeren van een beoordeling. <b>Rechts:</b> tonen van een nieuwsitem.</i>
</p>

# Design

Het doel van **COM**COM is om de interne communicatie van organisaties te verbeteren, dus moet de aandacht zoveel mogelijk liggen op de boodschap die de gebruiker probeert over te brengen. Een beoordeling moet simpel en gebruiksvriendelijk uit te voeren en in te zien zijn; een nieuwsbericht moet zijn boodschap snel kunnen overbrengen. Om eenvoud en gebruiksgemak in de app te verwerken, is ervoor gekozen om de UITableView als een vast element in de app te laten terugkomen. Een overzicht van alle componenten toont dan ook, dat het merendeel van de ViewControllers in basis een tableView representeren, waarin (Firebase) data wordt getoond. 

## ViewControllers

De app heeft globaal gezien 6 functionaliteitsgroepen: 
- Login- and Registerprocess
- Settings
- Review Process
- Show Results
- Add and Change Forms
- News

Het Login- and Registerproces is het eerste dat de gebruiker te zien krijgt. Dit bestaat uit drie ViewControllers, die allen bestaan uit een x-aantal tekstvelden en knoppen. Hiermee kan een bestaande gebruiker zich aanmelden, een nieuwe gebruiker een account aanmaken en gelijk de organisatie registreren, oefen nieuwe gebruiker zich aanmelden bij een bestaande organisatie. Daarnaast houden RequestsVC en AddEmployeeVC zich bezig met het accepteren van inschrijfverzoeken.

Na aanmelden en inloggen, komt de gebruiker bij de MainMenuVC terecht: dit is het centrale punt in d structuur van de overige functionaliteitsgroepen. Het main menu bestaat uit een tabel met menu-opties, die de gebruiker de mogelijkheid geeft door de app te navigeren. Iedere optie leidt naar een ‘tak’ van ViewControllers die een bepaalde functionaliteit mogelijk maken (bv. beoordelen, nieuws tonen, etc.). In het projectbestand in Xcode zijn de ViewControllers van iedere specifieke tak gegroepeerd in een map met de naam van die functionaliteit; deze structuur is hieronder volledig weergegeven.

* ViewControllers
  * MainMenu VC
  * Login- and Register Process
    * LoginVC.swift
    * RegisterVC.swift
    * RegisterEmployeeVC.swift
    * RequestsVC.swift
    * AddEmployeeVC.swift
  * Settings
    * SettingsVC.swift
    * LocationsVC.swift
    * EmployeeSettingsVC.swift
  * Review Process
    * ReviewEmployeeVC.swift
    * ChooseReviewFormVC.swift
    * NewReviewVC.swift
  * Show Results
    * ReviewResultsVC.swift
    * ReviewResultsEmployeeVC.swift
    * ReviewResultFormVC.swift
  * Add and Change Forms
    * FormsListVC.swift
    * AddFormVC.swift
  * News
    * NewsAdminVC.swift
    * NewsItemAdminVC.swift
    * AddNewsItemVC.swift


De map ‘Cells’ is op dezelfde manier gegroepeerd als die voor de ViewControllers, met mappen die dezelfde namen dragen als de functionaliteitsgroepen. Hierbij bevat iedere map de cellen, die worden gebruikt in de tableViews van de ViewControllers in die groep. Zo zal bijvoorbeeld de cel die wordt gebruikt om een nieuwsitem weer te geven in het nieuwsoverzicht, te vinden zijn in de map Cells > News.

Alle bestanden die in de Cells structuur te vinden zijn hebben dezelfde functionaliteit en vorm. Ze hebben weinig inhoud, maar worden alleen gebruikt om outlets van de elementen in de cel in te plaatsen, zodat deze eenvoudig aangeroepen kunnen worden in de ViewControllers. Er is geen logica in deze bestanden verwerkt.

## Models

De map ‘Models’ bevat bestanden die van belang zijn bij het werken met Firebase. Ieder bestand bestaat uit een struct, waarin de eigenschappen van een bepaalde ‘tak’ in Firebase worden beschreven. Iedere eigenschap staat voor een waarde die kan worden opgeslagen in de database, zoals bijvoorbeeld de naam van een gebruiker of de organisatie waar hij/zij werkt. Er zijn bestanden voor: 

- **Organisaties** (Organisation.swift), met een unieke organisationID. 
- **Gebruikers** (User.swift), met een unieke employeeID. Gebruikers zijn aan een organisatie gekoppeld via de organisationID
- **Beoordelingsformulieren** (Form.swift), met een unieke formID.
- **Beoordelingsvragen** (Questions.swift), met een unieke questionID. De vragen zijn gekoppeld aan een beoordelingsformulier via de formID.
- **Beoordelingen** (Review.swift),  met een unieke reviewID. Zijn gekoppeld zijn aan een gebruiker via employeeID. Vragen en antwoorden worden opgeslagen in een dictionary, waarbij de vraag de ‘key’ is en het antwoord de ‘value’.
- **Nieuwsitems** (News.swift), met een unieke itemID. Als er ook een afbeelding is toegevoegd aan het nieuwsitem, dan wordt deze in Firebase Storage opgeslagen met als naam de itemID van het artikel. Hierdoor kunnen het item en de afbeelding later weer eenvoudig gekoppeld worden.

Naast deze eigenschappen, gevat in een aantal lets, worden er ook een aantal functies geïmplementeerd die de omgang met Firebase vereenvoudigen. init(snapshot: FIRDataSnapshot) zorgt ervoor dat er makkelijk een *snapshot* van de data kan worden gemaakt, wanneer deze uit Firebase opgehaald moet worden. Verder maakt toAnyObject() het eenvoudiger om input van de gebruiker om te zetten in het gewenste format voor opslaan in Firebase.

In Firebase worden ook nog de verschillende locaties van een organisatie opgeslagen, waarbij deze als waarde worden toegevoegd aan een child met als naam de organisationID. Hiervoor is echter geen apart bestand gemaakt, omdat dit maar om één waarde gaat, die bovendien maar op weinig plaatsen wordt gebruikt. Hierbij is de afweging gemaakt en besloten dat dit eerder verwarrender zou worden, dan de code zou verbeteren.

## Extensions

De laatste bestanden die nog zijn toegevoegd, zijn te vinden in de map ‘Other’; dit betreft twee extensions op de UIViewController. AlertExtension voegt een functie toe (alertSingleOption), waarmee eenvoudig een alert met alleen een ‘OK’ knop kan worden gemaakt. Hierbij moet de gebruiker twee parameters geven, die staan voor een titel van het alert en een toelichting (message).

KeyboardExtension is een iets uitgebreidere extension, met functies die gebruikt kunnen worden om het ‘voorkomen’ van het toetsenbord te beïnvloeden. keyboardWillShow en keyboardWillHide dragen eraan bij, dat het scherm gedeeltelijk omhoog schuift als het toetsenbord verschijnt en weer terug schuift als het toetsenbord weer verdwijnt. Dit zorgt ervoor dat tekstvelden, knoppen, etc. zichtbaar blijven. dismissKeyboard heeft daarnaast als functie om, verassing, het keyBoard te laten verdwijnen. Deze functie wordt aangeroepen als ergens buiten het toetsenbord of een invulveld wordt gedrukt.

## Database tables and Fields

Onder het kopje models is al een korte toelichting gegeven op de inhoud van Firebase. De verschillende tabellen en hun velden zijn daarnaast hieronder ook nog eens weergegeven.

**Forms**
* formID
  * formID
  * formName
  * organisationID

**Locations**
* organisationID
  * locationName
  
**News**
* itemID
  * date
  * itemID
  * locationName
  * organisationID
  * newsItemText
  * newsItemTitle
  
**Organisations**
* organisationID
  * organisationName
  * organisationID

**Questions**
* questionID
  * formID
  * organisationID
  * question
  * questionID
  
**Reviews**
* reviewID
  * date
  * employeeID
  * employeeName
  * formName
  * locationID
  * observatorName
  * remark
  * reviewID
  * result
    * [question: answer]
    
**Users**
  * uid
    * accepted
    * admin
    * email
    * employeeNr
    * locationID
    * name
    * organisationID
    * organisationName
    * uid

## Sketches of your UI

# Proces

Het programmeerproject is voor mij een leuke en leerzame periode geweest, omdat ik hierin in feite (een beetje) op eigen benen heb leren staan. Ik heb met **COM**COM een app gemaakt, waarvan ik begin september misschien niet had durven dromen dat ik daar aan het einde van de minor toe in staat zou zijn. Aan het begin van dit project had ik echter wel al meer kennis van mijn eigen programmeerkunde gekregen, want ik heb in het initiële app-ontwerp een aardig beeld kunnen schetsen van hoe de app er uiteindelijk uit zou komen te zien. Toch hebben er gedurende het proces zeker veranderingen plaatsgevonden, die voor een groot deel in PROCESS.md beschreven zijn. De meest belangrijke uitdagingen, die de kern van **COM**COM soms hebben veranderd, worden hieronder toegelicht.

## Firebase: het centrale, veranderlijke element van COMCOM

Al in een vrij vroeg stadium ontdekte ik, dat de Firebase-component een centrale rol zou gaan spelen in de ontwikkeling van mijn app. De grootste moeilijkheidsgraad zat in het solide en correct ontwerpen, schrijven, lezen en manipuleren van de data in Firebase. Ik had een ambitieus web in gedachte van verschillende gebruikers, uiteenlopende rollen, vele soorten formulieren, meerdere organisaties met meerdere vestigingen, etc. Veel veranderingen ten opzichte van mijn design document hebben dan ook te maken met de database structuur: een extra tabel toevoegen, een tabel iets uitbreiden, twee tabellen via een gemeenschappelijke ID aan elkaar koppelen, etc.

Eén van de eerste belangrijke veranderingen op dit gebied betrof het gebruik van organisatie ID’s. Het initiële idee hierachter was, dat iemand niet alle gegevens van een bestaande organisatie zou kunnen overschrijven door simpelweg een organisatie onder exact dezelfde naam te registreren. Toen dit probleem later werd opgelost door simpelweg een check toe te voegen of een bepaalde naam al was ingeschreven, bleef het echter belangrijk en nuttig om database entries voortaan te voorzien van een unieke ID. Zo ben je er zeker van dat niets wordt overschreven en er niet ongewenst de verkeerde dingen in de database worden veranderd/verwijderd. Bovendien stelt het je in staat om bijvoorbeeld twee werknemers met dezelfde naam in dienst te hebben, zonder dat zij worden beoordeeld onder hetzelfde account.

Een ander moment waarop het nut van ID’s naar voren kwam, was toen ik bezig was met het ontwerpen van de functionaliteit rondom beoordelingsformulieren. Door deze een unieke ID te geven, stel je organisaties namelijk in staat formulieren toe te voegen met iedere gewenste naam. Zou je de naam als sleutel gebruiken, dan kan het voorkomen dat twee verschillende organisaties allebei een formulier onder de naam ‘Kassa’ maken en daarmee onbewust elkaars formulieren overschrijven.

## Aanmeld en inlog perikelen

Goed ontwerpen van de database, waarbij aan alle eisen wordt voldaan, bleek dus een essentieel onderdeel van de app, waar dan ook veel aandacht aan is besteedt in het hele ontwikkeltraject. Een ander (Firebase gerelateerde) uitdaging die al snel naar boven kwam, had te maken met het aanmelden en inloggen. 

Allereerst zorgde de verschillende gebruikersrollen hier voor een probleem. Het eerste idee was namelijk, dat er admin gebruikers zouden zijn (leidinggevenden), die hun werknemers zouden toevoegen. Vervolgens zouden de werknemers dan een bericht met hun gegevens ontvangen, waarmee ze konden inloggen en dan hun wachtwoord moesten veranderen. Veel uittesten en rondkijken op het internet, deed mij echter concluderen dat het lastig was om dit proces goed te laten plaatsvinden. Je kon een leidinggevende namelijk wel een account voor een ander laten aanmaken, maar dan zou hij automatisch ook ingelogd worden op dat account. Dit uitte zich bij **COM**COM in het feit, dat een admin gebruiker na registratie van niet-admin gebruikers alleen nog het (minder uitgebreide) niet-admin hoofdmenu te zien kreeg.

Na lang wikken en wegen, besloot ik daarom om het hele aanmeldt proces op de schop te gooien. Hierdoor konden meteen mijn bezwaren worden verholpen, dat ik het als gebruiker misschien wel fijner zou vinden om zelf te kunnen inloggen (direct zelfgekozen e-mail en gebruikersnaam) en dit daarnaast een hoop werklast zou weghalen bij admins voor het invoeren van alle werknemers (niet gebruiksvriendelijk). 

De uitdaging was nu echter, dat niet zomaar iedere gebruiker toegang moest kunnen krijgen tot de omgeving van iedere organisatie. Wanneer je inschrijvingen simpelweg zou accepteren, kon iedereen zomaar toegang krijgen tot de interne communicatie van iedere gewenste, ingeschreven onderneming. De oplossing hiervoor werd (opnieuw) gevonden in het toevoegen van een extra eigenschap in de users database tabel. Door hierin, met een Boolean waarde, aan te geven of een gebruiker al was geaccepteerd, kan je voorkomen dat hij bepaalde content te zien krijgt. Er werd daarbij een extra feature (ViewController) toegevoegd, waarmee admins inschrijfverzoeken kunnen inzien, op bepaalde punten kunnen verbeteren en vervolgens kunnen accepteren. Hiermee was, door het compleet anders aan te pakken, ook dit probleem opgelost. Uiteindelijk heeft dit gedwongen herzien van het ontwerp, in mijn ogen geleidt tot een betere app.

## Focus vernauwt, maar kan je daardoor juist meer leren

In het proces was misschien wel de grootste uitdaging, om uit te vinden hoe ik het concept van **COM**COM precies wilde neerzetten en uitwerken. In het originele idee faciliteerde de app interne bedrijfscommunicatie op meer onderdelen dan alleen beoordelingen en nieuws; er was ook ruimte voor een rooster. Al snel kwam ik er echter achter dat, zeker gezien de tijd, focus belangrijk was. Het is altijd beter om een volledig werkende app met beperkte functionaliteit af te leveren, dan een zeer uitgebreide app waarvan maar de helft functioneert. 

Ik dwong mijzelf om na te gaan welke aspecten van het idee ik het meest belangrijk vond en besloot zo om alleen beoordelingen en nieuws te implementeren. De nadruk zou hierbij liggen op beoordelingen, omdat dit naar mijn idee het meest onderscheidende aspect van de app was. Daarnaast leek het toevoegen van nieuws mij relatief eenvoudig, maar wel nuttig en leuk om communicatie tussen organisatie en werknemer te verbeteren.

Anders dan je misschien zou verwachten, heb ik het idee dat deze focus mij niet minder heeft laten leren; integendeel. Doordat er focus was op bepaalde onderdelen, kon aan die aspecten meer aandacht en tijd besteedt worden. Hierdoor werden ze meer uitgediept en werd ik er meer een expert in. Ik merkte dit, doordat ik andere studenten op een gegeven moment heel goed kon helpen bij hun problemen met betrekking tot bijvoorbeeld tableViews, segues, verschillende gebruikersrollen, etc.

Ook kon ik nog steeds nieuwe technieken blijven leren. Ik heb dan namelijk wel frameworks voor bijvoorbeeld een calenderView en notificaties laten varen, maar daarvoor in de plaats kwamen onder andere de pickerView en Firebase Storage. Doordat ik meer aandacht aan nieuwsitems kon besteden, had ik de mogelijkheid om het toevoegen van foto’s aan zo’n bericht beter uit te werken; hierdoor werden dit soort elementen van de **COM**COM beter dan ik in eerste instantie bedacht. Ditzelfde geldt voor het continu verbeteren van mijn skills op het gebied van tableViews en het manipuleren van elementen in de app tijdens het gebruik van het toetsenbord.

# Beslissingen
