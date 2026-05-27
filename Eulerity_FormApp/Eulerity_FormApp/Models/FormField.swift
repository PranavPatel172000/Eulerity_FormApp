//
//  FormField.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import Foundation

struct FormField: Identifiable, Codable {
    let id: String
    let order: Int
    let type: FieldType
    let label: String
    let required: Bool
    let errorMessage: String?
    let defaultValue: AnyCodableValue?
    
    // TEXT specific
    let subtype: TextSubtype?
    let placeholder: String?
    let supportingText: String?
    let maxLength: Int?
    let regex: String?
    
    // DROPDOWN specific
    let options: [DropdownOption]?
    let allowMultiple: Bool
    
    // CHECKBOX specific
    let metadata: [String: String]?
    let clickableTextColor: String?
    
    enum CodingKeys: String, CodingKey {
        case id, order, label, required
        case type = "type"
        case errorMessage = "error_message"
        case defaultValue = "default_value"
        case subtype, placeholder
        case supportingText = "supporting_text"
        case maxLength = "max_length"
        case regex
        case options
        case allowMultiple = "allow_multiple"
        case metadata
        case clickableTextColor = "clickable_text_color"
    }
    
    init(id: String,
         order: Int,
         type: FieldType,
         label: String,
         required: Bool,
         errorMessage: String?,
         defaultValue: AnyCodableValue?,
         subtype: TextSubtype?,
         placeholder: String?,
         supportingText: String?,
         maxLength: Int?,
         regex: String?,
         options: [DropdownOption]?,
         allowMultiple: Bool,
         metadata: [String: String]?,
         clickableTextColor: String?
    ) {
        self.id = id
        self.order = order
        self.type = type
        self.label = label
        self.required = required
        self.errorMessage = errorMessage
        self.defaultValue = defaultValue
        self.subtype = subtype
        self.placeholder = placeholder
        self.supportingText = supportingText
        self.maxLength = maxLength
        self.regex = regex
        self.options = options
        self.allowMultiple = allowMultiple
        self.metadata = metadata
        self.clickableTextColor = clickableTextColor
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        order = try c.decode(Int.self, forKey: .order)
        type = try c.decode(FieldType.self, forKey: .type)
        label = try c.decode(String.self, forKey: .label)
        required = try c.decodeIfPresent(Bool.self, forKey: .required) ?? false
        errorMessage = try c.decodeIfPresent(String.self, forKey: .errorMessage)
        defaultValue = try c.decodeIfPresent(AnyCodableValue.self, forKey: .defaultValue)
        subtype = try c.decodeIfPresent(TextSubtype.self, forKey: .subtype)
        placeholder = try c.decodeIfPresent(String.self, forKey: .placeholder)
        supportingText = try c.decodeIfPresent(String.self, forKey: .supportingText)
        maxLength = try c.decodeIfPresent(Int.self, forKey: .maxLength)
        regex = try c.decodeIfPresent(String.self, forKey: .regex)
        options = try c.decodeIfPresent([DropdownOption].self, forKey: .options)
        allowMultiple = try c.decodeIfPresent(Bool.self, forKey: .allowMultiple) ?? false
        metadata = try c.decodeIfPresent([String: String].self, forKey: .metadata)
        clickableTextColor = try c.decodeIfPresent(String.self, forKey: .clickableTextColor)
    }
}
