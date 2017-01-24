//
//  Organisation.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 23-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import Foundation
import Firebase

struct Organisation {
    
    let organisationID: String
    let organisation: String
    //let locations: [String]
    
    init(organisationID: String, organisation: String) {
        self.organisationID = organisationID
        self.organisation = organisation
        //self.locations = locations
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
