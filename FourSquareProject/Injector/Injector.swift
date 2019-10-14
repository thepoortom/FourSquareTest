//
//  Injector.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import CoreLocation
import Swinject
import UIKit

protocol InjectorProtocol {
    func resolve<Service>(_ serviceType: Service.Type) -> Service?
    func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type,
                                      arguments arg1: Arg1, _ arg2: Arg2) -> Service?
}

class Injector {
    private let container: Container = Container()
    
    init() {
        setup()
    }
    
    private func setup() {
        setupViewModels()
        setupViewControllers()
        setupServices()
        setupRequestManager()
        setupRouter()
    }
    
    private func setupViewModels() {
        container.register(PlacesViewModelProtocol.self) { resolver in
            let neighborPlacesDatasource = resolver.resolve(NeighborPlacesDatasource.self)!
            return PlacesViewModel(neighborPlacesDatasource: neighborPlacesDatasource)
        }
        container.register(PlaceDetailsViewModelProtocol.self) {
            (resolver: Resolver, identifier: String, name: String?) -> PlaceDetailsViewModelProtocol in
            let placeDatasource = resolver.resolve(PlaceDatasource.self)!
            return PlaceDetailsViewModel(identifier: identifier, name: name, placeDatasource: placeDatasource)
        }
    }
    
    private func setupViewControllers() {
        container.register(PlacesViewController.self) { resolver, viewModel, router in
            PlacesViewController(viewModel: viewModel, router: router)
        }
        container.register(PlaceDetailsViewController.self) { resolver, viewModel, router in
            PlaceDetailsViewController(viewModel: viewModel, router: router)
        }
    }

    private func setupServices() {
        container.register(LocationManager.self) { _ in CLLocationManager() }
        container.register(UserLocationDatasource.self) { resolver in
            let locationManager = resolver.resolve(LocationManager.self)!
            return UserLocationService(locationManager: locationManager)
        }
        
        container.register(PlacesDatasource.self) { resolver in
            let requestManager = resolver.resolve(RequestManagerProtocol.self)!
            return PlacesService(requestManager: requestManager)
        }
        container.register(NeighborPlacesDatasource.self) { resolver in
            let userLocationDatasource = resolver.resolve(UserLocationDatasource.self)!
            let placesDatasource = resolver.resolve(PlacesDatasource.self)!
            return NeighborPlacesService(
                userLocationDatasource: userLocationDatasource,
                placesDatasource: placesDatasource
            )
        }
        container.register(PlaceDatasource.self) { resolver in
            let requestManager = resolver.resolve(RequestManagerProtocol.self)!
            return PlaceService(requestManager: requestManager)
        }
    }

    private func setupRequestManager() {
        container.register(RequestManagerProtocol.self) { _ in RequestManager() }
    }
    
    private func setupRouter() {
        container.register(RouterProtocol.self) { [unowned self] resolver, navigationController, rootScreen in
            return Router(navigationController: navigationController, rootScreen: rootScreen, container: self.container)
        }
    }
}

extension Injector: InjectorProtocol {
    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
    
    func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type,
                                      arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
        return container.resolve(serviceType, arguments: arg1, arg2)
    }
}
