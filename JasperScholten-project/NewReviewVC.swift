//
//  NewReviewVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class NewReviewVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewTitle: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    
    var employee: String = "Medewerker"
    let questions = ["Klanten worden door de medewerker opgemerkt.", "Klanten worden door de medewerker begroet.", "De medewerker spreekt de klanten aan.", "De medewerker opent het gesprek.", "De medewerker toont de geadviseerde producten.", "De medewerker heeft gevraagd of hij de klant nog ergens anders mee kan helpen.", "De medewerker heeft afscheid genomen van de klant."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewTitle.text = employee
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
        
        cell.questionView.text = questions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reviewTableView.deselectRow(at: indexPath, animated: true)
    }

}
