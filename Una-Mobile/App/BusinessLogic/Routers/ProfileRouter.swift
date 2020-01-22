//
//  ProfileRouter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

final class ProfileRouter: BaseRouter {
    
    private let profileStoryboardName = "Profile"
    
    private let profileEditorVCId = "ProfileEditor"
    
    func toEditor(configurate: ((ProfileEditorViewController) -> ())? = nil) {
        let storyboard = UIStoryboard(name: profileStoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: profileEditorVCId)
        guard let profileVC = controller as? ProfileEditorViewController else { fatalError() }
        configurate?(profileVC)
        self.push(profileVC, animated: true)
    }
    
}
