//
//  ReviewResultsEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase

class ReviewResultsEmployeeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    var employee = String()
    var employeeID = String()
    let ref = FIRDatabase.database().reference(withPath: "Reviews")
    var reviews = [Review]()
    
    // MARK: - Outlets
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var reviewResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        employeeName.text = employee
        
        // ALS NOG GEEN REVIEWS, geef dat aan in de eerste cell.
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.ref.observe(.value, with: { snapshot in
                    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chosenReview = segue.destination as? ReviewResultFormVC {
            let indexPath = self.reviewResultsTableView.indexPathForSelectedRow
            chosenReview.reviewID = reviews[(indexPath?.row)!].reviewID
        }
    }
}
