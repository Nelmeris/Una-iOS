//
//  RegisterViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var router: RegisterRouter!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameField: CustomTextField!
    @IBOutlet weak var lastNameField: CustomTextField!
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var rPasswordField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        configureNavigationController()
        registerForKeyboardNotifications()
        addTapGestureToHideKeyboard()
    }
    
    // MARK: - Configuratings
    
    func configureTextFields() {
        firstNameField.delegate = self
        firstNameField.returnKeyType = .next
        
        lastNameField.delegate = self
        lastNameField.returnKeyType = .next
        
        emailField.delegate = self
        emailField.returnKeyType = .next
        
        passwordField.delegate = self
        passwordField.returnKeyType = .next
        
        rPasswordField.delegate = self
        rPasswordField.returnKeyType = .done
    }
    
    func configureNavigationController() {
        self.navigationItem.title = "РЕГИСТРАЦИЯ"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    @IBAction func registrationProcess(_ sender: Any) {
        if (passwordField.text == rPasswordField.text) {
            router.toMain(configurate: nil)
        }
    }
    
    // MARK: - TextField & Keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case let field where field == firstNameField:
            lastNameField.becomeFirstResponder()
            break
        case let field where field == lastNameField:
            emailField.becomeFirstResponder()
            break
        case let field where field == emailField:
            passwordField.becomeFirstResponder()
            break
        case let field where field == passwordField:
            rPasswordField.becomeFirstResponder()
            break
            
        default:
            self.view.endEditing(true)
            registrationProcess(textField)
            break;
        }
        return false
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let offsetY = firstNameField.frame.origin.y - firstNameField.frame.size.height
        scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }
    
    @objc func kbWillHide() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    deinit {
        removeKeyboardNotifications()
    }

}
