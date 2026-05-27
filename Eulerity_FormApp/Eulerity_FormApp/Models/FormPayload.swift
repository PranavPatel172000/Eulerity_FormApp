//
//  FormPayload.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation

struct FormPayload: Codable {
    let theme: FormTheme
    let formTitle: String
    let fields: [FormField]
    
    enum CodingKeys: String, CodingKey {
        case theme
        case formTitle = "form_title"
        case fields
    }
}
