//
//  YouLang_MobileTests.swift
//  YouLang-MobileTests
//
//  Created by Artem Kufaev on 12/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import YouLang_Mobile

class YLUsersTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCources() {
        let expectation = XCTestExpectation(description: "Cources")
        YLService.shared.getCources(accessToken: "1hr1hfqpnfdlkfnlw1po43810podl") { response in
            switch response.result {
            case .success: break
            case .failure (let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLogin() {
        let expectation = XCTestExpectation(description: "Login")
        YLService.shared.login(email: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success: break
            case .failure (let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLogout() {
        let expectation = XCTestExpectation(description: "Logout")
        YLService.shared.logout(accessToken: "1hr1hfqpnfdlkfnlw1po43810podl") { response in
            switch response.result {
            case .success: break
            case .failure (let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRegister() {
        let expectation = XCTestExpectation(description: "Registration")
        YLService.shared.register(firstName: "Artem", lastName: "Kufaev", email: "kfuaevArtem@icloud.com", password: "596235235") { response in
            switch response.result {
            case .success: break
            case .failure (let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
