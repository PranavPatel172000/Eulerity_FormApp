//
//  ToggleComponent.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import SwiftUI

struct ToggleComponent: View {
    let field: FormField
    @EnvironmentObject var vm: FormViewModel
    
    private var isOn: Binding<Bool> {
        Binding(
            get: { vm.boolValues[field.id] ?? false },
            set: { vm.boolValues[field.id] = $0 }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Toggle(isOn: isOn) {
                HStack(spacing: 2) {
                    Text(field.label)
                        .font(.subheadline)
                        .foregroundColor(vm.theme?.textSwiftUIColor ?? .primary)
                    if field.required {
                        Text("*").foregroundColor(vm.theme?.errorSwiftUIColor ?? .red)
                    }
                }
            }
            .tint(Color(hex: vm.theme?.borderColor ?? "#007AFF") ?? .blue)
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }
    }
}

#Preview("Default OFF") {
    let field = FormField(
        id: "enable_ai_opt",
        order: 8,
        type: .toggle,
        label: "Enable AI Bidding Optimization",
        required: false,
        errorMessage: nil,
        defaultValue: .bool(false),
        subtype: nil,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    ToggleComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("Default ON") {
    let field = FormField(
        id: "enable_ai_opt",
        order: 8,
        type: .toggle,
        label: "Enable AI Bidding Optimization",
        required: false,
        errorMessage: nil,
        defaultValue: .bool(true),
        subtype: nil,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    let vm = FormViewModel()
    vm.boolValues["enable_ai_opt"] = true
    return ToggleComponent(field: field)
        .environmentObject(vm)
        .padding()
}
