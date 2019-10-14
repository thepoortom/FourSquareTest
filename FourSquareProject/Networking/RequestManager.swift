//
//  RequestManager.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Alamofire
import CodableAlamofire
import RxAlamofire
import RxSwift

protocol RequestManagerProtocol {
    func makeRequest<T: Decodable>(_ request: Request) -> Single<T>
}

fileprivate extension Request {
    var httpMethod: HTTPMethod {
        switch method {
        case .get:      return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch method {
        case .get:      return URLEncoding.default
        }
    }
}

class RequestManager {
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}

extension RequestManager: RequestManagerProtocol {
    func makeRequest<T: Decodable>(_ request: Request) -> Single<T> {
        let dataRequest: Observable<DataRequest> = RxAlamofire.request(
            request.httpMethod,
            request.baseURL + request.path,
            parameters: request.parameters,
            encoding: request.parameterEncoding,
            headers: nil
        )
        return dataRequest
            .concatMap { [unowned self] dataRequest in
                self.makeDecodableResponse(dataRequest: dataRequest, keyPath: request.keyPath)
        }.asSingle()
    }
    
    private func makeDecodableResponse<T: Decodable>(dataRequest: DataRequest, keyPath: String?) -> Single<T> {
        let observable: Single<T> = Single.create { single -> Disposable in
            dataRequest.responseDecodableObject(queue: nil, keyPath: keyPath, decoder: self.jsonDecoder) {
                (response: DataResponse<T>) in
                guard let value = response.result.value else {
                    single(.error(AppError.networkError))
                    return
                }
                single(.success(value))
            }
            return Disposables.create()
        }
        return observable
    }
}
