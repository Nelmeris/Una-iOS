//
//  TaskResultViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

class TaskResultViewController: UIViewController {
    
    var correctlyCount: Int!
    var incorrectlyCount: Int!
    var part: LessonPart!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var correctlyCountLabel: UILabel!
    @IBOutlet weak var incorrectlyCountLabel: UILabel!
    @IBOutlet var router: TaskResultRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Вы прошли «\(part.title!)»"
        correctlyCountLabel.text = String(correctlyCount)
        incorrectlyCountLabel.text = String(incorrectlyCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backToLessonPartList(_ sender: Any) {
        router.backToLessonPartsList(animated: true)
    }
    
    @IBAction func repeatPart(_ sender: Any) {
        router.backToLessonPart(animated: true)
    }
    
}
