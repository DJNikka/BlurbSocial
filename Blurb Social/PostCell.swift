//
//  PostCell.swift
//  Blurb Social
//
//  Created by Konstantine Piterman on 7/12/17.
//  Copyright © 2017 Konstantine Piterman. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
                       
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            
                
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("NIKKA: Unable to download image from Firebase storage")
                    } else {
                        print("NIKKA: Image downloaded from Firebase storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageUrl)
                                
                                //downloading images and saving them to cache
                                //FIRStorage deprecated to Storage
                            }
                        }
                    }
                })
        }
    }
}

