//
//  News.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 16-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import Foundation
import Firebase

struct News {
    
    let itemID: String
    let title: String
    let date: String
    let text: String
    
    // Gebruik storage om afbeeldingen te kunnen opslaan.
    // https://firebase.google.com/docs/storage/ios/start
    // https://firebase.google.com/docs/storage/ios/create-reference
    // let image: UIImage
    
    init(itemID: String, title: String, date: String, text: String) {
        self.itemID = itemID
        self.title = title
        self.text = text
        self.date = date
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.itemID = snapshotValue["itemID"] as! String
        self.title = snapshotValue["title"] as! String
        self.text = snapshotValue["text"] as! String
        self.date = snapshotValue["date"] as! String
        
    }
    
    func toAnyObject() -> Any {
        return [
            "itemID": itemID,
            "title": title,
            "text": text,
            "date": date
        ]
    }
}
