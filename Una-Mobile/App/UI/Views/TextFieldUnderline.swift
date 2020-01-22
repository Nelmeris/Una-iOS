//
//  CustomTextField.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

@IBDesignable
class TextFieldUnderline: UITextField {
    
    var underline: CALayer = CALayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        underline.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: underlineHeight)
        underline.backgroundColor = underlineColor.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(underline)
    }

    @IBInspectable
    var underlineHeight: CGFloat = 1.0

    @IBInspectable
    var underlineColor: UIColor = .black

}
