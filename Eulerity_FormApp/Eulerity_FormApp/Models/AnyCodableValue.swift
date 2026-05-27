//
//  AnyCodableValue.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation

enum AnyCodableValue: Codable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let b = try? container.decode(Bool.self) { self = .bool(b); return }
        if let i = try? container.decode(Int.self) { self = .int(i); return }
        if let d = try? container.decode(Double.self) { self = .double(d); return }
        if let s = try? container.decode(String.self) { self = .string(s); return }
        self = .string("")
    }
    
    var stringValue: String {
        switch self {
        case .string(let s): return s
        case .bool(let b): return b ? "true" : "false"
        case .int(let i): return "\(i)"
        case .double(let d): return "\(d)"
        }
    }
    
    var boolValue: Bool? {
        if case .bool(let b) = self { return b }
        return nil
    }
}
