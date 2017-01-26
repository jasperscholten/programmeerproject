//
//  AddNewsItemVC.swift
//  JasperScholten-project
//
//  Created by Jasper Scholten on 12-01-17.
//  Copyright © 2017 Jasper Scholten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos

class AddNewsItemVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Constants and variables
    let newsRef = FIRDatabase.database().reference(withPath: "News")
    let storageRef = FIRStorage.storage().reference(forURL: "gs://beoordeling-4d8e2.appspot.com")
    let imagePicker = UIImagePickerController()
    var imageReference = URL(fileURLWithPath: "")
    
    // MARK: - Outlets
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addTitle: UITextView!
    @IBOutlet weak var addText: UITextView!
    @IBOutlet weak var chooseImageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        addTitle.textColor = UIColor.lightGray
        addText.textColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Make remarkBox placeholder
    // http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Klik om te beginnen met typen"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Actions
    
    @IBAction func saveNewsItem(_ sender: Any) {
        saveNewsItem()
    }
    
    func saveNewsItem() {
        
        // http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: Date())
        
        let newRef = self.newsRef.childByAutoId()
        let newID = newRef.key
        
        let newsItem = News(itemID: newID, title: addTitle.text, date: date, text: addText.text)
        newRef.setValue(newsItem.toAnyObject())
        
        saveNewsImage(childID: newID)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    // https://firebase.google.com/docs/storage/ios/upload-files
    //https://github.com/firebase/quickstart-ios/blob/master/storage/StorageExampleSwift/ViewController.swift
    func saveNewsImage(childID: String) {
        
        // if it's a photo from the library, not an image from the camera
        let referenceUrl = imageReference
        let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceUrl], options: nil)
        let asset = assets.firstObject
        asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
            let imageFile = contentEditingInput?.fullSizeImageURL

            // [START uploadimage]
            self.storageRef.child(childID)
                .putFile(imageFile!, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    print("Upload Succeeded!")
                    print("URL \((metadata?.downloadURL()?.absoluteString)!)")
            }
            // [END uploadimage]
        })
    }
    
    
    
    
    
    
    // http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
    @IBAction func pickImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImage.contentMode = .scaleAspectFit
            addImage.image = pickedImage
            addImage.contentMode = .scaleAspectFill
            chooseImageButton.setTitle("", for: .normal)
        }
        
        imageReference = info[UIImagePickerControllerReferenceURL] as! URL
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
