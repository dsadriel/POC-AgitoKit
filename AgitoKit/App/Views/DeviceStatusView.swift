//
//  DeviceStatusView.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import SwiftUI

struct DeviceStatusView: View {
    @State private var batteryMonitor = BatteryMonitor()
    @State private var networkMonitor = NetworkMonitor()
    @State private var brightnessMonitor = BrightnessMonitor()
    @State private var volumeMonitor = VolumeMonitor()

    var body: some View {
        NavigationView {
            List {
                // --- Battery Status ---
                Section("Battery Status 🔋") {
                    HStack {
                        Text("Level")
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(Int(batteryMonitor.level * 100))%")
                            Text("Rounded every 5%")
                                .font(.caption2)
                        }
                    }
                    HStack {
                        Text("State")
                        Spacer()
                        Text(batteryMonitor.batteryStateString())
                            .foregroundColor(
                                batteryMonitor.state == .charging || batteryMonitor.state == .full ? .green : .primary
                            )
                    }
                }

                // --- Network Status ---
                Section("Network Status 🌐") {
                    HStack {
                        Text("Connection")
                        Spacer()
                        Text(networkMonitor.isConnected ? "Connected" : "Not Connected")
                            .foregroundColor(networkMonitor.isConnected ? .green : .red)
                    }
                    HStack {
                        Text("Type")
                        Spacer()
                        Text(networkMonitor.connectionType)
                    }
                }

                // --- Display Status ---
                Section("Display Status 💡") {
                    VStack(alignment: .leading) {
                        Text("Brightness: \(Int(brightnessMonitor.brightness * 100))%")
                        // A slider for *your app's* current brightness
                        Slider(value: $brightnessMonitor.brightness, in: 0...1) {
                            Text("Brightness")
                        }
                        // IMPORTANT: Set the system brightness when the slider changes
                        .onChange(of: brightnessMonitor.brightness) {
                            UIScreen.main.brightness = brightnessMonitor.brightness
                        }
                    }
                }

                Section("Audio Status 🔊") {
                    HStack {
                        Text("Current Volume")
                        Spacer()
                        // Volume is reported as a Float from 0.0 to 1.0
                        Text("\(Int(volumeMonitor.currentVolume * 100))%")
                    }
                }
            }
            .navigationTitle("Device Monitors")
        }
    }
}
