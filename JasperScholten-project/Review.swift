//
//  Review.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 16-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import Foundation
import Firebase

struct Review {
    
    let reviewID: String
    let formID: String
    // uid employee
    let employeeID: String
    // uid admin
    let observatorID: String
    let locationID: String
    let time: String
    let result: [Bool]
    let remark: String
    
    init(reviewID: String, formID: String, employeeID: String, observatorID: String, locationID: String, time: String, result: [Bool], remark: String) {
        self.reviewID = reviewID
        self.formID = formID
        self.employeeID = employeeID
        self.observatorID = observatorID
        self.locationID = locationID
        self.time = time
        self.result = result
        self.remark = remark
    }

}
