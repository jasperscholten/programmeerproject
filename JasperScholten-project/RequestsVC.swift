//
//  RequestsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 18-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  After a user signs up to an organisation, they don't immediately get access to the app; the first need to get accepted. This viewController shows all employees of the current user's organisation, who are not yet accepted. Selecting one of them segues to a view where the employee can be accepted.

import UIKit
import Firebase

class RequestsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants and variables
    let userRef = FIRDatabase.database().reference(withPath: "Users")
    let user = FIRAuth.auth()?.currentUser
    var employees = [User]()
    var organisationID = String()
    
    // MARK: - Outlets
    @IBOutlet weak var requestsTableView: UITableView!

    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve users from Firebase, who registered to organisation of current admin user, but are not yet accepted
        if user != nil {
            self.userRef.observe(.value, with: { snapshot in
                var newEmployees: [User] = []
                
                for item in snapshot.children {
                    let userData = User(snapshot: item as! FIRDataSnapshot)
                    if !(userData.accepted!) && userData.organisationID == self.organisationID {
                        newEmployees.append(userData)
                    }
                }
                self.employees = newEmployees
                self.requestsTableView.reloadData()
            })
        }
    }
    
    // MARK: - TableView Population
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requestsTableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestCell
        cell.employee.text = employees[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "acceptRequest", sender: nil)
        requestsTableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "acceptRequest" {
            let nextVC = segue.destination as! AddEmployeeVC
            let indexPath = requestsTableView.indexPathForSelectedRow
            nextVC.user = employees[indexPath!.row]
        }
    }

}
