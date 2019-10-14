//
//  PlacesViewModel.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import RxCocoa
import RxSwift

protocol PlacesViewModelProtocol {
    var title: Driver<String> { get }
    var places: Driver<[Place]> { get }
    func getNeighborPlaces()
    func getNeighborPlaces(latitude: Double, longitude: Double)
}

// MARK: - PlacesViewModel
class PlacesViewModel {
    private let neighborPlacesDatasource: NeighborPlacesDatasource
    private let disposeBag = DisposeBag()
    
    init(neighborPlacesDatasource: NeighborPlacesDatasource) {
        self.neighborPlacesDatasource = neighborPlacesDatasource
    }
}

// MARK: - PlacesViewModelProtocol
extension PlacesViewModel: PlacesViewModelProtocol {
    var title: Driver<String> {
        .just("Restaurants")
    }
    
    var places: Driver<[Place]> {
        return neighborPlacesDatasource.places
    }
    
    func getNeighborPlaces() {
        neighborPlacesDatasource.getNeighborPlaces()
    }
    
    func getNeighborPlaces(latitude: Double, longitude: Double) {
        neighborPlacesDatasource.getNeighborPlaces(
            latitude: latitude,
            longitude: longitude
        )
    }
}
