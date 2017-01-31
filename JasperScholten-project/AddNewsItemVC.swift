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
    var organisation = String()
    var location = String()
    var originChange = CGFloat()
    
    // MARK: - Outlets
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addTitle: UITextView!
    @IBOutlet weak var addText: UITextView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var uploadImage: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImage.stopAnimating()
        imagePicker.delegate = self
        
        addTitle.textColor = UIColor.lightGray
        addText.textColor = UIColor.lightGray
        
        keyboardActions()
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
        
        if addTitle.text == "Titel" || addText.text == "Nieuwsitem tekst" || addTitle.text == "Klik om te beginnen met typen" || addText.text == "Klik om te beginnen met typen" {
            addAlert(titleInput: "Vul alle velden in", messageInput: "Schrijf een titel en tekst om het nieuwsitem te kunnen publiceren.")
        } else {
            // http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let date = formatter.string(from: Date())
            
            let newRef = self.newsRef.childByAutoId()
            let newID = newRef.key
            
            let newsItem = News(itemID: newID, organisation: organisation, location: location, title: self.addTitle.text, date: date, text: self.addText.text)
            newRef.setValue(newsItem.toAnyObject())
            
            self.saveNewsImage(childID: newID)
            
            
        }
    }
    
    // ACTIVITY INDICATOR TOEVOEGEN

    // https://firebase.google.com/docs/storage/ios/upload-files
    //https://github.com/firebase/quickstart-ios/blob/master/storage/StorageExampleSwift/ViewController.swift
    func saveNewsImage(childID: String) {
        
        if addImage.image != nil {
            // http://stackoverflow.com/questions/37603312/firebase-storage-upload-works-in-simulator-but-not-on-iphone
            let imageData = UIImageJPEGRepresentation(addImage.image!, 0.05)
            
            // [START uploadimage]
            uploadImage.startAnimating()
            self.storageRef.child(childID)
                .put(imageData!, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    print("Upload Succeeded!")
                    print("URL \((metadata?.downloadURL()?.absoluteString)!)")
                    self.uploadImage.stopAnimating()
                    _ = self.navigationController?.popViewController(animated: true)
            }
            // [END uploadimage]
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }

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
    
    
    
    func addAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Keyboard actions [2, 3]
    
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [2]
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewsItemVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewsItemVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [3]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNewsItemVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                originChange = (keyboardSize.height)/1.5
                self.view.frame.origin.y -= originChange
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y += originChange
        }
    }
    
}
