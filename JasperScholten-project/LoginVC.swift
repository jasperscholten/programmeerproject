//
//  LoginVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 10-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This View will be the first one shown to users. Here they can login with an existing account, or choose to go to one of the registration pages.

import UIKit
import Firebase

class LoginVC: UIViewController {

    // MARK: - Constants and variables
    let userRef = FIRDatabase.database().reference(withPath: "Users")
    
    // MARK: - Outlets
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardActions()
        
        // Check if a user has already logged in
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            userRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChildren() {
                    let userData = User(snapshot: snapshot)
                    if userData.accepted! {
                        self.performSegue(withIdentifier: "loginUser", sender: nil)
                        self.emptyTextfield()
                    }
                }
            })
        }
    }
    
    // Lock current view on Portrait mode. [1, 2]
    override var shouldAutorotate: Bool { return false }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: - Actions
    
    // On login-button click, sign user in if he has been accepted.
    @IBAction func loginUser(_ sender: Any) {
        userRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let userData = User(snapshot: item as! FIRDataSnapshot)
                
                if userData.email == self.mail.text! {
                    if userData.accepted == true {
                        self.signIn()
                    } else {
                        self.alertSingleOption(titleInput: "Geen toegang", messageInput: "Het verzoek dat je hebt ingediend bij je werkgever, is nog niet geaccepteerd. Probeer het later nog een keer en/of neem contact op met je leidinggevende.")
                        self.emptyTextfield()
                    }
                }
            }
        })
    }
    
    // Present alert with options to go to employee or organisation registration.
    @IBAction func registerUser(_ sender: Any) {
        
        let alert = UIAlertController(title: "Registreren",
                                      message: "Wil je je als medewerker aanmelden bij een bestaande organisatie, of ben je nieuw bij deze app en ga je het gebruiken voor een nieuwe organisatie?",
                                      preferredStyle: .alert)
        
        let employeeAction = UIAlertAction(title: "Medewerker",
                                       style: .default) { action in
                                        self.performSegue(withIdentifier: "employeeRegistration", sender: nil)
        }
        
        let organisationAction = UIAlertAction(title: "Organisatie",
                                         style: .default) { action in
                                            self.performSegue(withIdentifier: "organisationRegistration", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(employeeAction)
        alert.addAction(organisationAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func signIn() {
        FIRAuth.auth()!.signIn(withEmail: self.mail.text!,
                               password: self.password.text!) { (user, error) in
                                if error != nil {
                                    self.alertSingleOption(titleInput: "Foute invoer", messageInput: "Het emailadres of wachtwoord dat je hebt ingevoerd is incorrect.")
                                    self.emptyTextfield()
                                } else {
                                    self.performSegue(withIdentifier: "loginUser", sender: nil)
                                    self.emptyTextfield()
                                }
        }
    }
    
    func emptyTextfield() {
        self.mail.text! = ""
        self.password.text! = ""
    }
    
    // Handle keyboard behaviour.
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [3]
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [4]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: - References

// 1. http://stackoverflow.com/questions/25651969/setting-device-orientation-in-swift-ios
// 2. http://stackoverflow.com/questions/38721302/shouldautorotate-function-in-xcode-8-beta-4
// 3. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
// 4. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift

