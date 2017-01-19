//
//  FormsListVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 19-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class FormsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Forms")
    var nameInput = String()
    var organisation = String()
    var forms = [Form]()
    
    // MARK: - Outlets
    @IBOutlet weak var formsListTableView: UITableView!
    
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
            self.formsListTableView.reloadData()
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = formsListTableView.dequeueReusableCell(withIdentifier: "formListCell", for: indexPath) as! FormListCell
        
        cell.formName.text = forms[indexPath.row].formName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        formsListTableView.deselectRow(at: indexPath, animated: true)
        nameInput = forms[indexPath.row].formName
        performSegue(withIdentifier: "newForm", sender: nil)
    }
    
    // MARK: - Actions
    @IBAction func addNewForm(_ sender: Any) {
        addNewList()
    }
    
    func addNewList() {
        let alert = UIAlertController(title: "Nieuwe vragenlijst",
                                      message: "Wil je een nieuwe vragenlijst gaan opstellen?",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Lijstnaam"
        }
        
        let newFormAction = UIAlertAction(title: "OK",
                                          style: .default) { action in
                                            let text = alert.textFields?[0].text
                                            if text != nil && text!.characters.count>0 {
                                                self.nameInput = text!
                                                
                                                let form = Form(formName: text!, organisationID: self.organisation)
                                                self.ref.child(text!).setValue(form.toAnyObject())
                                                
                                                self.performSegue(withIdentifier: "newForm", sender: nil)
                                            } else {
                                                self.formNameError()
                                            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(newFormAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func formNameError() {
        let alert = UIAlertController(title: "Lege naam",
                                      message: "Geef de nieuwe lijst een naam om 'm te kunnen aanmaken.",
                                      preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "OK",
                                         style: .default) { action in
                                            self.addNewList()
        }
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let choice = segue.destination as? AddFormVC {
            choice.form = nameInput
            choice.organisation = organisation
        }
    }

}
