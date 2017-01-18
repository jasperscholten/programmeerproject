//
//  AddEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 13-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class AddEmployeeVC: UIViewController {

    // MARK: Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Users")
    var organisation = String()
    
    // MARK: - Outlets
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var employee: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var role: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve data from Firebase.
        ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let userData = User(snapshot: item as! FIRDataSnapshot)
                if userData.uid == (FIRAuth.auth()?.currentUser?.uid)! {
                    self.organisation = userData.organisationID!
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func registerEmployee(_ sender: Any) {
        
        // password random genereren?
        FIRAuth.auth()!.createUser(withEmail: mail.text!, password: "test123") { user, error in
            if error == nil {
                
                var admin = false
                if self.role.selectedSegmentIndex == 1 {
                    admin = true
                }
                
                // Create complete user profile
                let user = User(uid: (user?.uid)!, email: self.mail.text!, name: self.name.text!, admin: admin, employeeNr: self.employee.text!, organisationID: self.organisation, locationID: self.location.text!, accepted: true)
                
                let userRef = self.ref.child(self.name.text!)
                userRef.setValue(user.toAnyObject())
                
            } else {
                let alert = UIAlertController(title: "Foute invoer", message: "Het emailadres dat je hebt ingevoerd bestaat al of voldoet niet aan de eisen.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
