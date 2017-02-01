//
//  ReviewResultFormVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This ViewController shows the results of the review that was selected in the previous ViewController. Results cannot be changed.

import UIKit
import Firebase

class ReviewResultFormVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let reviewsRef = FIRDatabase.database().reference(withPath: "Reviews")
    var reviewID = String()
    var review = [Review]()
    var result = [String: Bool]()
    var questions = [String]()
    var states = [Bool]()
    
    // MARK: - Outlets
    @IBOutlet weak var reviewFormTableView: UITableView!
    @IBOutlet weak var remarkField: UITextView!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve selected review from Firebase.
        reviewsRef.child(reviewID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                let reviewData = Review(snapshot: snapshot)
                if reviewData.reviewID == self.reviewID {
                    self.populateTable(newResult: reviewData.result)
                    self.remarkField.text = reviewData.remark
                }
            }
        })
        
        // Make tableViewCell rowHeight dynamically sized. [1]
        reviewFormTableView.rowHeight = UITableViewAutomaticDimension
        reviewFormTableView.estimatedRowHeight = 140
    }
    
    // MARK: - Tableview Population

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewFormTableView.dequeueReusableCell(withIdentifier: "reviewFormCell", for: indexPath) as! ReviewResultFormCell
        cell.questionField.text = questions[indexPath.row]
        cell.answerSwitch.isOn = states[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reviewFormTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Functions
    
    // Populate table with retrieved Firebase review. [2]
    func populateTable(newResult: [String: Bool]){
        result = newResult
        for (key, value) in result {
            questions.append(key)
            states.append(value)
        }
        reviewFormTableView.reloadData()
    }
}

// MARK: - References

// 1. https://www.raywenderlich.com/129059/self-sizing-table-view-cells
// 2. http://stackoverflow.com/questions/25741114/how-can-i-get-keys-value-from-dictionary-in-swift
