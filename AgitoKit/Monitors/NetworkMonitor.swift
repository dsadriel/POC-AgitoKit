//
//  NetworkMonitor.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import Foundation
import Network

@Observable
class NetworkMonitor {
    var isConnected = false
    var connectionType = "N/A"

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                // Update connection status
                self?.isConnected = path.status == .satisfied

                // Determine connection type
                if path.usesInterfaceType(.wifi) {
                    self?.connectionType = "Wi-Fi"
                } else if path.usesInterfaceType(.cellular) {
                    self?.connectionType = "Cellular"
                } else if path.usesInterfaceType(.wiredEthernet) {
                    self?.connectionType = "Ethernet"
                } else if path.usesInterfaceType(.loopback) {
                    self?.connectionType = "Loopback"
                } else {
                    self?.connectionType = "None"
                }
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
