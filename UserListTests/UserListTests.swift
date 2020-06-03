//
//  UserListTests.swift
//  UserListTests
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import XCTest
@testable import UserList

class UserListTests: XCTestCase {
    var userDataHandler: UserDataHandler!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.userDataHandler = UserDataHandler()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.userDataHandler = nil
    }

    func testUserDataFetch() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        self.userDataHandler.fetchUsers()
    }
    
}
