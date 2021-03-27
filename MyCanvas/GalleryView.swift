//
//  GalleryView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI
import CoreData

struct GalleryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Drawing.timestamp, ascending: true)], animation: .default)
    private var drawings: FetchedResults<Drawing>
    
    var body: some View {
        List {
            NavigationLink(
                destination:
                    CanvasView(drawingName: "Drawing 1"),
                label: {
                    Text("Drawing")
                }
            )
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
