//
//  TextSubtype.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation

enum TextSubtype: String, Codable {
    case plain = "PLAIN"
    case multiline = "MULTILINE"
    case number = "NUMBER"
    case uri = "URI"
    case secure = "SECURE"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = TextSubtype(rawValue: raw) ?? .unknown
    }
}
