//
//  GalleryView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI
import PencilKit

struct GalleryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Drawing.timestamp, ascending: true)], animation: .default) private var drawings: FetchedResults<Drawing>
    
    var body: some View {
        List {
            ForEach(drawings) { drawing in
                NavigationLink(destination: CanvasView(drawingId: drawing.id ?? UUID()), label: {
                    Text("\(drawing.name ?? "Untitled") - \(drawing.timestamp ?? Date(), formatter: dateFormatter)")
                })
            }
            .onDelete(perform: deleteDrawing)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addDrawing, label: { Label("New Drawing", systemImage: "plus") })
            }
        }
    }
    
    func addDrawing() {
        let drawing = Drawing(context: viewContext)
        
        drawing.id = UUID()
        drawing.name = "Drawing"
        drawing.timestamp = Date()
        
        let pkDrawing : PKDrawing = PKDrawing()
        drawing.data = pkDrawing.dataRepresentation()
        
        PersistenceController.shared.save()
    }
    
    func deleteDrawing(at offsets: IndexSet) {
        for index in offsets {
            let drawing = drawings[index]
            PersistenceController.shared.delete(drawing)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
