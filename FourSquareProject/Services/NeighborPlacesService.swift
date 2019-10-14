//
//  NeighborPlacesService.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

protocol NeighborPlacesDatasource {
    var places: Driver<[Place]> { get }
    func getNeighborPlaces()
    func getNeighborPlaces(latitude: Double, longitude: Double)
}

class NeighborPlacesService {
    private let placesDatasource: PlacesDatasource
    private let userLocationDatasource: UserLocationDatasource
    
    private let placesRelay: BehaviorRelay<[Place]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    
    init(userLocationDatasource: UserLocationDatasource,
         placesDatasource: PlacesDatasource) {
        self.userLocationDatasource = userLocationDatasource
        self.placesDatasource = placesDatasource
    }
}

extension NeighborPlacesService: NeighborPlacesDatasource {
    var places: Driver<[Place]> {
        return placesRelay
            .asDriver()
    }
    
    func getNeighborPlaces() {
        return userLocationDatasource
            .getUserLocation()
            .take(1)
            .subscribe(
                onNext: { [weak self] userLocation in
                    guard let strongSelf = self else { return }
                    strongSelf.getNeighborPlaces(
                        latitude: userLocation.coordinate.latitude,
                        longitude: userLocation.coordinate.longitude
                    )
                }, onError: { error in
                    print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func getNeighborPlaces(latitude: Double, longitude: Double) {
        placesDatasource.getPlaces(latitude: latitude, longitude: longitude)
            .asDriver(onErrorJustReturn: [])
            .drive(placesRelay)
            .disposed(by: disposeBag)
    }
}
