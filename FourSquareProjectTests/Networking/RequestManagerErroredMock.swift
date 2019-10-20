//
//  RequestManagerErrorMock.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import RxSwift
@testable import FourSquareProject

class RequestManagerErroredMock: RequestManagerProtocol {
    func makeRequest<T: Decodable>(_ request: Request) -> Single<T> {
        let mockError = NSError(
            domain: "com.foursquareproject.tests",
            code: 101,
            userInfo: [NSLocalizedDescriptionKey: "Sample data error"]
        )
        
        let observable: Single<T> = Single.create { single -> Disposable in
            single(.error(mockError))
            return Disposables.create()
        }
        return observable
    }
}
