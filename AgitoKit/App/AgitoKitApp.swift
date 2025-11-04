//
//  ContentView.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 04/11/25.
//

import SwiftUI

@main
struct AgitoKitApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Sensors", systemImage: "circle") {
                    SensorsView()
                }

                Tab("Device Status", systemImage: "circle") {
                    DeviceStatusView()
                }
            }
        }
    }
}
