//
//  FeedVC.swift
//  Blurb Social
//
//  Created by Konstantine Piterman on 7/5/17.
//  Copyright © 2017 Konstantine Piterman. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("NIKKA: ID removed from keychain \(keychainResult)")
        dismiss(animated: true, completion: nil)
    }

}
