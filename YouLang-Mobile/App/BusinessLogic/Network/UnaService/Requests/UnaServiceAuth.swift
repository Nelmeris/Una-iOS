//
//  UnaServiceAuth.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 07.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import CryptoSwift

protocol UnaServiceAuthFactory {
    func login(email: String, password: String) -> Bool
    func register()
    func restorePassword()
}

extension UnaService: UnaServiceAuthFactory {
    
    func login(email: String, password: String) -> Bool {
        return true
    }
    
    func register() {
        
    }
    
    func restorePassword() {
        
    }
    
}
