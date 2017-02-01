//
//  KeyboardExtension.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 31-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This extension adds three functions to UIViewController, that deal with keyboard behavior.

import Foundation
import UIKit

extension UIViewController {
    
    // Move screen upward on keyboardWillShow
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height)/3
            }
        }
    }

    // Move screen downward on keyboardWillHide
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height)/3
            }
        }
    }

    // Enable dismissal of keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
