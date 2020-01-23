//
//  LessonPartTableViewCell.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

class LessonPartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var checkMarkBackgroundView: RoundView!
    @IBOutlet weak var checkMarkImageView: RoundImage!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topConnectionLineView: UIView!
    @IBOutlet weak var bottomConnectionLineView: UIView!
    
    override func prepareForReuse() {
        selectedView.backgroundColor = .clear
        checkMarkBackgroundView.backgroundColor = .white
        titleLabel.textColor = .white
        topConnectionLineView.backgroundColor = .white
        bottomConnectionLineView.backgroundColor = .white
        checkMarkImageView.image = UIImage(named: "CheckMarkIcon")
        checkMarkBackgroundView.borderWidth = 3
    }
    
    public func configure(with viewModel: LessonPartViewModel, isFirst: Bool, isLast: Bool, isActive: Bool) {
        self.selectionStyle = .none

        let unfulfilledColor = UIColor(hex: "#C2C4C6FF")
        if !viewModel.isCompleted && !isActive {
            checkMarkBackgroundView.backgroundColor = unfulfilledColor
            titleLabel.textColor = unfulfilledColor
            topConnectionLineView.backgroundColor = unfulfilledColor
            bottomConnectionLineView.backgroundColor = unfulfilledColor
            checkMarkImageView.image = nil
            checkMarkBackgroundView.borderWidth = 0
        }
        if isActive {
            checkMarkImageView.image = nil
            checkMarkBackgroundView.borderWidth = 0
        }
        
        if self.isSelected {
            self.selectedView.backgroundColor = UIColor(white: 1, alpha: 0.15)
        } else {
            self.selectedView.backgroundColor = .clear
        }
        
        if isFirst {
            topConnectionLineView.backgroundColor = .clear
        }
        if isLast {
            bottomConnectionLineView.backgroundColor = .clear
        }
        
        titleLabel.text = viewModel.title
    }
    
}
