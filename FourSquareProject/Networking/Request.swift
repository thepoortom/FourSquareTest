//
//  Request.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

enum Request {
    case places(latitude: Double, longitude: Double)
    case place(id: String)
    
    enum Method {
        case get
    }
    
    var baseURL: String {
        return "https://api.foursquare.com/v2"
    }
    
    var path: String {
        switch self {
        case .places:
            return "/venues/search"
        case .place(let id):
            return "/venues/\(id)"
        }
    }
    
    var keyPath: String? {
        switch self {
        case .places:
            return "response.venues"
        case .place:
            return "response.venue"
        }
    }
    
    var method: Method {
        switch self {
        case .place, .places:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .places(latitude, longitude):
            return [
                "v": Configuration.FourSquare.apiVersion,
                "venuePhotos": 1,
                "limit": 10,
                "radius": Int(Configuration.regionRadius * 2),
                "ll": String(format: "%f,%f", latitude, longitude),
                "categoryId": "4d4b7105d754a06374d81259", // Restaurants
                "client_id": Configuration.FourSquare.clientID,
                "client_secret": Configuration.FourSquare.clientSecret
            ]
        case .place:
            return [
                "v": Configuration.FourSquare.apiVersion,
                "venuePhotos": 1,
                "client_id": Configuration.FourSquare.clientID,
                "client_secret": Configuration.FourSquare.clientSecret
            ]
        }
    }
}
