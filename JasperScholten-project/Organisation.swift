//
//  Organisation.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 23-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  The struct presented here deals with 'Organisations' saved in Firebase. These are saved in a separate list, to make it easier to retrieve them all when you, for example, want to present them in a pickerView on registration of a new employee.

import Foundation
import Firebase

struct Organisation {
    
    let organisationID: String
    let organisation: String
    
    init(organisationID: String, organisation: String) {
        self.organisationID = organisationID
        self.organisation = organisation
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.organisationID = snapshotValue["organisationID"] as! String
        self.organisation = snapshotValue["organisation"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "organisationID": organisationID,
            "organisation": organisation
        ]
    }
}
