//
//  PlacesServiceSpec.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import RxSwift
import Swinject
import XCTest
@testable import FourSquareProject

class PlacesServiceSpec: XCTestCase {
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
        let placesService = PlacesService(requestManager: requestManager)
        let expectation = XCTestExpectation(description: "Got sample data")
        
        _ = placesService.getPlaces(latitude: 56.011925, longitude: 92.973822)
            .subscribe(onSuccess: { _ in
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Should not return error")
            })
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testShouldEmitTheCorrectError() {
        let placesService = PlacesService(requestManager: requestManagerErrored)
        let expectation = XCTestExpectation(description: "Got error")
        
        _ = placesService.getPlaces(latitude: 56.011925, longitude: 92.973822)
            .subscribe(onSuccess: { _ in
                XCTFail("Should return error")
            }, onError: { error in
                XCTAssertEqual(error.localizedDescription, "Sample data error")
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 1.0)
    }
}
