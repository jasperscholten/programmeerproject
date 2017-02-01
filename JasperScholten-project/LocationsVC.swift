//
//  LocationsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 23-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This ViewController handles management of an organisation's locations; a user could add a new location, or delete an existing one.

import UIKit
import Firebase

class LocationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Constants and variables
    let locationsRef = FIRDatabase.database().reference(withPath: "Locations")
    var organisationName = String()
    var organisationID = String()
    var organisations = [String]()
    var locations = ["Hoorn"]
    var locationsFirebase = [String: String]()
    
    // MARK: - Outlets
    @IBOutlet weak var locationsTableView: UITableView!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve locations of current user's organisation from Firebase.
        locationsRef.observe(.value, with: { snapshot in
            let locationSnapshot = snapshot.childSnapshot(forPath: self.organisationID)
            let locationData = locationSnapshot.value as! [String: String]
            self.locationsFirebase = locationData
            
            var newLocations: [String] = []
            for location in locationData {
                newLocations.append(location.value)
            }
            self.locations = newLocations
            self.locationsTableView.reloadData()
        })
    }

    // MARK: - Tableview Population
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationsTableView.dequeueReusableCell(withIdentifier: "locationsCell", for: indexPath) as! LocationsCell
        cell.locationName.text = locations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        locationsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Enable user to delete locations.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = "\(organisationName)\(locations[indexPath.row])"
            locationsRef.child(organisationID).child(location).removeValue { (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
            }
            
        }
    }
    
    // MARK: - Actions
    @IBAction func addLocations(_ sender: Any) {
        addNewLocation()
    }
    
    // MARK: - Functions
    func addNewLocation() {
        let alert = UIAlertController(title: "Nieuwe Locatie",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Locatie"
        }
        
        let newLocationAction = UIAlertAction(title: "OK",
                                              style: .default) { action in
                                                let locName = alert.textFields?[0].text
                                                if locName != nil && locName!.characters.count>0 {
                                                    self.locationsFirebase["\(self.organisationName)\(locName!)"] = locName
                                                    self.locationsRef.child(self.organisationID).setValue(self.locationsFirebase)
                                                }
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(newLocationAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
