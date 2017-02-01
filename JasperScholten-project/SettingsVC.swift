//
//  SettingsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 23-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This ViewController handles the presentation of a settings menu.

import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    var organisationName = String()
    var organisationID = String()
    var settings = ["Medewerkers", "Vestigingen"]
    
    // MARK: - Outlets
    @IBOutlet weak var settingsTableView: UITableView!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Prevent initial misplacement of tableView, by adding 64.0 to heightOfVisibleTableViewArea.
        resizeTable(add: 64.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resizeTable(add: 0.0)
    }
    
    // Resize tableView on device rotation.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in self.resizeTable(add: 0.0) },
                            completion: nil)
    }
    
    // MARK: - Tableview Population
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        cell.settingsOption.text = settings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: settings[indexPath.row], sender: nil)
        settingsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Functions
    
    // Segue specific data to chosen settings option.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locations = segue.destination as? LocationsVC {
            locations.organisationName = organisationName
            locations.organisationID = organisationID
        } else if let employees = segue.destination as? EmployeeSettingsVC {
            employees.organisationID = organisationID
        }
    }
    
    // Resize the rowheight of menu cells, such that they fill the screen and are of equal height. [1]
    func resizeTable(add: CGFloat) {
        let heightOfVisibleTableViewArea = view.bounds.height - topLayoutGuide.length - bottomLayoutGuide.length - add
        let numberOfRows = settingsTableView.numberOfRows(inSection: 0)
        
        settingsTableView.rowHeight = heightOfVisibleTableViewArea / CGFloat(numberOfRows)
        settingsTableView.reloadData()
    }
}

// MARK: - References

// 1. http://stackoverflow.com/questions/34161016/how-to-make-uitableview-to-fill-all-my-view
