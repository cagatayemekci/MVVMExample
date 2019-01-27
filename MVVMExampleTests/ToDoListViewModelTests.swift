//
//  ToDoListViewModelTests.swift
//  MVVMExampleTests
//
//  Created by Çağatay Emekci on 27.01.2019.
//  Copyright © 2019 Çağatay Emekci. All rights reserved.
//
import XCTest
@testable import MVVMExample


class ToDoListViewModelTests: XCTestCase {
    
    var sut:ToDoListViewModel!
    var mockApiService:MockApiService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockApiService = MockApiService()
        sut = ToDoListViewModel(apiService: mockApiService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockApiService = nil
        sut = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchToDos(){
        mockApiService.completToDos = [ToDoModel]()
        sut.initFetch()
        XCTAssert(mockApiService.isFetchCalled)
    }
    
    func testFetchToDosFail(){
        let error = APIError.jsonParse
        sut.initFetch()
        mockApiService.fetchFail(error: error)
        XCTAssertEqual(sut.alertMessage, error.rawValue)
    }
    
    func testCreateCellViewModel(){
        let toDos = StubGenerator().stubToDos()
        mockApiService.completToDos = toDos
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        sut.initFetch()
        mockApiService.fetchSuccess()
        XCTAssertEqual(sut.numberOfCells,toDos.count)
        wait(for: [expect], timeout: 1.0)
    }
    
    func testLoadingWhenFetching(){
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = {[weak sut] () in
            guard let status = sut?.isLoading else {return}
            loadingStatus = status
            expect.fulfill()
        }
        
        sut.initFetch()
        XCTAssertTrue( loadingStatus)
        mockApiService.fetchSuccess()
        XCTAssertFalse( loadingStatus)
        wait(for: [expect], timeout: 1.0)
    }
    
}

class MockApiService: APIServiceProtocol{
    
    var isFetchCalled = false
    var completToDos: [ToDoModel] = [ToDoModel]()
    var completeClosure: ((Bool, [ToDoModel], APIError?) -> ())!
    
    func fetchToDoList ( complete: @escaping ( _ success: Bool, _ photos: [ToDoModel], _ error: APIError? )->() ){
        isFetchCalled = true
        completeClosure = complete
    }
    
    func fetchSuccess() {
        completeClosure( true, completToDos, nil )
    }
    
    func fetchFail(error: APIError?) {
        completeClosure( false, completToDos, error )
    }
}

class StubGenerator {
    func stubToDos() -> [ToDoModel] {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let todos = try! decoder.decode([ToDoModel].self, from: data)
        return todos
    }
}
