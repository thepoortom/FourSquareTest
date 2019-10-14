//
//  LocationContainer.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

struct LocationContainer: Decodable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
