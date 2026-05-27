//
//  FormViewModel.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation

import Foundation
import SwiftUI


@MainActor
final class FormViewModel: ObservableObject {
   
     @Published private(set) var payload: FormPayload?
     @Published private(set) var sortedFields: [FormField] = []
     @Published private(set) var loadError: String?
     @Published var textValues: [String: String] = [:]
     @Published var boolValues: [String: Bool] = [:]
     @Published var singleSelectValues: [String: String] = [:]
     @Published var multiSelectValues: [String: Set<String>] = [:]
     @Published var fieldErrors: [String: String] = [:]
     @Published var showSuccessAlert = false
     @Published var showValidationAlert = false
     @Published var successPayload = ""
    
    var theme: FormTheme? {
        payload?.theme
    }
    
    var formTitle: String {
        payload?.formTitle ?? ""
    }
    
    func loadForm(filename: String = "form_config") {
        do {
            let loaded = try FormLoader.load(filename: filename)
            payload = loaded
            sortedFields = loaded.fields
                .filter { $0.type != .unknown }
                .sorted { $0.order < $1.order }
            initializeDefaults()
        } catch {
            loadError = error.localizedDescription
        }
    }
    
    private func initializeDefaults() {
        for field in sortedFields {
            switch field.type {
            case .text:
                var def = field.defaultValue?.stringValue ?? ""
                if let max = field.maxLength, def.count > max {
                    def = String(def.prefix(max))
                }
                textValues[field.id] = def
            case .toggle:
                boolValues[field.id] = field.defaultValue?.boolValue ?? false
            case .checkbox:
                boolValues[field.id] = field.defaultValue?.boolValue ?? false
            case .dropdown:
                if field.allowMultiple {
                    multiSelectValues[field.id] = []
                } else {
                    singleSelectValues[field.id] = ""
                }
            case .unknown:
                break
            }
        }
    }
    
    func validate() -> Bool {
        var errors: [String: String] = [:]
        
        for field in sortedFields {
            guard field.required else {
                continue
            }
            
            let msg = field.errorMessage ?? "This field is required."
            switch field.type {
            case .text:
                let value = textValues[field.id] ?? ""
                if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    errors[field.id] = msg
                } else if let pattern = field.regex, !matchesRegex(value, pattern: pattern) {
                    errors[field.id] = msg
                }
            case .checkbox:
                if !(boolValues[field.id] ?? false) {
                    errors[field.id] = msg
                }
            case .dropdown:
                
                guard let opts = field.options, !opts.isEmpty else {
                    errors[field.id] = nil
                    break
                }
                
                if field.allowMultiple {
                    if (multiSelectValues[field.id] ?? []).isEmpty {
                        errors[field.id] = msg
                    }
                } else {
                    if (singleSelectValues[field.id] ?? "").isEmpty {
                        errors[field.id] = msg
                    }
                }
            case .toggle, .unknown:
                break
            }
        }
        fieldErrors = errors
        return errors.isEmpty
    }
    
    func save() {
        if validate() {
            successPayload = buildPayloadJSON()
            showSuccessAlert = true
            print(" Submission:\n\(successPayload)")
        } else {
            showValidationAlert = true
        }
    }
    
    private func buildPayloadJSON() -> String {
        var dict: [String: Any] = [:]
        for field in sortedFields {
            switch field.type {
            case .text:
                dict[field.id] = textValues[field.id] ?? ""
            case .toggle, .checkbox:
                dict[field.id] = boolValues[field.id] ?? false
            case .dropdown:
                if field.allowMultiple {
                    dict[field.id] = Array(multiSelectValues[field.id] ?? []).sorted()
                } else {
                    dict[field.id] = singleSelectValues[field.id] ?? ""
                }
            case .unknown:
                break
            }
        }
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
              let str = String(data: data, encoding: .utf8) else { return "{}" }
        return str
    }
    
    private func matchesRegex(_ value: String, pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return true }
        let range = NSRange(value.startIndex..., in: value)
        return regex.firstMatch(in: value, range: range) != nil
    }
    
}
