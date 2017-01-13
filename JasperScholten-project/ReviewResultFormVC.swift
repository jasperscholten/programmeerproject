//
//  ReviewResultFormVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class ReviewResultFormVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var reviewFormTableView: UITableView!
    @IBOutlet weak var commentField: UITextView!
    
    let questions = ["Klanten worden door de medewerker opgemerkt.", "Klanten worden door de medewerker begroet.", "De medewerker spreekt de klanten aan.", "De medewerker opent het gesprek.", "De medewerker toont de geadviseerde producten.", "De medewerker heeft gevraagd of hij de klant nog ergens anders mee kan helpen.", "De medewerker heeft afscheid genomen van de klant."]
    let result = [true, true, true, true, false, false, true]
    let comment = "De basis staat, nu nog verderwerken aan de details."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentField.text = comment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewFormTableView.dequeueReusableCell(withIdentifier: "reviewFormCell", for: indexPath) as! ReviewResultFormCell
        
        cell.questionField.text = questions[indexPath.row]
        cell.answerSwitch.isOn = result[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reviewFormTableView.deselectRow(at: indexPath, animated: true)
    }

}
