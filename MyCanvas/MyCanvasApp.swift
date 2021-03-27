//
//  MyCanvasApp.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI

@main
struct MyCanvasApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
