//
//  PlacesServiceMock.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Foundation
import RxSwift
@testable import FourSquareProject

class PlacesServiceMock: PlacesDatasource {
    private(set) var requestedLatitude: Double?
    private(set) var requestedLongitude: Double?
    
    func getPlaces(latitude: Double, longitude: Double) -> Single<[Place]> {
        requestedLatitude = latitude
        requestedLongitude = longitude

        return Single.create { single -> Disposable in
            single(.success([]))
            return Disposables.create()
        }
    }
}
