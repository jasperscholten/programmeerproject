//
//  LoginVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 10-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "signin" {
            let destinationNavigationController = segue.destination as! UINavigationController
        
            if let role = destinationNavigationController.topViewController as? MainMenuVC {
                if segue.identifier == "adminLogin" {
                    role.admin = true
                } else {
                    role.admin = false
                }
            }
        }
    }
}

