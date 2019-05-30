//
//  TheoryViewController.swift
//  YouLang-Mobile
//
//  Created by Артем Куфаев on 30/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit
import PanModal

class TheoryViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension TheoryViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
}
