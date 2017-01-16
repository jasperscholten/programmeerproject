//
//  User.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 16-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import Foundation
import Firebase

// Moet er een aparte tabel worden gemaakt met de userInfo? Hoe werken met authenticatie?
struct User {
    
    let uid: String
    let email: String
    var name: String?
    var admin: Bool?
    var employeeNr: String?
    var organisationID: String?
    var locationID: String?
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String, name: String, admin: Bool, employeeNr: String, organisationID: String, locationID: String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.admin = admin
        self.employeeNr = employeeNr
        self.organisationID = organisationID
        self.locationID = locationID
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "email": email,
            "name": name ?? "Medewerker",
            "admin": admin ?? false,
            "employeeNr": employeeNr ?? "Geen nummer",
            "organisationID": organisationID ?? "Geen organisatie",
            "locationID": locationID ?? "Geen locatie"
        ]
    }
    
}
