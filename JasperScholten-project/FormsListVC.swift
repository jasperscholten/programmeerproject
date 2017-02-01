//
//  FormsListVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 19-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This ViewController deals with management of an organisation's reviewforms. New forms can be created, but existing forms can also be deleted.

import UIKit
import Firebase

class FormsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let formsRef = FIRDatabase.database().reference(withPath: "Forms")
    let questionsRef = FIRDatabase.database().reference(withPath: "Questions")
    var nameInput = String()
    var organisation = String()
    var organisationID = String()
    var forms = [Form]()
    var formID = String()
    
    // MARK: - Outlets
    @IBOutlet weak var formsListTableView: UITableView!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve available reviewforms from Firebase.
        formsRef.observe(.value, with: { snapshot in
            var newForms: [Form] = []
            
            for item in snapshot.children {
                let formData = Form(snapshot: item as! FIRDataSnapshot)
                if formData.organisationID == self.organisationID {
                    newForms.append(formData)
                }
            }
            self.forms = newForms
            self.formsListTableView.reloadData()
        })
    }
    
    // MARK: - Tableview Population
    
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
        formID = forms[indexPath.row].formID
        performSegue(withIdentifier: "newForm", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let form = forms[indexPath.row].formID
            formsRef.child(form).removeValue { (error, ref) in
                if error != nil {
                    self.alertSingleOption(titleInput: "Er is iets misgegaan met verwijderen van het formulier",
                                      messageInput: error as! String)
                    self.deleteFormQuestions(formID: form)
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func addNewForm(_ sender: Any) {
        addNewForm()
    }
    
    // MARK: - Functions
    
    func addNewForm() {
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
                                                self.addFormToFirebase(text: text!)
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
    
    func addFormToFirebase(text: String) {
        let newRef = self.formsRef.childByAutoId()
        let newFormID = newRef.key
        self.nameInput = text
        self.formID = newFormID
        let form = Form(formName: text, formID: newFormID, organisationID: self.organisationID)
        
        newRef.setValue(form.toAnyObject())
        self.performSegue(withIdentifier: "newForm", sender: nil)
    }
    
    func formNameError() {
        let alert = UIAlertController(title: "Lege naam",
                                      message: "Geef de nieuwe lijst een naam om 'm te kunnen aanmaken.",
                                      preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "OK",
                                         style: .default) { action in
                                            self.addNewForm()
        }
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteFormQuestions(formID: String) {
        // Find questions of deleted form, then delete these as well.
        questionsRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let question = Questions(snapshot: item as! FIRDataSnapshot)
                if question.formID == formID {
                    self.questionsRef.child(question.questionID).removeValue { (error, ref) in
                        if error != nil {
                            self.alertSingleOption(titleInput: "Er is iets misgegaan met verwijderen van het formulier",
                                                   messageInput: error as! String)
                        }
                    }
                }
            }
        })
    }
    
    // Segue details of newly created form.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let choice = segue.destination as? AddFormVC {
            choice.form = nameInput
            choice.organisation = organisation
            choice.organisationID = organisationID
            choice.formID = formID
        }
    }
}
