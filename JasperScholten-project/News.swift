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
    let time: String
    let text: String
    
    // Gebruik storage om afbeeldingen te kunnen opslaan.
    // https://firebase.google.com/docs/storage/ios/start
    // https://firebase.google.com/docs/storage/ios/create-reference
    let image: UIImage
    
    init(itemID: String, title: String, time: String, text: String, image: UIImage) {
        self.itemID = itemID
        self.title = title
        self.text = text
        self.time = time
        self.image = image
    }
}
