//
//  Questions.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 19-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  The struct presented here contains all characteristics of the 'Questions' saved in Firebase. These questions are linked to a specific form through the formID.

import Foundation
import Firebase

struct Questions {
    
    let questionID: String
    let formID: String
    let organisationID: String
    let question: String
    
    init(questionID: String, formID: String, organisationID: String, question: String) {
        self.questionID = questionID
        self.formID = formID
        self.organisationID = organisationID
        self.question = question
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.questionID = snapshotValue["questionID"] as! String
        self.formID = snapshotValue["formID"] as! String
        self.organisationID = snapshotValue["organisationID"] as! String
        self.question = snapshotValue["question"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "questionID": questionID,
            "formID": formID,
            "organisationID": organisationID,
            "question": question
        ]
    }
}
