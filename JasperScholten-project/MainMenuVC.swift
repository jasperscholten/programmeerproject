//
//  MainMenuVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 11-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let menuItems = ["Beoordelen", "Resultaten", "Stel lijst samen", "Rooster (admin)", "Nieuws (admin)", "Beoordelingen", "Rooster", "Nieuws"]
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MainMenuCell
        
        cell.menuItem.text = menuItems[indexPath.row]
        
        return cell
    }

}
