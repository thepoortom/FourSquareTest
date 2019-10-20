//
//  LocationManagerMock.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import CoreLocation
@testable import FourSquareProject

class LocationManagerMock: LocationManager {
    private(set) var calledRequestWhenInUseAuthorization = false
    private(set) var calledRequestLocation = false
    
    weak var delegate: CLLocationManagerDelegate?
    
    func requestWhenInUseAuthorization() {
        calledRequestWhenInUseAuthorization = true
    }
    
    func requestLocation() {
        calledRequestLocation = true
    }
}
