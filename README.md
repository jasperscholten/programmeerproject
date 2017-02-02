<img src="https://github.com/jasperscholten/programmeerproject/blob/master/doc/comcomLogo-83.5%402x.png">

# COMCOM // Interne bedrijfscommunicatie vereenvoudigd.
### Jasper Scholten, 11157887

**COMCOM is een app die interne bedrijfscommunicatie kan vereenvoudigen voor zowel kleine als grote organisaties. In de huidige versie ligt de nadruk op het stroomlijnen van medewerker beoordelingsproces en het delen van (korte) nieuwsberichten binnen een vestiging. In toekomstige versies kunnen hier opties aan worden toegevoegd, zoals het beheren en inzichtelijk maken van een werktijden-rooster, om de interne communicatie nog breder te ondersteunen.**

Wanneer **COM**COM voor het eerst wordt gebruikt, kan een nieuwe organisatie worden geregistreerd. De gebruiker die dit doet ontvangt automatisch admin-rechten, die hem/haar onder andere in staat stellen medewerkers en vestigingen van de organisatie te ‘managen’. Volgende gebruikers kunnen zich vervolgens aanmelden bij deze organisatie, waarna de admin-gebruiker een verzoek tot inschrijving binnenkrijgt. Als hij dit verzoek accepteert (waarbij hij nog de keuze heeft om de gebruiker ook admin-rechten te geven), krijgt de nieuwe gebruiker ook toegang tot de app.

**COM**COM heeft op het moment twee ‘hoofdfuncties’: beoordelen van medewerkers en tonen van nieuwsberichten. Admin gebruikers (leidinggevenden) kunnen beoordelingen uitvoeren voor alle medewerkers van hun eigen vestiging. Dit proces gebeurt aan de hand van de beschikbare beoordelingsformulieren; een admin gebruiker kan naar wens formulieren toevoegen, of in een bestaand formulier vragen toevoegen/verwijderen. Hierbij zijn het allemaal vragen met een Boolean antwoord, dat kan worden aangegeven door de waarde van een switch aan te passen.
Wanneer een beoordeling is uitgevoerd, kan deze worden opgeslagen. Alle beoordelingen die in het verleden zijn uitgevoerd, zijn zichtbaar voor zowel leidinggevenden als de medewerker die is beoordeeld. Hierbij kan zo’n overzicht van beoordelingen functioneren als leidraad voor een beoordelings/functioneringsgesprek.

De tweede functionaliteit die **COM**COM biedt, draait om het delen van nieuwsitems. Admin gebruikers kunnen een nieuwsbericht plaatsen, met titel, tekst en eventueel afbeelding, om de medewerkers van hun vestiging te informeren over zaken die spelen. Op die manier kan iedereen up-to-date blijven met wat er gebeurt, ook als ze een tijd niet aanwezig zijn geweest. Het idee is dat dit de samenwerking bevordert en misverstanden voorkomt. Iedere werknemer kan hierbij de berichten inzien, maar alleen admin gebruikers kunnen nieuwsberichten ook verwijderen.

> Curious of the app? You can start by taking a look at the screenshots below, but you could also download the complete project. Any questions? Send me an e-mail at j.o.scholten@student.vu.nl

# Screenshots

# Referenties

Hieronder is een overzicht gegeven van de bronnen die zijn geraadpleegd, om bepaalde problemen in de ontwikkeling van **COM**COM op te lossen. Veel van de bronnen zijn op meerdere plaatsen, in verschillende ViewControllers gebruikt; onder aan iedere ViewController staat welke bronnen specifiek daar zijn gebruikt. Ik zou graag nog speciaal willen verwijzen naar bron 25, de Ray Wenderlich Firebase tutorial, omdat deze aan de basis stond van vrijwel alle Firebase functionaliteit in de app.

1. http://stackoverflow.com/questions/27887218/how-to-hide-a-bar-button-item-for-certain-users
2. http://stackoverflow.com/questions/34161016/how-to-make-uitableview-to-fill-all-my-view
3. http://stackoverflow.com/questions/25651969/setting-device-orientation-in-swift-ios
4. http://stackoverflow.com/questions/38721302/shouldautorotate-function-in-xcode-8-beta-4
5. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
6. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
7. http://stackoverflow.com/questions/30238224/multiple-uipickerview-in-the-same-uiview
8. http://stackoverflow.com/questions/38410593/how-to-verify-users-current-password-when-changing-password-on-firebase-3
9. https://www.raywenderlich.com/129059/self-sizing-table-view-cells
10. http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
11. http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
12. http://stackoverflow.com/questions/32087809/how-to-change-bottom-layout-constraint-in-ios-swift
13. http://stackoverflow.com/questions/25649926/trying-to-animate-a-constraint-in-swift
14. http://stackoverflow.com/questions/26244293/scrolltorowatindexpath-with-uitableview-does-not-work
15. http://stackoverflow.com/questions/25741114/how-can-i-get-keys-value-from-dictionary-in-swift
16. https://firebase.google.com/docs/storage/ios/download-files
17. https://www.sitepoint.com/self-sizing-cells-uitableview-auto-layout/
18. http://stackoverflow.com/questions/29431968/how-to-adjust-the-height-of-a-textview-to-his-content-in-swift
19. http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
20. https://firebase.google.com/docs/storage/ios/upload-files
21. https://github.com/firebase/quickstart-ios/blob/master/storage/StorageExampleSwift/ViewController.swift
22. http://stackoverflow.com/questions/37603312/firebase-storage-upload-works-in-simulator-but-not-on-iphone
23. http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
24. http://stackoverflow.com/questions/36630652/swift-change-autolayout-constraints-when-keyboard-is-shown
25. https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2

<p align="center"><i>
This project is licensed under the terms of the Apache license.</br>
Jasper Scholten, 2017
</i></p>
