//
//  Request+Stubs.swift
//  FourSquareProjectTests
//
//  Created by Leo on 20.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Foundation
@testable import FourSquareProject

extension Request {
    var sampleDataFilename: String {
        switch self {
        case .places:
            return "places"
        case .place:
            return "place"
        }
    }
}
