//
//  StudyTableViewCell.swift
//  YouLang-Mobile
//
//  Created by Артем Куфаев on 30/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class StudyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.transform = progressView.transform.scaledBy(x: 1, y: 3)
        }
    }
    @IBOutlet weak var courceImage: UIImageView!
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        courceImage.image = nil
    }
    
}
