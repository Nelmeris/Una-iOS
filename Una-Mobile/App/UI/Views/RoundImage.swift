//
//  RoundImage.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundImage: UIImageView {
    
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
        cornerRadius = self.frame.size.height / 2
    }
    
}
