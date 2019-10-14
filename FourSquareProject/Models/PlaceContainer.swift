//
//  PlaceContainer.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Foundation

struct PlaceContainer: Decodable {
    let identifier: String
    let name: String
    let rating: Float?
    let location: LocationContainer
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case rating
        case location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decodeIfPresent(Float.self, forKey: .rating)
        location = try container.decode(LocationContainer.self, forKey: .location)
    }
}
