//
//  ClockView.swift
//  GPSTracker
//
//  Created by Jakub Kuciński on 22/05/2024.
//

import SwiftUI

struct ClockView: View {
    @State private var currentTime = Date()

    var body: some View {
        Text(currentTimeString)
            .font(.largeTitle)
            .onAppear(perform: {
                let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    self.currentTime = Date()
                }
                timer.fire()
            })
    }

    var currentTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: currentTime)
    }
}
