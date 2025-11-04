//
//  ProximityMonitor.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import SwiftUI

@Observable
final class ProximityMonitor {
    var isClose: Bool = false

    func start() {
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            forName: UIDevice.proximityStateDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.isClose = UIDevice.current.proximityState
        }
        isClose = UIDevice.current.proximityState
    }

    func stop() {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self)
        isClose = false
    }
}
