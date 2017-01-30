//
//  AlertExtension.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 30-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertSingleOption(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
