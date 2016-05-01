//
//  LocationController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 5/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = LocationController()

    private let locationManager = CLLocationManager()
    private var queue = Array<(coordinate: Coordinate) -> ()>()

    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestUserLocationAndExecute(block callback: (coordinate: Coordinate) -> ()) {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .Restricted, .Denied:
            self.wipeQueue()
            print("locations not enabled")
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        self.queue.append(callback)
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let coordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.locationManager.stopUpdatingLocation()

        while self.queue.count != 0 {
            self.queue.popLast()!(coordinate: coordinate)
        }
    }

    func wipeQueue() {
        self.queue = []
    }
}
