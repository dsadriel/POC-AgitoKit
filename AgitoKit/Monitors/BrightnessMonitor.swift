//
//  BrightnessMonitor.swift
//  AgitoKit
//
//  Created by Adriel de Souza on 05/11/25.
//


import Foundation
import UIKit

@Observable
final class BrightnessMonitor {
    var brightness: CGFloat = 0.0

    init() {
        self.brightness = UIScreen.main.brightness
        
        // Listen for system brightness changes
        NotificationCenter.default.addObserver(self, selector: #selector(brightnessDidChange), name: UIScreen.brightnessDidChangeNotification, object: nil)
    }

    @objc private func brightnessDidChange() {
        self.brightness = UIScreen.main.brightness
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
