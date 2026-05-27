//
//  FormFieldView.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import SwiftUI

struct FormFieldView: View {
    let field: FormField
    @EnvironmentObject var vm: FormViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            switch field.type {
            case .text:
                TextFieldComponent(field: field)
                    .environmentObject(vm)
            case .dropdown:
                DropdownComponent(field: field)
                    .environmentObject(vm)
            case .toggle:
                ToggleComponent(field: field)
                    .environmentObject(vm)
            case .checkbox:
                CheckboxComponent(field: field)
                    .environmentObject(vm)
            case .unknown:
                EmptyView()
            }
        }
    }
}

#Preview("Text - Plain") {
    let field = FormField(
        id: "campaign_name",
        order: 1,
        type: .text,
        label: "Campaign Name",
        required: true,
        errorMessage: "Name is required.",
        defaultValue: .string("Summer Sale"),
        subtype: .plain,
        placeholder: nil,
        supportingText: nil,
        maxLength: 20,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    let vm = FormViewModel()
    return FormFieldView(field: field)
        .environmentObject(vm)
        .padding()
}

#Preview("Dropdown") {
    let field = FormField(
        id: "ad_networks",
        order: 4,
        type: .dropdown,
        label: "Ad Networks",
        required: true,
        errorMessage: "Select at least one.",
        defaultValue: nil,
        subtype: nil,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: [
            DropdownOption(id: "net_google", label: "Google Search"),
            DropdownOption(id: "net_meta", label: "Meta Platforms"),
            DropdownOption(id: "net_tiktok", label: "TikTok")
        ],
        allowMultiple: true,
        metadata: nil,
        clickableTextColor: nil
    )
    let vm = FormViewModel()
    return FormFieldView(field: field)
        .environmentObject(vm)
        .padding()
}
