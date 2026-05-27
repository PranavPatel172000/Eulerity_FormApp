//
//  Color+Hex.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation
import SwiftUICore

extension Color {
    init?(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        
        guard hex.count == 6 else {
            return nil
        }
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hex).scanHexInt64(&rgb) else {
            return nil
        }
        
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double( rgb & 0x0000FF) / 255.0
        )
    }
}
