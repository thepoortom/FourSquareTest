//
//  Place.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

class Place {
    let identifier: String
    let name: String
    let rating: Float?
    let location: Location
    
    var subtitle: String? {
        guard let rating = rating else { return nil }
        return "Rating: \(rating)"
    }
    
    init(container: PlaceContainer) {
        self.identifier = container.identifier
        self.name = container.name
        self.rating = container.rating
        self.location = Location(container: container.location)
    }
}
