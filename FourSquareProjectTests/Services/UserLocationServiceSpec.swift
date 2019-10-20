//
//  UserLocationServiceSpec.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import CoreLocation
import RxSwift
import Swinject
import XCTest
@testable import FourSquareProject

class UserLocationServiceSpec: XCTestCase {
    private var container: Container!
    private var locationManager: LocationManagerMock!
    private var userLocationService: UserLocationService!
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        container = Container()
        container.register(LocationManager.self) { _ in LocationManagerMock() }
            .inObjectScope(.container)
        container.register(UserLocationService.self) { resolver in
            let locationManager = resolver.resolve(LocationManager.self)!
            return UserLocationService(locationManager: locationManager)
        }
        
        locationManager = container.resolve(LocationManager.self)! as? LocationManagerMock
        userLocationService = container.resolve(UserLocationService.self)!
    }
    
    override func tearDown() {
        super.tearDown()
        container.removeAll()
    }
    
    func testDependencyDelegateShouldBeWrapperClass() {
        XCTAssertTrue(locationManager.delegate === userLocationService)
    }
    
    func testShouldRequestUserPermission() {
        XCTAssertFalse(locationManager.calledRequestWhenInUseAuthorization)
        _ = userLocationService.getUserLocation()
        XCTAssertTrue(locationManager.calledRequestWhenInUseAuthorization)
    }
    
    func testShouldRequestLocation() {
        XCTAssertFalse(locationManager.calledRequestLocation)
        _ = userLocationService.getUserLocation()
        XCTAssertTrue(locationManager.calledRequestLocation)
    }
    
    func testShouldProvideLocation() {
        let mockLocation = CLLocation(latitude: 56.011925, longitude: 92.973822)
        let locationStream = userLocationService.getUserLocation()
        
        locationStream.subscribe(onNext: { location in
            XCTAssertEqual(mockLocation, location)
        }, onError: { _ in
            XCTFail("Should not return error")
        }).disposed(by: disposeBag)
        
        locationManager.delegate?.locationManager!(CLLocationManager(),
                                                   didUpdateLocations: [mockLocation])
    }
    
    func testShouldReturnErrorIfLocationManagerFail() {
        let mockError = NSError(domain: "Mock error", code: 101, userInfo: nil)
        let locationStream = userLocationService.getUserLocation()
        
        locationStream.subscribe(onNext: { _ in
            XCTFail("Should return error")
        }, onError: { error in
            XCTAssertEqual(mockError, error as NSError)
        }).disposed(by: disposeBag)
        
        locationManager.delegate?.locationManager!(CLLocationManager(),
                                                   didFailWithError: mockError)
    }
}
