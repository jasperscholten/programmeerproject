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
    var organisation = String()
    let ref = FIRDatabase.database().reference(withPath: "Questions")
    var questions = [Questions]()
    
    // MARK: - outlets
    @IBOutlet weak var tableViewTitle: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewTitle.text = "\(form) - \(employee)"
        
        // Retrieve data from Firebase.
        ref.observe(.value, with: { snapshot in
            
            var newQuestions: [Questions] = []
            
            for item in snapshot.children {
                let questionData = Questions(snapshot: item as! FIRDataSnapshot)
                if questionData.organisationID == self.organisation {
                    if questionData.formName == self.form {
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

}
