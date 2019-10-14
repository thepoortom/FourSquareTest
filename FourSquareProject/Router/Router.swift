//
//  Router.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Swinject
import UIKit

class Router {
    private let navigationController: UINavigationController
    private let container: Container
    
    init(navigationController: UINavigationController,
         rootScreen: Screen,
         container: Container) {
        self.navigationController = navigationController
        self.container = container
        self.navigationController.viewControllers = [
            self.getViewController(for: rootScreen)
        ]
    }
    
    private func getViewController(for screen: Screen) -> UIViewController {
        switch screen {
        case .places:
            let viewModel = container.resolve(PlacesViewModelProtocol.self)!
            return container.resolve(PlacesViewController.self,
                                     arguments: viewModel,
                                     self as RouterProtocol)!
        case let .place(identifier, name):
            let viewModel = container.resolve(PlaceDetailsViewModelProtocol.self,
                                              arguments: identifier, name)!
            return container.resolve(PlaceDetailsViewController.self,
                                     arguments: viewModel,
                                     self as RouterProtocol)!
        }
    }
}

// MARK: RouterProtocol
extension Router: RouterProtocol {
    var rootViewController: UIViewController? {
        return navigationController
    }
    
    func push(screen: Screen, animated: Bool) {
        let vc = getViewController(for: screen)
        navigationController.pushViewController(vc, animated: animated)
    }
    
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}
