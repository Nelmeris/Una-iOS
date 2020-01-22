//
//  ProfileEditorViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class ProfileEditorViewController: UIViewController {
    
    var user: User!
    @IBOutlet weak var nameTextField: TextFieldUnderline!
    @IBOutlet weak var surnameTextField: TextFieldUnderline!
    @IBOutlet weak var cityTextField: TextFieldUnderline!
    @IBOutlet weak var countryTextField: TextFieldUnderline!
    @IBOutlet weak var birthdayTextField: TextFieldUnderline!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showProfile()
    }
    
    private func showProfile() {
        
    }

}
