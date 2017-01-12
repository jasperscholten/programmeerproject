//
//  NewsItemAdminVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit

class NewsItemAdminVC: UIViewController {

    @IBOutlet weak var newsItemImage: UIImageView!
    @IBOutlet weak var newsItemTitle: UITextView!
    @IBOutlet weak var newsItemText: UITextView!
    
    var image = UIImage()
    var itemTitle = String()
    var itemDate = String()
    var itemText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsItemText.textAlignment = .justified
        newsItemTitle.text = itemTitle
        newsItemText.text = "\(itemDate) - \(itemText)"
        newsItemImage.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
