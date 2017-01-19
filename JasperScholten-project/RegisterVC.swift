//
//  RegisterVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    // MARK: Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Users")
    
    // MARK: Outlets
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var organisation: UITextField!
    @IBOutlet weak var employee: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordRepeat: UITextField!
    
    // MARK: UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Action
    
    @IBAction func registerUser(_ sender: Any) {
        FIRAuth.auth()!.createUser(withEmail: mail.text!, password: password.text!) { user, error in
            if error == nil {
                // Create complete user profile
                let user = User(uid: (user?.uid)!,
                                email: self.mail.text!,
                                name: self.name.text!,
                                admin: true,
                                employeeNr: self.employee.text!,
                                organisationID: self.organisation.text!,
                                locationID: self.location.text!,
                                accepted: true)

                let userRef = self.ref.child(user.uid)
                userRef.setValue(user.toAnyObject())
                                        
                // Automatically login after registering.
                FIRAuth.auth()!.signIn(withEmail: self.mail.text!,
                                       password: self.password.text!)
                self.dismiss(animated: true, completion: {})
            
            } else {
                let alert = UIAlertController(title: "Foute invoer", message: "Het emailadres of wachtwoord dat je hebt ingevoerd bestaat al of voldoet niet aan de eisen. Een wachtwoord moet bestaan uit minmaal 6 karakters.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelRegistration(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
}
