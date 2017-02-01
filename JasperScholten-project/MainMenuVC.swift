//
//  MainMenuVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This ViewController handles the presentation of a main menu, which content depends on the type of user that has logged in; an admin will have more options. The main menu also serves as a hub, that sends specific data to other ViewControllers (mainly currentOrganisationID and currenOrganisation name).

import UIKit
import Firebase

class MainMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let userRef = FIRDatabase.database().reference(withPath: "Users")
    let uid = FIRAuth.auth()?.currentUser?.uid
    var admin = Bool()
    var currentOrganisation = String()
    var currentOrganisationID = String()
    var currentLocation = String()
    var currentName = String()
    var menuItems = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var menuTableView: UITableView!
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userRef.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                let userData = User(snapshot: snapshot)
                
                if userData.uid == self.uid! {
                    self.currentOrganisation = userData.organisationName!
                    self.currentOrganisationID = userData.organisationID!
                    self.currentLocation = userData.locationID!
                    self.currentName = userData.name!
                    
                    if userData.admin! == true {
                        self.menuItems = ["Beoordelen", "Resultaten", "Nieuws (admin)", "Stel lijst samen", "Medewerker verzoeken"]
                        self.admin = true
                    } else {
                        self.menuItems = ["Beoordelingen", "Nieuws"]
                        // Only allow admins to access settings menu. [1]
                        self.navigationItem.rightBarButtonItem = nil
                    }
                    self.menuTableView.reloadData()
                    self.resizeTable()
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resizeTable()
    }
    
    // Resize table on device rotation.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in self.resizeTable() },
                            completion: nil)
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
    
    // MARK: - Segue data specific to current user to chosen menu option.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let employeeResults = segue.destination as? ReviewResultsEmployeeVC {
            employeeResults.employee = currentName
            employeeResults.employeeID = uid!
        } else if let news = segue.destination as? NewsAdminVC {
            news.admin = admin
            news.location = currentLocation
            news.organisationID = currentOrganisationID
        } else if let requests = segue.destination as? RequestsVC {
            requests.organisationID = currentOrganisationID
        } else if let forms = segue.destination as? FormsListVC {
            forms.organisation = currentOrganisation
            forms.organisationID = currentOrganisationID
        } else if let employees = segue.destination as? ReviewEmployeeVC {
            employees.organisation = currentOrganisation
            employees.organisationID = currentOrganisationID
        } else if let results = segue.destination as? ReviewResultsVC {
            results.organisation = currentOrganisation
            results.organisationID = currentOrganisationID
        } else if let settings = segue.destination as? SettingsVC {
            settings.organisationName = currentOrganisation
            settings.organisationID = currentOrganisationID
        }
    }
    
    // MARK: - Actions
    
    @IBAction func signOut(_ sender: Any) {
        if (try? FIRAuth.auth()?.signOut()) != nil {
            self.dismiss(animated: true, completion: {})
        } else {
            alertSingleOption(titleInput: "Fout bij uitloggen",
                              messageInput: "Het is niet gelukt om je correct uit te loggen. Probeer het nog een keer.")
        }
    }

    @IBAction func showSettings(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    
    // MARK: - Functions
    
    // Resize the rowheight of menu cells, such that they fill the screen and are of equal height. [2]
    func resizeTable() {
        let heightOfVisibleTableViewArea = view.bounds.height - topLayoutGuide.length - bottomLayoutGuide.length
        let numberOfRows = menuTableView.numberOfRows(inSection: 0)
        
        menuTableView.rowHeight = heightOfVisibleTableViewArea / CGFloat(numberOfRows)
        menuTableView.reloadData()
    }
    
}

// MARK: - References

// 1. http://stackoverflow.com/questions/27887218/how-to-hide-a-bar-button-item-for-certain-users
// 2. http://stackoverflow.com/questions/34161016/how-to-make-uitableview-to-fill-all-my-view
