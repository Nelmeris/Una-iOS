//
//  ProfileEditorViewPresenter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 22.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileEditorView: class {
}

protocol ProfileEditorViewPresenter {
    init(view: ProfileEditorView, user: User)
}


class ProfileEditorPresenter : ProfileEditorViewPresenter {
    
    unowned let view: ProfileEditorView
    private let user: User
    
    required init(view: ProfileEditorView, user: User) {
        self.view = view
        self.user = user
    }
    
    func showUserDetails() {
        
    }
    
    
    
}
