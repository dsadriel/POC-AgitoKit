//
//  MotionMonitor.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import SwiftUI
import CoreMotion

@Observable
final class MotionMonitor {
    private let manager = CMMotionManager()
    var roll: Double = 0
    var pitch: Double = 0
    var yaw: Double = 0
    var tiltMagnitude: Double = 0

    func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1.0/30.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let m = motion, let self = self else { return }
            self.roll = m.attitude.roll
            self.pitch = m.attitude.pitch
            self.yaw = m.attitude.yaw

            // Aggregated "tilt" — simple 2D norm using roll/pitch in degrees
            let r = abs(m.attitude.roll * 180/Double.pi)
            let p = abs(m.attitude.pitch * 180/Double.pi)
            self.tiltMagnitude = sqrt(r*r + p*p)
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}
