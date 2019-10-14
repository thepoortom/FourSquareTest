//
//  PlacesViewController.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import MapKit
import RxCocoa
import RxSwift
import UIKit

class PlacesViewController: UIViewController {
    private let viewModel: PlacesViewModelProtocol
    private let router: RouterProtocol
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        view.showsUserLocation = true
        return view
    }()
    
    private var userLocationInitialized = false
    
    var annotations: Binder<[Place]> {
        return Binder(self) { vc, places in
            vc.mapView.removeAnnotations(vc.mapView.annotations)
            let annotations = places.map { place -> PlaceAnnotation in
                let coordinate = CLLocationCoordinate2D(
                    latitude: place.location.latitude,
                    longitude: place.location.longitude
                )
                return PlaceAnnotation(
                    title: place.name,
                    subtitle: place.subtitle,
                    identifier: place.identifier,
                    coordinate: coordinate
                )
            }
            vc.mapView.addAnnotations(annotations)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: PlacesViewModelProtocol,
         router: RouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setConstraints()
        setupBindings()
    }
}

// MARK: - Bindings
extension PlacesViewController {
    private func setupBindings() {
        viewModel.title
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        viewModel.places
            .drive(annotations)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension PlacesViewController {
    private func setupUI() {
        view.addSubview(mapView)
        mapView.delegate = self
        
        let buttonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = buttonItem
    }
}

// MARK: - Layout
extension PlacesViewController {
    private func setConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        if let superview = mapView.superview {
            mapView.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            mapView.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            mapView.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            mapView.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
}

// MARK: - MKMapViewDelegate
extension PlacesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? PlaceAnnotation {
            let identifier = "placePin"
            let view: MKPinAnnotationView = {
                guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                    as? MKPinAnnotationView else {
                        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                        view.canShowCallout = true
                        view.calloutOffset = CGPoint(x: -5, y: 5)
                        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                        return view
                }
                view.annotation = annotation
                return view
            }()
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PlaceAnnotation else { return }
        router.push(screen: .place(identifier: annotation.identifier, name: annotation.title),
                    animated: true)
    }
    
    func mapView(_ mapView: MKMapView,
                 didUpdate userLocation: MKUserLocation) {
        defer { userLocationInitialized = true }
        if !userLocationInitialized {
            center(to: userLocation.coordinate, regionRadius: Configuration.regionRadius)
            viewModel.getNeighborPlaces()
        }
    }
    
    func mapView(_ mapView: MKMapView,
                 regionDidChangeAnimated animated: Bool) {
        guard userLocationInitialized else { return }
        let coordinate = mapView.centerCoordinate
        viewModel.getNeighborPlaces(latitude: coordinate.latitude,
                                    longitude: coordinate.longitude)
    }
}

// MARK: - Map
extension PlacesViewController {
    private func center(to coordinate: CLLocationCoordinate2D,
                        regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
