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

# Beslissingen
