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
    let formName: String
    let employeeID: String
    let employeeName: String
    let observatorName: String
    let locationID: String
    let date: String
    let remark: String
    let result: [String: Bool]
    
    init(reviewID: String, formName: String, employeeID: String, employeeName: String, observatorName: String, locationID: String, date: String, remark: String, result: [String: Bool]) {
        self.reviewID = reviewID
        self.formName = formName
        self.employeeID = employeeID
        self.employeeName = employeeName
        self.observatorName = observatorName
        self.locationID = locationID
        self.date = date
        self.remark = remark
        self.result = result
    }

    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.reviewID = snapshotValue["reviewID"] as! String
        self.formName = snapshotValue["formName"] as! String
        self.employeeID = snapshotValue["employeeID"] as! String
        self.employeeName = snapshotValue["employeeName"] as! String
        self.observatorName = snapshotValue["observatorName"] as! String
        self.locationID = snapshotValue["locationID"] as! String
        self.date = snapshotValue["date"] as! String
        self.remark = snapshotValue["remark"] as! String
        self.result = snapshotValue["result"] as! [String: Bool]
    }
    
    func toAnyObject() -> Any {
        return [
            "reviewID": reviewID,
            "formName": formName,
            "employeeID": employeeID,
            "employeeName": employeeName,
            "observatorName": observatorName,
            "locationID": locationID,
            "date": date,
            "remark": remark,
            "result": result
        ]
    }
    
}
