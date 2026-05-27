//
//  FormLoaderError.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation

enum FormLoaderError: LocalizedError {
    case fileNotFound(String)
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "Could not find '\(name)' in the app bundle."
        case .decodingFailed(let error):
            return "Failed to decode form config: \(error.localizedDescription)"
        }
    }
}

struct FormLoader {
    static func load(filename: String = "form_config") throws -> FormPayload {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw FormLoaderError.fileNotFound("\(filename).json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(FormPayload.self, from: data)
        } catch {
            throw FormLoaderError.decodingFailed(error)
        }
    }
}
