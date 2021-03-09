//
//  ContentView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            GalleryView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
