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

    // MARK: - Constants and variables
    let storageRef = FIRStorage.storage().reference(forURL: "gs://beoordeling-4d8e2.appspot.com")
    let newsRef = FIRDatabase.database().reference(withPath: "News")
    var newsItem = News(itemID: "", organisation: "", location: "", title: "Geen artikel", date: "", text: "Er is iets misgegaan met het laden van een nieuwsartikel")
    var image = UIImage()
    var admin = Bool()
    
    // MARK: - Outlets
    @IBOutlet weak var newsItemImage: UIImageView!
    @IBOutlet weak var newsItemImageHeight: NSLayoutConstraint!
    @IBOutlet weak var newsItemTitle: UITextView!
    @IBOutlet weak var newsItemText: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        setImage()
        setTextComponents()
        
        // Only allow admin users to delete newsItems. [1]
        if admin == false {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTitleHeigthToFit()
    }
    
    // MARK: - Actions
    @IBAction func deleteNewsItem(_ sender: Any) {
        deleteNewsTextComponents()
        deleteNewsImage()
    }
    
    // MARK: - Functions
    
    // Initialize title and text of newsItem
    func setTextComponents() {
        newsItemText.textAlignment = .justified
        newsItemTitle.text = newsItem.title
        newsItemText.text = "\(newsItem.date) - \(newsItem.text)"
    }
    
    // Initialize image of newsItem. [2]
    func setImage() {
        let imageRef = storageRef.child(newsItem.itemID)
        let newsItemImage: UIImageView = self.newsItemImage
        let placeholderImage = UIImage(named: "placeholder.jpg")
        let downloadTask = newsItemImage.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
        
        downloadTask?.observe(.resume) { snapshot in
            self.activityIndicator.startAnimating()
        }
        
        // Hide UIImageView when newsItem has no accompanying photo. [3]
        downloadTask?.observe(.failure) { snapshot in
            self.newsItemImageHeight.constant = 0.0
            self.activityIndicator.stopAnimating()
            
        }
    
        downloadTask?.observe(.success) { snapshot in
            self.activityIndicator.stopAnimating()
        }
    }
    
    // Make textView that contains title, adjust its height to the size of the title. [4]
    func adjustTitleHeigthToFit() {
        let contentSize = self.newsItemTitle.sizeThatFits(self.newsItemTitle.bounds.size)
        var frame = self.newsItemTitle.frame
        frame.size.height = contentSize.height
        self.newsItemTitle.frame = frame
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.newsItemTitle, attribute: .height, relatedBy: .equal, toItem: self.newsItemTitle, attribute: .width, multiplier: newsItemTitle.bounds.height/newsItemTitle.bounds.width, constant: 1)
        self.newsItemTitle.addConstraint(aspectRatioTextViewConstraint)
    }
    
    // Delete newsItem text and title from Firebase.
    func deleteNewsTextComponents() {
        newsRef.child(newsItem.itemID).removeValue { (error, ref) in
            if error != nil {
                self.alertSingleOption(titleInput: "Fout bij verwijderen",
                                       messageInput: error as! String)
            }
        }
    }
    
    // Delete newsItem image from Firebase Storage.
    func deleteNewsImage() {
        let imageRef = storageRef.child(newsItem.itemID)
        imageRef.delete { error in
            if let error = error {
                self.alertSingleOption(titleInput: "Fout bij verwijderen",
                                       messageInput: error as! String)
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

// MARK: - References

// 1. http://stackoverflow.com/questions/27887218/how-to-hide-a-bar-button-item-for-certain-users
// 2. https://firebase.google.com/docs/storage/ios/download-files
// 3. https://www.sitepoint.com/self-sizing-cells-uitableview-auto-layout/
// 4. http://stackoverflow.com/questions/29431968/how-to-adjust-the-height-of-a-textview-to-his-content-in-swift
