//
//  Form.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 16-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import Foundation
import Firebase

struct Form {
    
    let formName: String
    let formID: String
    let organisationID: String
    
    init(formName: String, formID: String, organisationID: String) {
        self.formName = formName
        self.formID = formID
        self.organisationID = organisationID
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]

        self.formName = snapshotValue["formName"] as! String
        self.formID = snapshotValue["formID"] as! String
        self.organisationID = snapshotValue["organisationID"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "formName": formName,
            "formID": formID,
            "organisationID": organisationID
        ]
    }
}
