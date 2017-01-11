//
//  ReviewEmployeeVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class ReviewEmployeeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let employees = ["Hans Beerekamp", "Ineke Bosch", "Niels Pel", "Marinus Zeekoe", "Emma Post", "Henk van Ingrid", "Ingrid van Henk", "Jan Janssen"]
    
    @IBOutlet weak var employeesTableView: UITableView!
    
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
        let cell = employeesTableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeCell
        
        cell.employeeName.text = employees[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "newReview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newReview = segue.destination as? NewReviewVC {
            let indexPath = self.employeesTableView.indexPathForSelectedRow
            newReview.employee = employees[indexPath!.row]
        }
    }

}
