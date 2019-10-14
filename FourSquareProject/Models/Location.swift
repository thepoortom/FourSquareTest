//
//  Location.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

class Location {
    let latitude: Double
    let longitude: Double
    
    init(container: LocationContainer) {
        self.latitude = container.latitude
        self.longitude = container.longitude
    }
    
    init(latitude: Double,
         longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
