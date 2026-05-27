//
//  Eulerity_FormAppApp.swift
//  Eulerity_FormApp
//
//  Created by pranavashok.patel on 25/05/26.
//

import SwiftUI

@main
struct Eulerity_FormAppApp: App {
    @StateObject private var vm = FormViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
        }
    }
}
