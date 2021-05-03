//
//  ContentView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = Preferences()
    
    var body: some View {
        NavigationView {
            GalleryView()
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
