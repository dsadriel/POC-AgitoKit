//
//  HapticsManager.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import SwiftUI
import CoreHaptics

@Observable
final class HapticsManager {
    var engine: CHHapticEngine?

    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()

            engine?.resetHandler = { [weak self] in
                do {
                    try self?.engine?.start()
                } catch {
                    print("Haptics reset failed: \(error)")
                }
            }

            try engine?.start()
        } catch {
            print("Haptics init failed: \(error)")
        }
    }

    func tap() {
        // Fallback rápido se não houver haptics avançado
        if engine == nil {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

            print("no engine")

            return
        }
        do {
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0)
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)

            try player?.start(atTime: 0)

        } catch {
            print("fallback")
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }

    func successBurst() {
        if engine == nil {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            return
        }
        do {
            var events: [CHHapticEvent] = []
            let times: [TimeInterval] = [0.0, 0.08, 0.18]
            for t in times {
                let ev = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
                    ],
                    relativeTime: t
                )
                events.append(ev)
            }
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}
