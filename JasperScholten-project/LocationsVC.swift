//
//  LocationsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 23-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class LocationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Constants and variables
    let locationsRef = FIRDatabase.database().reference(withPath: "Locations")
    var organisationName = String()
    var organisationID = String()
    var number = Int()
    var organisations = [String]()
    var locations = ["Hoorn"]
    var locationsFirebase = [String: String]()
    
    // MARK: - Outlets
    @IBOutlet weak var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve data from Firebase.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
    
    // MARK: - Actions

    @IBAction func addLocations(_ sender: Any) {
        
        addNewLocation()
        
    }
    
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
                                                    
                                                    print(self.locationsFirebase)
                                                    self.locationsFirebase["\(self.organisationName)\(locName!)"] = locName
                                                    self.locationsRef.child(self.organisationID).setValue(self.locationsFirebase)
                                                    //self.locationsRef.child(self.organisationID).setValue(["\(self.organisationName)\(locName!)": locName])
                                                }
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(newLocationAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
