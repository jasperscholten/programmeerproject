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
    var organisationID = String()
    var location = String()
    var originChange = CGFloat()
    var textInset = CGFloat()
    
    // MARK: - Outlets
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addTitle: UITextView!
    @IBOutlet weak var addText: UITextView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var uploadImage: UIActivityIndicatorView!

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImage.stopAnimating()
        keyboardActions()
        imagePicker.delegate = self

        addTitle.textColor = UIColor.lightGray
        addText.textColor = UIColor.lightGray
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
    
    // MARK: - Actions
    
    @IBAction func saveNewsItem(_ sender: Any) {
        saveNewsItem()
    }
    
    // Use imagePicker to let the user select a newsItemImage from its cameraroll. [1]
    @IBAction func pickImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func saveNewsItem() {
        
        if addTitle.text == "Titel" || addText.text == "Nieuwsitem tekst" || addTitle.text == "Klik om te beginnen met typen" || addText.text == "Klik om te beginnen met typen" {
            alertSingleOption(titleInput: "Vul alle velden in",
                              messageInput: "Schrijf een titel en tekst om het nieuwsitem te kunnen publiceren.")
           } else {
            let date = getCurrentDate()
            let newRef = self.newsRef.childByAutoId()
            let newID = newRef.key
            let newsItem = News(itemID: newID, organisation: organisationID, location: location, title: self.addTitle.text, date: date, text: self.addText.text)
            
            newRef.setValue(newsItem.toAnyObject())
            self.saveNewsImage(childID: newID)
        }
    }
    
    // Use Firebase Storage to save selected image from camera roll to Firebase. [2, 3, 4]
    func saveNewsImage(childID: String) {
        if addImage.image != nil {
            uploadImage.startAnimating()
            
            let imageData = UIImageJPEGRepresentation(addImage.image!, 0.05)
            self.storageRef.child(childID).put(imageData!, metadata: nil) { (metadata, error) in
                    if let error = error {
                        self.alertSingleOption(titleInput: "Fout met uploaden",
                                          messageInput: error as! String)
                        return
                    }
                    self.uploadImage.stopAnimating()
                    _ = self.navigationController?.popViewController(animated: true)
            }
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Reference: [5]
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: Date())
    }

    // textViewDidBeginEditing and textViewDidEndEditing functions enable setting a placeholder in remarkBox textView. [6]
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
    
    // Handle keyboard behaviour.
    func keyboardActions() {
        // Make sure all buttons and inputfields keep visible when the keyboard appears. [7]
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewsItemVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewsItemVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Enable user to dismiss keyboard by tapping outside of it. [8]
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNewsItemVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Move screen upwards on keyboardshow. Also make sure that the textViews don't get covered by the keyboard. [9]
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                originChange = (keyboardSize.height)/1.5
                textInset = keyboardSize.height - originChange
                self.view.frame.origin.y -= originChange
                self.addText.contentInset.bottom = textInset
                self.addText.scrollIndicatorInsets.bottom = textInset
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y += originChange
            self.addText.contentInset.bottom = 0.0
            self.addText.scrollIndicatorInsets.bottom = 0.0
        }
    }
    
}

// MARK: - References

// 1. http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
// 2. https://firebase.google.com/docs/storage/ios/upload-files
// 3. https://github.com/firebase/quickstart-ios/blob/master/storage/StorageExampleSwift/ViewController.swift
// 4. http://stackoverflow.com/questions/37603312/firebase-storage-upload-works-in-simulator-but-not-on-iphone
// 5. http://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
// 6. http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
// 7. http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
// 8. http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
// 9. http://stackoverflow.com/questions/36630652/swift-change-autolayout-constraints-when-keyboard-is-shown
