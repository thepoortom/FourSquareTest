//
//  UserLocationService.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import CoreLocation
import RxSwift

protocol LocationManager {
    var delegate: CLLocationManagerDelegate? { get set }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager: LocationManager { }

protocol UserLocationDatasource {
    func getUserLocation() -> Observable<CLLocation>
}

class UserLocationService: NSObject {
    fileprivate var locationManager: LocationManager
    fileprivate let locationSubject = PublishSubject<CLLocation>()
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
    }
}

// MARK: Authorization
extension UserLocationService {
    func handleLocationAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            break
        }
    }
}

// MARK: - UserLocationDatasource
extension UserLocationService: UserLocationDatasource {
    func getUserLocation() -> Observable<CLLocation> {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        return locationSubject
    }
}

// MARK: - CLLocationManagerDelegate
extension UserLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationSubject.onNext(location)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        locationSubject.onError(error)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status)
    }
}
