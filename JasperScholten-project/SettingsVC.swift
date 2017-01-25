//
//  SettingsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 23-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    var organisationName = String()
    var organisationID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locations = segue.destination as? LocationsVC {
            locations.organisationName = organisationName
            locations.organisationID = organisationID
        }
        if let employees = segue.destination as? EmployeeSettingsVC {
            employees.organisationID = organisationID
        }
    }
}
