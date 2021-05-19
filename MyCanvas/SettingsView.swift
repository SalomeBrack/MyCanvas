//
//  SettingsView.swift
//  MyCanvas
//
//  Created by Student on 19.05.21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var preferences = Preferences()
    
    var body: some View {
        VStack(spacing: 25) {
            Toggle(isOn: $preferences.darkMode) { Text("Dark Mode") }
            //if UIDevice.current.userInterfaceIdiom == .pad {}
            Toggle(isOn: $preferences.pencilOnly) { Text("Pencil Only Mode") }
            Toggle(isOn: $preferences.vectorEraser) { Text("Vector Eraser") }
        }
    }
}
