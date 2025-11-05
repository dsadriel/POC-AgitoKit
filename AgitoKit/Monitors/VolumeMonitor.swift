//
//  VolumeMonitor.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import Foundation
import AVFoundation // Required for AVAudioSession

@Observable
final class VolumeMonitor {
    var currentVolume: Float = 0.0
    private var volumeObservation: NSKeyValueObservation?

    init() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            // 1. Activate the audio session. It's often best practice to set a category.
            // .playback allows your app to play audio, and .mixWithOthers ensures
            // other app audio isn't silenced.
            try audioSession.setCategory(.playback, options: .mixWithOthers)
            try audioSession.setActive(true)

            // 2. Get the initial volume level
            self.currentVolume = audioSession.outputVolume

            // 3. Start observing the 'outputVolume' property using KVO
            volumeObservation = audioSession.observe(\.outputVolume, options: [.new]) { [weak self] session, _ in
                // KVO callback happens on an arbitrary thread, so dispatch to main
                DispatchQueue.main.async {
                    self?.currentVolume = session.outputVolume
                }
            }
        } catch {
            print("Failed to initialize AVAudioSession for volume monitoring: \(error.localizedDescription)")
        }
    }

    deinit {
        // Stop observation to avoid memory leaks
        volumeObservation?.invalidate()

        // Optionally deactivate the session when the monitor is destroyed
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
