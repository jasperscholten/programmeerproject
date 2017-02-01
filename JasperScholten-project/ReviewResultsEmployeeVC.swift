//
//  ReviewResultsEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//
//  This ViewController shows all finished reviews of the selected employee.

import UIKit
import Firebase

class ReviewResultsEmployeeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let reviewsRef = FIRDatabase.database().reference(withPath: "Reviews")
    var employee = String()
    var employeeID = String()
    var reviews = [Review]()
    
    // MARK: - Outlets
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var reviewResultsTableView: UITableView!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeName.text = employee
    
        let user = FIRAuth.auth()?.currentUser
        if user != nil {
            
            // Retrieve reviews of selected employee from Firebase.
            self.reviewsRef.observe(.value, with: { snapshot in
                var newReviews: [Review] = []
                
                for item in snapshot.children {
                    let reviewData = Review(snapshot: item as! FIRDataSnapshot)
                    if reviewData.employeeID == self.employeeID {
                        newReviews.append(reviewData)
                    }
                }
                self.reviews = newReviews
                self.reviewResultsTableView.reloadData()
            })
        }
    }
    
    // MARK: - Tableview Population
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewResultsTableView.dequeueReusableCell(withIdentifier: "reviewResultEmployee", for: indexPath) as! ReviewResultsEmployeeCell
        cell.reviewDate.text = reviews[indexPath.row].date
        cell.reviewResult.text = reviews[indexPath.row].formName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDateResult", sender: self)
        reviewResultsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Segue details of selected review.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedReview = segue.destination as? ReviewResultFormVC {
            let indexPath = self.reviewResultsTableView.indexPathForSelectedRow
            selectedReview.reviewID = reviews[(indexPath?.row)!].reviewID
        }
    }
}
