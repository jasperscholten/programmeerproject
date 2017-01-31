//
//  ReviewResultFormVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class ReviewResultFormVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let ref = FIRDatabase.database().reference(withPath: "Reviews")
    var reviewID = String()
    
    var review = [Review]()
    var result = [String: Bool]()
    var questions = [String]()
    var states = [Bool]()
    
    // MARK: - Outlets
    @IBOutlet weak var reviewFormTableView: UITableView!
    @IBOutlet weak var remarkField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.ref.observe(.value, with: { snapshot in
                    
                    for item in snapshot.children {
                        let reviewData = Review(snapshot: item as! FIRDataSnapshot)
                        if reviewData.reviewID == self.reviewID {
                            self.populateTable(newResult: reviewData.result)
                            self.remarkField.text = reviewData.remark
                        }
                    }
                })
            }
        }
        
        // https://www.raywenderlich.com/129059/self-sizing-table-view-cells
        reviewFormTableView.rowHeight = UITableViewAutomaticDimension
        reviewFormTableView.estimatedRowHeight = 140
    }
    
    // MARK: - Tableview

    func populateTable(newResult: [String: Bool]){
        result = newResult
        // http://stackoverflow.com/questions/25741114/how-can-i-get-keys-value-from-dictionary-in-swift
        for (key, value) in result {
            questions.append(key)
            states.append(value)
        }
        reviewFormTableView.reloadData()
    }

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
}
