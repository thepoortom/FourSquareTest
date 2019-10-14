//
//  PlaceDetails.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

class PlaceDetails {
    let identifier: String
    let name: String
    let description: String?
    let rating: Float?
    let location: Location
    let photo: PlacePhoto?
    
    var ratingText: String? {
        guard let rating = rating else { return nil }
        return "Rating: \(rating)"
    }
    
    init(container: PlaceDetailsContainer) {
        self.identifier = container.identifier
        self.name = container.name
        self.description = container.description
        self.rating = container.rating
        self.location = Location(container: container.location)
        self.photo = {
            guard let value = container.photo else { return nil }
            return PlacePhoto(container: value)
        }()
    }
    
    init(identifier: String,
         name: String,
         description: String? = nil,
         rating: Float? = nil,
         location: Location = Location(latitude: 0, longitude: 0),
         photo: PlacePhoto? = nil) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.rating = rating
        self.location = location
        self.photo = photo
    }
}
