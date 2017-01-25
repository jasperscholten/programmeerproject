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
    let organisationRef = FIRDatabase.database().reference(withPath: "Organisations")
    let locationsRef = FIRDatabase.database().reference(withPath: "Locations")
    
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
        if password.text! != passwordRepeat.text! {
            addAlert(titleInput: "Wachtwoorden komen niet overeen",
                     messageInput: "")
            password.text! = ""
            passwordRepeat.text! = ""
        } else if name.text! == "" || mail.text! == "" || organisation.text! == "" || employee.text! == "" || location.text! == "" {
            addAlert(titleInput: "Vul alle velden in", messageInput: "Vul alle velden in om een organisatie te kunnen registreren.")
        } else {
            createUser()
        }
    }
    
    @IBAction func cancelRegistration(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    func createUser() {
        FIRAuth.auth()!.createUser(withEmail: mail.text!, password: password.text!) { user, error in
            if error == nil {
                
                let orgName = self.organisation.text!
                let locName = self.location.text!
                
                let orgRef = self.organisationRef.childByAutoId()
                let orgID = orgRef.key
                let organisation = Organisation(organisationID: orgID,
                                                organisation: orgName)
                orgRef.setValue(organisation.toAnyObject())
                
                // Create complete user profile
                let user = User(uid: (user?.uid)!,
                                email: self.mail.text!,
                                name: self.name.text!,
                                admin: true,
                                employeeNr: self.employee.text!,
                                organisationName: orgName,
                                organisationID: orgID,
                                locationID: locName,
                                accepted: true)
                
                let userRef = self.ref.child(user.uid)
                userRef.setValue(user.toAnyObject())
                
                self.locationsRef.child(orgID).setValue(["\(orgName)\(locName)": locName])
                
                // Automatically login after registering.
                FIRAuth.auth()!.signIn(withEmail: self.mail.text!,
                                       password: self.password.text!)
                self.dismiss(animated: true, completion: {})
                
            } else {
                self.addAlert(titleInput: "Foute invoer",
                              messageInput: "Het emailadres of wachtwoord dat je hebt ingevoerd bestaat al of voldoet niet aan de eisen. Een wachtwoord moet bestaan uit minmaal 6 karakters.")
            }
        }
    }
    
    func addAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
