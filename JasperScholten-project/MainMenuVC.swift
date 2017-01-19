//
//  MainMenuVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class MainMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Users")
    var admin = Bool()
    var currentOrganisation = String()
    var currentName = String()
    var menuItems = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve data from Firebase.
        ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let userData = User(snapshot: item as! FIRDataSnapshot)
                
                if userData.uid == (FIRAuth.auth()?.currentUser?.uid)! {
                    self.currentOrganisation = userData.organisationID!
                    self.currentName = userData.name!
                    
                    if userData.admin! == true {
                        self.menuItems = ["Beoordelen", "Resultaten", "Nieuws (admin)", "Rooster (admin)", "Stel lijst samen", "Medewerker verzoeken"]
                    } else {
                        self.menuItems = ["Beoordelingen", "Rooster", "Nieuws"]
                    }
                    self.menuTableView.reloadData()
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView Population
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MainMenuCell
        
        cell.menuItem.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: menuItems[indexPath.row], sender: self)
        menuTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Segue user details
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let employeeResults = segue.destination as? ReviewResultsEmployeeVC {
            // Segue details of current user
            employeeResults.employee = currentName
        }
        if let news = segue.destination as? NewsAdminVC {
            news.admin = admin
        }
        if let requests = segue.destination as? RequestsVC {
            requests.organisation = currentOrganisation
        }
    }
    
    // MARK: - Action
    // Kan weg wanneer kan worden uitgelogd met Firebase
    @IBAction func signOut(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

}
