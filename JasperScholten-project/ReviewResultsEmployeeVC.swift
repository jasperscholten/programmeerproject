//
//  ReviewResultsEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class ReviewResultsEmployeeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var reviewResultsTableView: UITableView!
    
    var employee: String = "Medewerker"
    let dates = ["25-02-2016", "13-05-2016", "20-08-2016", "01-12-2016"]
    let result = ["7.0", "8.0", "8.0", "7.5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        employeeName.text = employee
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewResultsTableView.dequeueReusableCell(withIdentifier: "reviewResultEmployee", for: indexPath) as! ReviewResultsEmployeeCell
        
        cell.reviewDate.text = dates[indexPath.row]
        cell.reviewResult.text = result[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDateResult", sender: self)
    }

}
