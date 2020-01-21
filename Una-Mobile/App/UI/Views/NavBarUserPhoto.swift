//
//  NavBarUserPhoto.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

class NavBarUserItem: UIBarButtonItem {
    
    init(_ photo: UIImage, size: CGFloat, target: Any?, action: Selector) {
        super.init()
        
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        let button = UIButton(frame: frame)
        
        let resizeblePhoto = photo.resizeImage(size, opaque: false)
        
        button.setImage(resizeblePhoto, for: .normal)
        button.imageView?.cornerRadius = button.frame.size.height / 2
        button.addTarget(target, action: action, for: .touchUpInside)
        
        self.customView = button
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
