//
//  CanvasViewRepresentable.swift
//  MyCanvas
//
//  Created by Student on 02.04.21.
//

import SwiftUI
import PencilKit

struct CanvasViewRepresentable: UIViewRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Drawing.timestamp, ascending: true)], animation: .default) private var drawings: FetchedResults<Drawing>

    @Binding var drawingId : UUID
    @Binding var canvasView : PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        let drawingData = drawings.first(where: {$0.id == drawingId})?.data
        if let pkDrawing = try? PKDrawing(data: drawingData!) { canvasView.drawing = pkDrawing }
        
        canvasView.delegate = context.coordinator
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $canvasView)
    }
}


class Coordinator: NSObject, PKCanvasViewDelegate {
    var canvasView: Binding<PKCanvasView>
    
    init(canvasView: Binding<PKCanvasView>) {
        self.canvasView = canvasView
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        
    }
}
