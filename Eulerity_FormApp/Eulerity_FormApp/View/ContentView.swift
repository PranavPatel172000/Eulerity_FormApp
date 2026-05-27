//
//  ContentView.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: FormViewModel
    
    var body: some View {
        Group {
            if let error = vm.loadError {
                errorView(error)
            } else if vm.payload == nil {
                ProgressView("Loading form...")
            } else {
                formView
            }
        }
        .onAppear { vm.loadForm() }
    }
    
    private var formView: some View {
        let bg = vm.theme?.backgroundSwiftUIColor ?? Color(.systemBackground)
        let text = vm.theme?.textSwiftUIColor ?? Color(.label)
        
        return ZStack {
            bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Title
                    Text(vm.formTitle)
                        .font(.largeTitle).bold()
                        .foregroundColor(text)
                        .padding(.top, 8)
                    
                    // Fields
                    ForEach(vm.sortedFields) { field in
                        FormFieldView(field: field)
                            .environmentObject(vm)
                    }
                    
                    //Save buton
                    saveButton
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .alert("Incomplete Form", isPresented: $vm.showValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please fix the highlighted fields before saving.")
        }
        .alert(" Form Submitted", isPresented: $vm.showSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.successPayload)
        }
    }
    
    private var saveButton: some View {
        Button(action: { vm.save() }) {
            Text("Save")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                )
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Failed to load form")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
}

#Preview {
    ContentView(vm: FormViewModel())
}

#Preview("With Validation Error") {
    let vm = FormViewModel()
    vm.loadForm()
    vm.fieldErrors = [
        "campaign_name": "Name is required.",
        "ad_networks": "Select at least one network."
    ]
    return ContentView(vm: vm)
}
        
     
