//
//  AddNewsItemVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class AddNewsItemVC: UIViewController {

    
    @IBOutlet weak var addImage: UIView!
    @IBOutlet weak var addTitle: UITextView!
    // http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
    @IBOutlet weak var addText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
