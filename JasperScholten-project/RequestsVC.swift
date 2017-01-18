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
                            self.employees.append(userData)
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
        requestsTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "acceptRequest", sender: nil)
    }

}
