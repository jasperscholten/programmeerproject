//
//  ReviewEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class ReviewEmployeeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Users")
    var employees = [User]()
    var organisation = String()
    
    @IBOutlet weak var employeesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.ref.observe(.value, with: { snapshot in
                    
                    var newEmployees: [User] = []
                    
                    for item in snapshot.children {
                        let userData = User(snapshot: item as! FIRDataSnapshot)
                        if userData.accepted == true {
                            if userData.organisationID == self.organisation {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeesTableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeCell
        
        cell.employeeName.text = employees[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chooseForm", sender: self)
        employeesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newReview = segue.destination as? ChooseReviewFormVC {
            let indexPath = self.employeesTableView.indexPathForSelectedRow
            newReview.employee = employees[indexPath!.row].name!
            newReview.employeeID = employees[indexPath!.row].uid
            newReview.organisation = organisation
        }
    }

}
