//
//  LoadUserBackendOperation.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 23.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

enum LoadUserBackendOperationResult {
    case success(UnaAuthUser, UnaUserProfile)
    case notFound
    case failure(Error)
}

class LoadUserBackendOperation: BaseBackendOperation {
    
    private(set) var result: LoadUserBackendOperationResult? { didSet { finish() } }
    private let email: String
    
    init(userEmail: String) {
        self.email = userEmail
        super.init()
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        do {
            try UnaDBService.shared.getUser(with: email) { user in
                guard let user = user else {
                    self.result = .notFound
                    return
                }
                do {
                    try UnaDBService.shared.getUserProfile(with: user.id) { profile in
                        guard let profile = profile else {
                            self.result = .notFound
                            return
                        }
                        self.result = .success(user, profile)
                    }
                } catch {
                    self.result = .failure(error)
                }
            }
        } catch {
            self.result = .failure(error)
        }
    }
    
}
