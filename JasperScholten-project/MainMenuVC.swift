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
    var currentOrganisationID = String()
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
                    self.currentOrganisation = userData.organisationName!
                    self.currentOrganisationID = userData.organisationID!
                    self.currentName = userData.name!
                    
                    if userData.admin! == true {
                        self.menuItems = ["Beoordelen", "Resultaten", "Nieuws (admin)", "Stel lijst samen", "Medewerker verzoeken"]
                    } else {
                        self.menuItems = ["Beoordelingen", "Nieuws"]
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
            employeeResults.employeeID = (FIRAuth.auth()?.currentUser?.uid)!
        }
        if let news = segue.destination as? NewsAdminVC {
            news.admin = admin
        }
        if let requests = segue.destination as? RequestsVC {
            requests.organisation = currentOrganisationID
        }
        if let forms = segue.destination as? FormsListVC {
            forms.organisation = currentOrganisation
        }
        if let employees = segue.destination as? ReviewEmployeeVC {
            employees.organisation = currentOrganisation
        }
        if let results = segue.destination as? ReviewResultsVC {
            results.organisation = currentOrganisation
        }
        if let settings = segue.destination as? SettingsVC {
            settings.organisationName = currentOrganisation
            settings.organisationID = currentOrganisationID
        }
    
    }
    
    // MARK: - Action
    
    @IBAction func signOut(_ sender: Any) {
        if (try? FIRAuth.auth()?.signOut()) != nil {
            print("success")
            self.dismiss(animated: true, completion: {})
        } else {
            
            let alert = UIAlertController(title: "Fout bij uitloggen",
                                          message: "Het is niet gelukt om je correct uit te loggen. Probeer het nog een keer.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))

            self.present(alert, animated: true, completion: nil)
            
        }
    }

    @IBAction func showSettings(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: self)
    }

}
