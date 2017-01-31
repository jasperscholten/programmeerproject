//
//  RegisterEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 18-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class RegisterEmployeeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Users")
    let organisationRef = FIRDatabase.database().reference(withPath: "Organisations")
    let locationsRef = FIRDatabase.database().reference(withPath: "Locations")
    var organisation = ["Geen organisatie"]
    var organisationID = ["Geen locaties"]
    var location = [String: [String]]()
    
    // MARK: - Outlets
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var employeeNr: UITextField!

    @IBOutlet weak var organisationPicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardActions()

        // Retrieve data from Firebase.
        organisationRef.observe(.value, with: { snapshot in
            var newOrganisations: [String] = []
            var newOrganisationIDs: [String] = []
            
            for item in snapshot.children {
                let organisationData = Organisation(snapshot: item as! FIRDataSnapshot)
                newOrganisations.append(organisationData.organisation)
                newOrganisationIDs.append(organisationData.organisationID)
            }
            self.organisation = newOrganisations
            self.organisationID = newOrganisationIDs
            self.organisationPicker.reloadAllComponents()
        })
        
        locationsRef.observe(.value, with: { snapshot in
            
            let snapshotValue = snapshot.value as! [String: [String: String]]
            var newLocations: [String: [String]] = [:]
            
            for (key, value) in snapshotValue {
                var locations: [String] = []
                for newLocation in value {
                    locations.append(newLocation.value)
                }
                newLocations[key] = locations
            }
            
            self.location = newLocations
            self.locationPicker.reloadAllComponents()
        })
    }
    
    // MARK: - Picker views
    // http://stackoverflow.com/questions/30238224/multiple-uipickerview-in-the-same-uiview
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == organisationPicker {
            return organisation.count
        } else {
            let pickedOrganisation = organisationID[organisationPicker.selectedRow(inComponent: 0)]
            return (location[pickedOrganisation] ?? ["Geen organisaties geladen"]).count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == organisationPicker {
            return organisation[row]
        } else {
            let pickedOrganisation = organisationID[organisationPicker.selectedRow(inComponent: 0)]
            let pickedLocations = location[pickedOrganisation]
            return pickedLocations?[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.organisationPicker.reloadAllComponents()
        self.locationPicker.reloadAllComponents()
    }
    
    // MARK: - Actions
    @IBAction func registerUser(_ sender: Any) {
        
        if password.text! != repeatPassword.text! {
            addAlert(titleInput: "Wachtwoorden komen niet overeen",
                     messageInput: "")
            password.text! = ""
            repeatPassword.text! = ""
        } else if name.text! == "" || mail.text! == "" || employeeNr.text! == ""{
            addAlert(titleInput: "Vul alle velden in", messageInput: "Vul alle velden in om een organisatie te kunnen registreren.")
        } else {
            createUser()
        }
        
    }

    @IBAction func cancelRegistration(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    // Functions
    
    func createUser() {
        FIRAuth.auth()!.createUser(withEmail: mail.text!, password: password.text!) { user, error in
            if error == nil {
                
                let pickedOrganisation = self.organisation[self.organisationPicker.selectedRow(inComponent: 0)]
                
                let pickedOrganisationID = self.organisationID[self.organisationPicker.selectedRow(inComponent: 0)]
                let pickedLocations = self.location[pickedOrganisationID]
                let pickedLocation = pickedLocations![self.locationPicker.selectedRow(inComponent: 0)]
                
                // Create complete user profile
                let user = User(uid: (user?.uid)!,
                                email: self.mail.text!,
                                name: self.name.text!,
                                admin: false,
                                employeeNr: self.employeeNr.text!,
                                organisationName: pickedOrganisation,
                                organisationID: pickedOrganisationID,
                                locationID: pickedLocation,
                                accepted: false)
                
                let userRef = self.ref.child(user.uid)
                userRef.setValue(user.toAnyObject())
                
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

    // MARK: Keyboard actions [2, 3]
    
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [2]
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterEmployeeVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterEmployeeVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [3]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterEmployeeVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: References

/*
 2. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
 3. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
 */

