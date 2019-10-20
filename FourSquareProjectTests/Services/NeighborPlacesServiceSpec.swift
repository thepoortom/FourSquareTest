//
//  NeighborPlacesServiceSpec.swift
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

class NeighborPlacesServiceSpec: XCTestCase {
    private var container: Container!
    private var placesDatasource: PlacesServiceMock!
    private var userLocationDatasource: UserLocationServiceMock!
    private var neighborPlacesService: NeighborPlacesService!
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        container = Container()
        container.register(UserLocationDatasource.self) { _ in UserLocationServiceMock() }
            .inObjectScope(.container)
        container.register(PlacesDatasource.self) { _ in PlacesServiceMock()}
            .inObjectScope(.container)
        container.register(NeighborPlacesService.self) { resolver in
            let userLocationDatasource = resolver.resolve(UserLocationDatasource.self)!
            let placesDatasource = resolver.resolve(PlacesDatasource.self)!
            return NeighborPlacesService(userLocationDatasource: userLocationDatasource,
                                         placesDatasource: placesDatasource)}
        
        placesDatasource = container.resolve(PlacesDatasource.self)! as? PlacesServiceMock
        userLocationDatasource = container.resolve(UserLocationDatasource.self)! as? UserLocationServiceMock
        neighborPlacesService = container.resolve(NeighborPlacesService.self)
    }
    
    func testShouldResolveDependencies() {
        XCTAssertNotNil(placesDatasource)
        XCTAssertNotNil(userLocationDatasource)
        XCTAssertNotNil(neighborPlacesService)
    }
    
    func testShouldRequestNeighborNearUserLocation() {
        neighborPlacesService.getNeighborPlaces()
        
        let mockUserLatitude = userLocationDatasource.location.coordinate.latitude
        let mockUserLongitude = userLocationDatasource.location.coordinate.longitude
        
        XCTAssertEqual(placesDatasource.requestedLatitude, mockUserLatitude)
        XCTAssertEqual(placesDatasource.requestedLongitude, mockUserLongitude)
    }
}
