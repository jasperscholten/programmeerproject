//
//  RegisterVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This ViewController handles registration of a new user that wants to use the app for a new organisation. Besides signing up the new user and saving his data in Firebase, the app also saves data for the organisation and organisation location that is first registered.

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    // MARK: - Constants and variables
    let userRef = FIRDatabase.database().reference(withPath: "Users")
    let organisationRef = FIRDatabase.database().reference(withPath: "Organisations")
    let locationsRef = FIRDatabase.database().reference(withPath: "Locations")
    var organisations = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var organisation: UITextField!
    @IBOutlet weak var employee: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordRepeat: UITextField!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardActions()
        
        // Retrieve current organisations from Firebase
        organisationRef.observe(.value, with: { snapshot in
            var newOrganisations: [String] = []
            for item in snapshot.children {
                let organisationData = Organisation(snapshot: item as! FIRDataSnapshot)
                newOrganisations.append(organisationData.organisation)
            }
            self.organisations = newOrganisations
        })
    }
    
    // Lock current view on Portrait mode. [1, 2]
    override var shouldAutorotate: Bool { return false }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: - Actions
    
    @IBAction func registerUser(_ sender: Any) {
        if password.text! != passwordRepeat.text! {
            alertSingleOption(titleInput: "Wachtwoorden komen niet overeen", messageInput: "")
            password.text! = ""
            passwordRepeat.text! = ""
            
        } else if name.text!.isEmpty || mail.text!.isEmpty || organisation.text!.isEmpty || employee.text!.isEmpty || location.text!.isEmpty {
            alertSingleOption(titleInput: "Vul alle velden in",
                              messageInput: "Vul alle velden in om een organisatie te kunnen registreren.")
            
        } else if doesOrganisationExist(input: organisation.text!) {
            alertSingleOption(titleInput: "Organisatie bestaat al",
                              messageInput: "Er is al een organisatie geregistreerd onder deze naam. Kies een andere naam om te kunnen registreren.")
            organisation.text! = ""
            
        } else {
            createUser()
        }
    }
    
    @IBAction func cancelRegistration(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    // MARK: - Functions
    
    // Add user to Firebase
    func createUser() {
        FIRAuth.auth()!.createUser(withEmail: mail.text!, password: password.text!) { user, error in
            if error == nil {
                let orgName = self.organisation.text!
                let locName = self.location.text!
                let orgID = self.createOrganisation(orgName: orgName)
                
                let user = User(uid: (user?.uid)!,
                                email: self.mail.text!,
                                name: self.name.text!,
                                admin: true,
                                employeeNr: self.employee.text!,
                                organisationName: orgName,
                                organisationID: orgID,
                                locationID: locName,
                                accepted: true)
                
                self.createLocation(user: user,
                                    orgID: orgID,
                                    orgName: orgName,
                                    locName: locName)
            
                self.dismiss(animated: true, completion: {})
            } else {
                self.alertSingleOption(titleInput: "Foute invoer",
                                       messageInput: "Het emailadres of wachtwoord dat je hebt ingevoerd bestaat al of voldoet niet aan de eisen. Een wachtwoord moet bestaan uit minmaal 6 karakters.")
            }
        }
    }
    
    // Add organisation to Firebase
    func createOrganisation(orgName: String) -> String {
        let orgRef = self.organisationRef.childByAutoId()
        let orgID = orgRef.key
        let organisation = Organisation(organisationID: orgID, organisation: orgName)
        orgRef.setValue(organisation.toAnyObject())
        return orgID
    }
    
    // Add location to Firebase
    func createLocation(user: User, orgID: String, orgName: String, locName: String) {
        let newUserRef = self.userRef.child(user.uid)
        newUserRef.setValue(user.toAnyObject())
        self.locationsRef.child(orgID).setValue(["\(orgName)\(locName)": locName])
    }
    
    func doesOrganisationExist(input: String) -> Bool {
        for element in organisations {
            if element.lowercased() == input.lowercased() {
                return true
            }
        }
        return false
    }
    
    // Handle keyboard behaviour.
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [3]
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [4]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: - References

// 1. http://stackoverflow.com/questions/25651969/setting-device-orientation-in-swift-ios
// 2. http://stackoverflow.com/questions/38721302/shouldautorotate-function-in-xcode-8-beta-4
// 3. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
// 4. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
