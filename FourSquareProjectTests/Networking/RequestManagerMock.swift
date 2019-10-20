//
//  RequestManagerMock.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import RxSwift
@testable import FourSquareProject

class RequestManagerMock {
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data) -> T? {
        guard let response = try? jsonDecoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
    private func readJSON(name: String) -> Data? {
        let bundle = Bundle(for: RequestManagerMock.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else { return nil }
        do {
            return try Data(contentsOf: url, options: .mappedIfSafe)
        } catch {
            return nil
        }
    }
}

extension RequestManagerMock: RequestManagerProtocol {
    func makeRequest<T: Decodable>(_ request: Request) -> Single<T> {
        let observable: Single<T> = Single.create { single -> Disposable in
            if let data = self.readJSON(name: request.sampleDataFilename),
                let value = self.decodeJSON(type: T.self, from: data) {
                single(.success(value))
            } else {
                single(.error(AppError.sampleDataFetchingError))
            }
            return Disposables.create()
        }
        return observable
    }
}
