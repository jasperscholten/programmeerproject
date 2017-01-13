//
//  ReviewResultsVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class ReviewResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var resultListTableView: UITableView!
    
    let employees = ["Hans Beerekamp", "Ineke Bosch", "Niels Pel", "Marinus Zeekoe", "Emma Post", "Henk van Ingrid", "Ingrid van Henk", "Jan Janssen"]
    let results = ["9.0", "7.5", "6.5", "8.0", "7.0", "8.0", "7.5", "9.0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultListTableView.dequeueReusableCell(withIdentifier: "resultListID", for: indexPath) as! ReviewResultsCell
        
        cell.employeeName.text = employees[indexPath.row]
        cell.employeeResult.text = results[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showReviewsEmployee", sender: self)
        resultListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let employeeResults = segue.destination as? ReviewResultsEmployeeVC {
            let indexPath = self.resultListTableView.indexPathForSelectedRow
            employeeResults.employee = employees[indexPath!.row]
        }
    }

}
