//
//  Questions.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 19-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import Foundation
import Firebase

struct Questions {
    
    let questionID: String
    let formID: String
    let organisationID: String
    let question: String
    let state: Bool
    
    init(questionID: String, formID: String, organisationID: String, question: String, state: Bool) {
        self.questionID = questionID
        self.formID = formID
        self.organisationID = organisationID
        self.question = question
        self.state = state
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.questionID = snapshotValue["questionID"] as! String
        self.formID = snapshotValue["formID"] as! String
        self.organisationID = snapshotValue["organisationID"] as! String
        self.question = snapshotValue["question"] as! String
        self.state = snapshotValue["state"] as! Bool
    }
    
    func toAnyObject() -> Any {
        return [
            "questionID": questionID,
            "formID": formID,
            "organisationID": organisationID,
            "question": question,
            "state": state
        ]
    }
}
