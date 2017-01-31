//
//  ReviewResultsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class ReviewResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Users")
    var employees = [User]()
    var organisation = String()
    var organisationID = String()
    
    // MARK: - Outlets
    @IBOutlet weak var resultListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref.observe(.value, with: { snapshot in
            
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
            self.resultListTableView.reloadData()
        })
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultListTableView.dequeueReusableCell(withIdentifier: "resultListID", for: indexPath) as! ReviewResultsCell
        
        cell.employeeName.text = employees[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showReviewsEmployee", sender: self)
        resultListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let employeeResults = segue.destination as? ReviewResultsEmployeeVC {
            let indexPath = self.resultListTableView.indexPathForSelectedRow
            employeeResults.employee = employees[indexPath!.row].name!
            employeeResults.employeeID = employees[indexPath!.row].uid
        }
    }

}
