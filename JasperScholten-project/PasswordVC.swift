//
//  PasswordVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 13-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func cancelPasswordChange(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }

}
