//
//  ChooseReviewFormVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 20-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class ChooseReviewFormVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Forms")
    var forms = [Form]()
    var employee = String()
    var employeeID = String()
    var observatorName = String()
    var organisation = String()
    var location = String()
    
    // MARK: - Outlets
    @IBOutlet weak var formListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve data from Firebase.
        ref.observe(.value, with: { snapshot in
            
            var newForms: [Form] = []
            
            for item in snapshot.children {
                let formData = Form(snapshot: item as! FIRDataSnapshot)
                if formData.organisationID == self.organisation {
                    newForms.append(formData)
                }
            }
            self.forms = newForms
            self.formListTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = formListTableView.dequeueReusableCell(withIdentifier: "reviewForms", for: indexPath) as! ReviewFormsCell
        
        cell.form.text = forms[indexPath.row].formName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Present alert om zeker te weten dat er niet voor niets een nieuwe review in de database wordt geplant. Eventueel kan je ook een optie annuleren in het formulier zetten, waardoor de huidige evaluatie weer wordt verwijderd. Alleen als op opslaan wordt gedrukt, komt 'ie in de database te staan.
        
        performSegue(withIdentifier: "newReview", sender: self)
        formListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newReview = segue.destination as? NewReviewVC {
            let indexPath = self.formListTableView.indexPathForSelectedRow
            newReview.employee = employee
            newReview.employeeID = employeeID
            newReview.form = forms[indexPath!.row].formName
            newReview.formID = forms[indexPath!.row].formID
            newReview.observatorName = observatorName
            newReview.organisation = organisation
            newReview.location = location
        }
    }

}
