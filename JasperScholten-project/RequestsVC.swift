//
//  RequestsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 18-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class RequestsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Users")
    var employees = [User]()
    var organisation = String()
    
    // MARK: - Outlets
    @IBOutlet weak var requestsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.ref.observe(.value, with: { snapshot in
                    
                    for item in snapshot.children {
                        let userData = User(snapshot: item as! FIRDataSnapshot)
                        if userData.accepted == false {
                            if userData.organisationID == self.organisation {
                                self.employees.append(userData)
                            }
                        }
                    }
                    self.requestsTableView.reloadData()
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
