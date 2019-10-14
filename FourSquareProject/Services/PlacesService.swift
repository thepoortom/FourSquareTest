//
//  PlacesService.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import RxSwift

protocol PlacesDatasource {
    func getPlaces(latitude: Double, longitude: Double) -> Single<[Place]>
}

// MARK: - PlacesService
class PlacesService {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
}

// MARK: - PlacesDatasource
extension PlacesService: PlacesDatasource {
    func getPlaces(latitude: Double, longitude: Double) -> Single<[Place]> {
        let request: Request = .places(latitude: latitude, longitude: longitude)
        let dataRequest: Single<[PlaceContainer]> = requestManager.makeRequest(request)
        return dataRequest
            .map { containers in containers.map { Place(container: $0) } }
    }
}
