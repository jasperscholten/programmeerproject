//
//  NewReviewVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This ViewController deals with creating a new review and saving the results to Firebase. The user can use switches to answer questions, and also has the possibilty to enter additional comments in the remarkBox. Much logic in this file deals with proper visualisation of, for example, the keyboard.

import UIKit
import Firebase

class NewReviewVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    // MARK: - Constants and variables
    let questionsRef = FIRDatabase.database().reference(withPath: "Questions")
    let reviewRef = FIRDatabase.database().reference(withPath: "Reviews")
    var employee = String()
    var employeeID = String()
    var form = String()
    var formID = String()
    var observatorName = String()
    var organisation = String()
    var organisationID = String()
    var location = String()
    var questions = [Questions]()
    var result = [String: Bool]()
    
    // MARK: - outlets
    @IBOutlet weak var tableViewTitle: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var remarkBox: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardActions()
        tableViewTitle.text = "\(form) - \(employee)"
        remarkBox.textColor = UIColor.lightGray
        
        // Retrieve questions in selected form from Firebase.
        questionsRef.observe(.value, with: { snapshot in
            var newQuestions: [Questions] = []
            
            for item in snapshot.children {
                let questionData = Questions(snapshot: item as! FIRDataSnapshot)
                if questionData.organisationID == self.organisationID && questionData.formID == self.formID {
                    newQuestions.append(questionData)
                }
            }
            self.questions = newQuestions
            self.reviewTableView.reloadData()
        })
        
        // Make tableViewCell rowHeight dynamically sized. [1]
        reviewTableView.rowHeight = UITableViewAutomaticDimension
        reviewTableView.estimatedRowHeight = 140
    }
    
    // MARK: - Tableview Population
    
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
                                            self.saveReview()
                                            _ = self.navigationController?.popViewController(animated: true)
                                            
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Functions
    
    func saveReview() {
        getAnswers()
        if result != [:] {
            let date = getCurrentDate()
            let newRef = self.reviewRef.childByAutoId()
            let newID = newRef.key
            let review = Review(reviewID: newID, formName: form, employeeID: employeeID, employeeName: employee, observatorName: observatorName, locationID: location, date: date, remark: remarkBox.text, result: result)
            
            newRef.setValue(review.toAnyObject())
        }
    }
    
    // Retrieve the results for each question on the form.
    func getAnswers() {
        for questionRow in 0 ..< questions.count {
            let indexPath = IndexPath(row: questionRow, section: 0)
            let cell = reviewTableView.cellForRow(at: indexPath) as! NewReviewCell
            let state = cell.answerSwitch.isOn
            let question = questions[questionRow].question
            result[question] = state
        }
    }
    
    // Reference: [2]
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: Date())
    }
    
    // textViewDidBeginEditing and textViewDidEndEditing functions enable setting a placeholder in remarkBox textView. [3]
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Overige opmerkingen"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // Handle keyboard behaviour.
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [4]
        NotificationCenter.default.addObserver(self, selector: #selector(NewReviewVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewReviewVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [5]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewReviewVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Change bottom constraint of tableView, so that keyboard and textView don't overlap. [6, 7]
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomConstraint.constant == 0{
                self.bottomConstraint.constant += keyboardSize.height
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                self.tableViewScrollToBottom()
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomConstraint.constant == keyboardSize.height {
                self.bottomConstraint.constant -= keyboardSize.height
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // Scroll to bottom of tableView, so that textView stays visible. [8]
    func tableViewScrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let indexPath = IndexPath(row: self.questions.count-1, section: 0)
            self.reviewTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

// MARK: - References

// 1. https://www.raywenderlich.com/129059/self-sizing-table-view-cells
// 2. http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
// 3. http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
// 4. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
// 5. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
// 6. http://stackoverflow.com/questions/32087809/how-to-change-bottom-layout-constraint-in-ios-swift
// 7. http://stackoverflow.com/questions/25649926/trying-to-animate-a-constraint-in-swift
// 8. http://stackoverflow.com/questions/26244293/scrolltorowatindexpath-with-uitableview-does-not-work
