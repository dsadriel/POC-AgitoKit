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
                Section("Sensors 🔎") {
                    HStack {
                        Text("Tilt magnitude")
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(String(format: "%.1f°", motion.tiltMagnitude))
                            Text("Combined roll/pitch")
                                .font(.caption2)
                        }
                    }

                    HStack {
                        Text("Roll")
                        Spacer()
                        Text(String(format: "%.1f°", motion.roll * 180 / Double.pi))
                    }

                    HStack {
                        Text("Pitch")
                        Spacer()
                        Text(String(format: "%.1f°", motion.pitch * 180 / Double.pi))
                    }

                    HStack {
                        Text("Yaw")
                        Spacer()
                        Text(String(format: "%.1f°", motion.yaw * 180 / Double.pi))
                    }

                    HStack {
                        Text("Proximity")
                        Spacer()
                        Text(proximity.isClose ? "Near" : "Far")
                            .foregroundColor(proximity.isClose ? .green : .red)
                    }

                    HStack {
                        Text("Noise (mic)")
                        Spacer()
                        Text(String(format: "%.0f%%", audio.level * 100))
                    }
                }
                .navigationTitle("Sensors")

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { toggleSensors() }) {
                        Text(isRunning ? "Stop" : "Start")
                    }
                    .tint(isRunning ? .red : .green)
                }
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
