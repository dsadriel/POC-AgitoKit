//
//  SensorsView.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import SwiftUI

struct SensorsView: View {
    @State private var motion = MotionMonitor()
    @State private var proximity = ProximityMonitor()
    @State private var audio = AudioLevelMonitor()

    @State var isRunning = false
    @State var isSheetPresented = false

    var body: some View {
        NavigationView {
            List {
                Section("Sensors") {
                    sensorRow(label: "Tilt magnitude", value: String(format: "%.1f°", motion.tiltMagnitude))
                    sensorRow(label: "Roll", value: String(format: "%.1f°", motion.roll * 180 / Double.pi))
                    sensorRow(label: "Pitch", value: String(format: "%.1f°", motion.pitch * 180 / Double.pi))
                    sensorRow(label: "Yaw (rotation)", value: String(format: "%.1f°", motion.yaw * 180 / Double.pi))
                    sensorRow(label: "Proximity", value: proximity.isClose ? "Near" : "Far")
                    sensorRow(label: "Noise (mic)", value: String(format: "%.0f%%", audio.level * 100))
                }

                Section {
                    Group {
                        Button(isRunning ? "Stop sensors" : "Start sensors") {
                            toggleSensors()
                        }
                    }
                    .tint(isRunning ? .red : .green)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .buttonStyle(.bordered)
                }
                .listRowBackground(Color.clear)

            }
        }
    }
}

extension SensorsView {
    private func sensorRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .bold()
            Spacer()
            Text(value)
        }
        .padding(.horizontal, 12)
    }

    private func toggleSensors() {
        isRunning.toggle()
        if isRunning {
            motion.start()
            audio.start()
            proximity.start()
        } else {
            motion.stop()
            proximity.stop()
            audio.stop()
        }
    }
}

#Preview {
    SensorsView()
}
