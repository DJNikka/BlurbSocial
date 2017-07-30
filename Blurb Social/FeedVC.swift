//
//  FeedVC.swift
//  Blurb Social
//
//  Created by Konstantine Piterman on 7/5/17.
//  Copyright © 2017 Konstantine Piterman. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: UIImageView!
    //CircleView! instead of UIImageView! if circular button desired
   
    @IBOutlet weak var captionField: UITextField!

    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var imageSelected = false
    //by default, no images are selected

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.captionField.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }

            }
            self.posts.reverse()
            self.tableView.reloadData()
                        
            //Pulling posts from firebase and adding them to a table view
            
        })

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        captionField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        //if the touching outside of the keyboard begins, dismisses keyboard
    }
    
  
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
        //Will eventually have to be limited in order to save space/data with a "Refresh Load" 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let post = posts[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
           //  var img: UIImage!
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
              
                cell.selectionStyle = .none
                
                //removes highlight from table view cells
                
            } else {
        
            cell.configureCell(post: post)
         
            }
               return cell
            } else {
            
            return PostCell()
        }
        //Saves memory/data by not loading all cells at once, only as needede
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageAdd.image = image
                imageSelected = true
            
            //if image is picked, changes variable imageSelected to true
            
        } else {
            print("NIKKA: A valid image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        //1. If it is the first time user is selecting photos, prompts permission request
        //2. Choose photo to upload
        //3. Dismiss the photo boxes
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
                present(imagePicker, animated: true, completion: nil)
        
     
    }
    @IBAction func postBtnTapped(_ sender: Any) {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            captionField.resignFirstResponder()
            return (true)
        }
        
        guard let caption = captionField.text, caption != "" else {
            print("NIKKA: Caption must be entered")
            let alert = UIAlertController(title: "Caption Required", message: "Say something funny!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion:nil)
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("NIKKA: An image must be selected")
            let alert = UIAlertController(title: "Image Required", message: "Please select a photo.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion:nil)
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("NIKKA: Unable to upload image to Firebase storage")
                    
                } else {
                    print ("NIKKA: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                    }
            
            }
        
        }
    
    
        
    }
    

    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text! as AnyObject,
        "imageUrl": imgUrl as AnyObject,
        "likes": 0 as AnyObject
            
            ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("NIKKA: ID removed from keychain \(keychainResult)")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func tapOut(_ sender: Any) {
      
//         self.view.endEditing(true)
      
       captionField.resignFirstResponder()
        
    }
    
    
  }
