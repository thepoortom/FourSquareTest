//
//  UserLocationServiceMock.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import CoreLocation
import RxSwift
@testable import FourSquareProject

struct UserLocationServiceMock: UserLocationDatasource {
    let location = CLLocation(latitude: 56.011925, longitude: 92.973822)
    
    func getUserLocation() -> Observable<CLLocation> {
        return .of(location)
    }
}
