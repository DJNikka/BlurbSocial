//
//  DataService.swift
//  Blurb Social
//
//  Created by Konstantine Piterman on 7/13/17.
//  Copyright © 2017 Konstantine Piterman. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("Models")
    
    //use same process for profile images as post images above
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
        
    }
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        
        
    }
    
    
    
}
