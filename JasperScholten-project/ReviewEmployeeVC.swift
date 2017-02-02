//
//  ReviewEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  In this View, the user can select an employee from a tableView, in order to review that person.

import UIKit
import Firebase

class ReviewEmployeeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let userRef = FIRDatabase.database().reference(withPath: "Users")
    var employees = [User]()
    var organisation = String()
    var organisationID = String()
    var observatorName = String()
    
    // MARK: - Outlets
    @IBOutlet weak var employeesTableView: UITableView!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve all of the current organisation's employees from Firebase, except for the current user.
        self.userRef.observe(.value, with: { snapshot in
            var newEmployees: [User] = []
            
            for item in snapshot.children {
                let userData = User(snapshot: item as! FIRDataSnapshot)
                if userData.accepted! && userData.organisationID == self.organisationID {
                    if userData.uid == FIRAuth.auth()?.currentUser?.uid {
                        self.observatorName = userData.name!
                    } else {
                        newEmployees.append(userData)
                    }
                }
            }
            self.employees = newEmployees
            self.employeesTableView.reloadData()
        })
    }

    // MARK: - Tableview Population
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeesTableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeCell
        cell.employeeName.text = employees[indexPath.row].name
        cell.employeeNR.text = employees[indexPath.row].employeeNr
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chooseForm", sender: self)
        employeesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Segue data necessary to fill in a new review.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newReview = segue.destination as? ChooseReviewFormVC {
            let indexPath = self.employeesTableView.indexPathForSelectedRow
            newReview.employee = employees[indexPath!.row].name!
            newReview.employeeID = employees[indexPath!.row].uid
            newReview.observatorName = observatorName
            newReview.organisation = organisation
            newReview.organisationID = organisationID
            newReview.location = employees[indexPath!.row].locationID!
        }
    }
}
