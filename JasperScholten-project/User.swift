//
//  User.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 16-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  The struct presented here contains all characteristics of the 'Users' saved in Firebase. Some characteristcs define the role of the user (admin, accepted), others describe the user (e.g. name) and its 'position' (organisationID, locationID). The login feature of the app also makes use of properties described here, in order to authenticate users.

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    var name: String?
    var admin: Bool?
    var employeeNr: String?
    var organisationName: String?
    var organisationID: String?
    var locationID: String?
    var accepted: Bool?
    let key: String
    let ref: FIRDatabaseReference?
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
        key = ""
        ref = nil
    }
    
    init(uid: String, email: String, name: String, admin: Bool, employeeNr: String, organisationName: String, organisationID: String, locationID: String, accepted: Bool, key: String = "") {
        self.uid = uid
        self.email = email
        self.name = name
        self.admin = admin
        self.employeeNr = employeeNr
        self.organisationName = organisationName
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
        self.organisationName = snapshotValue["organisationName"] as! String?
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
            "organisationName": organisationName ?? "Geen organisatie",
            "organisationID": organisationID ?? "Geen organisatie",
            "locationID": locationID ?? "Geen locatie",
            "accepted": accepted ?? false
        ]
    }
    
}
