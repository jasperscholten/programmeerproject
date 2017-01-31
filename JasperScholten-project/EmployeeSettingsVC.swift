//
//  EmployeeSettingsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 25-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class EmployeeSettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Constants and variables
    let usersRef = FIRDatabase.database().reference(withPath: "Users")
    var organisationID = String()
    var employees = [User]()
    
    // MARK: - Outlets
    @IBOutlet weak var employeesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.usersRef.observe(.value, with: { snapshot in
                    
                    var newEmployees: [User] = []
                    
                    for item in snapshot.children {
                        let userData = User(snapshot: item as! FIRDataSnapshot)
                        if userData.accepted == true {
                            if userData.organisationID == self.organisationID {
                                newEmployees.append(userData)
                            }
                        }
                    }
                    self.employees = newEmployees
                    self.employeesTableView.reloadData()
                })
            }
        }
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeesTableView.dequeueReusableCell(withIdentifier: "employeeSettingsCell", for: indexPath) as! EmployeeSettingsCell
        
        cell.employee.text = employees[indexPath.row].name
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEmployeeDetails", sender: nil)
        employeesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let employeeDetails = segue.destination as? AddEmployeeVC {
            let indexPath = employeesTableView.indexPathForSelectedRow
            employeeDetails.user = employees[(indexPath?.row)!]
        }
    }

}
