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
        XCTAssertEqual(self.userDataHandler.users.count, 0)
        let expectation = XCTestExpectation(description: "Make API request to retrieve data")
        
        self.userDataHandler.fetchUsers({
            XCTAssertLessThanOrEqual(self.userDataHandler.users.count, total)
            expectation.fulfill()
        })
        wait(for:[expectation], timeout: 15.0)
    }
    
    func testUserDataHandlerCoreData() throws {
        XCTAssertNotNil(self.userDataHandler.dataContainer) 
    }
}
