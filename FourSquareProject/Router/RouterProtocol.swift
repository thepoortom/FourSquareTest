//
//  RouterProtocol.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import UIKit

enum Screen {
    case places
    case place(identifier: String, name: String?)
}

protocol RouterProtocol {
    var rootViewController: UIViewController? { get }
    func push(screen: Screen, animated: Bool)
    func pop(animated: Bool)
}
