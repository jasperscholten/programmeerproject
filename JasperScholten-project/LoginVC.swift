//
//  LoginVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 10-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginUser", sender: nil)
                self.mail.text! = ""
                self.password.text! = ""
            }
        }
        
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
    
    // MARK: - Actions
    
    @IBAction func loginUser(_ sender: Any) {
        FIRAuth.auth()!.signIn(withEmail: mail.text!,
                               password: password.text!) { (user, error) in
                                if error != nil {
                                    let alert = UIAlertController(title: "Foute invoer", message: "Het emailadres of wachtwoord dat je hebt ingevoerd is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
        }
        
    }
}

