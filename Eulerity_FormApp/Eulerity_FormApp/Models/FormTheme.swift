//
//  FormTheme.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation
import SwiftUICore

struct FormTheme: Codable {
    let backgroundColor: String
    let textColor: String
    let borderColor: String
    let errorColor: String
    
    enum CodingKeys: String, CodingKey {
        case backgroundColor = "background_color"
        case textColor = "text_color"
        case borderColor = "border_color"
        case errorColor = "error_color"
    }
    
    var backgroundSwiftUIColor: Color { Color(hex: backgroundColor) ?? .white }
    var textSwiftUIColor: Color { Color(hex: textColor) ?? .black }
    var borderSwiftUIColor: Color { Color(hex: borderColor) ?? .gray }
    var errorSwiftUIColor: Color { Color(hex: errorColor) ?? .red }
    
}
