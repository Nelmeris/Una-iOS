//
//  ProfileEditorViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class ProfileEditorViewController: UIViewController, UITextFieldDelegate, AlertDelegate {
    
    // MARK: - Properties
    
    var user: User!
    
    // MARK: - Outlets
    
    // Views
    @IBOutlet weak var scrollView: UIScrollView!
    // Name
    @IBOutlet weak var nameTextField: TextFieldUnderline!
    @IBOutlet weak var surnameTextField: TextFieldUnderline!
    // Location
    @IBOutlet weak var cityTextField: TextFieldUnderline!
    @IBOutlet weak var countryTextField: TextFieldUnderline!
    // Birthday
    @IBOutlet weak var birthdayTextField: TextFieldUnderline!
    var datePicker: UIDatePicker!
    // Email
    @IBOutlet weak var emailTextField: TextFieldUnderline!
    // Password
    @IBOutlet weak var passwordTextField: TextFieldUnderline!
    @IBOutlet weak var repeatPasswordTextField: TextFieldUnderline!
    
    @IBOutlet var router: ProfileEditorRouter!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatePicker()
        configureTextFields()
        configureNavBar()
        registerForKeyboardNotifications(with: #selector(adjustForKeyboard))
        addTapGestureToHideKeyboard()
        
        showProfile()
    }
    
    private func configureDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        var date = Date()
        let maxAge = 100
        var dateComponents = DateComponents()
        dateComponents.year = maxAge * -1
        datePicker.maximumDate = date
        date = Calendar.current.date(byAdding: dateComponents, to: date)!
        datePicker.minimumDate = date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    // MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            surnameTextField.becomeFirstResponder() // To surname
        } else if textField == surnameTextField {
            cityTextField.becomeFirstResponder() // To city
        } else if textField == cityTextField {
            countryTextField.becomeFirstResponder() // To country
        } else if textField == countryTextField {
            birthdayTextField.becomeFirstResponder() // To birthday
        } else if textField == birthdayTextField {
            emailTextField.becomeFirstResponder() // To email
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder() // To password
        } else if textField == passwordTextField {
            repeatPasswordTextField.becomeFirstResponder() // To repeat password
        } else {
            self.view.dismissKeyboard()
            saveChanges(textField)
        }
        return false
    }
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        birthdayTextField.text = UserCoreDataService.dateFormatter.string(from: datePicker.date)
    }
    
    private func configureNavBar() {
        self.title = "Редактирование профиля".uppercased()
    }
    
    private func configureTextFields() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        cityTextField.delegate = self
        countryTextField.delegate = self
        birthdayTextField.delegate = self
        birthdayTextField.inputView = datePicker
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }
    
    private func showProfile() {
        nameTextField.text = user.name
        surnameTextField.text = user.surname
        cityTextField.text = user.city
        countryTextField.text = user.country
        if let birthday = user.birthday {
            datePicker.setDate(birthday, animated: true)
            birthdayTextField.text = UserCoreDataService.dateFormatter.string(from: birthday)
        }
        emailTextField.text = user.email
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        guard let name = nameTextField.text,
            !name.isEmpty else {
            print()
                return
        }
        guard let surname = surnameTextField.text,
            !surname.isEmpty else {
            print()
                return
        }
        guard let city = cityTextField.text,
            !city.isEmpty else {
            print()
                return
        }
        guard let country = countryTextField.text,
            !country.isEmpty else {
            print()
                return
        }
        guard let birthdayStr = birthdayTextField.text,
            !birthdayStr.isEmpty,
            let birthday = UserCoreDataService.dateFormatter.date(from: birthdayStr) else {
            print()
                return
        }
        guard let email = emailTextField.text,
            !email.isEmpty else {
            print()
                return
        }
        do {
            _ = try ValidatorFactory.validatorFor(type: .email).validated(email)
        } catch {
            print(error)
        }
        self.user.email = email.trimmingCharacters(in: .whitespaces)
        self.user.name = name.trimmingCharacters(in: .whitespaces)
        self.user.surname = surname.trimmingCharacters(in: .whitespaces)
        self.user.country = country.trimmingCharacters(in: .whitespaces)
        self.user.city = city.trimmingCharacters(in: .whitespaces)
        self.user.birthday = birthday
        AuthManager.shared.saveUserChanges(user) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showJustAlert(title: "Operation Error", message: error.localizedDescription)
                } else {
                    self.router.backToProfile(animated: true)
                }
            }
        }
    }
    
    @IBAction func exitFromAccount(_ sender: Any) {
        AuthManager.shared.logout()
    }
    
    // MARK: - Keyboard
    
    var selectedTextFieldYPosition: CGFloat = 0.0
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextFieldYPosition = textField.frame.origin.y - textField.frame.size.height
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        scrollViewContentShift(keyboardNotification: notification, scrollView: scrollView, position: selectedTextFieldYPosition)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
}
