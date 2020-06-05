//
//  UserListTests.swift
//  UserListTests
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import XCTest
import CoreData
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

    func testUserDataHandlerFetch() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let total = self.userDataHandler.totalResults
        self.userDataHandler.deleteUsers(users: self.userDataHandler.users)
        XCTAssertEqual(self.userDataHandler.users.count, 0)
        let expectation = XCTestExpectation(description: "Make API request to retrieve data")
        
        self.userDataHandler.fetchUsers({
            XCTAssertLessThanOrEqual(self.userDataHandler.users.count, total)
            XCTAssertLessThanOrEqual(self.userDataHandler.users.count, self.userDataHandler.fetchAmount * self.userDataHandler.page)
            expectation.fulfill()
        })
        wait(for:[expectation], timeout: 15.0)
    }
    
    func testUserDataHandlerCoreData() throws {
        let expectation = XCTestExpectation(description: "Make API request to retrieve data for CoreData to save")
        
        self.userDataHandler.deleteUsers(users: self.userDataHandler.users)
        XCTAssertEqual(self.userDataHandler.users.count, 0)
        XCTAssertNotNil(self.userDataHandler.dataContainer)
        let users = self.userDataHandler.fetchUsersData()
        XCTAssertEqual(users.count, 0)
        self.userDataHandler.fetchUsers({
            let users = self.userDataHandler.fetchUsersData()
            XCTAssertEqual(users.count, self.userDataHandler.users.count)
            expectation.fulfill()
        })
        wait(for:[expectation], timeout: 15.0)
    }
}
