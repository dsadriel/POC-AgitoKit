//
//  AudioLevelMonitor.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import AVFoundation
import SwiftUI

@Observable
final class AudioLevelMonitor {
    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    var level: Float = 0 // 0..1

    func start() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .default, options: [.mixWithOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            session.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted { self.setupRecorder() }
                }
            }
        } catch {
            print("Audio session error:", error.localizedDescription)
        }
    }

    private func setupRecorder() {
        let url = URL(fileURLWithPath: "/dev/null")
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.record()
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                guard let self, let rec = self.recorder else { return }
                rec.updateMeters()
                // normaliza média (dB) para 0..1
                let avg = rec.averagePower(forChannel: 0) // ~[-160, 0]
                let norm = max(0, min(1, (avg + 50) / 50)) // sensibilidade simples
                self.level = norm
            }
        } catch {
            print("Recorder error:", error.localizedDescription)
        }
    }

    func stop() {
        timer?.invalidate()
        recorder?.stop()
        recorder = nil
        level = 0
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
