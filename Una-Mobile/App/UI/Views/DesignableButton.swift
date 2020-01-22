//
//  DesignableButton.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeDefaultValues()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeDefaultValues()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeDefaultValues()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        makeDefaultValues()
    }
    
    private func makeDefaultValues() {
        cornerRadius = 20.0
        shadowColor = .black
        shadowOffset.height = 3.0
        shadowOpacity = 0.16
        shadowRadius = 6
        titleLabel?.font = UIFont(name: "Lato", size: 21)
        contentEdgeInsets = UIEdgeInsets(top: 14.5, left: 29, bottom: 14.5, right: 29)
    }
    
}
