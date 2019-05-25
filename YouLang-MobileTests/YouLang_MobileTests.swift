//
//  YouLang_MobileTests.swift
//  YouLang-MobileTests
//
//  Created by Artem Kufaev on 12/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import YouLang_Mobile

class YouLang_MobileTests: XCTestCase {

    let requestFactory = YLRequestFactory()
    var auth: YLAuthRequestFactory! = nil
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        auth = requestFactory.makeAuthRequestFatory()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        auth = nil
    }
    
    func testGetCources() {
        let cources = requestFactory.makeCourceRequestFactory()
        let expectation = XCTestExpectation(description: "Cources")
        cources.getCources(accessToken: "fqwfqwfqwfqwfq") { response in
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
        auth.login(email: "Somebody", password: "mypassword") { response in
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
        auth.logout(accessToken: "fqfqwfqwfqwf") { response in
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
        auth.register(firstName: "Artem", lastName: "Kufaev", email: "kfuaevArtem@icloud.com", password: "596235235") { response in
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
