//
//  ApiServiceTest.swift
//  MVVMExampleUITests
//
//  Created by Çağatay Emekci on 27.01.2019.
//  Copyright © 2019 Çağatay Emekci. All rights reserved.
//

import XCTest
@testable import MVVMExample


class APIServiceTest: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetch_todo_list() {
        
        // Given A apiservice
        let sut = self.sut!
        let expect = XCTestExpectation(description: "callback")
        
        sut.fetchToDoList { (success, todos, error) in
            expect.fulfill()
            XCTAssertEqual(todos.count, 200)
            for todo in todos {
                XCTAssertNotNil(todo.id)
            }
        }
        wait(for: [expect], timeout: 3.1)
    }
    
}
