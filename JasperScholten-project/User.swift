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
    var accepted: Bool?
    
    let key: String
    let ref: FIRDatabaseReference?
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
        
        // Hoe dit te initialiseren
        key = ""
        ref = nil
    }
    
    init(uid: String, email: String, name: String, admin: Bool, employeeNr: String, organisationID: String, locationID: String, accepted: Bool, key: String = "") {
        self.uid = uid
        self.email = email
        self.name = name
        self.admin = admin
        self.employeeNr = employeeNr
        self.organisationID = organisationID
        self.locationID = locationID
        self.accepted = accepted
        
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.key = snapshot.key
        self.ref = snapshot.ref
    
        self.uid = snapshotValue["uid"] as! String
        self.email = snapshotValue["email"] as! String
        self.name = snapshotValue["name"] as! String?
        self.admin = snapshotValue["admin"] as! Bool?
        self.employeeNr = snapshotValue["employeeNr"] as! String?
        self.organisationID = snapshotValue["organisationID"] as! String?
        self.locationID = snapshotValue["locationID"] as! String?
        self.accepted = snapshotValue["accepted"] as! Bool?
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "email": email,
            "name": name ?? "Medewerker",
            "admin": admin ?? false,
            "employeeNr": employeeNr ?? "Geen nummer",
            "organisationID": organisationID ?? "Geen organisatie",
            "locationID": locationID ?? "Geen locatie",
            "accepted": accepted ?? false
        ]
    }
    
}
