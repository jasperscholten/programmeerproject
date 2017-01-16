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
    
    let formID: String
    let formName: String
    let question: String
    
    init(formID: String, formName: String, question: String) {
        self.formID = formID
        self.formName = formName
        self.question = question
    }
    
}
