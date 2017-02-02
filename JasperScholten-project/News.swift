//
//  News.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 16-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  The struct presented here contains all characteristics of the 'News' saved in Firebase. It only deals with the text components of a newsItem; images are separately saved through Firebase Storage. The itemID is used to link these two with eachother.

import Foundation
import Firebase

struct News {
    
    let itemID: String
    let organisation: String
    let location: String
    let title: String
    let date: String
    let text: String
    
    init(itemID: String, organisation: String, location: String, title: String, date: String, text: String) {
        self.itemID = itemID
        self.organisation = organisation
        self.location = location
        self.title = title
        self.text = text
        self.date = date
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.itemID = snapshotValue["itemID"] as! String
        self.organisation = snapshotValue["organisation"] as! String
        self.location = snapshotValue["location"] as! String
        self.title = snapshotValue["title"] as! String
        self.text = snapshotValue["text"] as! String
        self.date = snapshotValue["date"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "itemID": itemID,
            "organisation": organisation,
            "location": location,
            "title": title,
            "text": text,
            "date": date
        ]
    }
}
