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
            
            print(self.locations)
            var locationNumber = 0
            for selected in self.locations {
                print(selected)
                if selected == self.user.locationID {
                    self.location.selectRow(locationNumber, inComponent: 0, animated: true)
                }
                locationNumber += 1
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
}
