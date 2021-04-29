//
//  CanvasView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//


import SwiftUI
import PencilKit

struct CanvasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Drawing.timestamp, ascending: true)], animation: .default) private var drawings: FetchedResults<Drawing>
    
    @State var drawingId: UUID
    
    var body: some View {
        if let drawing = drawings.first(where: {$0.id == drawingId}) {
            CanvasWrapper(drawing: drawing, onSaved: updateDrawing)
                .ignoresSafeArea()
        }
    }
    
    func updateDrawing(drawingData: Data) {
        if let drawing = drawings.first(where: {$0.id == drawingId}) {
            drawing.data = drawingData
            PersistenceController.shared.save()
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(drawingId: UUID())
    }
}
