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
    var organisations = [String]()
    
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
        
        keyboardActions()
        
        organisationRef.observe(.value, with: { snapshot in
            var newOrganisations: [String] = []
            
            for item in snapshot.children {
                let organisationData = Organisation(snapshot: item as! FIRDataSnapshot)
                newOrganisations.append(organisationData.organisation)
            }
            self.organisations = newOrganisations
        })

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
        } else if doesOrganisationExist(input: organisation.text!) == true {
            addAlert(titleInput: "Organisatie bestaat al", messageInput: "Er is al een organisatie geregistreerd onder deze naam. Kies een andere naam om te kunnen registreren.")
            organisation.text! = ""
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
    
    func doesOrganisationExist(input: String) -> Bool {
        for element in organisations {
            if element == input {
                return true
            }
        }
        return false
    }
    
    // MARK: Keyboard actions [2, 3]
    
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [2]
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [3]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
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

// MARK: References

/*
 2. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
 3. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
 */
