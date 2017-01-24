//
//  NewReviewVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class NewReviewVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    var employee = String()
    var employeeID = String()
    var form = String()
    var formID = String()
    var observatorName = String()
    var organisation = String()
    var organisationID = String()
    var location = String()
    let ref = FIRDatabase.database().reference(withPath: "Questions")
    let reviewRef = FIRDatabase.database().reference(withPath: "Reviews")
    var questions = [Questions]()
    var result = [String: Bool]()
    
    // MARK: - outlets
    @IBOutlet weak var tableViewTitle: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var remarkBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewTitle.text = "\(form) - \(employee)"
        
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
            self.reviewTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! NewReviewCell
        
        cell.questionView.text = questions[indexPath.row].question
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reviewTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func cancelReview(_ sender: Any) {
        
        let alert = UIAlertController(title: "Evaluatie stoppen",
                                      message: "Weet je zeker dat je de huidige evaluatie wil stoppen? In dat geval zullen alle ingevoerde resultaten worden verwijderd.",
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "OK",
                                               style: .default) { action in
                                                _ = self.navigationController?.popViewController(animated: true)
                                                
        }
    
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }

    @IBAction func saveReview(_ sender: Any) {
        
        let alert = UIAlertController(title: "Evaluatie opslaan en stoppen",
                                      message: "Weet je zeker dat je alle gegevens goed hebt ingevoerd en wil stoppen met deze evaluatie. In dat geval worden de gegevens opgeslagen en ga je terug naar het vorige scherm. Je kan de gegevens later niet meer aanpassen.",
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Sla op en ga door",
                                         style: .default) { action in
                                            // SAVE VALUES IN DATABASE
                                            self.saveReview()
                                            _ = self.navigationController?.popViewController(animated: true)
                                            
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func getAnswers() {
        for questionRow in 0 ..< questions.count {
            let indexPath = IndexPath(row: questionRow, section: 0)
            print("INDEX: \(indexPath)")
            print("CELL: \(reviewTableView.cellForRow(at: indexPath))")
            let cell = reviewTableView.cellForRow(at: indexPath) as! NewReviewCell
            let state = cell.answerSwitch.isOn
            let question = questions[questionRow].question
            result[question] = state
            print("QUESTION \(question), STATE \(state)")
        }
    }
    
    func saveReview() {
        
        getAnswers()
        
        // http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: Date())
        
        let newRef = self.reviewRef.childByAutoId()
        let newID = newRef.key
        
        let review = Review(reviewID: newID, formName: form, employeeID: employeeID, employeeName: employee, observatorName: observatorName, locationID: location, date: date, remark: remarkBox.text, result: result)
        newRef.setValue(review.toAnyObject())
        
    }
    
}
