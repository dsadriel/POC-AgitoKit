//
//  TorchController.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//

import AVFoundation


@Observable
final class TorchController {
    var torchOn: Bool = false

    func toggle(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if on {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
            torchOn = on
        } catch {
            print("Torch error:", error.localizedDescription)
        }
    }

    func pulse(duration: TimeInterval = 0.15) {
        toggle(on: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.toggle(on: false)
        }
    }
}
