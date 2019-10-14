//
//  PlaceDetailsViewModel.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import RxCocoa
import RxSwift

protocol PlaceDetailsViewModelProtocol {
    var title: Driver<String> { get }
    var place: Driver<PlaceDetails> { get }
}

// MARK: - PlaceDetailsViewModel
class PlaceDetailsViewModel {
    private let placeDatasource: PlaceDatasource
    private let disposeBag = DisposeBag()
    
    private let identifier: String
    private let name: String?
    
    init(identifier: String,
         name: String?,
         placeDatasource: PlaceDatasource) {
        self.identifier = identifier
        self.name = name
        self.placeDatasource = placeDatasource
    }
}

// MARK: - PlaceDetailsViewModelProtocol
extension PlaceDetailsViewModel: PlaceDetailsViewModelProtocol {
    var title: Driver<String> {
        .just(name ?? "Restaurant")
    }
    
    var place: Driver<PlaceDetails> {
        return placeDatasource
            .getPlace(id: identifier)
            .asDriver(onErrorJustReturn: PlaceDetails(identifier: identifier, name: name ?? ""))
    }
}
