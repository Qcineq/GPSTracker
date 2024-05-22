//
//  ContentView.swift
//  GPSTracker
//
//  Created by Jakub Kuciński on 20/05/2024.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            ClockView()
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
                .frame(maxWidth: .infinity)

            if locationManager.isGPSWeak {
                Text("Słaby sygnał GPS")
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()

            VStack {
                Text("Trip 1")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text(formattedDistance(locationManager.trip1Distance))
                    .font(.system(size: 72))
                    .foregroundColor(.white)
                    .onTapGesture {
                        locationManager.resetTrip1()
                    }
                Divider().background(Color.white)
                Text("Trip 2")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text(formattedDistance(locationManager.trip2Distance))
                    .font(.system(size: 72))
                    .foregroundColor(.white)
                    .onLongPressGesture {
                        locationManager.resetTrip2()
                    }
                Divider().background(Color.white)
                Text("Prędkość")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text(formattedSpeed(locationManager.speed))
                    .font(.system(size: 48))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.black)
            .cornerRadius(10)
            .padding()

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    func formattedDistance(_ distance: Double) -> String {
        let distanceInKilometers = distance / 1000
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1

        if let formattedString = numberFormatter.string(from: NSNumber(value: distanceInKilometers)) {
            return "\(formattedString) KM"
        } else {
            return "0.00 KM"
        }
    }

    func formattedSpeed(_ speed: CLLocationSpeed) -> String {
        let speedInKilometersPerHour = speed * 3.6 // m/s to k/h
        let roundedSpeed = Int(speedInKilometersPerHour.rounded())

        return "\(roundedSpeed) KM/H"
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
