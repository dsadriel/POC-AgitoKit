//
//  DeviceStatusView.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import SwiftUI
import MediaPlayer

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
                        Text("\(Int(batteryMonitor.level * 100))%")
                    }
                    HStack {
                        Text("State")
                        Spacer()
                        Text(batteryMonitor.batteryStateString())
                            .foregroundColor(batteryMonitor.state == .charging || batteryMonitor.state == .full ? .green : .primary)
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

                                    // The standard, user-facing way to adjust volume
                                    VStack(alignment: .leading) {
                                        Text("System Volume Control (User Only)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                        // Bridge the UIKit MPVolumeView to SwiftUI
                                        VolumeControlView()
                                            .frame(height: 30) // Give it a fixed height
                                    }
                                }
            }
            .navigationTitle("Device Monitors")
        }
    }
}

// Helper to wrap MPVolumeView for use in SwiftUI
struct VolumeControlView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        return MPVolumeView(frame: .zero)
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        // No update logic needed
    }
}
