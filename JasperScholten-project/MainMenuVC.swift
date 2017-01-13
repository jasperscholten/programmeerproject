//
//  MainMenuVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var admin = Bool()
    var menuItems = [String]()
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if admin == true {
            menuItems = ["Beoordelen", "Resultaten", "Nieuws (admin)", "Rooster (admin)", "Stel lijst samen", "Nieuwe medewerker"]
        } else {
            menuItems = ["Beoordelingen", "Rooster", "Nieuws"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    // MARK: - Segue user details
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let employeeResults = segue.destination as? ReviewResultsEmployeeVC {
            // Segue details of current user
            employeeResults.employee = "Niels (huidige gebruiker)"
        }
        if let news = segue.destination as? NewsAdminVC {
            news.admin = admin
        }
    }
    
    // MARK: - Action
    // Kan weg wanneer kan worden uitgelogd met Firebase
    @IBAction func signOut(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

}
