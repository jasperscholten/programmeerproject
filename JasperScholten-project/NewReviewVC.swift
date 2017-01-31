//
//  NewReviewVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class NewReviewVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardActions()
        
        tableViewTitle.text = "\(form) - \(employee)"
        remarkBox.textColor = UIColor.lightGray
        
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
            let cell = reviewTableView.cellForRow(at: indexPath) as! NewReviewCell
            let state = cell.answerSwitch.isOn
            let question = questions[questionRow].question
            result[question] = state
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
    
    // Make remarkBox placeholder
    // http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
    
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
    
    // MARK: Keyboard actions [2, 3]
    // http://stackoverflow.com/questions/32087809/how-to-change-bottom-layout-constraint-in-ios-swift
    
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [2]
        NotificationCenter.default.addObserver(self, selector: #selector(NewReviewVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewReviewVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [3]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewReviewVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Scroll to text view - http://stackoverflow.com/questions/25649926/trying-to-animate-a-constraint-in-swift
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
    
    // http://stackoverflow.com/questions/26244293/scrolltorowatindexpath-with-uitableview-does-not-work
    func tableViewScrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let indexPath = IndexPath(row: self.questions.count-1, section: 0)
            self.reviewTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
}
