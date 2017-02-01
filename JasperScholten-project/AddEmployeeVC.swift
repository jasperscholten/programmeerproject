//
//  AddEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 13-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  In this ViewController, users can be accepted if they are not accepted yet. The view can also be entered via the settings menu, where it functions as a place where one can change data of user's.

import UIKit
import Firebase

class AddEmployeeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Constants and variables
    let userRef = FIRDatabase.database().reference(withPath: "Users")
    let locationsRef = FIRDatabase.database().reference(withPath: "Locations")
    var user = User(uid: "", email: "", name: "", admin: false, employeeNr: "", organisationName: "", organisationID: "", locationID: "", accepted: false, key: "")
    let currentUser = FIRAuth.auth()?.currentUser
    var organisationID = String()
    var selectedLocation = String()
    var locations = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var employee: UITextField!
    @IBOutlet weak var role: UISegmentedControl!
    @IBOutlet weak var location: UIPickerView!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardActions()
        
        name.text = user.name!
        mail.text = user.email
        employee.text = user.employeeNr!
        
        // Retrieve selected employee's organisation from Firebase.
        userRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let userData = User(snapshot: item as! FIRDataSnapshot)
                if userData.uid == self.currentUser?.uid {
                    self.organisationID = userData.organisationID!
                }
            }
        })
        
        // Retrieve selected employee's locations from Firebase.
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
        
        userRef.child(user.uid).updateChildValues(["uid":user.uid,
                                                   "email":user.email,
                                                   "name":user.name!,
                                                   "admin":admin,
                                                   "employeeNr":employee.text!,
                                                   "organisationID":user.organisationID!,
                                                   "locationID":locations[self.location.selectedRow(inComponent: 0)],
                                                   "accepted":true])
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteEmployee(_ sender: Any) {
        askPassword()
    }
    
    // MARK: - Functions
    
    // Ask current user for password to authenticate deletion of employee.
    func askPassword() {
        let alert = UIAlertController(title: "Wil je deze gebruiker zeker verwijderen?",
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
    
    // Reauthenticate current user and on success, delete employee. [1]
    func checkPassword(currentPassword: String) {
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: (currentUser?.email)!,
                                                                 password: currentPassword)
        
        currentUser?.reauthenticate(with: credential, completion: { (error) in
            if error != nil{
                self.alertSingleOption(titleInput: "Fout wachtwoord",
                                       messageInput: "Voer het correcte wachtwoord in om deze gebruiker te kunnen verwijderen.")
            } else {
                self.deleteFromFirebase()
            }
        })
    }
    
    func deleteFromFirebase() {
        userRef.child(self.user.uid).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Handle keyboard behaviour.
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

// 1. http://stackoverflow.com/questions/38410593/how-to-verify-users-current-password-when-changing-password-on-firebase-3
// 2. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
// 3. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
