//
//  DropdownComponent.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import SwiftUI

struct DropdownComponent: View {
    let field: FormField
    @EnvironmentObject var vm: FormViewModel
    @State private var showMultiSheet = false
    private var options: [DropdownOption] { field.options ?? [] }
    
    private var borderColor: Color {
        vm.fieldErrors[field.id] != nil
        ? (vm.theme?.errorSwiftUIColor ?? .red)
        : (vm.theme?.borderSwiftUIColor ?? .gray)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Label
            HStack(spacing: 2) {
                Text(field.label)
                    .font(.subheadline).bold()
                    .foregroundColor(vm.theme?.textSwiftUIColor ?? .primary)
                if field.required {
                    Text("*").foregroundColor(vm.theme?.errorSwiftUIColor ?? .red)
                }
            }
            if options.isEmpty {
                emptyOptionsView
            } else if field.allowMultiple {
                multiSelectView
            } else {
                singleSelectView
            }
            // Error
            if let error = vm.fieldErrors[field.id] {
                Text(error)
                    .font(.caption)
                    .foregroundColor(vm.theme?.errorSwiftUIColor ?? .red)
            }
        }
    }
    
    private var singleSelectView: some View {
        let binding = Binding<String>(
            get: { vm.singleSelectValues[field.id] ?? "" },
            set: {
                vm.singleSelectValues[field.id] = $0
                vm.fieldErrors[field.id] = nil
            }
        )
        
        
        return Menu {
            ForEach(options) { option in
                Button(option.label) {
                    binding.wrappedValue = option.id
                }
            }
        } label: {
            HStack {
                Text(
                    options.first(where: { $0.id == binding.wrappedValue })?.label
                    ?? "Select an option"
                )
                .foregroundColor(
                    binding.wrappedValue.isEmpty
                    ? .secondary
                    : (vm.theme?.textSwiftUIColor ?? .primary)
                )
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 1))
        }
    }
    
    private var multiSelectView: some View {
        let selected = vm.multiSelectValues[field.id] ?? []
        let label = selected.isEmpty
        ? "Select options"
        : options.filter { selected.contains($0.id) }.map(\.label).joined(separator: ", ")
        
        return Button(action: { showMultiSheet = true }) {
            HStack {
                Text(label)
                    .foregroundColor(selected.isEmpty ? .secondary : (vm.theme?.textSwiftUIColor ?? .primary))
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 1))
        }
        .sheet(isPresented: $showMultiSheet) {
            MultiSelectSheet(
                title: field.label,
                options: options,
                selected: Binding(
                    get: { vm.multiSelectValues[field.id] ?? [] },
                    set: {
                        vm.multiSelectValues[field.id] = $0
                        vm.fieldErrors[field.id] = nil
                    }
                )
            )
        }
    }
   
    private var emptyOptionsView: some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
                .foregroundColor(.orange)
            Text("No options available")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 1))
    }
}


struct MultiSelectSheet: View {
    let title: String
    let options: [DropdownOption]
    @Binding var selected: Set<String>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(options) { option in
                Button(action: { toggle(option.id) }) {
                    HStack {
                        Text(option.label)
                            .foregroundColor(.primary)
                        Spacer()
                        if selected.contains(option.id) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func toggle(_ id: String) {
        if selected.contains(id) {
            selected.remove(id)
        } else {
            selected.insert(id)
        }
    }
}

#Preview("Single Select") {
    let field = FormField(
        id: "billing_account",
        order: 5,
        type: .dropdown,
        label: "Billing Account",
        required: true,
        errorMessage: "Please select an account.",
        defaultValue: nil,
        subtype: nil,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: [
            DropdownOption(id: "acc_1", label: "Account A"),
            DropdownOption(id: "acc_2", label: "Account B")
        ],
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    DropdownComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("Multi Select") {
    let field = FormField(
        id: "ad_networks",
        order: 4,
        type: .dropdown,
        label: "Ad Networks",
        required: true,
        errorMessage: "Select at least one network.",
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
    DropdownComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("Empty Options") {
    let field = FormField(
        id: "billing_account",
        order: 5,
        type: .dropdown,
        label: "Billing Account",
        required: true,
        errorMessage: "Please select an account.",
        defaultValue: nil,
        subtype: nil,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: [],
        allowMultiple: false,
        metadata: nil,
        clickableTextColor: nil
    )
    DropdownComponent(field: field)
        .environmentObject(FormViewModel())
        .padding()
}

#Preview("With Error State") {
    let field = FormField(
        id: "ad_networks",
        order: 4,
        type: .dropdown,
        label: "Ad Networks",
        required: true,
        errorMessage: "Select at least one network.",
        defaultValue: nil,
        subtype: nil,
        placeholder: nil,
        supportingText: nil,
        maxLength: nil,
        regex: nil,
        options: [
            DropdownOption(id: "net_google", label: "Google Search"),
            DropdownOption(id: "net_meta", label: "Meta Platforms")
        ],
        allowMultiple: true,
        metadata: nil,
        clickableTextColor: nil
    )
    let vm = FormViewModel()
    vm.fieldErrors["ad_networks"] = "Select at least one network."
    return DropdownComponent(field: field)
        .environmentObject(vm)
        .padding()
}
