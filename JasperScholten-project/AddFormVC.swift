//
//  AddFormVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 19-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class AddFormVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Questions")
    var form = String()
    var formID = String()
    var organisation = String()
    var organisationID = String()
    var questions = [Questions]()
    
    // MARK: - Outlets
    @IBOutlet weak var newFormTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Retrieve data from Firebase.
        ref.observe(.value, with: { snapshot in
            
            var newQuestions: [Questions] = []
            
            for item in snapshot.children {
                let questionData = Questions(snapshot: item as! FIRDataSnapshot)
                if questionData.organisationID == self.organisationID {
                    if questionData.formID == self.formID {
                        newQuestions.append(questionData)
                    }
                }
            }
            self.questions = newQuestions
            self.newFormTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newFormTableView.dequeueReusableCell(withIdentifier: "newFormQuestion", for: indexPath) as! FormQuestionCell
        
        cell.newQuestion.text = questions[indexPath.row].question
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newFormTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let question = questions[indexPath.row].questionID
            
            //http://stackoverflow.com/questions/39631998/how-to-delete-from-firebase-database
            ref.child(question).removeValue { (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
            }
            
        }
    }
    
    // MARK: - Actions
    
    @IBAction func newQuestion(_ sender: Any) {
        addNewQuestion()
    }
    
    func addNewQuestion() {
        let alert = UIAlertController(title: "Nieuwe vraag",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Vraag"
        }
        
        let newQuestionAction = UIAlertAction(title: "OK",
                                          style: .default) { action in
                                            let text = alert.textFields?[0].text
                                            if text != nil && text!.characters.count>0 {
                                                
                                                // let replaceString = ".#$[]"
                                                // Onderstaande werkt, maar is misschien niet heel elegant
                                                let deleteDot = text?.replacingOccurrences(of: ".", with: "")
                                                let deleteHash = deleteDot?.replacingOccurrences(of: "#", with: "")
                                                let deleteDollar = deleteHash?.replacingOccurrences(of: "$", with: "")
                                                let deleteBracket = deleteDollar?.replacingOccurrences(of: "[", with: "")
                                                let newText = deleteBracket?.replacingOccurrences(of: "]", with: "")
                                                
                                                let newRef = self.ref.childByAutoId()
                                                let newID = newRef.key
                                                
                                                let question = Questions(questionID: newID, formID: self.formID, organisationID: self.organisationID, question: newText!, state: false)
                                                newRef.setValue(question.toAnyObject())
                                            } else {
                                                self.formNameError()
                                            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(newQuestionAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func formNameError() {
        let alert = UIAlertController(title: "Vul een vraag in",
                                      message: "",
                                      preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "OK",
                                         style: .default) { action in
                                            self.addNewQuestion()
        }
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    }
}
