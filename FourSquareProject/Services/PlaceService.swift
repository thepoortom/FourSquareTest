//
//  PlaceService.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import RxSwift

protocol PlaceDatasource {
    func getPlace(id: String) -> Single<PlaceDetails>
}

// MARK: - PlaceService
class PlaceService {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
}

// MARK: - PlaceDatasource
extension PlaceService: PlaceDatasource {
    func getPlace(id: String) -> Single<PlaceDetails> {
        let request: Request = .place(id: id)
        let dataRequest: Single<PlaceDetailsContainer> = requestManager.makeRequest(request)
        return dataRequest
            .map { PlaceDetails(container: $0) }
    }
}
