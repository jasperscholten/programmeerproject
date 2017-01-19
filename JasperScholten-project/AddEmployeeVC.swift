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
    var user = User(uid: "", email: "", name: "", admin: false, employeeNr: "", organisationID: "", locationID: "", accepted: false, key: "")
    var organisation = String()
    
    // MARK: - Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var employee: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var role: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = user.name!
        mail.text = user.email
        employee.text = user.employeeNr!
        
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
                                               "locationID":user.locationID!,
                                               "accepted":true])
    }
    
}
