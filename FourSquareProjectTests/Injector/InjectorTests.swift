//
//  InjectorTests.swift
//  FourSquareProjectTests
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import XCTest
@testable import FourSquareProject

class InjectorTests: XCTestCase {
    private var injector: Injector!

    override func setUp() {
        super.setUp()
        injector = Injector()
    }

    func testShouldResolveServices() {
        let locationManager = injector.resolve(LocationManager.self)
        let userLocationService = injector.resolve(UserLocationDatasource.self)
        XCTAssertNotNil(locationManager)
        XCTAssertNotNil(userLocationService)
    }

    func testShouldResolveRequestManager() {
        let requestManager = injector.resolve(RequestManagerProtocol.self)
        XCTAssertNotNil(requestManager)
    }
}
