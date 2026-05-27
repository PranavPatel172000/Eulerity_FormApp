//
//  TextFieldComponent.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import SwiftUI

struct TextFieldComponent: View {
    let field: FormField
    @EnvironmentObject var vm: FormViewModel
    
    private var text: Binding<String> {
        Binding(
            get: { vm.textValues[field.id] ?? "" },
            set: { newValue in
                if let max = field.maxLength {
                    if newValue.count > max {
                        vm.textValues[field.id] = String(newValue.prefix(max))
                        vm.fieldErrors[field.id] = field.errorMessage ?? "Cannot exceed \(max) characters."
                    } else {
                        vm.textValues[field.id] = newValue
                        vm.fieldErrors[field.id] = nil
                    }
                } else {
                    vm.textValues[field.id] = newValue
                    vm.fieldErrors[field.id] = nil
                }
            }
        )
    }
    
    private var borderColor: Color {
        vm.fieldErrors[field.id] != nil
        ? (vm.theme?.errorSwiftUIColor ?? .red)
        : (vm.theme?.borderSwiftUIColor ?? .gray)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Label
            fieldLabel
            // Input
            inputField
            // Supporting text
            
            HStack(alignment: .top) {
                errorText
                
                Spacer()
                
                if let max = field.maxLength {
                    let current = (vm.textValues[field.id] ?? "").count
                    Text("\(current)/\(max)")
                        .font(.caption2)
                        .foregroundColor(current <= max ? (vm.theme?.errorSwiftUIColor ?? .red): .secondary)
                }
                
            }
            
            if let supporting = field.supportingText {
                Text(supporting)
                    .font(.caption)
                    .foregroundColor(vm.theme?.textSwiftUIColor.opacity(0.6) ?? .secondary)
            }
        }
    }
    
    private var fieldLabel: some View {
        HStack(spacing: 2) {
            Text(field.label)
                .font(.subheadline).bold()
                .foregroundColor(vm.theme?.textSwiftUIColor ?? .primary)
            if field.required {
                Text("*").foregroundColor(vm.theme?.errorSwiftUIColor ?? .red)
            }
        }
    }
   
    @ViewBuilder
    private var inputField: some View {
        let border = borderColor
        let textColor = vm.theme?.textSwiftUIColor ?? .primary
        switch field.subtype ?? .plain {
        case .secure:
            SecureField(field.placeholder ?? "", text: text)
                .keyboardType(.default)
                .padding(12)
                .foregroundColor(textColor)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(border, lineWidth: 1))
        case .multiline:
            TextEditor(text: text)
                .frame(minHeight: 100)
                .padding(8)
                .foregroundColor(textColor)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(border, lineWidth: 1))
        case .number:
            TextField(field.placeholder ?? "", text: text)
                .keyboardType(.decimalPad)
                .padding(12)
                .foregroundColor(textColor)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(border, lineWidth: 1))
        case .uri:
            TextField(field.placeholder ?? "https://", text: text)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(12)
                .foregroundColor(textColor)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(border, lineWidth: 1))
        default: // PLAIN or unknown subtype
            TextField(field.placeholder ?? "", text: text)
                .padding(12)
                .foregroundColor(textColor)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(border, lineWidth: 1))
        }
    }
    
    @ViewBuilder
    private var errorText: some View {
        if let error = vm.fieldErrors[field.id] {
            Text(error)
                .font(.caption)
                .foregroundColor(vm.theme?.errorSwiftUIColor ?? .red)
        }
    }
}

#Preview("PLAIN") {
    let field = FormField(
        id: "campaign_name",
        order: 1,
        type: .text,
        label: "Campaign Name",
        required: true,
        errorMessage: "Name is required.",
        defaultValue: .string("Summer Sale"),
        subtype: .plain,
        placeholder: "Enter name",
        supportingText: nil,
        maxLength: 20,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    TextFieldComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("NUMBER") {
    let field = FormField(
        id: "daily_budget",
        order: 2,
        type: .text,
        label: "Daily Budget ($)",
        required: true,
        errorMessage: "Budget is required.",
        defaultValue: nil,
        subtype: .number,
        placeholder: "0.00",
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    TextFieldComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("URI") {
    let field = FormField(
        id: "destination_url",
        order: 3,
        type: .text,
        label: "Destination URL",
        required: true,
        errorMessage: nil,
        defaultValue: nil,
        subtype: .uri,
        placeholder: "https://",
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    TextFieldComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("SECURE") {
    let field = FormField(
        id: "admin_password",
        order: 9,
        type: .text,
        label: "Admin Password",
        required: true,
        errorMessage: "Password required.",
        defaultValue: nil,
        subtype: .secure,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    TextFieldComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("MULTILINE") {
    let field = FormField(
        id: "description",
        order: 7,
        type: .text,
        label: "Campaign Description",
        required: false,
        errorMessage: nil,
        defaultValue: nil,
        subtype: .multiline,
        placeholder: "Describe your campaign...",
        supportingText: "Be concise and clear.",
        maxLength: nil,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    TextFieldComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("With Error State") {
    let field = FormField(
        id: "campaign_name",
        order: 1,
        type: .text,
        label: "Campaign Name",
        required: true,
        errorMessage: "Name is required.",
        defaultValue: nil,
        subtype: .plain,
        placeholder: "Enter name",
        supportingText: nil,
        maxLength: 20,
        regex: nil,
        options: nil,
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    let vm = FormViewModel()
    vm.fieldErrors["campaign_name"] = "Name is required."
    return TextFieldComponent(field: field)
        .environmentObject(vm)
        .padding()
}
