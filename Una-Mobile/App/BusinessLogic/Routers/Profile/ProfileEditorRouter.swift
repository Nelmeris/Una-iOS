//
//  ProfileEditorRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

final class ProfileEditorRouter: BaseRouter {
    
    func backToProfile(animated: Bool) {
        pop(animated: animated)
    }
    
}
