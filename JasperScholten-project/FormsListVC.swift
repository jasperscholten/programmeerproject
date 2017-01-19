//
//  FormsListVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 19-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class FormsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants and variables
    let list = ["test1", "test2"]
    
    // MARK: - Outlets
    @IBOutlet weak var formsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = formsListTableView.dequeueReusableCell(withIdentifier: "formListCell", for: indexPath) as! FormListCell
        
        cell.formName.text = list[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        formsListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func addNewForm(_ sender: Any) {
        let alert = UIAlertController(title: "Nieuwe vragenlijst",
                                      message: "Wil je een nieuwe vragenlijst gaan opstellen?",
                                      preferredStyle: .alert)
        
        let newFormAction = UIAlertAction(title: "OK",
                                          style: .default) { action in
                                            self.performSegue(withIdentifier: "newForm", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren",
                                         style: .default)
    
        alert.addTextField { (textField) in
            textField.text = "Moet nog een placeholder worden"
        }
        
        alert.addAction(newFormAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }


}
