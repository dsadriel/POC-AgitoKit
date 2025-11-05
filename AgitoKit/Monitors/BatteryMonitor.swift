//
//  BatteryMonitor.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import Foundation
import UIKit // Required for UIDevice

@Observable
final class BatteryMonitor {
    var level: Float = -1.0
    var state: UIDevice.BatteryState = .unknown

    init() {
        // 1. Enable battery monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true

        // 2. Initial read
        self.level = UIDevice.current.batteryLevel
        self.state = UIDevice.current.batteryState

        // 3. Set up listeners (Notifications)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }

    @objc private func batteryLevelDidChange() {
        self.level = UIDevice.current.batteryLevel
    }

    @objc private func batteryStateDidChange() {
        self.state = UIDevice.current.batteryState
    }

    // A function to get a readable string for the state
    func batteryStateString() -> String {
        switch state {
        case .full: return "Full"
        case .charging: return "Charging"
        case .unplugged: return "Unplugged"
        case .unknown: return "Unknown"
        @unknown default: return "Unknown"
        }
    }

    deinit {
        // Clean up observers
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
}
