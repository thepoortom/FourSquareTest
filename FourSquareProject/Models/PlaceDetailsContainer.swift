//
//  PlaceDetailsContainer.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

struct PlaceDetailsContainer: Decodable {
    let identifier: String
    let name: String
    let description: String?
    let rating: Float?
    let location: LocationContainer
    let photo: PlacePhotoContainer?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case rating
        case location
        case photos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        rating = try container.decodeIfPresent(Float.self, forKey: .rating)
        location = try container.decode(LocationContainer.self, forKey: .location)
        
        let photos = try container.decode(PlacePhotosContainer.self, forKey: .photos)
        let group = photos.groups.first(where: { !$0.items.isEmpty })
        photo = group?.items.first
    }
}

struct PlacePhotosContainer: Decodable {
    let groups: [PlacePhotoGroupContainer]
}

struct PlacePhotoGroupContainer: Decodable {
    let items: [PlacePhotoContainer]
}
