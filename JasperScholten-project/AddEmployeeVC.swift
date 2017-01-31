//
//  AddEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 13-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class AddEmployeeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Users")
    let locationsRef = FIRDatabase.database().reference(withPath: "Locations")
    var user = User(uid: "", email: "", name: "", admin: false, employeeNr: "", organisationName: "", organisationID: "", locationID: "", accepted: false, key: "")
    var organisationID = String()
    var selectedLocation = String()
    var locations = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var employee: UITextField!
    @IBOutlet weak var role: UISegmentedControl!
    @IBOutlet weak var location: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardActions()
        
        name.text = user.name!
        mail.text = user.email
        employee.text = user.employeeNr!
        
        // Retrieve data from Firebase.
        ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let userData = User(snapshot: item as! FIRDataSnapshot)
                if userData.uid == (FIRAuth.auth()?.currentUser?.uid)! {
                    self.organisationID = userData.organisationID!
                }
            }
        })
        
        locationsRef.observe(.value, with: { snapshot in
            
            let locationSnapshot = snapshot.childSnapshot(forPath: self.organisationID)
            let locationData = locationSnapshot.value as! [String: String]
            
            var newLocations: [String] = []
            for (_, value) in locationData {
                newLocations.append(value)
            }
            self.locations = newLocations
            self.location.reloadAllComponents()
            
            var locationNumber = 0
            for selected in self.locations {
                if selected == self.user.locationID {
                    self.location.selectRow(locationNumber, inComponent: 0, animated: true)
                }
                locationNumber += 1
            }
        })
    }
    
    // MARK: - Picker views
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
    
    // MARK: - Actions
    
    @IBAction func registerEmployee(_ sender: Any) {
        
        var admin = false
        
        if role.selectedSegmentIndex == 1 {
            admin = true
        }
        
        ref.child(user.uid).updateChildValues(["uid":user.uid,
                                               "email":user.email,
                                               "name":user.name!,
                                               "admin":admin,
                                               "employeeNr":employee.text!,
                                               "organisationID":user.organisationID!,
                                               "locationID":locations[self.location.selectedRow(inComponent: 0)],
                                               "accepted":true])
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    // http://stackoverflow.com/questions/38410593/how-to-verify-users-current-password-when-changing-password-on-firebase-3
    @IBAction func deleteEmployee(_ sender: Any) {
        askPassword()
    }
    
    
    func askPassword() {
        let alert = UIAlertController(title: "",
                                      message: "Voer je wachtwoord opnieuw in om deze gebruiker te kunnen verwijderen.",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "Wachtwoord"
        }
        
        let newQuestionAction = UIAlertAction(title: "OK",
                                              style: .default) { action in
                                                let passwordInput = alert.textFields?[0].text
                                                self.checkPassword(currentPassword: passwordInput!)
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(newQuestionAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func checkPassword(currentPassword: String) {
        
        let adminUser = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: (adminUser?.email)!, password: currentPassword)
        
        adminUser?.reauthenticate(with: credential, completion: { (error) in
            if error != nil{
                self.addAlert(titleInput: "Fout wachtwoord", messageInput: "Voer het correcte wachtwoord in om deze gebruiker te kunnen verwijderen.")
            } else {
                self.ref.child(self.user.uid).removeValue { (error, ref) in
                    if error != nil {
                        print("error \(error)")
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    
    
    func addAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard actions [2, 3]
    
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [2]
        NotificationCenter.default.addObserver(self, selector: #selector(AddEmployeeVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddEmployeeVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [3]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEmployeeVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: References

/*
 2. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
 3. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
 */
