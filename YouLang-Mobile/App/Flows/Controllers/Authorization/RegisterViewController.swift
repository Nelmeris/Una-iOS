//
//  RegisterViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 13/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var router: RegisterRouter!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Регистрация"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toMain(_ sender: Any) {
        router.toMain(configurate: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
