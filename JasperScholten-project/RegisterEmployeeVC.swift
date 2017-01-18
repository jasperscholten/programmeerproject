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
    let organisation = ["Gamma", "Karwei", "Van Neerbos", "Hornbach", "Praxis"]
    let location = ["Hoorn", "Grootebroek", "Alkmaar", "Purmerend", "Dronten"]
    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return location.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == organisationPicker {
            return organisation[row]
        } else {
            return location[row]
        }
    }
    
    // MARK: - Actions
    @IBAction func registerUser(_ sender: Any) {
        print(organisation[organisationPicker.selectedRow(inComponent: 0)])
        print(location[locationPicker.selectedRow(inComponent: 0)])
        
        FIRAuth.auth()!.createUser(withEmail: mail.text!, password: password.text!) { user, error in
            if error == nil {
                
                // Create complete user profile
                let user = User(uid: (user?.uid)!,
                                email: self.mail.text!,
                                name: self.name.text!,
                                admin: false,
                                employeeNr: self.employeeNr.text!,
                                organisationID: self.organisation[self.organisationPicker.selectedRow(inComponent: 0)],
                                locationID: self.location[self.locationPicker.selectedRow(inComponent: 0)],
                                accepted: false)
                
                let userRef = self.ref.child(self.name.text!)
                userRef.setValue(user.toAnyObject())

                self.dismiss(animated: true, completion: {})
                
            } else {
                let alert = UIAlertController(title: "Foute invoer", message: "Het emailadres of wachtwoord dat je hebt ingevoerd bestaat al of voldoet niet aan de eisen. Een wachtwoord moet bestaan uit minmaal 6 karakters.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

    @IBAction func cancelRegistration(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
}
