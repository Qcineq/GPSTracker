//
//  LocationManager.swift
//  GPSTracker
//
//  Created by Jakub Kuciński on 20/05/2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var trip1Distance: Double = 0.0
    @Published var trip2Distance: Double = 0.0
    @Published var speed: CLLocationSpeed = 0.0 // Speed in m/s
    @Published var isGPSWeak: Bool = true // Weak GPS Signal
    private var lastLocation: CLLocation?
    private var isStable: Bool = false // Stable GPS Signal

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        // Update GPS Signal status
        isGPSWeak = newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 20

        if isGPSWeak {
            // Handle GPS signal weakness
            if lastLocation == nil {
                lastLocation = newLocation
                return
            }
        } else {
            // GPS Signal is strong, proceed with location updates

            if !isStable {
                // GPS Stabilization
                if lastLocation == nil {
                    lastLocation = newLocation
                    return
                }

                let initialDistance = newLocation.distance(from: lastLocation!)
                if initialDistance > 10 {
                    // Too big initial distance - ignore
                    return
                }

                if initialDistance < 5 {
                    isStable = true
                }

                lastLocation = newLocation
                return
            }

            // Location update
            if let lastLocation = lastLocation, newLocation.speed >= 1 {
                let delta = newLocation.distance(from: lastLocation)
                trip1Distance += delta
                trip2Distance += delta
            }

            lastLocation = newLocation
            speed = newLocation.speed > 0 ? newLocation.speed : 0 // Set speed to 0 if shows negative
        }
    }

    func resetTrip1() {
        trip1Distance = 0.0
    }

    func resetTrip2() {
        trip2Distance = 0.0
    }
}
