//
//  SaveUserBackendOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

enum SaveUserBackendOperationResult {
    case success
    case failure(Error)
}

class SaveUserBackendOperation: BaseBackendOperation {
    
    private(set) var result: SaveUserBackendOperationResult? { didSet { finish() } }
    private let authUser: UnaAuthUser
    private let userProfile: UnaUserProfile
    
    init(authUser: UnaAuthUser, userProfile: UnaUserProfile) {
        self.authUser = authUser
        self.userProfile = userProfile
        super.init()
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        do {
            var finishedCount = 0
            try UnaDBService.shared.putUserAuth(with: authUser) {
                finishedCount += 1
                if finishedCount == 2 {
                    self.result = .success
                }
            }
            try UnaDBService.shared.putUserProfile(with: userProfile) {
                finishedCount += 1
                if finishedCount == 2 {
                    self.result = .success
                }
            }
        } catch {
            self.result = .failure(error)
        }
    }
    
}
