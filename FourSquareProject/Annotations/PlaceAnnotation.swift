//
//  PlaceAnnotation.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let identifier: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String?,
         identifier: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.identifier = identifier
        self.coordinate = coordinate
        super.init()
    }
}
