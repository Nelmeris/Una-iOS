//
//  LastWelcomeViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 17.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class LastWelcomeViewController: UIViewController {
    
    private let accessTokenKey = "access_token"
    
    @IBOutlet var router: WelcomeRouter!
    
    @IBAction func close(_ sender: Any) {
        if Keychain.load(accessTokenKey) != nil { // If need authorization
            router.toStudy()
        } else {
            router.toAuth()
        }
    }
    
}
