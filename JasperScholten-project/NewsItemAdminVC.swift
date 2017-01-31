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
    var image = UIImage()
    var admin = Bool()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://beoordeling-4d8e2.appspot.com")
    let newsRef = FIRDatabase.database().reference(withPath: "News")
    var newsItem = News(itemID: "", organisation: "", location: "", title: "Geen artikel", date: "", text: "Er is iets misgegaan met het laden van een nieuwsartikel")
    
    // MARK: - Outlets
    @IBOutlet weak var newsItemImage: UIImageView!
    @IBOutlet weak var newsItemTitle: UITextView!
    @IBOutlet weak var newsItemText: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - UIViewController Lifecycle
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

    func setImage() {
        // https://firebase.google.com/docs/storage/ios/download-files
        let imageRef = storageRef.child(newsItem.itemID)
        print("REF: \(imageRef)")
        let newsItemImage: UIImageView = self.newsItemImage
        let placeholderImage = UIImage(named: "placeholder.jpg")
        let downloadTask = newsItemImage.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
        
        downloadTask?.observe(.resume) { snapshot in
            self.activityIndicator.startAnimating()
        }
        
        downloadTask?.observe(.failure) { snapshot in
            guard let errorCode = (snapshot.error as? NSError)?.code else {
                return
            }
            guard let error = FIRStorageErrorCode(rawValue: errorCode) else {
                return
            }
            print("ERROR: \(error)")
            print("ERRORCODE: \(errorCode)")
            newsItemImage.isHidden = true
            // newsItemImage.bounds.height = 0 o.i.d.
            self.activityIndicator.stopAnimating()
            
        }
        
        downloadTask?.observe(.success) { snapshot in
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Actions
    @IBAction func deleteNewsItem(_ sender: Any) {
        
        newsRef.child(newsItem.itemID).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
        
        // Create a reference to the file to delete
        let imageRef = storageRef.child(newsItem.itemID)
        
        // Delete the file
        imageRef.delete { error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // File deleted successfully
            }
        }
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}
