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
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    
    public func configure(with viewModel: LessonViewModel) {
        titleLabel.text = viewModel.title
        stateLabel.text = viewModel.stateText
        levelLabel.text = viewModel.levelTitle
        levelLabel.textColor = viewModel.levelColor
    }
    
}
