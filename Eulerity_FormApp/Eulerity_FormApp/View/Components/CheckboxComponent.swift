//
//  CheckboxComponent.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import SwiftUI

struct CheckboxComponent: View {
    let field: FormField
    @EnvironmentObject var vm: FormViewModel
    
    private var isChecked: Binding<Bool> {
        Binding(
            get: {
                vm.boolValues[field.id] ?? false
            },
            set: {
                vm.boolValues[field.id] = $0
                vm.fieldErrors[field.id] = nil
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 12) {
                
                Button(action: {
                    isChecked.wrappedValue.toggle()
                }) {
                    Image(systemName: isChecked.wrappedValue ? "checkmark.square.fill" : "square") .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(
                            isChecked.wrappedValue
                            ? .blue
                            : (vm.fieldErrors[field.id] != nil
                               ? (vm.theme?.errorSwiftUIColor ?? .red)
                               : (vm.theme?.borderSwiftUIColor ?? .gray))
                        )
                }
                .buttonStyle(.plain)
                
                attributedLabel
                    .font(.subheadline)
                    .foregroundColor(vm.theme?.textSwiftUIColor ?? .primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            if let error = vm.fieldErrors[field.id] {
                Text(error)
                    .font(.caption)
                    .foregroundColor(vm.theme?.errorSwiftUIColor ?? .red)
                    .padding(.leading, 34)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    private var attributedLabel: Text {
        guard let metadata = field.metadata, !metadata.isEmpty else {
            return Text(field.label)
        }
        
        var attributed = AttributedString(field.label)
        let linkColor = Color(hex: field.clickableTextColor ?? "") ?? .blue
        
        for (phrase, urlString) in metadata {
            guard let url = URL(string: urlString),
                  let range = attributed.range(of: phrase) else {
                continue
            }
            attributed[range].link = url
            attributed[range].foregroundColor = linkColor
            attributed[range].underlineStyle = .single
        }
        return Text(attributed)
    }
}

#Preview("Unchecked") {
    let field = FormField(
        id: "accept_legal",
        order: 10,
        type: .checkbox,
        label: "I have read and agree to the Terms of Service and Privacy Policy.",
        required: true,
        errorMessage: "You must accept the legal terms.",
        defaultValue: nil,
        subtype: nil,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: [
            "Terms of Service": "https://example.com/terms",
            "Privacy Policy": "https://example.com/privacy"
        ],
        clickableTextColor: "#BB86FC"
    )
    CheckboxComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("Checked") {
    let field = FormField(
        id: "accept_legal",
        order: 10,
        type: .checkbox,
        label: "I have read and agree to the Terms of Service and Privacy Policy.",
        required: true,
        errorMessage: "You must accept the legal terms.",
        defaultValue: nil,
        subtype: nil,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: [
            "Terms of Service": "https://example.com/terms",
            "Privacy Policy": "https://example.com/privacy"
        ],
        clickableTextColor: "#BB86FC"
    )
    let vm = FormViewModel()
    vm.boolValues["accept_legal"] = true
    return CheckboxComponent(field: field)
        .environmentObject(vm)
        .padding()
}

#Preview("With Error State") {
    let field = FormField(
        id: "accept_legal",
        order: 10,
        type: .checkbox,
        label: "I have read and agree to the Terms of Service and Privacy Policy.",
        required: true,
        errorMessage: "You must accept the legal terms.",
        defaultValue: nil,
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
    vm.fieldErrors["accept_legal"] = "You must accept the legal terms."
    return CheckboxComponent(field: field)
        .environmentObject(vm)
        .padding()
}




