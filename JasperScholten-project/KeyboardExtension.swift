//
//  KeyboardExtension.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 31-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height)/3
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height)/3
            }
        }
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}
