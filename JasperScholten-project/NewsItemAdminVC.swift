//
//  NewsItemAdminVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

class NewsItemAdminVC: UIViewController {

    @IBOutlet weak var newsItemImage: UIImageView!
    @IBOutlet weak var newsItemTitle: UITextView!
    @IBOutlet weak var newsItemText: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var image = UIImage()
    var admin = Bool()
    
    let storageRef = FIRStorage.storage().reference(forURL: "gs://beoordeling-4d8e2.appspot.com")
    var newsItem = News(itemID: "", organisation: "", location: "", title: "Geen artikel", date: "", text: "Er is iets misgegaan met het laden van een nieuwsartikel")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if admin == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        activityIndicator.stopAnimating()
        setImage()

        newsItemText.textAlignment = .justified
        newsItemTitle.text = newsItem.title
        newsItemText.text = "\(newsItem.date) - \(newsItem.text)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setImage() {
        // https://firebase.google.com/docs/storage/ios/download-files
        let imageRef = storageRef.child(newsItem.itemID)
        let newsItemImage: UIImageView = self.newsItemImage
        let placeholderImage = UIImage(named: "placeholder.jpg")
        let downloadTask = newsItemImage.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
        
        downloadTask?.observe(.resume) { snapshot in
            self.activityIndicator.startAnimating()
        }
        
        downloadTask?.observe(.success) { snapshot in
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Actions
    @IBAction func deleteNewsItem(_ sender: Any) {
    }
    
}
