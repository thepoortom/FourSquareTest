//
//  PlaceServiceSpec.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Swinject
import RxSwift
import XCTest
@testable import FourSquareProject

class PlaceServiceSpec: XCTestCase {
    private var container: Container!
    private var requestManager: RequestManagerProtocol!
    private var requestManagerErrored: RequestManagerProtocol!
    
    override func setUp() {
        super.setUp()
        
        container = Container()
        container.register(RequestManagerMock.self) { _ in RequestManagerMock() }
        container.register(RequestManagerErroredMock.self) { _ in RequestManagerErroredMock() }
        
        requestManager = container.resolve(RequestManagerMock.self)!
        requestManagerErrored = container.resolve(RequestManagerErroredMock.self)!
    }
    
    override func tearDown() {
        super.tearDown()
        container.removeAll()
    }
    
    func testMapResponseToModel() {
        let placesService = PlaceService(requestManager: requestManager)
        let expectation = XCTestExpectation(description: "Got sample data")
        
        _ = placesService.getPlace(id: "4d3295d7ceb62d43366cea61")
            .subscribe(onSuccess: { _ in
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Should not return error")
            })
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testShouldEmitTheCorrectError() {
        let placesService = PlaceService(requestManager: requestManagerErrored)
        let expectation = XCTestExpectation(description: "Got error")
        
        _ = placesService.getPlace(id: "4d3295d7ceb62d43366cea61")
            .subscribe(onSuccess: { _ in
                XCTFail("Should return error")
            }, onError: { error in
                XCTAssertEqual(error.localizedDescription, "Sample data error")
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testShouldEmitTheCorrectResponseData() {
        let placesService = PlaceService(requestManager: requestManager)
        let expectation = XCTestExpectation(description: "Got sample data")
        
        _ = placesService.getPlace(id: "4d3295d7ceb62d43366cea61")
            .subscribe(onSuccess: { value in
                XCTAssertEqual(value.identifier, "4d3295d7ceb62d43366cea61")
                XCTAssertEqual(value.name, "Пельменная")
                XCTAssertEqual(value.location.latitude, 56.01163902219007)
                XCTAssertEqual(value.location.longitude, 92.96849544579148)
                XCTAssertEqual(value.photo?.prefix, "https://fastly.4sqi.net/img/general/")
                XCTAssertEqual(value.photo?.suffix, "/ThSALoFgrdFtaxEsuuyUVLPbteSYkteNbure2flzYGg.jpg")
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Should not return error")
            })
        
        wait(for: [expectation], timeout: 1.0)
    }
}
