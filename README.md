# Programmeerproject, Jasper Scholten, 11157887
[![BCH compliance](https://bettercodehub.com/edge/badge/jasperscholten/programmeerproject)](https://bettercodehub.com)

Uiteindelijk zal de app o.a. bestaan uit:
* Mogelijkheid tot invullen beoordelingsformulieren (teams, teamleider, etc.)
* Accounts maken (naam, personeelsnummer, mogelijk een profielfoto)
* Nieuwsitems plaatsen (met push notificatie)
* Rooster kunnen inzien
* Customizable voor iedere onderneming (logo, kleur)

Het bedrijf waar ik werk heeft te kennen gegeven, dat zij het lastig vinden om beoordelings- en functioneringsgesprekken goed vorm te geven. Om hiertoe in staat te zijn, is het belangrijk om het gesprek te kunnen baseren op (objectieve) waarnemingen. Op het moment is er binnen de onderneming echter nog geen tool voorhanden om dit eenvoudig te kunnen doen. Hierdoor worden gesprekken vaak nog ‘in de waan van de dag’ uitgevoerd, terwijl je hier liever een solide basis voor zou willen gebruiken die over de tijd is opgebouwd.

Om dit probleem op te lossen, kan een app ontwikkeld worden die de gebruiker in staat stelt snel en eenvoudig op de werkvloer beoordelingsformulieren in te vullen. De bedrijf/teamleider logt in met een ‘hoofdaccount’ en krijgt vervolgens de mogelijkheid om een questionnaire te ontwerpen. Deze vragen zijn snel te beantwoorden met behulp van switches (alleen ja/nee, wel/niet, etc. vragen) en worden opgeslagen in een database (Firebase). Hierna kunnen er voor werknemers accounts worden aangemaakt, zodat zij individueel beoordeeld kunnen worden. Wanneer zij zelf op hun account inloggen, kunnen zij tevens hun eigen beoordelingen inzien. Daarbij zou het ook fijn zijn om de resultaten op één of andere manier te kunnen exporteren, bijvoorbeeld naar een PDF.

De app kan uitgebreid worden, door meer onderdelen van de interne communicatie van een bedrijf toe te voegen. Denk hierbij aan het plaatsen van nieuwtjes/mededelingen (digitaal prikbord, met push notificaties) en het kunnen inzien van je eigen rooster. Ook zou een eventuele uitbreiding zijn, dat het voor bedrijven mogelijk is om het design van de app aan te passen aan hun eigen huisstijl. In dat geval kan de ‘hoofdgebruiker’ een logo uploaden en een kleur kunnen kiezen, op basis waarvan het app ontwerp wordt aangepast.

Om dit allemaal voor elkaar te kunnen krijgen, is het belangrijk om de database goed te ontwerpen (een API is niet nodig). Hierbij is het belangrijk om te weten wat er allemaal opgeslagen kan worden (datatypes) en wat de rollen van de verschillende gebruikers zijn (een werknemer moet zijn eigen beoordeling niet kunnen aanpassen). Daarnaast is gebruiksvriendelijkheid ook belangrijk: de app moet bij iedere taak snel en eenvoudig te gebruiken zijn (een nieuwbericht moet bijvoorbeeld ook snel opgesteld kunnen worden).

<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/beoordeling.png" width="300">
<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/beoordelingen.png" width="300"></br></br>
<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/medewerkers.png" width="300">
<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/rooster.png" width="300"></br></br>

## Better Code Hub

<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/BetterCodeHub2701.png" width="500"></br>

Write Code Once
- NewReviewVC.swift
- AddEmployeeVC.swift
- RegisterEmployeeVC.swift
- LoginVC.swift
- RegisterVC.swift
- ReviewEmployeeVC.swift
- ReviewResultsVC.swift
- ChooseReviewFormVC.swift
- FormsListVC.swift
- RegisterVC.swift

Keep Unit Interfaces Small
- FormsListVC.tableView(UITableView,UITableViewCellEditingStyle,IndexPath)
- AddFormVC.tableView(UITableView,UITableViewCellEditingStyle,IndexPath)
- LocationsVC.tableView(UITableView,UITableViewCellEditingStyle,IndexPath)
