//
//  ViewController.swift
//  Blurb Social
//
//  Created by Konstantine Piterman on 6/19/17.
//  Copyright © 2017 Konstantine Piterman. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: FancyField!

    @IBOutlet weak var pwdField: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
        
        
    }

    
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
            print ("NIKKA: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                print("NIKKA: User cancelled Facebook authentication")
                
            } else {
                print("NIKKA: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
                self.firebaseAuth(credential)
            }
        }
}
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
            print("NIKKA: Unable to authenticate with Firebase")
            } else {
            
                print("NIKKA: Succesfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                
    
                }
            }
        
        
            
        })
    }

    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("NIKKA: Email user authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                        print("NIKKA: Unable to authenticate with Firebase using email")
                        } else {
                            print("NIKKA: Successfully authenticated with Firebase")
                            if let user = user {
                            self.completeSignIn(id: user.uid)
                        
                        }
                        }
                    })
                    
                }
            
        })
    }
    }
    

        func completeSignIn(id: String) {
            
            let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
            print("NIKKA: Data saved to keychain \(keychainResult)")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
        
        
}

