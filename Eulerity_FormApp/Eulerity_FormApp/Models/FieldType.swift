//
//  FieldType.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation

enum FieldType: String, Codable {
    case text = "TEXT"
    case dropdown = "DROPDOWN"
    case toggle = "TOGGLE"
    case checkbox = "CHECKBOX"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = FieldType(rawValue: raw) ?? .unknown
    }
}
