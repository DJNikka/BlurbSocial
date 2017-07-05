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

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: FancyField!

    @IBOutlet weak var pwdField: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
            }
        
        
            
        })
    }

    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("NIKKA: Email user authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                        print("NIKKA: Unable to authenticate with Firebase using email")
                        } else {
                            print("NIKKA: Successfully authenticated with Firebase")
                        }
                    })
                    
                }
            
        })
    }

}
}
