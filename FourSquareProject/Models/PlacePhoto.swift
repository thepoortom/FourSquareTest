//
//  PlacePhoto.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

class PlacePhoto {
    let prefix: String
    let suffix: String
    
    var photoURL: String? {
        return "\(prefix)original\(suffix)"
    }
    
    init(container: PlacePhotoContainer) {
        self.prefix = container.prefix
        self.suffix = container.suffix
    }
}
